FROM ruby:2.4.1-alpine AS build-env

ARG BUILD_PACKAGES="build-base git"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /.

ENV LANG C.UTF-8

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

FROM ruby:2.4.1-alpine

############### Build step done ###############

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /.

ENV LANG C.UTF-8

COPY . .

CMD ["ruby", "test/bottles_test.rb"]