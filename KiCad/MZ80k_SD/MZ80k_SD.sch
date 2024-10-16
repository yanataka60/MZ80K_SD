EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr User 13780 9843
encoding utf-8
Sheet 1 1
Title "MZ-80K_SD"
Date "2022-01-14"
Rev "Rev1.5.5"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Arduino:Arduino_Pro_Mini U4
U 1 1 61A254A8
P 10650 4700
F 0 "U4" H 10650 5589 60  0000 C CNN
F 1 "Arduino_Pro_Mini_5V" H 10650 5483 60  0000 C CNN
F 2 "MZ80k_SD:Arduino_Pro_Mini" H 11450 3950 60  0001 C CNN
F 3 "https://www.sparkfun.com/products/11113" H 10850 3500 60  0001 C CNN
	1    10650 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 2900 4700 2900
Wire Wire Line
	2100 3000 4600 3000
Wire Wire Line
	2100 3100 4500 3100
Wire Wire Line
	2100 3200 4400 3200
Wire Wire Line
	1600 3200 1350 3200
Wire Wire Line
	1350 3200 1350 6600
Wire Wire Line
	1350 6600 3100 6600
Wire Wire Line
	1600 3400 1250 3400
Wire Wire Line
	1250 3400 1250 6700
Wire Wire Line
	1250 6700 5150 6700
Wire Wire Line
	1600 3600 1150 3600
Wire Wire Line
	1150 3600 1150 6800
Wire Wire Line
	1600 3800 1050 3800
Wire Wire Line
	1050 3800 1050 6900
Wire Wire Line
	6100 3400 6400 3400
Wire Wire Line
	2100 4400 3100 4400
Wire Wire Line
	3100 4400 3100 1800
Wire Wire Line
	3100 1800 6400 1800
Wire Wire Line
	2100 4300 3000 4300
Wire Wire Line
	3000 4300 3000 1900
Wire Wire Line
	3000 1900 6400 1900
Wire Wire Line
	4800 4200 4800 2000
Wire Wire Line
	4800 2000 6400 2000
Wire Wire Line
	4900 4100 4900 2100
Wire Wire Line
	4900 2100 6400 2100
Wire Wire Line
	5000 4000 5000 2200
Wire Wire Line
	5000 2200 6400 2200
Wire Wire Line
	5100 3900 5100 2300
Wire Wire Line
	5100 2300 6400 2300
Wire Wire Line
	5200 3800 5200 2400
Wire Wire Line
	5200 2400 6400 2400
Wire Wire Line
	5300 3700 5300 2500
Wire Wire Line
	5300 2500 6400 2500
Wire Wire Line
	2100 3600 5400 3600
Wire Wire Line
	5400 3600 5400 2600
Wire Wire Line
	5400 2600 6400 2600
Wire Wire Line
	2100 3500 5500 3500
Wire Wire Line
	5500 3500 5500 2700
Wire Wire Line
	5500 2700 6400 2700
Wire Wire Line
	2100 3400 5600 3400
Wire Wire Line
	5600 3400 5600 2800
Wire Wire Line
	5600 2800 6400 2800
Wire Wire Line
	2100 3300 5700 3300
Wire Wire Line
	5700 3300 5700 2900
Wire Wire Line
	5700 2900 6400 2900
Wire Wire Line
	2100 4600 2900 4600
Wire Wire Line
	2100 4700 2800 4700
Wire Wire Line
	2100 4800 2700 4800
Wire Wire Line
	2100 4900 2600 4900
Wire Wire Line
	2100 5000 2500 5000
Wire Wire Line
	2100 5100 2400 5100
Wire Wire Line
	2100 5200 2300 5200
Wire Wire Line
	2100 5300 2200 5300
Connection ~ 3100 4400
Connection ~ 3000 4300
Wire Wire Line
	1600 4400 950  4400
Wire Wire Line
	950  4400 950  7000
Wire Wire Line
	950  7000 7950 7000
Wire Wire Line
	7950 7000 7950 3600
$Comp
L power:+5V #PWR05
U 1 1 61C53293
P 6800 1600
F 0 "#PWR05" H 6800 1450 50  0001 C CNN
F 1 "+5V" H 6815 1773 50  0000 C CNN
F 2 "" H 6800 1600 50  0001 C CNN
F 3 "" H 6800 1600 50  0001 C CNN
	1    6800 1600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR06
U 1 1 61CA5FA4
P 6800 3750
F 0 "#PWR06" H 6800 3500 50  0001 C CNN
F 1 "GND" H 6805 3577 50  0000 C CNN
F 2 "" H 6800 3750 50  0001 C CNN
F 3 "" H 6800 3750 50  0001 C CNN
	1    6800 3750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR01
U 1 1 61CAF7EF
P 800 4700
F 0 "#PWR01" H 800 4450 50  0001 C CNN
F 1 "GND" H 805 4527 50  0000 C CNN
F 2 "" H 800 4700 50  0001 C CNN
F 3 "" H 800 4700 50  0001 C CNN
	1    800  4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 4500 1450 4500
Wire Wire Line
	800  4500 800  4700
Wire Wire Line
	7950 3600 8150 3600
Wire Wire Line
	3000 4300 3000 4500
