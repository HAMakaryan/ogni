// ============================================
//  Arduino nano 33
//  propeller CAR Controller (central)
// ============================================
//  PORT ASSIGNMENT
// ============================================
// D7:EX POWER
// A4:EX IO
// D13:LED
// ============================================
//  FILE INCLUDE 
// ============================================  
#include <Arduino_LSM9DS1.h>
#include <ArduinoBLE.h>
// ============================================
//  CONTROL VALUABLES
// ============================================  
   long itime, itime2;         // event timer  
   int tgll;
   int oldButtonState = LOW;   
// ============================================
//  SETUP
// ============================================
void setup() {
  Serial.begin(9600);
  //while (!Serial);
  pinMode(13, OUTPUT); // on board LED

  pinMode(22, OUTPUT); // RGB LED R
  pinMode(23, OUTPUT); // RGB LED G
  pinMode(24, OUTPUT); // RGB LED B
  RGB(1,0,1);          // Green  
  
  IMU.begin();                                              // begin gyro
  Serial.print("Accelerometer sample rate = "); Serial.println(IMU.accelerationSampleRate());
  
  BLE.begin(); Serial.println("BLE Central - LED");         // begin initialization       
  BLE.scanForUuid("19b10000-e8f2-537e-4f6c-d104768a1214");  // start scanning for peripherals
  
}
// ============================================
//  LOOP
  float x, y, z;
  int ONOFF;
// ============================================
void RGB(int R, int G, int B) { digitalWrite(22, R); digitalWrite(23, G); digitalWrite(24, B); }
void loop() {  
  gyro();
  BLEDevice peripheral = BLE.available();
  if (peripheral) {  // discovered a peripheral, print out address, local name, and advertised service
    Serial.print("Found "); Serial.print(peripheral.address());   Serial.print(" '");
                            Serial.print(peripheral.localName()); Serial.print("' ");
                            Serial.println(peripheral.advertisedServiceUuid());
    if (peripheral.localName() != "LED") { return; }
    BLE.stopScan();                                          // stop scanning
    controlLed(peripheral);    
    BLE.scanForUuid("19b10000-e8f2-537e-4f6c-d104768a1214"); // disconnect, start scanning again
  }   
}
void gyro() {
  if (IMU.accelerationAvailable()) { IMU.readAcceleration(x, y, z); } //Serial.println(-100*x);
  if(-100*x > 30) { ONOFF = 1; } else { ONOFF = 0; } digitalWrite(13, ONOFF);  
}

void controlLed(BLEDevice peripheral) {
  Serial.println("Connecting ...");  // connect to the peripheral
  if (peripheral.connect()) { Serial.println("Connected"); } else { Serial.println("Fail"); return; }

  Serial.println("Discovering attributes ..."); // discover peripheral attributes
  if (peripheral.discoverAttributes()) { Serial.println("Attributes discovered");
  } else { Serial.println("Fail"); peripheral.disconnect(); return; }

  Serial.println("Discovering retrieve the LED characteristic ..."); // retrieve the LED characteristic
  BLECharacteristic ledCharacteristic = peripheral.characteristic("19b10001-e8f2-537e-4f6c-d104768a1214");
  if (!ledCharacteristic) { Serial.println("no LED char"); peripheral.disconnect(); return; } 
  else if (!ledCharacteristic.canWrite()) { Serial.println("no wLED char"); peripheral.disconnect(); return; }

  RGB(0,0,1); // red selected! Red/Green
  while (peripheral.connected()) {   // while the peripheral is connected
    gyro(); 
    int buttonState = ONOFF; // read the button pin    
    if (oldButtonState != buttonState) { oldButtonState = buttonState; // status changed  
      if (buttonState) { ledCharacteristic.writeValue((byte)0x01); Serial.println("ON");  }
      else {             ledCharacteristic.writeValue((byte)0x00); Serial.println("OFF"); }
    }
  }
  RGB(1,0,1); Serial.println("Peripheral disconnected"); // blue
}