#!/bin/bash

if ! command -v gh-release-create &> /dev/null; then
	echo "gh (GitHub) cli not found"
	exit 1
fi
