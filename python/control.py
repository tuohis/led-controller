#!/usr/bin/env python
# -*- coding: utf-8 -*-

# (C) 2011 Mikko Tuohimaa
# Control a LED light source based on image brightness
# Aalto University School of Electronics project exercise

# Standard modules
import urllib2
import threading
import time
import sys

# May have to be installed separately (pySerial)
import serial

# Should be found in current working dir
from SerialInputMonitor import SerialInputMonitor
#from HistogramMonitor import HistogramMonitor



# Global var
config = {}

### Main function
	# Args as key=value
def main():
	global config
	try:
		# Load config values from cmdline and/or file
		loadConfig()
		# Get serial object
		ser = getSerial()
		# Initiate serial input monitor (threaded)
		serialMonitor = SerialInputMonitor(ser)
		serialMonitor.setDaemon(True)
		serialMonitor.start()
		
		# Initiate Controller object
		control = Controller(config['cameraIp'], ser)
		try:
			control.updateHistogram()
		except Exception as e:
			print('Unable to get histogram.')
			print e
		
		# Start control thread
		control.setDaemon(True)
		control.start()
		
		# Initiate histogram graph drawing (disabled for now)
		#histogramMonitor = HistogramMonitor(control)
		
		# Enter drawing loop
		while 1:
			#histogramMonitor.update()
			time.sleep(2)
		
	# All kinds of exceptions caught
	except KeyboardInterrupt:
		serialMonitor.halt()
		control.halt()
		serialMonitor.join()
		control.join()
		ser.close()
		del ser
		return 0
	except IOError as e:
		print e
	except ValueError:
		print "Could not convert data to an integer."
	except:
		print "Unexpected error:", sys.exc_info()[0]
		raise
	
	return 0

### Definitions

# Gets the config values from both sysargs and a config file
# and saves them in a global variable
def loadConfig():
	global config
	
	for arg in sys.argv:
		pair = arg.lstrip('- ').rstrip().split('=')
		if len(pair) < 2:
			continue
		config[pair[0]] = pair[1]
		
	if 'configFile' in config:
		filename = config['configFile']
	else:
		filename = 'config.conf'
	try:
		with open(filename, 'r') as configFile:
			for line in configFile:
				pair = line.lstrip().split(' ')
				if pair[0] == 'port':
					config['port'] = pair[1]
				elif pair[0] == 'cameraIp':
					config['cameraIp'] = pair[1]
	except IOError as (errno, strerror):
		print "Unable to open file '" + filename + "'"
	
	if not 'cameraIp' in config:
		raise Exception('No cameraIp configured!')
	
	if not 'debug' in config:
		config['debug'] = False

# Initiate serial communication.
# @return a Serial object initialized for the desired port
def getSerial(port=None):
	global config
	if port == None:
		if 'port' in config:
			port = config['port']
		else:
			port = '/dev/ttyACM0'
	
	# Serial connection with a read timeout of 1s
	ser = serial.Serial(port, 9600, serial.EIGHTBITS, serial.PARITY_NONE, serial.STOPBITS_ONE, 1)
	# Open connection to Arduino
	for i in range(100):
		if ser.isOpen():
			break
		else:
			ser.open()
			print('Waiting for port initialization..')
		time.sleep(0.1)
		if i > 98:
			raise Exception('Unable to connect to microcontroller! Port '+self.config['port'])
	print('Serial port opened!')
	
	# Initiate communication
	while ser.inWaiting() < 1:
		print('Waiting for connection..')
		time.sleep(1)
	print('Connected!')
	# write something to get the pwm running
	for i in range(5):
		ser.write(chr(128))
		time.sleep(0.1)
	ser.flushInput()
	
	return ser