$Comp
L Interface:8255 U3
U 1 1 618A36EE
P 8850 4900
F 0 "U3" H 8450 6400 50  0000 C CNN
F 1 "8255" H 9250 6400 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_LongPads" H 8850 5200 50  0001 C CNN
F 3 "http://aturing.umcs.maine.edu/~meadow/courses/cos335/Intel8255A.pdf" H 8850 5200 50  0001 C CNN
	1    8850 4900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 61E99EF6
P 6450 3750
F 0 "C2" V 6300 3850 50  0000 C CNN
F 1 "0.1uF" V 6300 3600 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L4.0mm_W2.5mm_P2.50mm" H 6488 3600 50  0001 C CNN
F 3 "~" H 6450 3750 50  0001 C CNN
	1    6450 3750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6600 3750 6800 3750
Wire Wire Line
	6800 3700 6800 3750
Connection ~ 6800 3750
Wire Wire Line
	6300 3750 6300 3300
Wire Wire Line
	6300 1600 6800 1600
$Comp
L Device:C C3
U 1 1 61F2D5C6
P 8350 6550
F 0 "C3" V 8200 6650 50  0000 C CNN
F 1 "0.1uF" V 8200 6400 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L4.0mm_W2.5mm_P2.50mm" H 8388 6400 50  0001 C CNN
F 3 "~" H 8350 6550 50  0001 C CNN
	1    8350 6550
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR08
U 1 1 61F38F70
P 8850 6600
F 0 "#PWR08" H 8850 6350 50  0001 C CNN
F 1 "GND" H 8855 6427 50  0000 C CNN
F 2 "" H 8850 6600 50  0001 C CNN
F 3 "" H 8850 6600 50  0001 C CNN
	1    8850 6600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 6550 8850 6550
Wire Wire Line
	8850 6550 8850 6600
Wire Wire Line
	8850 6500 8850 6550
Connection ~ 8850 6550
Wire Wire Line
	8200 6550 8100 6550
Wire Wire Line
	8100 6550 8100 3300
Wire Wire Line
	8100 3300 8850 3300
$Comp
L power:+5V #PWR07
U 1 1 61F63930
P 8850 3300
F 0 "#PWR07" H 8850 3150 50  0001 C CNN
F 1 "+5V" H 8865 3473 50  0000 C CNN
F 2 "" H 8850 3300 50  0001 C CNN
F 3 "" H 8850 3300 50  0001 C CNN
	1    8850 3300
	1    0    0    -1  
$EndComp
Connection ~ 8850 3300
Wire Wire Line
	11600 6100 11600 4800
Wire Wire Line
	11600 4800 11250 4800
Wire Wire Line
	9550 5600 9700 5600
Wire Wire Line
	9700 5600 9700 6200
Wire Wire Line
	9700 6200 11700 6200
Wire Wire Line
	11700 6200 11700 4700
Wire Wire Line
	11700 4700 11250 4700
Wire Wire Line
	11700 3600 11700 4600
Wire Wire Line
	11700 4600 11250 4600
Wire Wire Line
	11600 3700 11600 4500
Wire Wire Line
	11600 4500 11250 4500
Wire Wire Line
	9900 3800 9900 5700
Wire Wire Line
	9900 5700 10750 5700
Wire Wire Line
	10750 5700 10750 5600
Wire Wire Line
	9800 3900 9800 5800
Wire Wire Line
	9800 5800 10850 5800
Wire Wire Line
	10850 5800 10850 5600
$Comp
L power:GND #PWR09
U 1 1 621A9C99
P 11350 5400
F 0 "#PWR09" H 11350 5150 50  0001 C CNN
F 1 "GND" H 11355 5227 50  0000 C CNN
F 2 "" H 11350 5400 50  0001 C CNN
F 3 "" H 11350 5400 50  0001 C CNN
	1    11350 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	11250 4200 11350 4200
Wire Wire Line
	11350 4200 11350 5400
$Comp
L power:+5V #PWR010
U 1 1 621E99AD
P 11450 4100
F 0 "#PWR010" H 11450 3950 50  0001 C CNN
F 1 "+5V" H 11465 4273 50  0000 C CNN
F 2 "" H 11450 4100 50  0001 C CNN
F 3 "" H 11450 4100 50  0001 C CNN
	1    11450 4100
	1    0    0    -1  
$EndComp
NoConn ~ 9550 4000
NoConn ~ 9550 4100
NoConn ~ 9550 4200
NoConn ~ 9550 4300
NoConn ~ 9550 5400
NoConn ~ 9550 5500
NoConn ~ 9550 5700
NoConn ~ 9550 5800
NoConn ~ 9550 5900
NoConn ~ 9550 6000
Wire Wire Line
	6400 3200 6300 3200
Connection ~ 6300 3200
Wire Wire Line
	6300 3200 6300 3100
$Comp
L power:GND #PWR04
U 1 1 622D4BBF
P 5100 1550
F 0 "#PWR04" H 5100 1300 50  0001 C CNN
F 1 "GND" H 5105 1377 50  0000 C CNN
F 2 "" H 5100 1550 50  0001 C CNN
F 3 "" H 5100 1550 50  0001 C CNN
	1    5100 1550
	1    0    0    -1  
