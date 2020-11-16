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

# Generate the POT file from Blade.
find . -iname '*.blade.php' | xargs xgettext --language=Python --add-comments=TRANSLATORS --force-po --from-code=UTF-8 --default-domain=de_DE -k__ -k_e -k_n:1,2 -k_x:1,2c -k_ex:1,2c -k_nx:4c,12 -kesc_attr__ -kesc_attr_e -kesc_attr_x:1,2c -kesc_html__ -kesc_html_e -kesc_html_x:1,2c -k_n_noop:1,2 -k_nx_noop:3c,1,2, -k__ngettext_noop:1,2 -j -o "$PATH/$TEXTDOMAIN.pot"

# Generate the POT file from other resources.
wp i18n make-pot . "$PATH/$TEXTDOMAIN.pot" --exclude="$EXCLUDES" --slug="$SLUG" --package-name="$NAME" --headers="$HEADERS" --domain="$TEXTDOMAIN" --allow-root
