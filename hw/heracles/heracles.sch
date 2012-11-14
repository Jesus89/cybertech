EESchema Schematic File Version 2  date Wed 14 Nov 2012 06:54:59 AM CET
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
LIBS:motor_drivers
LIBS:bluetooth
LIBS:power_converter
LIBS:reflective_sensor
LIBS:74
LIBS:microcontroller
LIBS:heracles-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 5
Title ""
Date "14 nov 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	3600 4250 4150 4250
Wire Wire Line
	3600 4250 3600 3500
Connection ~ 2600 3500
Wire Wire Line
	3600 3500 2600 3500
Connection ~ 2600 1600
Wire Wire Line
	2600 2950 2600 1600
Wire Wire Line
	2350 2450 3200 2450
Wire Wire Line
	2350 1600 3200 1600
Connection ~ 2800 3550
Wire Wire Line
	2800 3550 3550 3550
Connection ~ 2800 2450
Wire Wire Line
	2800 2950 2800 2450
Wire Wire Line
	4600 2450 5350 2450
Wire Wire Line
	5050 2950 5050 1800
Connection ~ 3300 1800
Connection ~ 5050 2650
Wire Wire Line
	3300 1800 3300 1400
Wire Wire Line
	9350 5500 8950 5500
Wire Wire Line
	8950 5500 8950 5450
Wire Wire Line
	8950 5450 8550 5450
Wire Wire Line
	9350 5100 8950 5100
Wire Wire Line
	8950 5100 8950 5050
Wire Wire Line
	8950 5050 8550 5050
Wire Wire Line
	4150 4950 2950 4950
Wire Wire Line
	4150 5250 2950 5250
Wire Wire Line
	7550 4950 6350 4950
Wire Wire Line
	7550 5150 6350 5150
Wire Wire Line
	6350 5350 7550 5350
Wire Wire Line
	7550 5350 7550 5400
Wire Wire Line
	7550 5700 7200 5700
Wire Wire Line
	7250 4000 6750 4000
Wire Wire Line
	6750 4000 6750 4350
Wire Wire Line
	6750 4350 6350 4350
Wire Wire Line
	6350 4450 6850 4450
Wire Wire Line
	6850 4450 6850 4150
Wire Wire Line
	6850 4150 7250 4150
Wire Wire Line
	7550 5450 6350 5450
Wire Wire Line
	7550 5250 6350 5250
Wire Wire Line
	7550 5050 6350 5050
Wire Wire Line
	2950 5350 4150 5350
Wire Wire Line
	2950 5050 4150 5050
Wire Wire Line
	8550 4950 8950 4950
Wire Wire Line
	8950 4950 8950 4900
Wire Wire Line
	8950 4900 9350 4900
Wire Wire Line
	8550 5350 8950 5350
Wire Wire Line
	8950 5350 8950 5300
Wire Wire Line
	8950 5300 9350 5300
Wire Wire Line
	3200 1600 3200 1400
Wire Wire Line
	3400 1400 3400 1600
Wire Wire Line
	3400 1600 5350 1600
Wire Wire Line
	4850 2950 4850 2450
Connection ~ 4850 2450
Wire Wire Line
	4600 2650 5350 2650
Wire Wire Line
	2800 3450 2800 3600
Wire Wire Line
	2800 4100 2800 4350
Wire Wire Line
	2600 4100 2600 4350
Wire Wire Line
	5050 1800 2350 1800
Wire Wire Line
	2350 2650 3200 2650
Wire Wire Line
	2600 3600 2600 3450
Wire Wire Line
	3550 3550 3550 4350
Wire Wire Line
	3550 4350 4150 4350
$Comp
L R R?
U 1 1 50A3318F
P 2600 3200
F 0 "R?" V 2680 3200 50  0000 C CNN
F 1 "10k" V 2600 3200 50  0000 C CNN
	1    2600 3200
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 50A3318E
P 2600 3850
F 0 "R?" V 2680 3850 50  0000 C CNN
F 1 "10k" V 2600 3850 50  0000 C CNN
	1    2600 3850
	1    0    0    -1  
