ARG DEBIAN_VERSION_NAME
ARG NODE_VERSION
ARG PG_MAJOR
ARG RUBY_VERSION

FROM node:${NODE_VERSION}-${DEBIAN_VERSION_NAME}-slim as nodejs
FROM ruby:${RUBY_VERSION}-slim-${DEBIAN_VERSION_NAME} as ruby

ENV PACK_CORE="git curl wget unzip build-essential tzdata gnupg python locales locales-all" \
  PACK_LIBS="zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev libpq-dev" \
  APP_HOME=/app

RUN mkdir ${APP_HOME} \
  && apt-get update \
  && apt-get install -fqq --no-install-recommends \
  ${PACK_CORE} \
  ${PACK_LIBS} \
  && curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' ${PG_MAJOR} > /etc/apt/sources.list.d/pgdg.list \
  && apt-get install -fqq --no-install-recommends \
  postgresql-client-${PG_MAJOR} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN dpkg-reconfigure --frontend noninteractive tzdata

ENV LANG=de_DE.UTF-8 \
  LANGUAGE=de_DE.UTF-8

COPY --from=nodejs /usr/local /usr/local
COPY --from=nodejs /opt /opt

RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

# set ruby specific vars
ARG BUNDLER_VERSION

ENV GEM_HOME=/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
  BUNDLE_BIN=$BUNDLE_PATH/bin

RUN gem update --system \
  && gem install bundler -v $BUNDLER_VERSION

WORKDIR ${APP_HOME}

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG SVC_VERSION="${VCS_REF}"
ARG SVC_DESCRIPTION

LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Territory Embrace | Talentplatforms" \
  org.label-schema.vcs-url="${VCS_URL}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.name="ruby-node" \
  org.label-schema.version="${SVC_VERSION}" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.description="an opinionated base image for rails apps"
