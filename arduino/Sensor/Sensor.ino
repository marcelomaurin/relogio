#include <SimpleDHT.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

// for DHT11, 
//      VCC: 5V or 3V
//      GND: GND
//      DATA: 2
int pinDHT22 = A2;
SimpleDHT22 dht22(pinDHT22);

LiquidCrystal_I2C lcd(0x27,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display

void setup() {
  Serial.begin(115200);
  lcd.init();                      // initialize the lcd 
  lcd.init();
  // Print a message to the LCD.
  lcd.backlight();
}

void loop() {
  // start working...
 
  // read with raw sample data.
  float temperature = 0;
  float humidity = 0;
  byte data[40] = {0};
  static char disp[7];
  char aux[16];
   int err = SimpleDHTErrSuccess;
  if ((err = dht22.read2(&temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
    Serial.print("Read DHT22 failed, err="); Serial.println(err);delay(2000);
    return;
  }
  lcd.setCursor(0,0);
  sprintf(aux,"Temp:%s C",dtostrf(temperature,5,2,disp));
  lcd.print(aux);
  lcd.setCursor(0,1);
  sprintf(aux,"Hum:%s RH%",dtostrf(humidity,5,2,disp));
  lcd.print(aux);


  Serial.print("Temperatura:");
  Serial.println((float)temperature); 
  Serial.print("Humidade:");
  Serial.println((float)humidity);
  
  // DHT11 sampling rate is 1HZ.
  delay(1500);
}
