/*
 * BLE Shield SoftSerial Test Sketch for Arduino 1.0.5
 * v2.0.0 2013-10-20
 * 
 * Copyright (c) 2012-2013 Dr. Michael Kroll
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this 
 * software and associated documentation files (the "Software"), to deal in the Software 
 * without restriction, including without limitation the rights to use, copy, modify, merge, 
 * publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
 * to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or 
 * substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://www.mkroll.mobi
 * http://forum.mkroll.mobi
 */

boolean connected;

void setup()   {
  
  // On the Leonardo, the Serial port is mapped to the USB Cable
  // and is not available at pins D0/D1.
  // We set it to 9600 baud.
  Serial.begin(9600);

  // The BLE-Shield v2.0.0 is running at 9600 baud by default
  // Set the data rate for the Serial1 port on Pins 0/1
  // The jumpers has to be set to RX -> D0 and TX -> D1
  Serial1.begin(9600);

  Serial.print("BLE-Shield v2.0.0 Sketch setup...");

  // The BLE-Shield v2.0.0 is not only litting up the blue LED on connection, 
  // but raising and lowering an interrupt on the Arduino.
  // Finally you are able to see the connected state on the Arduino :-)
  // Here we attach the interrupt according to the spec at 
  // http://arduino.cc/en/Reference/attachInterrupt
  // The interrupt jumper has to be set to D7
  attachInterrupt(4, connection, CHANGE);    
  Serial.println(" done.");
  connected = false;
}

void loop() // run over and over
{
  // Wait for Data on the serial console and submit it to the
  // BLE-Shield byte per byte. there is no longer a buffer involved.
  if (Serial.available()) {
    int ch = Serial.read();
    Serial.print(ch);
    Serial1.write(ch);
  }
  
  // Wait for data send from the iPhone and print it to the serial console.
  // That's it. Quite simple.
  if (Serial1.available()) {
    Serial.write(Serial1.read());
  }
}

// This method is called if the connection state changes. 
// When a connection is established, the Interrupt will be set to high, and
// set to low, once the BLE-Shield is disconnected.
void connection() {
  connected = !connected;
  if (connected) {
    Serial.println("BLE-Shield Connected = true (4)");
  }
  else {
    Serial.println("BLE-Shield Connected = false (4)");  
  }
}
