#!/bin/bash

if ! command -v gh &> /dev/null; then
	echo "gh (GitHub) cli not found"
	exit 1
fi

if ! git diff-index --quiet HEAD; then
	git status --untracked-files=no --porcelain
	echo "Above uncommitted changes in local repo"
	exit 1
fi

[[ "$1" == "" ]] && echo "Need release number in the form of vMAJOR.MINOR.PATCH" && exit 1

if ! git rev-parse "$1" >/dev/null 2>&1; then
	echo "Creating new tag $1"
	if ! git tag $1; then
		echo "Could not create tag $1"
		exit 1
	fi
else
	echo "Found existing tag $1"
fi

gh release create $1 /tmp/t.tgz --draft=true --notes-file=/home/rahul/env/README.md -t "Env release $1"

