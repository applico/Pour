Pour
==============

###To Run Each Component

Raspberry Pi server: run ```sudo python server.py```

Node.js server: `npm install -g nodemon` then `nodemon` to start the server.

###To Roll Your Own Version of Pour
In the iOS app code, add your own Heroku URL to these lines:

```APPAppLoginViewController.m``` - line 411, 620, 650 - replace with your app name and URL

```APPCompanyViewController.m``` - line 69 - replace with your app name and URL

```APPKegViewController.m``` - line 134 - replace with your app name and URL

```APPPastPoursViewController.m``` - line 210 - replace with your app name and URL

```APPKegViewController.h/m``` - You will need to provide your own ShinobiCharts binary to compile this class

Node.js Server Code:

```app/keen.js``` - add your own projectId, writeKey, readKey, masterKey

```mongoose.js``` - add your own mongodb URL if necessary

```newrelic.js``` - name your app and provide your license_key

Raspberry Pi Python and C Code:

Dependencies:

```lbcm2835``` - http://www.raspberry-projects.com/pi/programming-in-c/c-libraries/bcm2835-by-mike-mccauley

```pigpio``` - http://abyz.co.uk/rpi/pigpio/

Install both libraries, then run ```make``` in both the ```flowmeter``` and ```temp_humid``` directories.  Run ```sudo python server.py``` in the main directory to start the server.

###Credits
FlatUIKit - https://github.com/Grouper/FlatUIKit

Adafruit Temperature and Humidity Sensor code - https://github.com/adafruit/Adafruit_Python_DHT

Flowmeter Code -  http://direct.raspberrypi.org/forums/viewtopic.php?t=73534
