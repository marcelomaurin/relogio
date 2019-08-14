
#include <SPI.h>
#include <TimeLib.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <DTime.h>
#include <Nextion.h>
#include <NextionPage.h>
#include <NextionButton.h>
#include <SDHT.h>
#include <SD.h>
#include "SerialMP3Player.h"

#define TX 14
#define RX 15

SoftwareSerial nextionSerial(10, 11); // RX, 

//NexDSButton btEntrar = NexDSButton(0,1,"btentrar");
Nextion nex(nextionSerial);
NextionButton btEntrar(nex, 0, 1, "btentrar");


SerialMP3Player mp3(RX,TX);

File myFile;

bool event = 0;
extern volatile unsigned long timer0_millis;
String text = "";

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED
};
IPAddress ip(192, 168, 1, 177);
IPAddress myDns(192, 168, 1, 1);
IPAddress gateway(192, 168, 1, 1);
IPAddress subnet(255, 255, 0, 0);


// Initialize the Ethernet server library
// with the IP address and port you want to use
// (port 80 is default for HTTP):
EthernetServer server(80);

IPAddress timeServer(132, 163, 4, 101); // time-a.timefreq.bldrdoc.gov
const int timeZone = 1;     // Central European Time
unsigned int localPort = 8888;  // local port to listen for UDP packets
EthernetUDP EthernetUdp;
time_t prevDisplay = 0; // when the digital clock was displayed


DTime dtime;
Nextion nextion(10, 11);
SDHT dht;

LiquidCrystal_I2C lcd(0x27,20,4);  // set the LCD address to 0x27 for a 16 chars and 2 line display

void sendFormat(String s);
void sendText(String s, nextionComponent c);

void Wellcome()
{
  lcd.setCursor(6,0);
  lcd.print("Relogio!");
  lcd.setCursor(4,1);        
  lcd.print("Maurinsoft!");
  lcd.setCursor(4,2);
  lcd.print("Multi ponto");
  lcd.setCursor(3,3);
  lcd.print("Power By MMM!");
}

void Start_SD()
{
  Serial.print("Initializing SD card...");

  if (!SD.begin(4)) {
    Serial.println("initialization failed!");
    while (1);
  }
  Serial.println("initialization done.");

}

void Start_Serial()
{
   Serial.begin(9600);                // start serial
}

void Start_LCD()
{
  lcd.init();                      // initialize the lcd 
  lcd.init();
  // Print a message to the LCD.
  lcd.backlight();
  Wellcome();
}

void Start_NTP()
{
  EthernetUdp.begin(localPort);
  Serial.println("waiting for sync");
  setSyncProvider(getNtpTime);
}

void Start_Ethernet()
{
  
  // start the Ethernet connection and the server:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // Check for Ethernet hardware present
    if (Ethernet.hardwareStatus() == EthernetNoHardware) {
      Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
      while (true) {
        delay(1); // do nothing, no point running without Ethernet hardware
      }
    }
    if (Ethernet.linkStatus() == LinkOFF) {
      Serial.println("Ethernet cable is not connected.");
    }
    // initialize the Ethernet device not using DHCP:
    Ethernet.begin(mac, ip, myDns, gateway, subnet);

  // Check for Ethernet hardware present
  if (Ethernet.hardwareStatus() == EthernetNoHardware) {
    Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
    while (true) {
      delay(1); // do nothing, no point running without Ethernet hardware
      }
    }
  }
  
  if (Ethernet.linkStatus() == LinkOFF) {
    Serial.println("Ethernet cable is not connected.");
  }

  // start the server
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());
}

void Start_Nextion()
{
  nextion.begin(9600);
  for (int i = 1; i <= 10; i++) nextion.attach({2, i, NEXTION_EVENT_RELEASE}, numericEvent);
  nextion.attach({2, 11, NEXTION_EVENT_RELEASE}, OKEvent);
  nextion.attach({1, 2, NEXTION_EVENT_RELEASE}, configEvent);
  nextion.attach({1, 1, NEXTION_EVENT_RELEASE}, configEvent);
  sendData();
}

void Start_MP3(){
  mp3.showDebug(1);       // print what we are sending to the mp3 board.

  //Serial.begin(9600);     // start serial interface
  mp3.begin(9600);        // start mp3-communication
  delay(500);             // wait for init

  mp3.sendCommand(CMD_SEL_DEV, 0, 2);   //select sd-card
  delay(500);             // wait for init
}

void numericEvent(uint8_t, uint8_t id) 
{
  sendFormat(text = String(text + String(id - ((id / 10) * 10))).substring(1));
}

void OKEvent() 
{
  if (event) dtime.setDate(text.substring(4).toInt(), text.substring(2, 4).toInt(), text.substring(0, 2).toInt());
  else dtime.setTime(text.substring(0, 2).toInt(), text.substring(2, 4).toInt(), text.substring(4).toInt());
  sendData();
}

void configEvent(uint8_t, uint8_t id) 
{
  if (event = (2 - id)) sendFormat(text = decimate(dtime.day) + decimate(dtime.month) + dtime.year);
  else sendFormat(text = decimate(dtime.hour) + decimate(dtime.minute) + decimate(dtime.second));
}

String decimate(byte b) 
{
  return ((b < 10) ? "0" : "") + String(b);
}


