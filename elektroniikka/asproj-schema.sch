EESchema Schematic File Version 2  date 05/05/2011 17:29:19
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title ""
Date "5 may 2011"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	4200 4000 3500 4000
Wire Wire Line
	6650 2750 6650 2850
Wire Wire Line
	4700 3700 3500 3700
Wire Wire Line
	3500 4800 4350 4800
Wire Wire Line
	4350 4300 4050 4300
Wire Wire Line
	4050 4300 4050 4000
Wire Wire Line
	3500 4000 3500 4050
Connection ~ 4050 4000
Wire Wire Line
	4200 4550 3500 4550
Connection ~ 6000 4100
Connection ~ 6150 3300
Wire Wire Line
	6150 3500 6250 3500
Wire Wire Line
	6650 4800 6650 4450
Connection ~ 6650 4600
Wire Wire Line
	6150 4100 6200 4100
Wire Wire Line
	6150 4600 6650 4600
Wire Wire Line
	6250 3500 6250 2850
Wire Wire Line
	6250 2850 6650 2850
Connection ~ 6650 2850
NoConn ~ 6150 3300
Text Label 6400 4850 0    60   ~ 0
GND
Text Label 6250 2750 0    60   ~ 0
10-12V
Text Label 3500 4900 0    60   ~ 0
ARDUINO VCC
Text Label 3500 4500 0    60   ~ 0
VREF OUT
Text Label 3450 3950 0    60   ~ 0
ARDUINO GND
Text Label 3500 3650 0    60   ~ 0
PWM IN
$Comp
L GND #PWR?
U 1 1 4DC01702
P 6650 4800
F 0 "#PWR?" H 6700 4850 60  0001 C CNN
F 1 "GND" H 6650 4800 60  0001 C CNN
F 4 "#PWR" H 6650 4800 30  0001 C CNN "Reference"
F 5 "GND" H 6650 4730 30  0001 C CNN "Value"
F 6 "" H 6650 4800 60  0000 C CNN "Footprint"
F 7 "" H 6650 4800 60  0000 C CNN "Datasheet"
	1    6650 4800
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 4DC0162C
P 3500 4800
F 0 "#PWR?" H 3550 4850 60  0001 C CNN
F 1 "+5V" H 3500 4800 60  0001 C CNN
F 4 "#PWR" H 3500 4890 20  0001 C CNN "Reference"
F 5 "+5V" H 3500 4890 30  0000 C CNN "Value"
F 6 "" H 3500 4800 60  0000 C CNN "Footprint"
F 7 "" H 3500 4800 60  0000 C CNN "Datasheet"
	1    3500 4800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 4DC0158E
P 3500 4050
F 0 "#PWR?" H 3550 4100 60  0001 C CNN
F 1 "GND" H 3500 4050 60  0001 C CNN
F 4 "#PWR" H 3500 4050 30  0001 C CNN "Reference"
F 5 "GND" H 3500 3980 30  0001 C CNN "Value"
F 6 "" H 3500 4050 60  0000 C CNN "Footprint"
F 7 "" H 3500 4050 60  0000 C CNN "Datasheet"
	1    3500 4050
	1    0    0    -1  
$EndComp
$Comp
L POT RV?
U 1 1 4DC01483
P 4350 4550
F 0 "RV?" H 4400 4600 60  0001 C CNN
F 1 "POT" H 4350 4550 60  0001 C CNN
F 4 "RV" H 4350 4450 50  0000 C CNN "Reference"
F 5 "POT" H 4350 4550 50  0000 C CNN "Value"
F 6 "" H 4350 4550 60  0000 C CNN "Footprint"
F 7 "" H 4350 4550 60  0000 C CNN "Datasheet"
	1    4350 4550
	0    -1   -1   0   
$EndComp
$Comp
L R Rs
U 1 1 4DC01431
P 6650 3100
F 0 "Rs" H 6700 3150 60  0001 C CNN
F 1 "R" H 6650 3100 60  0001 C CNN
F 4 "Rs" V 6730 3100 50  0000 C CNN "Reference"
F 5 "5" V 6650 3100 50  0000 C CNN "Value"
	1    6650 3100
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4DC0137D
P 4450 4000
F 0 "R1" H 4500 4050 60  0001 C CNN
F 1 "R" H 4450 4000 60  0001 C CNN
F 4 "R1" V 4530 4000 50  0000 C CNN "Reference"
F 5 "220" V 4450 4000 50  0000 C CNN "Value"
	1    4450 4000
	0    -1   -1   0   
$EndComp
$Comp
L R R?
U 1 1 4DC01368
P 6150 4350
F 0 "R?" H 6200 4400 60  0001 C CNN
F 1 "10k" H 6150 4350 60  0001 C CNN
F 4 "R2" V 6230 4350 50  0000 C CNN "Reference"
F 5 "10k" V 6150 4350 50  0000 C CNN "Value"
	1    6150 4350
	1    0    0    -1  
$EndComp
$Comp
L FET_N Q?
U 1 1 4DC01346
P 6500 4100
F 0 "Q?" H 6550 4150 60  0001 C CNN
F 1 "FET_N" H 6500 4100 60  0001 C CNN
F 4 "Q" H 6403 4350 70  0000 C CNN "Reference"
F 5 "IRFZ34N" H 6750 4100 60  0000 C CNN "Value"
	1    6500 4100
	1    0    0    -1  
$EndComp
$Comp
L OPTO_DARLINGTON Optocoupler
U 1 1 4DC012CE
P 5350 3900
F 0 "Optocoupler" H 5850 4650 60  0000 C CNN
F 1 "4N26" H 5450 3400 60  0000 C CNN
	1    5350 3900
	1    0    0    -1  
$EndComp
$Comp
L LED LED780-66-60
U 1 1 4DC01167
P 6650 3550
F 0 "LED780-66-60" H 6650 3650 50  0000 C CNN
F 1 "LED" H 6650 3450 50  0000 C CNN
F 4 "LED780-66-60" H 6650 3550 60  0001 C CNN "Reference"
	1    6650 3550
	0    1    1    0   
$EndComp
$Comp
L VCC #PWR?
U 1 1 4DC01127
P 6650 2750
F 0 "#PWR?" H 6650 2850 30  0001 C CNN
F 1 "VCC" H 6650 2850 30  0000 C CNN
	1    6650 2750
	1    0    0    -1  
$EndComp
$EndSCHEMATC
