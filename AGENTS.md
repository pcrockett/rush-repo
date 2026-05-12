# AGENTS.md

Guidance for agentic coding tools working in this repository.

## What this repo is

A personal package repository for [Rush](https://github.com/DannyBen/rush-cli),
a Bash-based package manager. Each top-level directory is a Rush package.
Most install/uninstall a tool, but a package can be any Bash logic — e.g.
`random/128bit` just prints a URL-safe random string and has no `undo`. The
[YOLO script](https://philcrockett.com/yolo/v2.sh) in `README.md` lets people
consume these packages without installing Rush itself.

## Repository layout

- `<package>/` — one directory per package. Contains at minimum:
  - `info` — single-line human description (shown by `rush list`).
  - `main` — executed by `rush get <package>`. For install-style packages,
    expected to call `install_success` (or `install_success "$version"`).
    Non-install packages just do their work and exit.
  - `undo` — executed by `rush undo <package>`. Optional. For install-style
    packages, expected to call `uninstall_success`.
  - Anything else (`install.sh`, helper scripts, `README.md`) is package-local.
- `_lib/*.sh` — every file here is auto-sourced by `lib.sh`. Adding a file in
  `_lib/` makes its functions available to every package.
- `lib.sh` — entry point each package sources via
  `source "${REPO_PATH}/lib.sh"`. Sets `set -Eeuo pipefail` and loops
  `_lib/*.sh`. It does **not** source `main`/`undo` — Rush runs those
  directly; they pull in the shared library themselves.
- `_bin/newpackage` — scaffolder; runs `copier` over a chosen `_templates/`
  entry. Picked via fzf when the template name is omitted.
- `_templates/` — copier templates: `basic`, `script-bash`, `script-nushell`,
  `github-release`, `deb-repo`. `github-release` has a `tasks/` step that
  populates `info` from the GitHub repo description.
- `_tests/` — `bats` tests for the shared library. `util.sh` sets up an
  isolated `$HOME` and a fake repo under `$RUSH_ROOT`. `mock.sh` is a
  generic stand-in for shadowing real binaries on `$PATH` during a test.
- Underscore-prefixed dirs (`_bin`, `_lib`, `_tests`, `_templates`) are
  **not** packages — Rush ignores them.

## Daily commands

```bash
just                    # list recipes
just all                # lint + tagref + test (mirrors CI)
just lint               # pre-commit on all files
just tagref             # ref-integrity check
just test               # bats ./_tests
bats _tests/install_success.bats               # single test file
_bin/newpackage <name> [template]              # scaffold a new package
```

`.tool-versions` pins `bats`, `just`, and `shfmt` via asdf. `pre-commit` is
required locally; CI installs it via `actions/setup-python` +
`pre-commit/action`.

## Writing a package

Use `_bin/newpackage <name> [template]` to scaffold. The template menu
(fzf if omitted) covers every shape currently in use:

- `basic` — empty skeleton; fill in whatever `main`/`undo` should do.
- `script-bash` / `script-nushell` — package wraps a single committed
  script and `install_user_bin`s it.
- `github-release` — the `install_from_github` flow (see below).
- `deb-repo` — adds a Debian apt source.

The `github-release` template stamps out the standard "download a release
asset and install it" pattern. The generated `main` sources `lib.sh`,
optionally `require_commands tar/xz/unzip`, sets `GITHUB_ORG`,
`GITHUB_REPO`, `BIN_NAME`, and defines five functions consumed by
`install_from_github`:

- `latest_version` — usually `echo "${GITHUB_LATEST_TAG}"`, sometimes
  stripped of a leading `v`. This is what gets recorded as the installed
  version, so it must match what `installed_version` will later report.
- `installed_version` — typically delegates to `installed_package_version`
  after a `command_exists` guard; return `""` when not installed.
- `artifact_name` — the asset filename on the GitHub release.
- `download_url` — usually
  `https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/releases/download/${GITHUB_LATEST_TAG}/$(artifact_name)`.
- `install_artifact` — receives `$ARTIFACT_PATH`, does extraction and
  `install_user_bin <path>`.

It ends with `install_from_github` and `install_success "$(latest_version)"`.

Non-template installs (see `duckdb/main`, `sqrl/main`) skip
`install_from_github` and call `install_user_bin` / `install_success`
directly. The `undo` script removes whatever `main` placed in
`${RUSH_USER_BIN}` plus any state dirs (e.g. `bun/undo` clears
`$BUN_INSTALL`), then calls `uninstall_success`.

## Key shared helpers (from `_lib/`)

- `install_from_github` — orchestrates the version-check / download /
  install / cleanup flow described above.
- `install_user_bin <file>` — installs into `$RUSH_USER_BIN`
  (`~/.local/bin` for users, `/usr/local/bin` when running as root — see
  `_lib/vars.sh` for why).
- `install_global_bin <file>` — `as_root install` into `$RUSH_GLOBAL_BIN`.
- `install_success [version]` / `uninstall_success` — touch/remove a marker
  file under `$(repo_state_dir)/installed_packages/${RUSH_PACKAGE_NAME}`.
  `RUSH_PACKAGE_NAME` may be nested (`foo/bar`).
- `installed_package_version` — reads the marker file.
- `github_latest_tag <org> <repo>` — populated into `$GITHUB_LATEST_TAG` by
  `install_from_github`.
- `command_exists`, `require_commands`, `require_packages`.
- `curl_download <url>` / `download_artifact <url> <path>`.
- `mktemp_dir`, `panic`, `as_root`, `force_please`.
- `log_info` / `log_attention` / `log_warning` / `log_error` — all prefix
  the package name in cyan; prefer these over raw `echo`.

## Lint and formatting

`pre-commit` runs: standard hooks, `actionlint`, `gitleaks`, `shellcheck`,
`yamllint`, `shfmt`, `yamlfmt`. Notable:

- `.editorconfig` enforces 2-space indent for shell, 4-space for
  `Justfile`/`.py`, tabs for `Makefile`. `shfmt` reads
  `switch_case_indent = true` and `binary_next_line = true` from it.
- `.shellcheckrc` enables `external-sources=true` so `# shellcheck source=lib.sh`
  works. Use that directive whenever you `source "${REPO_PATH}/lib.sh"`.
- Shellcheck-skipped files: `template.bash`, `example.bats`,
  `ollama/install.sh`, `bun/install.sh` (vendored upstream installers).
- `.git-blame-ignore-revs` hides mass-format commits from blame.

## Testing notes

Tests run against a real `rush` binary (installed via the YOLO script in CI).
`_tests/util.sh::setup` builds a throwaway `$HOME` + repo dir; `teardown`
removes both. The `capture_output` / `assert_*` helpers are the standard
pattern — see `install_success.bats` for examples. `_tests/mock.sh` is a
self-logging stub: rename it to the binary you want to intercept and put it
earlier on `$PATH`.

## CI

`.github/workflows/ci.yml` runs on pushes to `main` and all PRs:
installs `tagref asdf rush yamlfmt` via the YOLO script, adds the `bats`,
`just`, and `shfmt` asdf plugins, then runs `pre-commit`, `just tagref`,
`just test`. Dependabot only updates GitHub Actions
(`.github/dependabot.yml`).
