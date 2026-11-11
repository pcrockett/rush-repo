[private]
_default:
    @just --list

# Run lint and tests
all: lint test

# Run pre-commit on all files
lint:
    pre-commit run --all --show-diff-on-failure --color always

# Run bats tests
test:
    bats ./_tests

# Draft a GitHub release for the action
release:
    gh release create --generate-notes --draft
