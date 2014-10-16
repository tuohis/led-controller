#######################################################
# The class is given a pySerial.Serial object. The    #
# thread monitors the serial connection and prints    #
# everything that comes through.                      #
# @author Mikko Tuohimaa                              #
#######################################################

# PySerial, may have to be installed separately depending
# on the distro
import serial
import threading
import time

class SerialInputMonitor(threading.Thread):
	def __init__(self, serial):
		threading.Thread.__init__(self)
		self.serial = serial
		self.target = '' # make something up here
		self.stop = False
	
	# Thread runs along and prints incoming data until
	# the program or the connection is terminated
	def run(self):
		while (not self.stop) and self.serial.isOpen():
			if self.serial.inWaiting() > 0:
				print self.serial.readline()
			time.sleep(0.1)
	
	def halt(self):
		self.stop = True
