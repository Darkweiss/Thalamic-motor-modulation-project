
// 0x0F (120x), ... , 0x7F (1x)
#define sensitivity 0x1F

// INCLUDES
//generic Arduino library for I2C interface
#include <stdint.h> 
#include <Wire.h>
//library for CAP118 specific functionality
#include "Adafruit_CAP1188.h"

//CONSTANTS
//LED pin will be driven HIGH to indicate when input is detected
const byte ledPin = LED_BUILTIN;
const byte ledPin_bnc = 13;
//GLOBALS
//Declare a CAP118 object
Adafruit_CAP1188 cap = Adafruit_CAP1188();
//flag to detect whether object is detected
bool detected = false;

void setup (){
  //start a USB serial connection
  Serial.begin(9600);
  //print put the file and the date at which it was last compiled
  Serial.println(__FILE__ __DATE__);

  //Initialize a connection to the sensor using the appropriate I2C address
  //The resistor soldered on to the board sets the default I2C address to 0x29
  //You can set the I2C address to one of five values by connecting the "AD" pin on the board as follows
  //Wire connecting AD to 3V -> 0x28
  //...
  if (!cap.begin(0x29)) {
    Serial.println(F("Could not connect to CAP1188"));
  }
  Serial.println(F("CAP1188 initialised"));

  //Configure the output pin
  pinMode(ledPin, OUTPUT);
  pinMode(ledPin_bnc, OUTPUT);
  //Read the registry value at address 0x1F, which contains the sensitivity in bits 4,5,6
  //We use a bitwise and mask of 0x0F to retrieve the low bits and clear these high bits
  uint8_t reg = cap.readRegister(0x1F) & 0x0F;
  //Now we use a bitwise | to set the high bits and then write the value back to the device
  cap.writeRegister(0x1F, reg | sensitivity);
}

//This function is called once when a new object is detected
void inputDetected() {
  digitalWrite(ledPin,HIGH);
  digitalWrite(ledPin_bnc,HIGH);
  Serial.print(F("New input detected!"));
  detected = true;
}

//This function is called repeatedly while an object renmains present
void inputHeld() {
  //Prints the distance on the default unit (centimetres)
  Serial.print(".");
}

//This function is called once when an object is removed
void inputRemoved() {
  digitalWrite(ledPin,LOW);
  digitalWrite(ledPin_bnc,LOW);
  Serial.println(F("removed"));
  detected = false;
}

void loop(){
  //The sensor has 8 inputs, each of which is either touched (1) or not (0)
  //We can retrieve the status of all 8 sensors in a single byte of data
  //touchStatus is a single byte of data
  byte touchStatus = cap.touched();

  //touch status is a single byte representing whether each of the 8 sensors detected a touch
  // to test whether a particular input has been touched we'll examine the bit at the corresponding position
  byte sensorIdx = 0;
  if(touchStatus & (1<<sensorIdx)) {
    if(detected == false) {
      inputDetected();
    }
    else {
      inputHeld();
    }
  }
  else {
    //If input was detected in the previous frame it means it's just been removed
    if(detected) {
      inputRemoved();
    }
  }
  delay(10);
}