$EndComp
NoConn ~ 1600 2900
NoConn ~ 1600 3000
NoConn ~ 1600 3900
NoConn ~ 1600 4000
NoConn ~ 1600 4200
NoConn ~ 1600 4300
NoConn ~ 2100 4500
NoConn ~ 11250 4100
NoConn ~ 11250 4300
NoConn ~ 10650 5600
NoConn ~ 10550 5600
NoConn ~ 10050 4400
NoConn ~ 10050 4200
NoConn ~ 10050 4100
Wire Wire Line
	11250 4400 11450 4400
Wire Wire Line
	11450 4400 11450 4100
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 626B92AA
P 9950 2200
F 0 "#FLG0101" H 9950 2275 50  0001 C CNN
F 1 "PWR_FLAG" H 9950 2373 50  0000 C CNN
F 2 "" H 9950 2200 50  0001 C CNN
F 3 "~" H 9950 2200 50  0001 C CNN
	1    9950 2200
	1    0    0    -1  
$EndComp
$Comp
L Connector:Jack-DC J4
U 1 1 6287BB15
P 8100 1500
F 0 "J4" H 7850 1750 50  0000 C CNN
F 1 "EXT 5V" H 8157 1734 50  0000 C CNN
F 2 "Connector_BarrelJack:BarrelJack_Horizontal" H 8150 1460 50  0001 C CNN
F 3 "~" H 8150 1460 50  0001 C CNN
	1    8100 1500
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J3
U 1 1 6287C72E
P 7950 2000
F 0 "J3" H 8050 2100 50  0000 C CNN
F 1 "INT VCC" H 7868 2126 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Horizontal" H 7950 2000 50  0001 C CNN
F 3 "~" H 7950 2000 50  0001 C CNN
	1    7950 2000
	-1   0    0    -1  
$EndComp
NoConn ~ 8150 2100
$Comp
L power:+5V #PWR015
U 1 1 62901E30
P 9650 2100
F 0 "#PWR015" H 9650 1950 50  0001 C CNN
F 1 "+5V" H 9665 2273 50  0000 C CNN
F 2 "" H 9650 2100 50  0001 C CNN
F 3 "" H 9650 2100 50  0001 C CNN
	1    9650 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	9650 2100 9650 2200
Wire Wire Line
	9650 2200 9950 2200
Connection ~ 9650 2200
$Comp
L Memory_RAM2:SLIDE_SWITCH_3P S1
U 1 1 62949B85
P 9100 1800
F 0 "S1" H 9100 1865 50  0000 C CNN
F 1 "INT/EXT" H 9100 1774 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 9100 1825 50  0001 C CNN
F 3 "" H 9100 1825 50  0001 C CNN
	1    9100 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9100 2150 9100 2200
Wire Wire Line
	9100 2200 9650 2200
Wire Wire Line
	8150 2000 8900 2000
$Comp
L power:GND #PWR0102
U 1 1 62BDE6ED
P 8500 1650
F 0 "#PWR0102" H 8500 1400 50  0001 C CNN
F 1 "GND" H 8505 1477 50  0000 C CNN
F 2 "" H 8500 1650 50  0001 C CNN
F 3 "" H 8500 1650 50  0001 C CNN
	1    8500 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	8400 1600 8500 1600
Wire Wire Line
	8500 1600 8500 1650
$Comp
L Connector_Generic:Conn_02x25_Odd_Even J1
U 1 1 61ABAF01
P 1900 4100
F 0 "J1" H 1950 2675 50  0000 C CNN
F 1 "MZ-80K BUS" H 1950 2766 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x25_P2.54mm_Horizontal" H 1900 4100 50  0001 C CNN
F 3 "~" H 1900 4100 50  0001 C CNN
	1    1900 4100
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8400 1400 9500 1400
Wire Wire Line
	9500 1400 9500 2000
Wire Wire Line
	9500 2000 9300 2000
$Comp
L Memory_RAM2:SLIDE_SWITCH_3P S2
U 1 1 61BBFE3F
P 5450 1300
F 0 "S2" H 5300 1250 50  0000 C CNN
F 1 "SD/CMT" H 5650 1250 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 5450 1325 50  0001 C CNN
F 3 "" H 5450 1325 50  0001 C CNN
	1    5450 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 3000 5800 3000
Wire Wire Line
	5800 3000 5800 1650
Wire Wire Line
	5800 1650 5450 1650
Wire Wire Line
	5100 1550 5100 1500
Wire Wire Line
	5100 1500 5250 1500
Wire Wire Line
	5650 1500 6300 1500
Wire Wire Line
	6300 1500 6300 1600
Connection ~ 6300 1600
$Comp
L power:PWR_FLAG #FLG01
U 1 1 61C4340B
P 800 4300
F 0 "#FLG01" H 800 4375 50  0001 C CNN
F 1 "PWR_FLAG" H 800 4473 50  0000 C CNN
F 2 "" H 800 4300 50  0001 C CNN
F 3 "~" H 800 4300 50  0001 C CNN
	1    800  4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	800  4300 800  4500
Connection ~ 800  4500
$Comp
L Device:CP1 C6
U 1 1 61AFFCD6
P 9650 2350
F 0 "C6" H 9765 2396 50  0000 L CNN
F 1 "100uF" H 9765 2305 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 9650 2350 50  0001 C CNN
F 3 "~" H 9650 2350 50  0001 C CNN
	1    9650 2350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR013
