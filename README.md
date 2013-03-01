## BLE-Shield


Copyright (c) 2012 Dr. Michael Kroll

Permission is hereby granted, free of charge, to any person obtaining a copy of this 
software and associated documentation files (the "Software"), to deal in the Software 
without restriction, including without limitation the rights to use, copy, modify, merge, 
publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or 
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Content

This repository contains the eagle design files as well as the firmware source code
which are needed modify and rebuild the firmware. The hexfiles are included as well.
Moreover I added the Arduino Sketches from my blog to this repository as well.
Finally the iPhone app is available as source code as well.

### Links
* http://www.mkroll.mobi
* http://forum.mkroll.mobi


### Notes:
* The Eagle design files are created using Eagle v5.11.0
* The Firmware v1.0.0 and v1.0.1 for the BLE112 module on the BLE-Shield was created and compiled for the Bluegiga BLE112 SDK v1.0.3 Build 43
* The Arduino Sketches have been tested with Arduino 1.0.1
* The .NETMF Sample has been tested with Microsoft Visual C# Express 2010, .NET Micro Framework SDK v4.2 and the Netduino SDK v4.2.2.0 (32-bit) running on a NetDuino2

## .NETMF support 
The latest addition to this repository is .NETMF support. With a little help of Thomas Amberg @tamberg I added a sample project for 
the NetDuino2 board available at http://www.netduino.com which shows how use the BLE-Shield with this platform.  

## BLE-Shield iPhone App

The BLE-Shield app provides access to the BLE-Shield Service and their characteristics. It's user interface is implemented like 
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
