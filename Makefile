MINT := $(shell command -v mint 2>/dev/null)
DESTINATION := platform=iOS Simulator,name=iPhone 17
TEST_SCHEME := Wanderly-Workspace

bootstrap:
	mint bootstrap

test:
	xcodebuild test \
		-workspace Wanderly.xcworkspace \
		-scheme "$(TEST_SCHEME)" \
		-destination '$(DESTINATION)' \
		-quiet

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