U 1 1 61B04D1B
P 9650 2500
F 0 "#PWR013" H 9650 2250 50  0001 C CNN
F 1 "GND" H 9655 2327 50  0000 C CNN
F 2 "" H 9650 2500 50  0001 C CNN
F 3 "" H 9650 2500 50  0001 C CNN
	1    9650 2500
	1    0    0    -1  
$EndComp
Connection ~ 6800 1600
$Comp
L Memory_EPROM:27C64 U2
U 1 1 61A4CF3B
P 6800 2600
F 0 "U2" H 6600 3550 50  0000 C CNN
F 1 "2764" H 7000 3550 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_LongPads" H 6800 2600 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/11107M.pdf" H 6800 2600 50  0001 C CNN
	1    6800 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 3300 6300 3300
Connection ~ 6300 3300
Wire Wire Line
	6300 3300 6300 3200
Wire Wire Line
	11250 2100 11250 2750
Wire Wire Line
	11400 2100 11250 2100
$Comp
L power:GND #PWR012
U 1 1 625DAB5A
P 11250 2750
F 0 "#PWR012" H 11250 2500 50  0001 C CNN
F 1 "GND" H 11255 2577 50  0000 C CNN
F 2 "" H 11250 2750 50  0001 C CNN
F 3 "" H 11250 2750 50  0001 C CNN
	1    11250 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	11250 1800 11400 1800
Wire Wire Line
	11250 1650 11250 1800
$Comp
L power:+5V #PWR011
U 1 1 625CD0DA
P 11250 1650
F 0 "#PWR011" H 11250 1500 50  0001 C CNN
F 1 "+5V" H 11265 1823 50  0000 C CNN
F 2 "" H 11250 1650 50  0001 C CNN
F 3 "" H 11250 1650 50  0001 C CNN
	1    11250 1650
	1    0    0    -1  
$EndComp
NoConn ~ 11400 2600
NoConn ~ 11400 2000
NoConn ~ 11400 1900
$Comp
L Memory_RAM2:Micro_SD_Card_Kit J2
U 1 1 6188B7C4
P 12300 2100
F 0 "J2" H 11800 2800 50  0000 L CNN
F 1 "Micro_SD_Card_Kit" H 12300 2800 50  0000 L CNN
F 2 "MZ80k_SD:AE-microSD-LLCNV" H 13450 2400 50  0001 C CNN
F 3 "http://katalog.we-online.de/em/datasheet/693072010801.pdf" H 12300 2100 50  0001 C CNN
	1    12300 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	9550 3900 9800 3900
Wire Wire Line
	9550 3800 9900 3800
Wire Wire Line
	9550 3700 11600 3700
Wire Wire Line
	9550 3600 11700 3600
Wire Wire Line
	11400 2500 11100 2500
Wire Wire Line
	11100 2500 11100 3500
Wire Wire Line
	11100 3500 12000 3500
Wire Wire Line
	12000 3500 12000 5200
Wire Wire Line
	12000 5200 11250 5200
Wire Wire Line
	11400 2400 11000 2400
Wire Wire Line
	11000 2400 11000 3400
Wire Wire Line
	11000 3400 12100 3400
Wire Wire Line
	12100 3400 12100 5100
Wire Wire Line
	12100 5100 11250 5100
Wire Wire Line
	11400 2300 10900 2300
Wire Wire Line
	10900 2300 10900 3300
Wire Wire Line
	10900 3300 12200 3300
Wire Wire Line
	12200 3300 12200 5000
Wire Wire Line
	12200 5000 11250 5000
Wire Wire Line
	11400 2200 10800 2200
Wire Wire Line
	10800 2200 10800 3200
Wire Wire Line
	10800 3200 12300 3200
Wire Wire Line
	12300 3200 12300 4900
Wire Wire Line
	12300 4900 11250 4900
Wire Wire Line
	1600 5300 1450 5300
Wire Wire Line
	1450 5300 1450 5200
Connection ~ 1450 4500
Wire Wire Line
	1450 4500 800  4500
Wire Wire Line
	1600 4600 1450 4600
Connection ~ 1450 4600
Wire Wire Line
	1450 4600 1450 4500
Wire Wire Line
	1600 4700 1450 4700
Connection ~ 1450 4700
Wire Wire Line
	1450 4700 1450 4600
Wire Wire Line
	1600 4800 1450 4800
Connection ~ 1450 4800
Wire Wire Line
	1450 4800 1450 4700
Wire Wire Line
	1600 4900 1450 4900
Connection ~ 1450 4900
Wire Wire Line
	1450 4900 1450 4800
Wire Wire Line
	1600 5000 1450 5000
Connection ~ 1450 5000
Wire Wire Line
	1450 5000 1450 4900
Wire Wire Line
	1600 5100 1450 5100
Connection ~ 1450 5100
Wire Wire Line
	1450 5100 1450 5000
Wire Wire Line
	1600 5200 1450 5200
Connection ~ 1450 5200
Wire Wire Line
	1450 5200 1450 5100
Wire Wire Line
	1450 4500 1450 4100
Wire Wire Line
	1450 4100 1600 4100
Wire Wire Line
	1450 4100 1450 3700
Wire Wire Line
	1450 3700 1600 3700
Connection ~ 1450 4100
Wire Wire Line
	1450 3700 1450 3500
Wire Wire Line
	1450 3500 1600 3500
