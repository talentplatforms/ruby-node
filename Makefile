################################################################################
# start / stop / prepare
################################################################################

init:
	npm install

################################################################################
# releases
################################################################################

# patches a version
patch:
	npm run release:patch

# minor up
minor:
	npm run release:minor

# major up
release:
	npm run release

################################################################################
# docker building stuff
################################################################################
# you have to know what you're doing if your using this ;)

RUBY_VERSION=2.5.5
NODE_VERSION=12.16.0
PG_MAJOR=10
DEBIAN_VERSION_NAME=buster
BUNDLER_VERSION=1.17.3

REGISTRY=talentplatforms/ruby-node
VCS_URL=https://github.com/talentplatforms/ruby-node

# DO NOT OVERRIDE!
_BUILD_DATE=$(shell echo $$(date -u +'%Y-%m-%dT%H:%M:%SZ'))
_VCS_REF=$(shell echo $$(git rev-parse --verify HEAD))
_IMAGE_LATEST=${REGISTRY}:latest
_IMAGE_TAGGED=${REGISTRY}:${NODE_VERSION}-alpine${ALPINE_VERSION}

# builds the image and tags it with the latest tag and the more specific tag defined in _IMAGE_TAGGED
build:
	docker build \
	--rm \
	--build-arg RUBY_VERSION=${RUBY_VERSION} \
	--build-arg NODE_VERSION=${NODE_VERSION} \
	--build-arg PG_MAJOR=${PG_MAJOR} \
	--build-arg DEBIAN_VERSION_NAME=${DEBIAN_VERSION_NAME} \
	--build-arg BUNDLER_VERSION=${BUNDLER_VERSION} \
	--build-arg BUILD_DATE=${_BUILD_DATE} \
	--build-arg VCS_URL=${VCS_URL} \
	--build-arg VCS_REF=${_VCS_REF} \
	--build-arg BUILDKIT_INLINE_CACHE=1 \
	-t ${_IMAGE_LATEST} \
	-t ${_IMAGE_TAGGED} \
	.

# pushes the tagged image to the registry
# if no variables are set, it uses the defaults
push:
	docker push ${_IMAGE_LATEST}
	docker push ${_IMAGE_TAGGED}

# make NODE_VERSION=13.10.1 build push
# -> registry.gitlab.com/talentplatforms-territory/docker/node-frontend:13.10.1-alpine3.11
