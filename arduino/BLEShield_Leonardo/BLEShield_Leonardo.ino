/*
 * BLE Shield Test Sketch for Arduino 1.0.3
 * Sketch for Arduino Leonardo
 * by Dr. Michael Kroll 2013
 * v1.0.0 2013-02-02
 */

long previousMillis = 0; 
long interval = 1000; 

void setup()  
{
  // set the data rate for the SoftwareSerial port
  Serial.begin(19200);
  Serial1.begin(19200);
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
    
    Serial1.write(randNumber1);
    Serial1.write(randNumber2);
    Serial1.write(randNumber3);
    Serial1.write(randNumber4);    
  }
  
  if (Serial1.available()) {
    Serial.write(Serial1.read());
  }
}
