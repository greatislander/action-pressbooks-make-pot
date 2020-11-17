#!/bin/bash
set -eo

BRANCH=${GITHUB_REF#refs/heads/}
SLUG="$INPUT_SLUG"
PATH="$INPUT_PATH"
NAME="$INPUT_NAME"
HEADERS="$INPUT_HEADERS"
EXCLUDES="$INPUT_EXCLUDES"
TEXTDOMAIN="$INPUT_TEXTDOMAIN"

if [[ -z "$SLUG" ]]; then
	ITEM_SLUG=${GITHUB_REPOSITORY#*/}
fi

if [[ -z "$PATH" ]]; then
	echo "No save destination was provided for the POT file."
	exit 1
fi

if [[ -z "$NAME" ]]; then
	echo "No project name was provided."
	exit 1
fi

if [[ -z "$HEADERS" ]]; then
	HEADERS='{}'
fi

if [[ -z "$TEXTDOMAIN" ]]; then
	TEXTDOMAIN=${SLUG}
fi

if [[ ! -e $PATH ]]; then
    echo "Save destination not found. Please make sure it exists in your repository."
	exit 1
elif [[ ! -d $PATH ]]; then
    echo "Save destination not found. Please make sure it exists in your repository."
fi

# Generate the POT file from other resources.
wp pb make-pot . "$PATH/$TEXTDOMAIN.pot" --exclude="$EXCLUDES" --slug="$SLUG" --package-name="$NAME" --headers="$HEADERS" --domain="$TEXTDOMAIN" --allow-root
