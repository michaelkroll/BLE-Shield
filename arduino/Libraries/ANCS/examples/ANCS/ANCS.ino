#include <SoftwareSerial.h>
#include "ANCS.h"

SoftwareSerial bleSerialPort(8, 9); // RX, TX
ANCS ble112Ancs((HardwareSerial *)&bleSerialPort, (HardwareSerial *)&Serial);

boolean connected = false;

void setup() {
  Serial.begin(9600);
  Serial.println("ANCS Sketch started.");
  ble112Ancs.notification_received = ancs_notification_received;

  // The interrupt jumper has to be set to D2
  attachInterrupt(0, connection, CHANGE);    
  bleSerialPort.begin(9600);
}

void loop() {
  ble112Ancs.loop();
}

void ancs_notification_received(const ancs_notification_t *notification) {
  Serial.print("eventId: "); Serial.print(notification -> eventId, HEX);
  Serial.print(", eventFlags: "); Serial.print(notification -> eventFlags, HEX);
  Serial.print(", categoryId: "); Serial.print(notification -> categoryId, HEX);
  Serial.print(", categoryCount: "); Serial.print(notification -> categoryCount, HEX);
  Serial.print(", notificationId: "); Serial.print(notification -> notificationId, HEX);
  Serial.println("");

  switch (notification -> categoryId) {
    case ANCS_CATEGORY_ID_OTHER:
      Serial.println("Notification received for category 'Other'");
      break;
    case ANCS_CATEGORY_ID_INCOMING_CALL:
      Serial.println("Notification received for category 'Incoming Call'");    
      break;
    case ANCS_CATEGORY_ID_MISSED_CALL:
      Serial.println("Notification received for category 'Missed Call'");    
      break;
    case ANCS_CATEGORY_ID_VOICEMAIL:
      Serial.println("Notification received for category 'Voice Mail'");    
      break;
    case ANCS_CATEGORY_ID_SOCIAL:
      Serial.println("Notification received for category 'Social'");
      //ble112Ancs.getAttributeAppId(notification -> notificationId);
      break;
    case ANCS_CATEGORY_ID_SCHEDULE:
      Serial.println("Notification received for category 'Schedule'");    
      break;
    case ANCS_CATEGORY_ID_EMAIL:
      Serial.println("Notification received for category 'Email'");    
      break;
    case ANCS_CATEGORY_ID_NEWS:
      Serial.println("Notification received for category 'News'");    
      break;
    case ANCS_CATEGORY_ID_BUSINESSANDFINANCE:
      Serial.println("Notification received for category 'Business and Finance'");    
      break;
    case ANCS_CATEGORY_ID_LOCATION:
      Serial.println("Notification received for category 'Location'");    
      break;
    case ANCS_CATEGORY_ID_ENTERTAINMENT:
      Serial.println("Notification received for category 'Entertainment'");    
      break;
  }    
}

// This method is called if the connection state changes. 
// When a connection is established, the Interrupt will be set to high, and
// set to low, once the BLE-Shield is disconnected.
void connection() {
  connected = !connected;
  if (connected) {
    Serial.println("BLE-Shield Connected = true");
  }
  else {
    Serial.println("BLE-Shield Connected = false");  
  }
}