void sendData() 
{
  String m[12] = {"Janeiro", "Fevereiro", "Mar" + String(char(0xE7)) + "o", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"};
  String w[7] = {"Domingo", "Segunda", "Ter" + String(char(0xE7)) + "a", "Quarta", "Quinta", "Sexta", "S" + String(char(0xE1)) + "bado"};

  sendText(w[dtime.weekday] + ", " + String(dtime.day) + " " + m[dtime.month - 1] + " " + String(dtime.year), {0, 2});
  sendText(decimate(dtime.hour) + ":" + decimate(dtime.minute) + ":" + decimate(dtime.second), {0, 1});

  if (dht.broadcast(DHT22, 2)) {
    sendText(String(dht.celsius, 0) + String(char(0xB0)) + "c", {0, 7});
    sendText(String(dht.humidity, 1) + "%", {0, 6});
  }
}



void sendFormat(String s) 
{
  if (event) sendText(s.substring(0, 2) + "-" + s.substring(2, 4) + "-" + s.substring(4), {2, 13});
  else sendText(s.substring(0, 2) + ":" + s.substring(2, 4) + ":" + s.substring(4), {2, 13});
}

void sendText(String s, nextionComponent c) 
{
  nextion.write("p[" + String(c.page) + "].b[" + String(c.id) + "].txt=\"" + String(s) + "\"");
}

void setup()
{
  Start_Serial();
  Start_LCD();
  Start_Ethernet();
  Start_NTP();
  Start_SD();
  Start_MP3();
}

void Le_Nextion()
{
    if (millis() >= 1000) 
    {
    noInterrupts();
    timer0_millis -= 1000;
    interrupts();
    dtime.tick();
    sendData();
    }
}

void SRV_Web()
{
    // listen for incoming clients
  EthernetClient client = server.available();
  if (client) {
    Serial.println("new client");
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        if (c == '\n' && currentLineIsBlank) {
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println("Connection: close");  // the connection will be closed after completion of the response
          client.println("Refresh: 5");  // refresh the page automatically every 5 sec
          client.println();
          client.println("<!DOCTYPE HTML>");
          client.println("<html>");
          // output the value of each analog input pin
          for (int analogChannel = 0; analogChannel < 6; analogChannel++) {
            int sensorReading = analogRead(analogChannel);
            client.print("analog input ");
            client.print(analogChannel);
            client.print(" is ");
            client.print(sensorReading);
            client.println("<br />");
          }
          client.println("</html>");
          break;
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
    Serial.println("client disconnected");
  }


}

void Le_UDP()
{
    if (timeStatus() != timeNotSet) {
    if (now() != prevDisplay) { //update the display only if time has changed
      prevDisplay = now();
      digitalClockDisplay();  
    }
  }
}

void digitalClockDisplay(){
  // digital clock display of the time
  Serial.print(hour());
  printDigits(minute());
  printDigits(second());
  Serial.print(" ");
  Serial.print(day());
  Serial.print(" ");
  Serial.print(month());
  Serial.print(" ");
  Serial.print(year()); 
  Serial.println(); 
}

void printDigits(int digits){
  // utility for digital clock display: prints preceding colon and leading 0
  Serial.print(":");
  if(digits < 10)
    Serial.print('0');
  Serial.print(digits);
}

/*-------- NTP code ----------*/

const int NTP_PACKET_SIZE = 48; // NTP time is in the first 48 bytes of message
byte packetBuffer[NTP_PACKET_SIZE]; //buffer to hold incoming & outgoing packets

time_t getNtpTime()
{
  while (EthernetUdp.parsePacket() > 0) ; // discard any previously received packets
  Serial.println("Transmit NTP Request");
  sendNTPpacket(timeServer);
  uint32_t beginWait = millis();
  while (millis() - beginWait < 1500) {
    int size = EthernetUdp.parsePacket();
    if (size >= NTP_PACKET_SIZE) {
      Serial.println("Receive NTP Response");
      EthernetUdp.read(packetBuffer, NTP_PACKET_SIZE);  // read packet into the buffer
      unsigned long secsSince1900;
      // convert four bytes starting at location 40 to a long integer
      secsSince1900 =  (unsigned long)packetBuffer[40] << 24;
      secsSince1900 |= (unsigned long)packetBuffer[41] << 16;
      secsSince1900 |= (unsigned long)packetBuffer[42] << 8;
      secsSince1900 |= (unsigned long)packetBuffer[43];
      return secsSince1900 - 2208988800UL + timeZone * SECS_PER_HOUR;
    }
  }
  Serial.println("No NTP Response :-(");
  return 0; // return 0 if unable to get the time
}

// send an NTP request to the time server at the given address
void sendNTPpacket(IPAddress &address)
{
  // set all bytes in the buffer to 0
  memset(packetBuffer, 0, NTP_PACKET_SIZE);
  // Initialize values needed to form NTP request
  // (see URL above for details on the packets)
  packetBuffer[0] = 0b11100011;   // LI, Version, Mode
  packetBuffer[1] = 0;     // Stratum, or type of clock
  packetBuffer[2] = 6;     // Polling Interval
  packetBuffer[3] = 0xEC;  // Peer Clock Precision
  // 8 bytes of zero for Root Delay & Root Dispersion
  packetBuffer[12]  = 49;
  packetBuffer[13]  = 0x4E;
  packetBuffer[14]  = 49;
  packetBuffer[15]  = 52;
  // all NTP fields have been given values, now
  // you can send a packet requesting a timestamp:                 
  EthernetUdp.beginPacket(address, 123); //NTP requests are to port 123
  EthernetUdp.write(packetBuffer, NTP_PACKET_SIZE);
  EthernetUdp.endPacket();
}

void PlayMusic(){
   mp3.play();
}

void StopMusic(){
  mp3.stop();
}

void NextMusic(){
  mp3.playNext();
}

void PreviusMusic(){
  mp3.playPrevious();
}

void VolUpMusic(){
  mp3.volUp();
}

void VolDownMusic(){
  mp3.volDown();
}


void Leituras()
{
  Le_Nextion();
  SRV_Web();
}

void loop()
{
  Leituras();
  
}
