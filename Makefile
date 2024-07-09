all: lint tagref
.PHONY: all

lint:
	@_bin/lint
.PHONY: lint

tagref:
	@tagref
.PHONY: tagref
