# Pressbooks Make POT Action

This Github Action updates the POT file for a Pressbooks plugin or theme based on the contents of the plugin or theme
repository.

This code is based on [WordPress Pot Generator][action-wp-pot-generator], Copyright (c) Varun Sridharan, which is
distributed under the terms of the MIT License.

## Usage

### Configuration

| Key | Default | Description |
| --- | ------- | ----------- |
| path | `NULL` | Path where the POT file should be saved. |
| slug | `GITHUB_REPOSITORY` | Slug of the Pressbooks plugin or theme. |
| textdomain | `SLUG` | Text domain of the Pressbooks plugin or theme. |
| name | `NULL` | Name of the Pressbooks plugin or theme. |
| headers | `{}` | JSON object of custom headers and values which will be added to the POT file. |
| excludes | `NULL` | Comma-separated list of paths to exclude when scanning for translateable strings. |


### Sample Workflow

```yaml
name: Update POT

on:
  push:
    branches:
      - main

jobs:
  WP_POT_Generator:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: WordPress POT Generator
      uses: pressbooks/action-pressbooks-make-pot@main
      with:
        path: './languages' # Directory where the file should be saved.
        slug: 'pressbooks' # Plugin or theme slug.
        textdomain: 'pressbooks' # Plugin or theme textodmain.
        name: 'Pressbooks' # Plugin or theme name.
        headers: "{\"Report-Msgid-Bugs-To\":\"https://github.com/pressbooks/pressbooks/issues\"}" # Custom headers (see: https://github.com/wp-cli/i18n-command/issues/47)
        excludes: 'symbionts,vendor' # Comma-separated files/directories to exclude.
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

[action-wp-pot-generator]: https://github.com/varunsridharan/action-wp-pot-generator

