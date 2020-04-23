[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

# Ruby/Node.js Image for Rails

This is an opinionated image for building rails apps.
It ships with a couple of tools and libraries found in the next section.

## Tools and Libraries

**PACK_CORE**
- git
- curl
- wget
- unzip
- build-essential
- tzdata
- gnupg
- python
- locales
- locales-all

**PACK_LIBS**
- zlib1g-dev
- libssl-dev
- libreadline-dev
- libyaml-dev
- libxml2-dev
- libxslt1-dev
- libcurl4-openssl-dev
- libffi-dev
- libpq-dev
- postgresql-client-${PG_MAJOR}
- yarn

Per default it uses the de_DE.UTF-8 LANG and LANGUAGE ENVs.

## Workdir

Per convention the working directory is set to **/app**

# How to use this

The image comes with a Makefile that has everything abstracted away for you to easily customize it.

```bash
$ make make NODE_VERSION=13.10.1 ALPINE_VERSION=3.11 build push
```

## Available VARS

```bash
RUBY_VERSION=2.5.5
NODE_VERSION=12.16.0
PG_MAJOR=10
DEBIAN_VERSION_NAME=buster
BUNDLER_VERSION=1.17.3
REGISTRY=${REGISTRY:-ORGANIZATION/ruby-node}
VCS_URL=${VCS_URL:-https://THE_REPO_URL}
```

## Optional Setup

If you are into some tooling for keeping commit-messages clean and want to keep an automated CHANGELOG.md, feel free to `make init` ;).

It'll install the node_modules:
- standard-version,
- husky
- commit-lint

To make this work you need to have NODE.js installed.

# Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style.

1. Fork it
2. Create your feature branch (git checkout -b feature/my-cool-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin feature/my-new-feature)
5. Create new Pull Request

# License
Copyright (c) 2020 Territory Embrace - Talent Platforms.
