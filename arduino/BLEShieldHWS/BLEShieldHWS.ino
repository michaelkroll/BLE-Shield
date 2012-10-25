/*
 * BLE Shield Serial Test Sketch for Arduino 1.0.1
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

// Pin 13 has an LED connected on most Arduino boards.
int led = 13;

long previousMillis = 0; 
long interval = 1000; 

void setup()  
{
  // set the data rate for the Serial port
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
    
    Serial.write(randNumber1);
    Serial.write(randNumber2);
    Serial.write(randNumber3);
    Serial.write(randNumber4);    
  }
  
  if (Serial.available()) {
    int data = Serial.read();
    digitalWrite(led, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(1000);               // wait for a second
    digitalWrite(led, LOW);    // turn the LED off by making the voltage LOW
  }
}