Connection ~ 1450 3700
Wire Wire Line
	1450 3500 1450 3300
Wire Wire Line
	1450 3300 1600 3300
Connection ~ 1450 3500
Wire Wire Line
	1450 3300 1450 3100
Wire Wire Line
	1450 3100 1600 3100
Connection ~ 1450 3300
Wire Wire Line
	3000 4500 8150 4500
Wire Wire Line
	3100 4400 8150 4400
Wire Wire Line
	7650 4800 7650 1800
Wire Wire Line
	7600 4900 7600 1900
Wire Wire Line
	7550 5000 7550 2000
Wire Wire Line
	7500 5100 7500 2100
Wire Wire Line
	7450 5200 7450 2200
Wire Wire Line
	7400 5300 7400 2300
Wire Wire Line
	7350 5400 7350 2400
Wire Wire Line
	7300 5500 7300 2500
Wire Wire Line
	2200 5300 2200 1250
Wire Wire Line
	2200 1250 7650 1250
Wire Wire Line
	7650 1250 7650 1800
Connection ~ 7650 1800
Wire Wire Line
	2300 5200 2300 1150
Wire Wire Line
	2300 1150 7600 1150
Wire Wire Line
	7600 1150 7600 1900
Connection ~ 7600 1900
Wire Wire Line
	2400 5100 2400 1050
Wire Wire Line
	2400 1050 7550 1050
Wire Wire Line
	7550 1050 7550 2000
Connection ~ 7550 2000
Wire Wire Line
	2500 5000 2500 950 
Wire Wire Line
	2500 950  7500 950 
Wire Wire Line
	7500 950  7500 2100
Connection ~ 7500 2100
Wire Wire Line
	2600 4900 2600 850 
Wire Wire Line
	2600 850  7450 850 
Wire Wire Line
	7450 850  7450 2200
Connection ~ 7450 2200
Wire Wire Line
	2700 4800 2700 750 
Wire Wire Line
	2700 750  7400 750 
Wire Wire Line
	7400 750  7400 2300
Connection ~ 7400 2300
Wire Wire Line
	2800 4700 2800 650 
Wire Wire Line
	2800 650  7350 650 
Wire Wire Line
	7350 650  7350 2400
Connection ~ 7350 2400
Wire Wire Line
	2900 4600 2900 550 
Wire Wire Line
	2900 550  7300 550 
Wire Wire Line
	7300 550  7300 2500
Connection ~ 7300 2500
Wire Wire Line
	7200 1800 7650 1800
Wire Wire Line
	7200 1900 7600 1900
Wire Wire Line
	7200 2000 7550 2000
Wire Wire Line
	7200 2100 7500 2100
Wire Wire Line
	7200 2200 7450 2200
Wire Wire Line
	7200 2300 7400 2300
Wire Wire Line
	7200 2400 7350 2400
Wire Wire Line
	7200 2500 7300 2500
Wire Wire Line
	7050 3900 8150 3900
Wire Wire Line
	7750 6800 7750 4000
Wire Wire Line
	7750 4000 8150 4000
Wire Wire Line
	1150 6800 5950 6800
Wire Wire Line
	7850 6900 7850 4100
Wire Wire Line
	7850 4100 8150 4100
Wire Wire Line
	1050 6900 7850 6900
Wire Wire Line
	7650 4800 8150 4800
Wire Wire Line
	7600 4900 8150 4900
Wire Wire Line
	7550 5000 8150 5000
Wire Wire Line
	7500 5100 8150 5100
Wire Wire Line
	7450 5200 8150 5200
Wire Wire Line
	7400 5300 8150 5300
Wire Wire Line
	7350 5400 8150 5400
Wire Wire Line
	7300 5500 8150 5500
Wire Wire Line
	2100 3700 3700 3700
Wire Wire Line
	2100 3800 3600 3800
Wire Wire Line
	2100 3900 3500 3900
Wire Wire Line
	2100 4000 3400 4000
Wire Wire Line
	2100 4100 3300 4100
Wire Wire Line
	5950 3500 5950 6800
Wire Wire Line
	5950 3500 6400 3500
Connection ~ 5950 6800
Wire Wire Line
	5950 6800 7750 6800
$Comp
L 74xx:74LS30 U5
U 1 1 620D1DFE
P 5200 4900
F 0 "U5" H 5550 5000 50  0000 C CNN
F 1 "74LS30" H 5500 4800 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 5200 4900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS30" H 5200 4900 50  0001 C CNN
	1    5200 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 2900 4700 4600
Wire Wire Line
	4700 4600 4900 4600
Wire Wire Line
	4600 3000 4600 4700
Wire Wire Line
	4600 4700 4900 4700
Wire Wire Line
	4500 3100 4500 4800
Wire Wire Line
	4500 4800 4900 4800
Wire Wire Line
	4400 3200 4400 4900
Wire Wire Line
	4400 4900 4900 4900
$Comp
L 74xx:74LS04 U1
U 1 1 6212ABE9
P 4300 5000
F 0 "U1" H 4300 5317 50  0000 C CNN
F 1 "74LS04" H 4300 5226 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 4300 5000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 4300 5000 50  0001 C CNN
	1    4300 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 5000 4900 5000
Wire Wire Line
	4000 5000 3100 5000
Wire Wire Line
	3100 5000 3100 6600
