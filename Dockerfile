FROM ruby:2.4.8-alpine

RUN apk update && \
    apk upgrade && \
    apk add build-base && \
    rm -rf /var/cache/apk/*

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /.

ENV LANG C.UTF-8

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["./your-daemon-or-script.rb"]