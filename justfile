[private]
_default:
    @just --list

# Run lint, tagref, and tests
all: lint tagref test

# Run pre-commit on all files
lint:
    pre-commit run --all --show-diff-on-failure --color always

# Check tagref integrity
tagref:
    tagref

# Run bats tests
test:
    bats ./_tests

# Draft a GitHub release for the action
release:
    gh release create --generate-notes --draft