Wire Wire Line
	4900 5100 4900 5200
Connection ~ 4900 5200
Wire Wire Line
	4900 5200 4900 5300
$Comp
L power:+5V #PWR03
U 1 1 62174D5D
P 4650 5450
F 0 "#PWR03" H 4650 5300 50  0001 C CNN
F 1 "+5V" H 4665 5623 50  0000 C CNN
F 2 "" H 4650 5450 50  0001 C CNN
F 3 "" H 4650 5450 50  0001 C CNN
	1    4650 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 5300 4900 5500
Wire Wire Line
	4900 5500 4650 5500
Wire Wire Line
	4650 5500 4650 5450
Connection ~ 4900 5300
Wire Wire Line
	5500 4900 6100 4900
$Comp
L 74xx:74LS30 U6
U 2 1 621D8C3B
P 7900 8100
F 0 "U6" H 8130 8146 50  0000 L CNN
F 1 "74LS30" H 8130 8055 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 7900 8100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS30" H 7900 8100 50  0001 C CNN
	2    7900 8100
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS30 U6
U 1 1 621DA5E3
P 6650 5950
F 0 "U6" H 6650 6475 50  0000 C CNN
F 1 "74LS30" H 6650 6384 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 6650 5950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS30" H 6650 5950 50  0001 C CNN
	1    6650 5950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS30 U5
U 2 1 621FB49F
P 6800 8100
F 0 "U5" H 7030 8146 50  0000 L CNN
F 1 "74LS30" H 7030 8055 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 6800 8100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS30" H 6800 8100 50  0001 C CNN
	2    6800 8100
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U1
U 7 1 62200B27
P 5700 8100
F 0 "U1" H 5930 8146 50  0000 L CNN
F 1 "74LS04" H 5930 8055 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 5700 8100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 5700 8100 50  0001 C CNN
	7    5700 8100
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 4200 3200 4200
$Comp
L 74xx:74LS04 U1
U 2 1 6232A904
P 3750 7850
F 0 "U1" H 3350 8000 50  0000 C CNN
F 1 "74LS04" H 3950 8000 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 3750 7850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 3750 7850 50  0001 C CNN
	2    3750 7850
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U1
U 3 1 6232C3F4
P 8900 2900
F 0 "U1" H 8550 3050 50  0000 C CNN
F 1 "74LS04" H 9100 3050 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 8900 2900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 8900 2900 50  0001 C CNN
	3    8900 2900
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U1
U 4 1 6232D3FF
P 4050 5650
F 0 "U1" H 4800 5700 50  0000 C CNN
F 1 "74LS04" H 4500 5700 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 4050 5650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 4050 5650 50  0001 C CNN
	4    4050 5650
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U1
U 5 1 6232E33E
P 4850 6050
F 0 "U1" H 5150 6300 50  0000 C CNN
F 1 "74LS04" H 4850 6300 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 4850 6050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 4850 6050 50  0001 C CNN
	5    4850 6050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U1
U 6 1 6232F73D
P 5600 6450
F 0 "U1" H 5800 6200 50  0000 C CNN
F 1 "74LS04" H 5450 6200 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 5600 6450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 5600 6450 50  0001 C CNN
	6    5600 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 5650 4350 5650
Wire Wire Line
	3200 4200 3200 5650
Wire Wire Line
	3200 5650 3750 5650
Connection ~ 3200 4200
Wire Wire Line
	3200 4200 4800 4200
Wire Wire Line
	3300 4100 3300 5850
Wire Wire Line
	3300 5850 4350 5850
Wire Wire Line
	4350 5850 4350 5750
Wire Wire Line
	4350 5750 6350 5750
Connection ~ 3300 4100
Wire Wire Line
	3300 4100 4900 4100
Wire Wire Line
	6350 5950 5150 5950
Wire Wire Line
	5150 5950 5150 6050
Wire Wire Line
	3400 4000 3400 5950
Wire Wire Line
	3400 5950 4450 5950
Wire Wire Line
	4450 5950 4450 5850
Wire Wire Line
	4450 5850 6350 5850
Connection ~ 3400 4000
Wire Wire Line
	3400 4000 5000 4000
Wire Wire Line
	3500 3900 3500 6050
Wire Wire Line
	3500 6050 4550 6050
Connection ~ 3500 3900
Wire Wire Line
	3500 3900 5100 3900
Wire Wire Line
	3600 3800 3600 6250
Wire Wire Line
	3600 6250 5250 6250
Wire Wire Line
	5250 6250 5250 6050
Wire Wire Line
	5250 6050 6350 6050
Connection ~ 3600 3800
Wire Wire Line
	3600 3800 5200 3800
Wire Wire Line
	3700 3700 3700 6350
Wire Wire Line
	3700 6350 5350 6350
Wire Wire Line
	5350 6350 5350 6150
Wire Wire Line
	5350 6150 6350 6150
Connection ~ 3700 3700
Wire Wire Line
	3700 3700 5300 3700
Wire Wire Line
	5150 6700 5150 6450
Wire Wire Line
	5150 6450 5300 6450
Wire Wire Line
	5900 6450 6150 6450
Wire Wire Line
	6150 6450 6150 6250
Wire Wire Line
	6150 6250 6350 6250
Wire Wire Line
	6950 5950 7050 5950
Wire Wire Line
	7050 3900 7050 5950
