SHELL               = /bin/bash
export LANG         = en_US.UTF-8
export LC_CTYPE     = en_US.UTF-8

.DEFAULT_GOAL := build

build: update-linux-test-manifest
	@swift build -c release -Xswiftc -warnings-as-errors > /dev/null

update-linux-test-manifest:
	@rm Tests/NetTimeTests/XCTestManifests.swift
	@touch Tests/NetTimeTests/XCTestManifests.swift
	@swift test --generate-linuxmain

test:
	@swift test -Xswiftc -warnings-as-errors

test-docker:
	@Scripts/run-tests-linux-docker.sh

develop-docker:
	@Scripts/develop-linux-docker.sh

carthage-archive: clean-carthage install-carthage
	@carthage build --archive

clean-carthage:
	@echo "Deleting Carthage artifacts…"
	@rm -rf Carthage
	@rm -rf NetTime.framework.zip

install-%:
	true

install-CocoaPods:
	sudo gem install cocoapods -v 1.6.0

install-carthage:
	brew update
	brew outdated carthage || brew upgrade carthage

test-SwiftPM: test

test-iOS:
	set -o pipefail && \
		xcodebuild \
		-project NetTime.xcodeproj \
		-scheme NetTime \
		-configuration Release \
		-destination "name=iPhone X,OS=12.2" \
		test

test-macOS:
	set -o pipefail && \
		xcodebuild \
		-project NetTime.xcodeproj \
		-scheme NetTime \
		-configuration Release \
		test \

test-tvOS:
	set -o pipefail && \
		xcodebuild \
		-project NetTime.xcodeproj \
		-scheme NetTime \
		-configuration Release \
		-destination "platform=tvOS Simulator,name=Apple TV,OS=12.2" \
		test \

test-carthage:
	set -o pipefail && \
		carthage build \
		--no-skip-current \
		--configuration Release \
		--verbose
	ls Carthage/build/Mac/NetTime.framework
	ls Carthage/build/iOS/NetTime.framework
	ls Carthage/build/tvOS/NetTime.framework
	ls Carthage/build/watchOS/NetTime.framework

test-CocoaPods:
	pod lib lint --verbose
