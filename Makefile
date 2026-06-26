MINT := $(shell command -v mint 2>/dev/null)
DESTINATION := platform=iOS Simulator,name=iPhone 16
TEST_SCHEMES := Wanderly Domain Data Features

bootstrap:
	mint bootstrap

test:
	@for scheme in $(TEST_SCHEMES); do \
		echo "▶ Testing $$scheme…"; \
		xcodebuild test \
			-workspace Wanderly.xcworkspace \
			-scheme "$$scheme" \
			-destination '$(DESTINATION)' \
			-quiet \
		&& echo "✓ $$scheme" || exit 1; \
	done

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

.PHONY: bootstrap test lint format lint-check
