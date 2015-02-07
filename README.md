## BLE-Shield

The MIT License (MIT)
Copyright (c) 2012-2015 Dr. Michael Kroll
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN 
NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Content

This repository contains the eagle design files as well as the firmware source code and precompiled hex files.
Moreover I added the Arduino Sketches from my blog to this repository.

### Latest Version

The Latest version of the BLE-Shield is v3.0.0 as illustrated in the image below.

[![](https://raw.github.com/michaelkroll/BLE-Shield/master/docs/BLE-Shieldv3C1.jpg)](https://raw.github.com/michaelkroll/BLE-Shield/master/docs/BLE-Shieldv3C1.jpg)

#### Services and Characteristics of the BLE-Shield v3.0.0

The new BLE-Shield supports some new services and haracteristics. The RX and TX characteristics are not combined into one indicating Data characteristic
Moreover the Bluegiga OTA Service is supported enabling you to update the BLE-Shield over the air using e.g. the iOS App BLExplr.

##### BLE-Shield Service v3.0.0 (B4BDB998-8F4A-45F6-A407-6B48D79CFC2F)

###### Bluetooth Device Address Characteristic (B4BDB998-8F4B-45F6-A407-6B48D79CFC2F)

This characteristic is read only and used to retrieve the Bluetooth Device Address of the BLE113-M256k module.

###### Baudrate Characteristic (B4BDB998-8F4C-45F6-A407-6B48D79CFC2F)

This characteristic is read and write and used to set the BLE-Shields baudrate. The default baudrate is 9600 baud
It is a one byte characteristic. The following baudrates are suported and can be set using the following byte set to the
characteristic:

Baudrate  | Configuration Byte
--------- | ------------------
9600      | 0x00
14400     | 0x01
19200     | 0x02
28800     | 0x03
38400     | 0x04
57600     | 0x05
115200    | 0x06

###### Enable Connect LED characteristic (B4BDB998-8F4D-45F6-A407-6B48D79CFC2F)

This characteristic is used to control the connection LED on the BLE-Shield. The LED is per default off.
In order to change it's behavior write e.g. 0xff the the characteristic to make it lit on the next connection.

LED State | Configuration Byte
--------- | ------------------
OFF       | 0x00
ON        | 0xff

###### Data characteristic (B4BDB998-8F4E-45F6-A407-6B48D79CFC2F)

The new BLE-Shield v3.0.0 uses a Data characteristic to send and receive data. In order to support this
the characteristic is a write and indicate characteristic. On BLExplr it is no longer necessary to switch between
RX and TX characteristics. You can stay on the same screen to see data which is recevied while you are transmitting data.

##### Bluegiga OTA Service (1d14d6ee-fd63-4fa1-bfa4-8f47b42119f0)

This is the implementation of Bluegiga's OTA Service to update the firmware over the air.

###### Data characteristic (f7bf3564-fb6d-4e53-88a4-5e37e0326063)

Bluegiga OTA Control Characteristic

###### Data characteristic (984227f3-34fc-4045-a5d0-2c581f81a153)

Bluegiga OTA Data Characteristic

### Links
* http://www.mkroll.mobi
* http://forum.mkroll.mobi


### Notes:
* The Eagle design files are created using Eagle v5.11.0 - v7.1 depending on the version of the BLE-Shield. BLE-Shield v3.0.0 was designed with Eagle v7.1.0
* The Firmware v1.0.0 and v1.0.1 for the BLE112 module on the BLE-Shield was created and compiled for the Bluegiga BLE112 SDK v1.0.3 Build 43
* The Firmware v3.0.0 was developed using Bluegiga's BLE SDK v1.3.2 Build 122.
* The Arduino Sketches have been tested with Arduino 1.0.1
* the Arduino Sketched vor BLE-Shield v3.0.0 has been tested with Arduino v1.0.6 on OSX
* The .NETMF Sample has been tested with Microsoft Visual C# Express 2010, .NET Micro Framework SDK v4.2 and the Netduino SDK v4.2.2.0 (32-bit) running on a NetDuino2

## .NETMF support 
The latest addition to this repository is .NETMF support. With a little help of Thomas Amberg @tamberg I added a sample project for 
the NetDuino2 board available at http://www.netduino.com which shows how use the BLE-Shield with this platform.  

## BLE-Shield iPhone App for the BLE-Shield v1.0.0

The iPhone App was part of the BLE-Shield Kickstarter campaign https://www.kickstarter.com/projects/rowdyrobot/arduino-ble-shield-connecting-the-ios-and-the-ardu and only
supports the BLE-Shield v1.0.0 The BLE-Shield app provides access to the BLE-Shield Service and their characteristics. It's user interface is implemented like 
a chat application. The chart partners are the BLE-Shield and the iPhone, illustrated by small icons.

Once the BLE-Shield is connected, the application will automatically enable notifications on the RX characteristic. So whenever 
the BLE-Shield's 16 byte buffer is filled completely, the buffer will be notified to the iPhone. 

The app was developed using Xcode 4.5.2, iOS6 SDK and tested on an iPhone4S and iPhone5 running iOS6.0.1

*Screenshots*

<img src="http://www.mkroll.mobi/BLE-Shield-Files/iphone/BLE-Shield-iPhone1.PNG" /> 
. <img src="http://www.mkroll.mobi/BLE-Shield-Files/iphone/BLE-Shield-iPhone2.PNG" />
. <img src="http://www.mkroll.mobi/BLE-Shield-Files/iphone/BLE-Shield-iPhone3.PNG" />
. <img src="http://www.mkroll.mobi/BLE-Shield-Files/iphone/BLE-Shield-iPhone4.PNG" />
. <img src="http://www.mkroll.mobi/BLE-Shield-Files/iphone/BLE-Shield-iPhone5.PNG" />
. <img src="http://www.mkroll.mobi/BLE-Shield-Files/iphone/BLE-Shield-iPhone6.PNG" />
. <img src="http://www.mkroll.mobi/BLE-Shield-Files/iphone/BLE-Shield-iPhone7.PNG" />


### Used third party components

* BLEUtils taken from the TI SensorTag App, created by Ole Andreas Torvmark 
* MBProgressHUD created by Matej Bukovinski https://github.com/matej/MBProgressHUD
* PTSMessagingCell created by Ralph Grasser https://github.com/ppanopticon/PTSMessagingCell/
