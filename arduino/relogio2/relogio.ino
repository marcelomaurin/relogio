#include <SimpleDHT.h>

// for dht, 
//      VCC: 5V or 3V
//      GND: GND
//      DATA: 2
int pindht = 2;
//SimpleDHT11 dht(pindht);
SimpleDHT22 dht(pindht);

void setup() {
  Serial.begin(115200);
}

void loop() {
  // start working...
 
  // read with raw sample data.
  byte temperature = 0;
  byte humidity = 0;
  byte data[40] = {0};
  int err = SimpleDHTErrSuccess;
  if ((err = dht.read(&temperature, &humidity, data)) != SimpleDHTErrSuccess) {
    Serial.print("Read dht failed, err="); Serial.println(err);delay(1000);
    return;
  }
  /*
  Serial.print("Sample RAW Bits: ");
  for (int i = 0; i < 40; i++) {
    Serial.print((int)data[i]);
    if (i > 0 && ((i + 1) % 4) == 0) {
      Serial.print(' ');
    }
  }
  Serial.println("");
  */
  Serial.print("Temperatura:");
  Serial.println((int)temperature); 
  Serial.print("Humidade:");
  Serial.println((int)humidity);
  
  // dht sampling rate is 1HZ.
  delay(1500);
}
