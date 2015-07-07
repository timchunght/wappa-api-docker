#Setup Wappa API using Fig

Make sure you have the newest ``wappa_api`` folder in the same directory as the ``Dockerfile``

	git clone git_repo # or go into "wappa_api" and do "git pull"
	fig up # use "-d" to run as daemon

Now, the app should be up on ``host_ip:8080``. Make sure to route your Nginx to that port.

#Execute Wappalyzer Phantomjs Driver

	/usr/local/phantomjs/bin/phantomjs --load-images=false --ignore-ssl-errors=yes --ssl-protocol=any /usr/local/wappalyzer/driver.js http://yourlink.com