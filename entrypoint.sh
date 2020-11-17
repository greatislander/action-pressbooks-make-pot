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
    mkdir $PATH
elif [[ ! -d $PATH ]]; then
    rm -r $PATH
    mkdir $PATH
fi

# Generate the POT file from other resources.
/usr/local/bin/wp pb make-pot . "$PATH/$TEXTDOMAIN.pot" --exclude="$EXCLUDES" --slug="$SLUG" --package-name="$NAME" --headers="$HEADERS" --domain="$TEXTDOMAIN" --allow-root
