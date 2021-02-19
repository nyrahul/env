#!/bin/bash

if ! command -v gh &> /dev/null; then
	echo "gh (GitHub) cli not found"
	exit 1
fi

if [ ! -z "$(git status --untracked-files=no --porcelain)" ]; then
	git status --untracked-files=no --porcelain
	echo "Above uncommitted changes in local repo"
	exit 1
fi
