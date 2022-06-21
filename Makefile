default: test

test:
	swift test

format:
	find . -type f -name "*.swift" -not -path '*/Package.swift' -exec sed -i '' -e '1,/^import/{/^\/\/.*/d;}' -e '/./,$$!d' {} \;
	swift-format --in-place --recursive --configuration ./.swift-format.json ./

.PHONY: format test
