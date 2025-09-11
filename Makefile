all: lint tagref test
.PHONY: all

lint:
	@pre-commit run shellcheck --all-files
.PHONY: lint

tagref:
	@tagref
.PHONY: tagref

test:
	bats ./_tests
.PHONY: test
