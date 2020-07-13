SHELL               = /bin/bash
export LANG         = en_US.UTF-8
export LC_CTYPE     = en_US.UTF-8

.DEFAULT_GOAL := build

build: update-linux-test-manifest
	@swift build -c release -Xswiftc -warnings-as-errors > /dev/null

generate-xcodeproj:
	@Scripts/ensure-xcodegen.sh
	@tmp/xcodegen

update-linux-test-manifest:
ifeq ($(shell uname),Darwin)
	@rm Tests/NetTimeTests/XCTestManifests.swift
	@touch Tests/NetTimeTests/XCTestManifests.swift
	@swift test --generate-linuxmain
else
	@echo "Only works on macOS"
endif

test:
	@swift test -Xswiftc -warnings-as-errors

test-codegen: update-linux-test-manifest generate-xcodeproj
	@git diff --exit-code

test-docker:
	@Scripts/ubuntu.sh NetTime test 5.1.1 bionic

install-%:
	true

install-CocoaPods:
	sudo gem install cocoapods -v 1.8.3

test-SwiftPM: test

test-CocoaPods:
	pod lib lint --verbose
