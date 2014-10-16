#######################################################
# The class monitors the histogram it fetches from    #
# a Controller object. ATM not very functional due to #
# threading issues with numpy/matplotlib.             #
# @author Mikko Tuohimaa                              #
#######################################################

# Non-standard libraries; may have to be installed separately
# depending on the Python distribution
import matplotlib as mpl
import numpy as npy
import pylab
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

class HistogramMonitor:
	def __init__(self, control):
		self.control = control
		print('Initing graph..')
		self.fig = plt.figure()
		self.ax = self.fig.add_subplot(1, 1, 1)
		self.canvas = FigureCanvas(self.fig)
		# Hold = False -> the new chart replaces the old
		self.ax.hold(False)
		#plt.ion() # start interactive mode to get the figure
		self.ax.bar(range(256), [0]*256)
		self.ax.set_xlabel('Brightness')
		self.ax.set_ylabel('n')
		self.canvas.print_figure('Histogram')
		#time.sleep(1)
		print('Graph drawn!')
	
	def update(self):
		newHistogram = self.control.getNewHistogram()
		newError = self.control.getError()
		# Update graph if the histogram has been updated
		if newHistogram:
			self.ax.bar(range(len(newHistogram)), newHistogram)
			print("Plotted a new histogram")
		else:
			print("No new histogram available")
		# Update title
		#title = "Error: {0}".format(newError)
		#self.ax.title = title
		# Draw the changed plot
		self.canvas.draw()
