FROM ubuntu

MAINTAINER Timothy Chung <timchunght@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get update && apt-get install -y \
	libfreetype6 \
	libfontconfig \
	&& apt-get clean && apt-get install curl -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get -y install build-essential g++ flex bison gperf ruby perl libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev

RUN curl -O http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz && \
    tar -zxvf ruby-2.1.2.tar.gz && \
    cd ruby-2.1.2 && \
    ./configure --disable-install-doc && \
    make && \
    make install && \
    cd .. && \
    rm -r ruby-2.1.2 ruby-2.1.2.tar.gz && \
    echo 'gem: --no-document' > /usr/local/etc/gemrc

WORKDIR /usr/local

RUN mkdir phantomjs
# PhantomJS
ADD phantomjs/ phantomjs/
# Wappalyzer
RUN mkdir wappalyzer
COPY wappalyzer-phantomjs wappalyzer/

#install wappa_api app
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir -p /var/www/wappa_api
ADD wappa_api /var/www/wappa_api
WORKDIR /var/www/wappa_api
COPY sidekiq.rb /var/www/wappa_api/config/initializers/
RUN gem install bundler
RUN bundle install