# This is the class that actually runs the control algorithm.
class Controller(threading.Thread):
	# Constructor.
	# @param cameraIp The IP address of the camera
	# @param serial_instance A serial communication object
	def __init__(self, cameraIp, serial_instance):
		threading.Thread.__init__(self)
		self.serial = serial_instance
		self.cameraIp = cameraIp
		self.histogramUrl = 'http://'+self.cameraIp+'/histogram.php'
		self.histogram = [0]*255
		self.timestep = 0.25 # 250 milliseconds -> 4fps
		self.p = 0.3
		self.i = 0.0 # disabled for now; works well without it
		self.d = 0.07
		self.iLimit = 50 # anti-windup
		self.output = 128
		self.error = 0
		self.iError = 0
		self.dError = 0
		self.oldError1 = 0
		self.oldError2 = 0
		self.histogramUpdated = False
		self.stop = False
	
	# Main control procedure
	def run(self):
		# Do the things one should do when controlling the LEDs
		while not self.stop:
			self.updateHistogram()
			self.calculateError()
			self.updateCumulativeError()
			debugPrint( "Error: %d. Cumulative: %d. Derivative: %d" % (self.error, self.iError, self.dError) )
			
			self.output += self.p * self.error + self.i * self.iError + self.d * self.dError
			# Limit output to Arduino's PWM range [0, 255]
			self.output = min(255, max(0, self.output))
			# Write the new value to serial connection
			self.write(self.output)
			# Sleep for a while
			time.sleep(self.timestep)
	
	# Stops the control loop
	def halt(self):
		self.stop = True
	
	# Get a new histogram from the camera
	def updateHistogram(self):
		file = None
		try:
			# Do a GET request
			file = urllib2.urlopen('http://192.168.0.9/histogram.php', None, 1)
		except Exception as e:
			# In case there's a HTTP error (404, 500 etc)
			print e
			return
		datastring = file.read() # Read the response
		# Each histogram value is space separated in the response string. Put them in a list.
		list = []
		for elem in datastring.split(' '):
			try:
				if len(elem) > 0:
					list.append(int(elem))
			except ValueError as e:
				debugPrint("Unexpected value in histogram: %s" % elem)
				list.append(0)
		file.close()
		if len(list) == 256:
			self.histogram = list
			self.histogramUpdated = True
		else:
			debugPrint("The list had %d values. Weird!" % len(list))
			if len(list) > 256:
				self.histogram = list[0:256]
				self.histogramUpdated = True
	
	# Get the most recent average histogram
	def getHistogram(self):
		return self.histogram
	
	# Get the previously unfetched average histogram if available. Purely an interface method
	def getNewHistogram(self):
		if not self.histogramUpdated:
			return None
		self.histogramUpdated = False
		# return average
		return self.histogram
	
	# Calculate new error signal based on the histogram.
	# Priorities:
	#   1. No overexposure (the 240:255 value almost empty)
	#   2. No underexposure (the 0:10 value almost empty)
	#   3. Average value = 172
	def calculateError(self):
		a = 10 # primary coef   (overexposure)
		b = 5  # secondary coef (underexposure)
		c = 0.3  # tertiary coef  (average)
		
		# Keep track of previous error values for D control
		self.oldError2 = self.oldError1
		self.oldError1 = self.error
		
		# Calculate the new error
		self.error = -a * getWeightedAverage(self.histogram[240:255]) + b * getWeightedAverage(self.histogram[0:10])
		# The target histogram average is 172 to keep the image well lit
		self.error += c * (172 - getWeightedAverage(self.histogram))
		
		# Determine D error
		self.dError = self.error - sum([self.oldError1, self.oldError2], 0.0) / 2
		
		debugPrint("Yl�ka: %d, alaka: %d, painoka: %d" % (getWeightedAverage(self.histogram[240:255]), getWeightedAverage(self.histogram[0:10]), getWeightedAverage(self.histogram)))
	
	def updateCumulativeError(self):
		self.iError += self.timestep * self.error
		self.iError = min(max(self.iError, -self.iLimit), self.iLimit)
	
	# Get current error signal based on the histogram
	def getError(self):
		return self.error
	
	# Write PWM value to microcontroller
	def write(self, value):
		# Do additional sanity checking
		value = max(0, min(value, 255))
		# Write the value to the serial bus as a byte
		self.serial.write(chr(int(value)))

# Returns a weighted sum of the array elements, the indices acting as the weight 
def getWeightedAverage(arr):
	weightedSum = 0
	for i in range(len(arr)):
		weightedSum += i * arr[i]
	if sum(arr) > 0:
		return float(weightedSum) / sum(arr)
	else:
		return 0

def debugPrint(msg):
	global config
	if config['debug']:
		print(msg)

# Execute main code
if __name__ == "__main__":
    sys.exit(main())
