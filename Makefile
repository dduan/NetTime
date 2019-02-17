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

xcode:
	@swift package generate-xcodeproj

test-docker:
	@Scripts/run-tests-linux-docker.sh

develop-docker:
	@Scripts/develop-linux-docker.sh
