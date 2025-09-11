all: lint tagref test
.PHONY: all

lint:
	@_bin/lint
.PHONY: lint

tagref:
	@tagref
.PHONY: tagref

test:
	bats ./_tests
.PHONY: test
