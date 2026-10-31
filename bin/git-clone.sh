#!/usr/bin/env bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: git-clone <owner> <repo>" >&2
    exit 1
fi

owner="$1"
repo="${2%.git}"

git clone "https://github.com/${owner}/${repo}.git"