$Comp
L power:+5V #PWR017
U 1 1 6252FE80
P 6700 6450
F 0 "#PWR017" H 6700 6300 50  0001 C CNN
F 1 "+5V" H 6715 6623 50  0000 C CNN
F 2 "" H 6700 6450 50  0001 C CNN
F 3 "" H 6700 6450 50  0001 C CNN
	1    6700 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 6350 6300 6350
Wire Wire Line
	6300 6350 6300 6550
Wire Wire Line
	6300 6550 6700 6550
Wire Wire Line
	6700 6550 6700 6450
Wire Wire Line
	3450 7850 3300 7850
$Comp
L power:GND #PWR02
U 1 1 62817458
P 3300 8450
F 0 "#PWR02" H 3300 8200 50  0001 C CNN
F 1 "GND" H 3305 8277 50  0000 C CNN
F 2 "" H 3300 8450 50  0001 C CNN
F 3 "" H 3300 8450 50  0001 C CNN
	1    3300 8450
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 628C00D7
P 5250 8150
F 0 "C1" V 5100 8250 50  0000 C CNN
F 1 "0.1uF" V 5100 8000 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L4.0mm_W2.5mm_P2.50mm" H 5288 8000 50  0001 C CNN
F 3 "~" H 5250 8150 50  0001 C CNN
	1    5250 8150
	-1   0    0    1   
$EndComp
$Comp
L Device:C C4
U 1 1 628E1651
P 6350 8150
F 0 "C4" V 6200 8250 50  0000 C CNN
F 1 "0.1uF" V 6200 8000 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L4.0mm_W2.5mm_P2.50mm" H 6388 8000 50  0001 C CNN
F 3 "~" H 6350 8150 50  0001 C CNN
	1    6350 8150
	-1   0    0    1   
$EndComp
$Comp
L Device:C C5
U 1 1 62902A84
P 7500 8150
F 0 "C5" V 7350 8250 50  0000 C CNN
F 1 "0.1uF" V 7350 8000 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L4.0mm_W2.5mm_P2.50mm" H 7538 8000 50  0001 C CNN
F 3 "~" H 7500 8150 50  0001 C CNN
	1    7500 8150
	-1   0    0    1   
$EndComp
Wire Wire Line
	5250 8000 5250 7500
Wire Wire Line
	5250 7500 5700 7500
Wire Wire Line
	5700 7500 5700 7600
Wire Wire Line
	5700 7500 6350 7500
Wire Wire Line
	6800 7500 6800 7600
Connection ~ 5700 7500
Wire Wire Line
	6800 7500 7500 7500
Wire Wire Line
	7900 7500 7900 7600
Connection ~ 6800 7500
Wire Wire Line
	5250 8300 5250 8700
Wire Wire Line
	5250 8700 5700 8700
Wire Wire Line
	5700 8700 5700 8600
Wire Wire Line
	5700 8700 6350 8700
Wire Wire Line
	6800 8700 6800 8600
Connection ~ 5700 8700
Wire Wire Line
	6800 8700 7500 8700
Wire Wire Line
	7900 8700 7900 8600
Connection ~ 6800 8700
Wire Wire Line
	7500 8300 7500 8700
Connection ~ 7500 8700
Wire Wire Line
	7500 8700 7900 8700
Wire Wire Line
	7500 8000 7500 7500
Connection ~ 7500 7500
Wire Wire Line
	7500 7500 7900 7500
Wire Wire Line
	6350 8000 6350 7500
Connection ~ 6350 7500
Wire Wire Line
	6350 7500 6800 7500
Wire Wire Line
	6350 8300 6350 8700
Connection ~ 6350 8700
Wire Wire Line
	6350 8700 6800 8700
$Comp
L power:GND #PWR016
U 1 1 62BBAEEE
P 5250 8800
F 0 "#PWR016" H 5250 8550 50  0001 C CNN
F 1 "GND" H 5255 8627 50  0000 C CNN
F 2 "" H 5250 8800 50  0001 C CNN
F 3 "" H 5250 8800 50  0001 C CNN
	1    5250 8800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR014
U 1 1 62C0DD1E
P 5250 7400
F 0 "#PWR014" H 5250 7250 50  0001 C CNN
F 1 "+5V" H 5265 7573 50  0000 C CNN
F 2 "" H 5250 7400 50  0001 C CNN
F 3 "" H 5250 7400 50  0001 C CNN
	1    5250 7400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 7400 5250 7500
Connection ~ 5250 7500
Wire Wire Line
	5250 8700 5250 8800
Connection ~ 5250 8700
NoConn ~ 4050 7850
Wire Wire Line
	9550 5200 10050 5200
Wire Wire Line
	9550 5100 10050 5100
Wire Wire Line
	9550 5000 10050 5000
Wire Wire Line
	9550 4900 10050 4900
Wire Wire Line
	9550 4800 10050 4800
Wire Wire Line
	9550 4700 10050 4700
Wire Wire Line
	9550 4600 10050 4600
Wire Wire Line
	9550 4500 10050 4500
Wire Wire Line
	9550 6100 11600 6100
Wire Wire Line
	7950 3600 7950 2900
Wire Wire Line
	9950 2900 9950 4300
Wire Wire Line
	9950 4300 10050 4300
Connection ~ 7950 3600
Wire Wire Line
	3300 7850 3300 8450
