Wappalyzer Phantomjs Docker Image
---

#Build Docker Image

	docker build -t name_of_image .

#Run the Docker

	docker run -it name_of_image /bin/bash

The ``/bin/bash`` at the end will bring you into the shell of your container.

#Execute Wappalyzer Phantomjs Driver

	/usr/local/phantomjs/bin/phantomjs --load-images=false --ignore-ssl-errors=yes --ssl-protocol=any /usr/local/wappalyzer/driver.js http://yourlink.com