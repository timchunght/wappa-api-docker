Wappa API powered by Rails
---

# Dependencies

The Rails app relies on Wappalyzer Phantomjs driver to be present

Install ``phantomjs`` and run the following in the terminal,

# Wappalyzer

	mkdir wappalyzer
	curl -sSL https://github.com/AliasIO/Wappalyzer/archive/master.tar.gz | tar xzC wappalyzer --strip 1
	wappalyzer/bin/wappalyzer-links wappalyzer

Now, to run the script, you can simply do (on Mac, if you are on Linux, you might need to run from source if you won't bother to setup symlink),

Mac:
	brew install phantomjs
	phantomjs /path/driver.js http://your_link.com

Linux (Replace paths if necessary):

	/usr/local/phantomjs/bin/phantomjs --load-images=false --ignore-ssl-errors=yes --ssl-protocol=any /usr/local/wappalyzer/driver.js http://your_link.com

Great, you now have a command line executable script to find out what technologies websites are using.

#Installation

Install the app
	
	git clone repo_of_this_app
	cd name_of_folder
	bundle install
	rake db:create
	rake db:migrate

Run the app

	brew install redis # if you have not installed ``redis`` yet
	redis-server # assuming you do not have ``redis-server`` running in background (in a separate tab)
	bundle exec sidekiq
	rails s # run this from another tab (sidekiq should be in a separate tab)

#Endpoint

	http://localhost:3000/analyze?url=https://www.wappalyzer.com


#Re-enqueue cached result

Sometimes, you might want to have the analyzer to reanalyse a website, a ``refresh`` param is so you can have the app reprocess your request and expire the old cache.

	http://localhost:3000/analyze?url=https://www.wappalyzer.com&refresh=true

You should get ``{status: "processing"}``, make sure the second request is ``WITHOUT`` the ``refresh`` param or else you will simply be reenqueueing the ``url`` and wasting memory and processing power.

Replace input for ``url`` with the website you want to analyze.

At first you will receive a ``JSON`` response of

	{
  	"status": "processing"
	}

Wait a second and make another ``GET`` request and you will find the output in the following format

	[
	  {
	    "name": "Drupal",
	    "confidence": 100,
	    "version": "7",
	    "categories": [
	      "cms"
	    ]
	  },
	  {
	    "name": "Highcharts",
	    "confidence": 100,
	    "version": "3.0.9",
	    "categories": [
	      "javascript-graphics"
	    ]
	  },
	  {
	    "name": "Nginx",
	    "confidence": 100,
	    "version": "1.6.2",
	    "categories": [
	      "web-servers"
	    ]
	  }
  ]

If you get ``[]`` or ``{status: "false"}``, double check your ``url`` to ensure that the input is correct.

###Deployment
Before we migrate the app to Docker, we will be using Ubuntu installation on any VPS (DigitalOcean or AWS). Make sure the following dependencies are met

rvm
ruby 2.1.5
unicorn
sidekiq
redis
phantomjs

#The following commands should complete Phantomjs and redis setup
	
	mkdir -p /usr/local/wappalyzer #Inside the wappalyzer folder should be the individual files

	#git clone all files into wappalyzer, steps not specified

	apt-get install build-essential g++ flex bison gperf ruby perl libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev
	cd /usr/local
	mkdir phantomjs && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 | tar xvjC phantomjs --strip 1 
	apt-get update && apt-get install -y \
		libfreetype6 \
		libfontconfig \
		&& apt-get clean && apt-get install curl -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	apt-get update && apt-get install redis-server -y

#Setup Rails app for deployment:
	
	mkdir -p /var/www
	cd /var/www
	git clone repo_of_this_app
	cd wappa_api # Assuming that you didn't change the app's folder name
	mkdir pids
	bundle install
	RAILS_ENV=production bundle exec rake db:migrate #We are using Sqlite since no database relations are present

#Redis and Sidekiq
	
	ps aux | grep redis #check if redis is running on ``port 6379``, if not, use ``redis-server`` to start it
	bundle exec sidekiq -e production -d -L log/sidekiq.log

The sidekiq command runs the sidekiq as production and daemon, all logs are in ``log/sidekiq.log`` file inside the rails app folder

#Run the server

	unicorn_rails

This will get the server up and running, it is not daemonized, you have to explicitly tell it to run as daemon (append -D).

###Credit
---
Wappalyzer
Timothy Chung

