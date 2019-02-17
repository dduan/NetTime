#!/usr/bin/env bash

command -v docker &> /dev/null || { echo >&2 "Install docker https://www.docker.com"; exit 1; }

IMAGE=norionomura/swift:swift-5.0-branch@sha256:165d082f63ec992b88859dc6d1c9e2a05cbf24a11a3f5c4816039d8a968d9763
NAME=nettimedev
docker run -it -v "$PWD":/NetTime --name "$NAME" --rm "$IMAGE"