Wire Wire Line
	7950 2900 8600 2900
Wire Wire Line
	9200 2900 9950 2900
Text Label 2100 5300 0    50   ~ 0
D0
Text Label 2100 5200 0    50   ~ 0
D1
Text Label 2100 5100 0    50   ~ 0
D2
Text Label 2100 5000 0    50   ~ 0
D3
Text Label 2100 4900 0    50   ~ 0
D4
Text Label 2100 4800 0    50   ~ 0
D5
Text Label 2100 4700 0    50   ~ 0
D6
Text Label 2100 4600 0    50   ~ 0
D7
Text Label 2100 4400 0    50   ~ 0
A0
Text Label 2100 4300 0    50   ~ 0
A1
Text Label 2100 4200 0    50   ~ 0
A2
Text Label 2100 4100 0    50   ~ 0
A3
Text Label 2100 4000 0    50   ~ 0
A4
Text Label 2100 3900 0    50   ~ 0
A5
Text Label 2100 3800 0    50   ~ 0
A6
Text Label 2100 3700 0    50   ~ 0
A7
Text Label 2100 3600 0    50   ~ 0
A8
Text Label 2100 3500 0    50   ~ 0
A9
Text Label 2100 3400 0    50   ~ 0
A10
Text Label 2100 3300 0    50   ~ 0
A11
Text Label 2100 3200 0    50   ~ 0
A12
Text Label 2100 3100 0    50   ~ 0
A13
Text Label 2100 3000 0    50   ~ 0
A14
Text Label 2100 2900 0    50   ~ 0
A15
Text Label 1450 3100 0    50   ~ 0
GND
Text Label 1400 3200 0    50   ~ 0
~MREQ
Text Label 1450 3300 0    50   ~ 0
GND
Text Label 1450 3500 0    50   ~ 0
GND
Text Label 1450 3700 0    50   ~ 0
GND
Text Label 1450 4100 0    50   ~ 0
GND
Text Label 1450 4500 0    50   ~ 0
GND
Text Label 1450 4600 0    50   ~ 0
GND
Text Label 1450 4700 0    50   ~ 0
GND
Text Label 1450 4800 0    50   ~ 0
GND
Text Label 1450 4900 0    50   ~ 0
GND
Text Label 1450 5000 0    50   ~ 0
GND
Text Label 1450 5100 0    50   ~ 0
GND
Text Label 1450 5200 0    50   ~ 0
GND
Text Label 1450 5300 0    50   ~ 0
GND
Text Label 1400 3400 0    50   ~ 0
~IORQ
Text Label 1500 3600 0    50   ~ 0
~RD
Text Label 1500 3800 0    50   ~ 0
~WR
Text Label 1400 4400 0    50   ~ 0
RESET
$Comp
L Connector_Generic:Conn_01x06 J5
U 1 1 62D11F48
P 13050 3250
F 0 "J5" H 13130 3242 50  0000 L CNN
F 1 "MicroSD Card Adapter" H 12450 2800 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x06_P2.54mm_Vertical" H 13050 3250 50  0001 C CNN
F 3 "~" H 13050 3250 50  0001 C CNN
	1    13050 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	12850 3050 12600 3050
Wire Wire Line
	12850 3150 12600 3150
Wire Wire Line
	12850 3250 12600 3250
Wire Wire Line
	12850 3350 12600 3350
Wire Wire Line
	12850 3450 12600 3450
Wire Wire Line
	12850 3550 12600 3550
Text Label 11000 2200 0    50   ~ 0
SCK
Text Label 11000 2300 0    50   ~ 0
MISO
Text Label 11000 2400 0    50   ~ 0
MOSI
Text Label 11100 2500 0    50   ~ 0
CS
Text Label 12600 3050 0    50   ~ 0
GND
Text Label 12600 3150 0    50   ~ 0
+5V
Text Label 12600 3250 0    50   ~ 0
MISO
Text Label 12600 3350 0    50   ~ 0
MOSI
Text Label 12600 3450 0    50   ~ 0
SCK
Text Label 12600 3550 0    50   ~ 0
CS
$Comp
L Memory_RAM2:SLIDE_SWITCH_3P S3
U 1 1 66BA1EE1
P 6300 4700
F 0 "S3" H 6150 4650 50  0000 C CNN
F 1 "80K/700" H 6500 4650 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 6300 4725 50  0001 C CNN
F 3 "" H 6300 4725 50  0001 C CNN
	1    6300 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 3400 6100 4200
Wire Wire Line
	6100 4200 6750 4200
Wire Wire Line
	6750 4200 6750 5200
Wire Wire Line
	6750 5200 6300 5200
Wire Wire Line
	6300 5200 6300 5050
$Comp
L Device:R R1
U 1 1 66BE3A29
P 6100 3250
F 0 "R1" H 5900 3350 50  0000 L CNN
F 1 "10k" H 5900 3200 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 6030 3250 50  0001 C CNN
F 3 "~" H 6100 3250 50  0001 C CNN
	1    6100 3250
	1    0    0    -1  
$EndComp
Connection ~ 6100 3400
Wire Wire Line
	6100 3100 6300 3100
Connection ~ 6300 3100
Wire Wire Line
	6300 3100 6300 1600
NoConn ~ 6500 4900
$EndSCHEMATC
