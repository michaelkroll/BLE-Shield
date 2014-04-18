#include "ANCS.h"

ANCS::ANCS(HardwareSerial *module, HardwareSerial *output) {
    _module = module;
    _output = output;

    notification_received = 0;
    notificationBuffer = (uint8_t *)malloc(sizeof(uint8_t) * 4 + sizeof(uint32_t));
    notificationBufferPos = 0;

    appid_received = 0;

    internalState = ANCS_INTERNAL_STATE_LISTENING;
}

void ANCS::loop() {
  if (notification_received && _module -> available() > 0) {
    if (internalState == ANCS_INTERNAL_STATE_LISTENING) {
      int ch = _module -> read();
        
      notificationBuffer[notificationBufferPos++] = ch;
      if (notificationBufferPos == 8) {
        notificationBufferPos = 0;
        notification_received((const struct ancs_notification_t *)(notificationBuffer)); 
      }          
    }
    else if (internalState == ANCS_INTERNAL_STATE_WAITING_FOR_TITLE) {

    }
    else if (internalState == ANCS_INTERNAL_STATE_WAITING_FOR_MESSAGE) {
          
    }
    else if (internalState == ANCS_INTERNAL_STATE_WAITING_FOR_APPID) {
      int ch = _module -> read();
      //if (ch == 0) {
      //  internalState = ANCS_INTERNAL_STATE_LISTENING;    
      //  _output -> println();
      //  _output -> println("App ID received");
      //}
      //else {
        _output -> print((char)ch);
      //}
    }
  }
}

void ANCS::getAttributeAppId(uint32 notificationId) {
  _output -> print("getAttributeAppId called: ");
  //internalState = ANCS_INTERNAL_STATE_WAITING_FOR_APPID;
  /*_output -> print("getAttributeAppId called: ");
   txBuffer = (uint8_t *)malloc(6);
  txBuffer[0] = 0x00;
  txBuffer[1] = (notificationId & 0xff000000) >> 24;
  txBuffer[2] = (notificationId & 0x00ff0000) >> 16;
  txBuffer[3] = (notificationId & 0x0000ff00) >> 8;
  txBuffer[4] = (notificationId & 0x000000ff);  
  txBuffer[5] = ANCS_ATTRIBUTE_ID_APPID;
  _module -> write(txBuffer, 6);
  
  for (int i=0; i<6; i++) { 
    if (txBuffer[i]<0x10) {
      _output -> print("0");
    } 
    _output -> print(txBuffer[i],HEX); 
    _output -> print(" "); 
  }

  _output -> println();

  free(txBuffer);
*/
}

void ANCS::getAttributeTitle(uint32 notificationId,uint8 maxLength) {
  //internalState = ANCS_INTERNAL_STATE_WAITING_FOR_TITLE;
  _output -> println("getAttributeTitle called.");  
}
	
void ANCS::getAttributeSubtitle(uint32 notificationId, uint8 maxLength) {
   //internalState = ANCS_INTERNAL_STATE_WAITING_FOR_SUBTITLE;
  _output -> println("getAttributeSubtitle called."); 
}
	
void ANCS::getAttributeMessage(uint32 notificationId,uint8 maxLength) {
  //internalState = ANCS_INTERNAL_STATE_WAITING_FOR_MESSAGE;
  _output -> println("getAttributeMessage called.");  }
	
void ANCS::getAttributeMessageSize(uint32 notificationId) {
  //internalState = ANCS_INTERNAL_STATE_WAITING_FOR_MESSAGESIZE;
  _output -> println("getAttributeMessageSize called.");  
}

void ANCS::getAttributeDate(uint32 notificationId) {
  //internalState = ANCS_INTERNAL_STATE_WAITING_FOR_DATE;
  _output -> println("getAttributeDate called.");  
}