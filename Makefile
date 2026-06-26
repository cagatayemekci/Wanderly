MINT := $(shell command -v mint 2>/dev/null)

bootstrap:
	mint bootstrap

lint:
ifdef MINT
	mint run swiftlint swiftlint
else
	swiftlint
endif

format:
ifdef MINT
	mint run swiftformat swiftformat .
else
	swiftformat .
endif

lint-check:
ifdef MINT
	mint run swiftlint swiftlint --strict
else
	swiftlint --strict
endif

.PHONY: bootstrap lint format lint-check
