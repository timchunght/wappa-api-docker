FROM ubuntu

MAINTAINER Timothy Chung <timchunght@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get update && apt-get install -y \
	libfreetype6 \
	libfontconfig \
	&& apt-get clean && apt-get install curl -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/local

# PhantomJS
RUN \
	mkdir phantomjs && \
	curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 | tar xvjC phantomjs --strip 1

# Wappalyzer
RUN mkdir wappalyzer
COPY . wappalyzer/

WORKDIR wappalyzer/