$EndComp
Text Label 2600 4350 1    60   ~ 0
GND
Text Label 2800 4350 1    60   ~ 0
GND
$Comp
L R R?
U 1 1 50A3307A
P 2800 3850
F 0 "R?" V 2880 3850 50  0000 C CNN
F 1 "10k" V 2800 3850 50  0000 C CNN
	1    2800 3850
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 50A33076
P 2800 3200
F 0 "R?" V 2880 3200 50  0000 C CNN
F 1 "10k" V 2800 3200 50  0000 C CNN
	1    2800 3200
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P?
U 1 1 50A32F64
P 4950 3300
F 0 "P?" V 4900 3300 40  0000 C CNN
F 1 "3V3OUT" V 5000 3300 40  0000 C CNN
	1    4950 3300
	0    1    1    0   
$EndComp
Text GLabel 5350 1600 2    60   Output ~ 0
VMOT
$Comp
L CONN_3 K?
U 1 1 50A32E8E
P 3300 1050
F 0 "K?" V 3250 1050 50  0000 C CNN
F 1 "MCONV" V 3350 1050 40  0000 C CNN
	1    3300 1050
	0    -1   -1   0   
$EndComp
Text GLabel 5350 2650 2    60   Output ~ 0
GND
Text GLabel 5350 2450 2    60   Output ~ 0
3V3
$Sheet
S 3200 2300 1400 500 
U 50A32263
F0 "Logic power converter" 60
F1 "logic_power_converter.sch" 60
F2 "GND" O R 4600 2650 60 
F3 "3V3" O R 4600 2450 60 
F4 "VBAT-" I L 3200 2650 60 
F5 "VBAT+" I L 3200 2450 60 
$EndSheet
$Comp
L CONN_2 P?
U 1 1 50A321E8
P 2000 1700
F 0 "P?" V 1950 1700 40  0000 C CNN
F 1 "MLIPO" V 2050 1700 40  0000 C CNN
	1    2000 1700
	-1   0    0    1   
$EndComp
$Comp
L CONN_2 P?
U 1 1 50A321DD
P 2000 2550
F 0 "P?" V 1950 2550 40  0000 C CNN
F 1 "LLIPO" V 2050 2550 40  0000 C CNN
	1    2000 2550
	-1   0    0    1   
$EndComp
Text Label 7200 5700 0    60   ~ 0
3V3
$Comp
L CONN_2 P?
U 1 1 50A31C57
P 9700 5000
F 0 "P?" V 9650 5000 40  0000 C CNN
F 1 "MOTORA" V 9750 5000 40  0000 C CNN
	1    9700 5000
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P?
U 1 1 50A31C51
P 9700 5400
F 0 "P?" V 9650 5400 40  0000 C CNN
F 1 "MOTORB" V 9750 5400 40  0000 C CNN
	1    9700 5400
	1    0    0    -1  
$EndComp
$Comp
L MAPLE_MINI U?
U 1 1 50A31370
P 5250 4800
F 0 "U?" H 4500 5900 60  0000 C CNN
F 1 "MAPLE_MINI" H 4700 3700 60  0000 C CNN
	1    5250 4800
	1    0    0    -1  
$EndComp
$Sheet
S 1900 4800 1050 700 
U 50A2F441
F0 "Sensor array" 60
F1 "sensor_array.sch" 60
F2 "2A" O R 2950 5050 60 
F3 "S0" I R 2950 5250 60 
F4 "1A" O R 2950 4950 60 
F5 "S1" I R 2950 5350 60 
$EndSheet
$Sheet
S 7250 3850 950  450 
U 509BC4E1
F0 "Bluetooth" 60
F1 "bluetooth.sch" 60
F2 "UART_RXD" I L 7250 4000 60 
F3 "UART_TXD" O L 7250 4150 60 
$EndSheet
$Sheet
S 7550 4750 1000 1150
U 509B0C31
F0 "Motor driver" 60
F1 "motor_driver.sch" 60
F2 "BO2" O R 8550 5450 60 
F3 "BO1" O R 8550 5350 60 
F4 "AO2" O R 8550 5050 60 
F5 "AO1" O R 8550 4950 60 
F6 "STBY" I L 7550 5700 60 
F7 "AIN1" I L 7550 5250 60 
F8 "AIN2" I L 7550 5150 60 
F9 "PWMA" I L 7550 5450 60 
F10 "PWMB" I L 7550 5350 60 
F11 "BIN2" I L 7550 4950 60 
F12 "BIN1" I L 7550 5050 60 
$EndSheet
$EndSCHEMATC
