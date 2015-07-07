FROM ubuntu:14.04

MAINTAINER Timothy Chung <timchunght@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update && apt-get install -y libfontconfig1-dev build-essential \
    libicu-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev libpq-dev \
    libsqlite3-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev \
    bison openssl make git && apt-get clean

RUN apt-get install -y curl wget ca-certificates autoconf python-software-properties libyaml-dev

RUN curl -O http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz && \
    tar -zxvf ruby-2.1.5.tar.gz && \
    cd ruby-2.1.5 && \
    ./configure --disable-install-doc && \
    make && \
    make install && \
    cd .. && \
    rm -r ruby-2.1.5 ruby-2.1.5.tar.gz && \
    echo 'gem: --no-document' > /usr/local/etc/gemrc


# Clear downloaded files
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

WORKDIR /usr/local

RUN mkdir phantomjs
# PhantomJS
ADD phantomjs/ phantomjs/
# Wappalyzer
RUN mkdir wappalyzer
COPY wappalyzer-phantomjs wappalyzer/

#install wappa_api app
RUN mkdir -p /var/www/wappa_api
ADD wappa_api /var/www/wappa_api
WORKDIR /var/www/wappa_api
COPY sidekiq.rb /var/www/wappa_api/config/initializers/
COPY redis.rb /var/www/wappa_api/config/initializers/
RUN gem install bundler
RUN bundle install
