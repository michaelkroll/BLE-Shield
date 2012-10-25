/*
 * BLE Shield SoftSerial Test Sketch for Arduino 1.0.1
 * v1.0.0 2012-10-25
 * 
 * Copyright (c) 2012 Dr. Michael Kroll
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
#include <SoftwareSerial.h>

SoftwareSerial bleShield(2, 3);

long previousMillis = 0; 
long interval = 1000; 

void setup()  
{
  // set the data rate for the SoftwareSerial port
  bleShield.begin(19200);
  Serial.begin(19200);
  randomSeed(analogRead(0));  
}

void loop() // run over and over
{
  
  unsigned long currentMillis = millis();
 
  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;   
    
    int randNumber1 = random(255);
    int randNumber2 = random(255);
    int randNumber3 = random(255);
    int randNumber4 = random(255);
    
    bleShield.write(randNumber1);
    bleShield.write(randNumber2);
    bleShield.write(randNumber3);
    bleShield.write(randNumber4);    
  }
  
  if (bleShield.available()) {
    Serial.write(bleShield.read());
  }
}
