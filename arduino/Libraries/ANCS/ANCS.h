#ifndef __ANCS_H__
#define __ANCS_H__

#include <Arduino.h>

#define ANCS_CATEGORY_ID_OTHER                           0
#define ANCS_CATEGORY_ID_INCOMING_CALL                   1
#define ANCS_CATEGORY_ID_MISSED_CALL                     2
#define ANCS_CATEGORY_ID_VOICEMAIL                       3
#define ANCS_CATEGORY_ID_SOCIAL                          4
#define ANCS_CATEGORY_ID_SCHEDULE                        5
#define ANCS_CATEGORY_ID_EMAIL                           6
#define ANCS_CATEGORY_ID_NEWS                            7
#define ANCS_CATEGORY_ID_HEALTHANDFITNESS                8
#define ANCS_CATEGORY_ID_BUSINESSANDFINANCE              9
#define ANCS_CATEGORY_ID_LOCATION                        10
#define ANCS_CATEGORY_ID_ENTERTAINMENT                   11

#define ANCS_ATTRIBUTE_ID_APPID                          0
#define ANCS_ATTRIBUTE_ID_TITLE                          1
#define ANCS_ATTRIBUTE_ID_SUBTITLE                       2
#define ANCS_ATTRIBUTE_ID_MESSAGE                        3
#define ANCS_ATTRIBUTE_ID_MESSAGESIZE                    4
#define ANCS_ATTRIBUTE_ID_DATE                           5

#define ANCS_INTERNAL_STATE_LISTENING                    0
#define ANCS_INTERNAL_STATE_WAITING_FOR_APPID            1
#define ANCS_INTERNAL_STATE_WAITING_FOR_TITLE            2
#define ANCS_INTERNAL_STATE_WAITING_FOR_SUBTITLE         3
#define ANCS_INTERNAL_STATE_WAITING_FOR_MESSAGE          4
#define ANCS_INTERNAL_STATE_WAITING_FOR_MESSAGESIZE      5
#define ANCS_INTERNAL_STATE_WAITING_FOR_DATE             6

#define PACKED __attribute__((packed))

typedef uint8_t    uint8;
typedef uint16_t   uint16;
typedef int16_t    int16;
typedef uint32_t   uint32;
typedef int8_t     int8;

struct ancs_notification_t {
    uint8 eventId;
    uint8 eventFlags;
    uint8 categoryId;
    uint8 categoryCount;
    uint32 notificationId;
} PACKED;

struct ancs_notification_attribute_t {
  uint8 commandId;
  uint32 notificationId;
  uint8 attributeId;
} PACKED;

struct ancs_notification_attribute_with_length_t {
  uint8 commandId;
  uint32 notificationId;
  uint8 attributeId;
  uint16 attributeLength; 
} PACKED;

class ANCS {
  
  public:
    ANCS(HardwareSerial *module=0, HardwareSerial *output=0);
    void loop();

    void getAttributeAppId(uint32 notificationId);
    void getAttributeTitle(uint32 notificationId, uint8 maxLength);
	void getAttributeSubtitle(uint32 notificationId, uint8 maxLength);
	void getAttributeMessage(uint32 notificationId, uint8 maxLength);
	void getAttributeMessageSize(uint32 notificationId);
	void getAttributeDate(uint32 notificationId);

	void (*notification_received)(const struct ancs_notification_t *msg);
    void (*appid_received)(void);

  private:
    HardwareSerial *_module; // required UART object with module connection
    HardwareSerial *_output;       // optional UART object for host/debug connection       
    uint8 internalState;

    // incoming packet buffer vars
    uint8_t *notificationBuffer;
    uint8_t notificationBufferSize;
    uint8_t notificationBufferPos;
    
    uint8_t *txBuffer;
    uint8_t attributeSize;
};

#endif /* __ANCS_H__ */