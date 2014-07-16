
import socket
import sys
import urllib
import urllib2
import json
import requests
import time
import calendar
import subprocess
import re
import time
import datetime
import random
# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('localhost', 9000)
print >>sys.stderr, 'starting up on %s port %s' % server_address
sock.bind(server_address)

# Listen for incoming connections
sock.listen(0)
receivedData = ''

#dummy variables
# start_time = str( int(calendar.timegm(time.gmtime()) ) )
# pulses = 150
# fluid_ounces = str(pulses / 15 )
# end_time = str( int(calendar.timegm(time.gmtime())) )
# pour_id = "10"
keg_id = "2"
isPouring = False
isComplete = False

while True:
    # Wait for a connection
    print >>sys.stderr, 'waiting for a connection'

    connection, client_address = sock.accept()
    connection.sendall('STOP')
    try:
        print >>sys.stderr, 'connection from', client_address
        # Receive the data in small chunks and retransmit it
        # send the current kegHealth information

        while True:
            data = connection.recv(16)
            print data
            print >>sys.stderr, receivedData
            if data:
              print data
              while True:
                moreData = connection.recv(16)
                if moreData:
                  receivedData += moreData
                  print receivedData

                  # confirm if its the last bit of data.
                  if moreData[-1:]=='|':
                    isPouring=True
                    data = ''
                    moreData = ''
                    # goes to finally: and process the information and send them to Heroku Server 
                    break
                  elif moreData[-1:] == '~':
                    connection.close()
                    break
                else:
                    print >>sys.stderr, 'waiting for more data'
                    connection.close()

            else:
                print >>sys.stderr, 'no more data from', client_address
                break
    finally:

        #Clean up the connection

        #and if Bool isPouring = YES, then send this info.
        if isPouring:
          splitString = receivedData.split('+',6)

          # Temp
          output = subprocess.check_output(["sudo", "./temp_humid/Adafruit_DHT", "22", "4"])
          matches = re.search("Temp =\s+([0-9.]+)", output)
          while (not matches):
            # this isn't elegent
            # TODO: fix retry reading
            time.sleep(3)
            output = subprocess.check_output(["sudo","./temp_humid/Adafruit_DHT", "22", "4"])
            matches = re.search("Temp =\s+([0-9.]+)", output)

          temp = str(float(matches.group(1)))
          # search for humidity printout
          matches = re.search("Hum =\s+([0-9.]+)", output)
          if (not matches):
            time.sleep(3)
            # continue
            # TODO: fix this, retry search
          humidity = str(float(matches.group(1)))
 
          # start time
          start_time = str( int(calendar.timegm(time.gmtime()) ) )
          print splitString[0], ' is Pouring'
          # Pour
          print "You have 20 seconds to pour."

          try:
             pourOut = subprocess.check_output("sudo ./flowmeter/flow 20", shell=True)                       
          except subprocess.CalledProcessError as pourexc:                                                                                                   
              print "error code", pourexc.returncode, pourexc.output

          # pourexc.output is our pulse value
          pulses = float(pourexc.output)
          pulsesPerFlOz = 10.0
          pour_amount = pulses/pulsesPerFlOz
          print "You poured", pour_amount, "fluid ounces!"

          # tostring for json
          fluid_ounces = str(pour_amount)

          # rand number for id
          # placerholder, will replace with proper uuid
          pour_id = str(random.randrange(100, 1000000))

          # pour finished, getting end time
          end_time = str( int(calendar.timegm(time.gmtime())) )

          url = "http://frank-the-tank.herokuapp.com/newJSON"
          values = {
              "pour" : [{
              # information below all comes from the keg.
                 "id":pour_id,
                 "container":keg_id,
                 "currentTime":start_time,
                 "startTime":start_time,
                 "endTime":end_time,
                 "fluidOunces":fluid_ounces,
                 "temperature":temp,
                 "humidity":humidity
              }],
             "user" : { 
                 "username" : splitString[0], 
                  "displayName" : splitString[1], 
                 "location" : splitString[2], 
                 "imageURL" : splitString[3]},
              "cid" : splitString[4]
          }

          headers = {'Content-Type':'application/json'}
          req=requests.post(url, data = json.dumps(values), headers=headers)
          isPouring = False
          stringInfo = 'DEMACIA!'
          # stringInfo Will become the Keg health informaition in string form separated by '+'and end with '|'
          connection.sendall(stringInfo)

        connection.close()
        receivedData=''


