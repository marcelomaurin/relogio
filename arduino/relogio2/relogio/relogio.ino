
#include <SoftwareSerial.h>
#include "SDHT.h"
#include <Nextion.h>
#include <NexUpload.h>
#include <SPI.h>
#include <TimeLib.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <DTime.h>
#include <SD.h>
#include <Keypad.h>
#include <SerialMP3Player.h>
#include <SoftwareSerial.h>


//****************** Defines ******************
#define TX 14
#define RX 15

/*Variavies associadas ao MP3*/
SerialMP3Player mp3(RX,TX);

#define voiceTX 19
#define voiceRX 20


#define pinRed A14
#define pinBlue A15
#define pinGreen A13

#define pinBlueTX A2
#define pinBlueRX A3

#define pinbutton A12


#define pinspeak A11 /*placa de som*/

#define DHTPIN A1 // pino que estamos conectado
#define DHTTYPE DHT11 // DHT 11


#define VOICEHEAD 0xAA


#define CONFIG "CONFIG.CFG"

File myFile;

SoftwareSerial Bluetooth(2, pinBlueTX); // RX, TX

// note names and their corresponding half-periods
//'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C'};
byte names[] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
int tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956};


//mapa de caracteres
uint8_t bell[8]  = {0x4, 0xe, 0xe, 0xe, 0x1f, 0x0, 0x4};
uint8_t note[8]  = {0x2, 0x3, 0x2, 0xe, 0x1e, 0xc, 0x0};
uint8_t clock[8] = {0x0, 0xe, 0x15, 0x17, 0x11, 0xe, 0x0};
uint8_t heart[8] = {0x0, 0xa, 0x1f, 0x1f, 0xe, 0x4, 0x0};
uint8_t duck[8]  = {0x0, 0xc, 0x1d, 0xf, 0xf, 0x6, 0x0};
uint8_t check[8] = {0x0, 0x1, 0x3, 0x16, 0x1c, 0x8, 0x0};
uint8_t cross[8] = {0x0, 0x1b, 0xe, 0x4, 0xe, 0x1b, 0x0};
uint8_t retarrow[8] = {  0x1, 0x1, 0x5, 0x9, 0x1f, 0x8, 0x4};
uint8_t setaD = 0x7F;
uint8_t setaE = 0x80;

//********************* Key Board *************************
char keyleft = 37;
char keyup = 38;
char keyright = 39;
char keydown = 40;
char keyenter = 10;
char keyesc = 27;
char keyF1 = 17;
char keyF2 = 18;

const byte ROWS = 5; //four rows
const byte COLS = 4; //four columns

//define the cymbols on the buttons of the keypads
char hexaKeys[ROWS][COLS] = {
  {
    keyF1, keyF2, '#', '*'
  }
  ,
  {
    '1', '2', '3', keyup
  }
  ,
  {
    '4', '5', '6', keydown
  }
  ,
  {
    '7', '8', '9', keyesc
  }
  ,
  {
    keyleft, '0', keyright, keyenter
  }
};


byte rowPins[ROWS] = {
  22, 24, 26, 28, 30
};
byte colPins[COLS] = {
  38, 36, 34, 32
}; //connect to the row pinouts of the keypad


//initialize an instance of class NewKeypad
Keypad customKeypad = Keypad( makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS);

SDHT dht;



//*************** Descricao do Produto *********************
char Versao = '0';  //Controle de Versao do Firmware
char Release = '2'; //Controle Revisao do Firmware
char Produto[20] = { "Relogio"};
char Empresa[20] = {"Maurinsoft"};
char HostDB[80] = {"http://maurinsoft.com.br"};
char PortDB[10] = {"3306"};
char Database[40] = {"CASADB"};
char User[40] = {"nouser"};
char Passwrd[40] = {"nopass"};

//Lista de firmwares
char LstArq[20][100];


String Mensagem = "";
String Musica = "";

/*Controle de contagem de ciclos*/
const float maxciclo  = 9000;
float contciclo = 0; //Contador de Ciclos de Repeticao

//Flags de Controle
bool OperflgLeitura = false;
byte flgEscape = 0; //Controla Escape
byte flgEnter = 0; //Controla Escape
byte flgTempo = 0; //Controle de Tempo e 
bool flgWait = false; //Espera programada
bool flgLeituraBasica = false; //Mostra linha 3 a temperatura, controlando a leitura basica
bool flgTemperatura = true; //Mostra temperatura e humidade no display
bool flgRedSerial1 = true; //Redirect Serial1 (VOICE) 
bool flgErro = false; //Controle de Erros de Execução

//Tempo Atual
long TempminAtual = 0;
long TempminTotal = 0;
float MaxTemp = 0;
float MinTemp = 0;
float PrgTemp = 0;

float Temperatura = 0;
float Humidade = 0;

byte Button = 1; /* Valor do Botao */



int FOPEPag = 0; //Controle de Pagina da Funcao
int FOPEMAXPag = 2; //Paginas para Funcoes
int FOPEItem = 0; //Item selecionado

//****************** Variaveis Globais ******************
//Variaveis associadas ao SD CARD
Sd2Card card;
SdVolume volume;
File root; //Pasta root
File farquivo; //Arquivo de gravacao
char ArquivoTrabalho[40]; //Arquivo de trabalho a ser carregado
String Arquivo1; //Arquivo de Gravacao
//Temporario
String strInfo;



//Buffer do Teclado e Input
char customKey;
char BufferKeypad[40]; //Buffer de Teclado
//BufferBluetooth
char BufferBluetooth[40]; //Buffer do bluetooth
char BufferEthernet[40]; //Buffer do 


/*Variaveis do Nextion*/
//SoftwareSerial nextionSerial(9, 8); // RX, TX
//Nextion nex(nextionSerial);
/* Forms  */
NexPage pageSplash = NexPage(0, 0, "splash");
NexPage pageMain = NexPage(1, 0, "main");
void btEntrarCallback(void *ptr);

/*Form  Splash */
NexButton btEntrar = NexButton(0, 1, "bsp1");
NexButton btPlay = NexButton(5, 5, "bmp3");

/* Form main */
//NextionButton btMainSetup(nex,1, 4, "b0");
//NextionButton btMainComputer(nex,1, 2, "b3");
//NextionButton btMainSplash(nex,1, 11, "b7");
NexText   txtData = NexText(1, 2, "dt1");
NexText   txtms1 = NexText(4, 2, "ms1");
NexText   txtmu1 = NexText(5, 8, "mu1");

/*
 * Register a button object to the touch event list.  
 */
NexTouch *nex_listen_list[] = 
{
    &pageSplash,
    &pageMain,
    &txtData,
    &btEntrar,
    &txtms1,
    &txtmu1,
    &btPlay,
    NULL
};



char buffer[100] = {0};

int PageIndex = 0;

bool event = 0;
extern volatile unsigned long timer0_millis;
String text = "";

/*Variaveis associadas ao Ethernet*/
// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED
};

char myIP[16];

IPAddress ip(192, 168, 1, 177);
IPAddress myDns(192, 168, 1, 1);
IPAddress gateway(192, 168, 1, 1);
IPAddress subnet(255, 255, 0, 0);

//Ethernet flags
bool flgRServer = false; //Controle de retorno Server
bool flgRClient = false; //Controle de retorno do cliente
bool flgEthernetErro = true; //Verifica se houve erro de start
boolean gotAMessage = false; // whether or not you got a message from the client yet

// Initialize the Ethernet server library
// with the IP address and port you want to use
// (port 80 is default for HTTP):
EthernetServer server(80);
EthernetServer serverport(23);

EthernetClient client;
EthernetClient Serverclient;



IPAddress timeServer(200, 189, 40, 8); // b.ntp.br
//IPAddress timeServer(132, 163, 4, 101); // time-a.timefreq.bldrdoc.gov
const int timeZone = -3;     // Sao Paulo
unsigned int localPort = 8888;  // local port to listen for UDP packets
EthernetUDP EthernetUdp;
time_t prevDisplay = 0; // when the digital clock was displayed


/*Variaveis associadas ao LCD*/
LiquidCrystal_I2C lcd(0x27,20,4);  // set the LCD address to 0x27 for a 16 chars and 2 line display


/*HORA ATUAL*/
String HORAATUAL;
String DATAATUAL;


/* ******************** Funcoes ****************************/
void VOICE_Version();
void CLS();
void Imprime(int y, String Info);
time_t getNtpTime();
void LedRedGreenBlue(int ValueRed, int ValueGreen, int ValueBlue);
void Le_Voice();
void KeyCMD();
void VOICE_ImpGrp1();
void PlayMusic();


//Toca um som
void Sound(char serByte)
{
  if (Button!=0){ /*Verifica se o botao de silencio esta ativo */
    int count = 0;

    for (count = 0; count <= 8; count++) { // look for the note
      if (names[count] == serByte) {  // ahh, found it
        for ( int i = 0; i < 20; i++ ) { // play it for 50 cycles
          digitalWrite(pinspeak, HIGH);
          delayMicroseconds(tones[count]);
          digitalWrite(pinspeak, LOW);
          delayMicroseconds(tones[count]);
        }
      }
    }
  }
}




void Wellcome()
{
  Serial.println("Open Hardware Relogio ");
  Serial.println(Empresa);
  Serial.println("Projeto Relogio");
  Serial.print("Versao:");
  Serial.print(Versao);
  Serial.print(".");
  Serial.println(Release);
  Serial.println(" ");
  Serial.println("Loading...");
  CLS();

  Imprime(0,"    "+String(Produto)+" "+String(Versao) + "." + String(Release));
  //Imprime(1,);
  Imprime(3, "      By Maurin");
}


//Inicializa Speaker
void Start_Speak()
{
  LedRedGreenBlue(1, 0, 1);
  Serial.println("Speaker Starting...");
  pinMode(pinspeak, OUTPUT);
  Serial.println("Speaker OK");
}

//Inicializa Speaker
void Start_Button()
{
  LedRedGreenBlue(1, 1, 0);
  Serial.println("Starting button...");
  pinMode(pinbutton, INPUT);
  Serial.println("Button ON");
}

void Start_Bluetooth(){
  LedRedGreenBlue(1, 1, 0);
  Imprime(2, " Start Bluetooth           ");
  Serial.println("Start Bluetooth...");
  Bluetooth.begin(9600);
}

void Start_SD()
{
   LedRedGreenBlue(1, 1, 1);
  Serial.print("Start SD card...");

  if (!SD.begin(4)) {
    Serial.println("initialization failed!");
    //while (1);
  }
  Serial.println("initialization done.");
}

void Start_Serial()
{
   LedRedGreenBlue(0, 0, 0);
   Serial.begin(9600);                // start serial
      
}

void Start_LCD()
{
  Serial.println("Start LCD...");
  LedRedGreenBlue(1, 0, 0);
  lcd.init();                      // initialize the lcd 
  lcd.init();
  // Print a message to the LCD.
  lcd.backlight();
  lcd.createChar(0, bell);
  lcd.createChar(1, note);
  lcd.createChar(2, clock);
  lcd.createChar(3, heart);
  lcd.createChar(4, duck);
  lcd.createChar(5, check);
  lcd.createChar(6, cross);
  lcd.createChar(7, retarrow);
}

void StartRGB(){
    Serial.println("Start RGB LED...");
    pinMode(pinRed, OUTPUT);
    pinMode(pinBlue, OUTPUT);
    pinMode(pinGreen, OUTPUT);
    digitalWrite(pinRed, LOW);
    digitalWrite(pinBlue, LOW);
    digitalWrite(pinGreen, LOW);
}

void StartDHT(){
  //  #define DHTPIN A0 // pino que estamos conectado
  //  #define DHTTYPE DHT11 // DHT 11
  Serial.println("Start DHT...");
  if (dht.read(DHTTYPE, DHTPIN)) {
    delay(2000);
    }
}


/*
 * Button component pop callback function. 
 * In this example,the button's text value will plus one every time when it is released. 
 */
void btEntrarCallback(void *ptr)
{
  Serial.println("btEntrar Click");
  PageIndex = 1;
    
}

void txtDataPopCallback(void *ptr)
{
    //dbSerialPrintln("txtDataPopCallback");
    //txtData.setText("50");
    Serial.println("txtDataPop");
}

void MainPopCallback(void *ptr){
  Serial.println("Main menu");
  PageIndex = 1;
}

void SplashPopCallback(void *ptr){
  Serial.println("Splash menu");
  PageIndex = 0;
}

void btPlayPopCallback(void *ptr){
  Serial.println("Play");
  PlayMusic();
}

void Start_Voice(){
  Imprime(2, " Start VOICE    ");
  Serial.println("Start Voice...");
  LedRedGreenBlue(0, 0, 1);
  Serial1.begin(9600);
  VOICE_Version();
  delay(100);
  Le_Voice();
  VOICE_ImpGrp1();
  delay(100);
  Le_Voice();
}

void Start_Nextion(){
    LedRedGreenBlue(0, 0, 1);
    Imprime(2, " Start NEXTION    ");
    Serial.println("Start Nextion...");

    /* Set the baudrate which is for debug and communicate with Nextion screen. */
    nexInit();

    /* Register the pop event callback function of the current button component. */
    //pageSplash.attachPop(pageSplashCallback,&pageSplash);
    //btEntrar.attachCallback(callback);
    pageMain.attachPop(MainPopCallback);
    pageSplash.attachPop(SplashPopCallback);
    btPlay.attachPop(btPlayPopCallback);
    //btMainComputer.attachCallback(callback);

    /* Register the pop event callback function of the current button component. */
    btEntrar.attachPop(btEntrarCallback);
    txtData.attachPop(txtDataPopCallback);
    Serial.println("Nextion Started!");
    
}

void Start_NTP()
{
  LedRedGreenBlue(0, 1, 1);
  Imprime(2, "  Start NTP         ");
  Serial.println("Start NTP...");
  EthernetUdp.begin(localPort);
  Serial.println("waiting for sync");
  setSyncProvider(getNtpTime);
}


void Start_Ethernet()
{
  LedRedGreenBlue(1, 0, 0);
  Imprime(2, " Start ETHERNET      ");
  Serial.println("Start Ethernet...");
  // start the Ethernet connection and the server:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // Check for Ethernet hardware present
    /*
    if (Ethernet.hardwareStatus() == EthernetNoHardware) {
      Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
      while (true) {
        delay(1); // do nothing, no point running without Ethernet hardware
      }
    }
    if (Ethernet.linkStatus() == LinkOFF) {
      Serial.println("Ethernet cable is not connected.");
    }
    */
    // initialize the Ethernet device not using DHCP:
    Ethernet.begin(mac, ip, myDns, gateway, subnet);
/*
  // Check for Ethernet hardware present
  if (Ethernet.hardwareStatus() == EthernetNoHardware) {
    Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
    while (true) {
      delay(1); // do nothing, no point running without Ethernet hardware
      }
    }
    */
  }
  /*
  if (Ethernet.linkStatus() == LinkOFF) {
    Serial.println("Ethernet cable is not connected.");
  }
*/
  // start the server
  LedRedGreenBlue(1, 1, 0);
  server.begin();
  Serial.print("server is at ");  
  sprintf(myIP,"%d.%d.%d.%d",Ethernet.localIP()[0],Ethernet.localIP()[1],Ethernet.localIP()[2],Ethernet.localIP()[3]);
  Serial.println(myIP);
}


void Start_MP3(){
  LedRedGreenBlue(1, 0, 1);
  Imprime(2, " Start MP3           ");
  Serial.println("Start MP3...");
  mp3.showDebug(1);       // print what we are sending to the mp3 board.

  
  mp3.begin(9600);        // start mp3-communication
  delay(500);             // wait for init

  mp3.sendCommand(CMD_SEL_DEV, 0, 2);   //select sd-card
  delay(500);             // wait for init
}

//Grava Bloco de Cancelamento 01
void GravaConfig(){
  // Check to see if the file exists:
  if (SD.exists(CONFIG)) {
    SD.remove(CONFIG);
  } 
  
    // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  myFile = SD.open(CONFIG, FILE_WRITE);
  Serial.println("Escrevendo arquivo CONFIG.CFG...");

 
  myFile.print(String("VERSAO:")+Versao);
  myFile.print(String("RELEASE:")+Release);
  myFile.print(String("PRODUTO:")+Produto);
  myFile.print(String("EMPRESA:")+Empresa);
  myFile.print(String("HOST:")+HostDB);
  myFile.print(String("PORT:")+PortDB);
  myFile.print(String("DATABASE:")+Database);
  myFile.print(String("USER:")+User);
  myFile.print(String("PASSWRD:")+Passwrd);
  
    // close the file:
  myFile.close();
}

void LE_CONFIG(){
  
  String info;

  if (!SD.exists(CONFIG)) {
    GravaConfig();
    Serial.println("Arquivo SD Criado.");
  }
  info = "";
  myFile = SD.open(CONFIG);
    while (myFile.available()) {
      info = info + char(myFile.read());
    }
  myFile.close();
  Serial.print("String do Fechamento com Erro:");
  Serial.println(info);
  return info;
}



void setup()
{
  StartRGB();
  Start_Serial();
  Start_LCD();
  Wellcome();
  Start_Speak();  
  StartDHT();
  Start_Bluetooth();
  Start_Nextion(); 
  Start_SD(); 
  Start_Ethernet();
  Start_NTP();
  Start_Voice();

  Start_MP3();
  char info[20];
  sprintf(info,"IP:%s     ",myIP);
  Imprime(1, info);
  Serial.println("Start Complete!");
  delay(2000);
  Imprime(2,"                     ");
  //PlayMusic();
  LedRedGreenBlue(0, 0, 0);
  Sound('a');
  Sound('c');
  delay(2000);
  Mensagem = "Nao há mensagens armazenadas!";
  Musica = "Nao esta tocando";
  LE_CONFIG();

}

/******************** Gerenciamento de Voice **********************/
void VOICE_WaitState(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x00);
}

void VOICE_DelGrp1(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x01);
}

void VOICE_DelGrp2(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x02);
}

void VOICE_DelGrp3(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x03);
}

void VOICE_DelAllGrp(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x04);
}

void VOICE_RecGrp1(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x11);
}

void VOICE_RecGrp2(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x12);
}

void VOICE_RecGrp3(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x13);
}


void VOICE_ImpGrp1(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x21);
}

void VOICE_ImpGrp2(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x22);
}

void VOICE_ImpGrp3(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0x23);
}

void VOICE_Version(){
  Serial1.print(VOICEHEAD);
  Serial1.print(0xBB);
}
/* ****************** GERENCIAMENTO DE LEDS ***********************/

void LedRedGreenBlue(int ValueRed, int ValueGreen, int ValueBlue){
    if(ValueBlue==0){
      digitalWrite(pinBlue, HIGH);
    } else {
      digitalWrite(pinBlue, LOW);
    }

    if(ValueGreen==0){
      digitalWrite(pinGreen, HIGH);
    } else {
      digitalWrite(pinGreen, LOW);
    }

    if(ValueRed==0){
      digitalWrite(pinRed, HIGH);
   } else { 
      digitalWrite(pinRed, LOW);
   }
    //digitalWrite(pinBlue, LOW);
    //digitalWrite(pinGreen, LOW);
}


/*Mostra a pagina principal do site*/
void PageWebIndex(EthernetClient client )
{
       client.println("HTTP/1.1 200 OK");
       client.println("Content-Type: text/html");
       client.println("Connection: close");  // the connection will be closed after completion of the response
       client.println("Refresh: 5");  // refresh the page automatically every 5 sec
       client.println();
       client.println("<!DOCTYPE HTML>");
       client.println("<html>");
       client.println("<center><H1>Relogio</H1></center>");
       client.println("<p>Bem vindo ao site do relogio</p>");

       client.println("</html>");
}

void PageSite(EthernetClient client, String filename  )
{
       client.println("HTTP/1.1 200 OK");
       client.println("Content-Type: text/html");
       client.println("Connection: close");  // the connection will be closed after completion of the response
       client.println("Refresh: 5");  // refresh the page automatically every 5 sec
       client.println();
       //LeArquivo(filename);

}

String PegaNome(String entrada) {
  int inicio = entrada.indexOf("Referer:");
  int final = entrada.indexOf("\n",inicio);
  //String bloco = entrada.Substring(inicio,final); 
  
}


void SRV_Web()
{
    // listen for incoming clients
  EthernetClient client = server.available();
  String Request;
  String filename;
  if (client) {
    Serial.println("new client");
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Request = Request + String(c);
        
        //Serial.write(c);
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        if (c == '\n' && currentLineIsBlank) {
          // send a standard http response header
          filename = PegaNome(Request);
          if (filename == NULL) {
            PageWebIndex(client);
          } else {
            PageSite(client,filename);
          }
          
     
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

/*Bloco de código do display*/
void CLS()
{
  //Serial.println("CLS");
  lcd.clear();
}

//Imprime linha
void Imprime(int y, String Info)
{
  lcd.setCursor(0, y);
  lcd.print(Info);
}


void Le_UDP()
{
    if (timeStatus() != timeNotSet) {
    if (now() != prevDisplay) { //update the display only if time has changed
      prevDisplay = now();
      MontaTempo();  
    }    
  } else {
    Serial.println("No time");
  }
}



void MontaTempo(){
  // digital clock display of the time
  /*
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
  */
  HORAATUAL = String(hour())+printDigits(minute())+printDigits(second());
  DATAATUAL = String(day())+"/"+String(month())+"/"+String(year());
}

String printDigits(int digits){
  // utility for digital clock display: prints preceding colon and leading 0
  String ACUM;
  ACUM = ":";
  if(digits < 10)
    ACUM += '0';
  ACUM += digits;
  return ACUM;
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
      char buff[20];
      time_t now = secsSince1900 - 2208988800UL + timeZone * SECS_PER_HOUR;
      //HORAATUAL = String(strftime(buff, 20, "%Y-%m-%d %H:%M:%S", localtime(&now));
      return now;
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

/*Bloco de Manipulação do SD*/
//Imprime Diretorios
void LstDir(File dir, int numTabs)
{
  Serial.println("Lista de aplicacoes do SD");
  while (true) {

    File entry =  dir.openNextFile();
    if (! entry) {
      // no more files
      break;
    }
    for (uint8_t i = 0; i < numTabs; i++) {
      Serial.print('\t');
    }
    Serial.print(entry.name());
    if (entry.isDirectory()) {
      Serial.println("/");
      LstDir(entry, numTabs + 1);
    } else {
      // files have sizes, directories do not
      Serial.print("\t\t");
      Serial.println(entry.size(), DEC);
    }
    entry.close();
  }
}

void LOADLoop(File root, char Info[40])
{
  //Tenta carregar arquivo temp.out para ser temporario
  File farquivo = SD.open("temp.out", FILE_WRITE);
  //Limpa os buffer
  if (!farquivo)
  {
    Imprime(1, "Erro SD");
    Imprime(2, "Nao pode abrir SD");
  }
  else
  {
    flgEscape = false; //Sai quando verdadeiro
    //Loop
    while (!flgEscape)
    {
      LOADLeituras();
      //Realiza analise das informações encontradas
      LOADAnalisa();
      //arquivo.println("Leitura Potenciometro: ");
    }
  }
  farquivo.close();
  //Apaga o Arquivo Temporario
  LOADRemoveTemp();
}

//Escreve no arquivo
void LOADBloco(char Info[40])
{
  farquivo.print(Info);
}


//Realiza Leitura do arquivo
void LOADLeituras()
{
  //Inicializa Temperatura
  //Le_Temperatura();
  //Le_Teclado();
  Le_Serial();
  //Le_Bluetooth();
  //Beep();
}



//Analisa Entrada de Informacoes de Entrada
void LOADAnalisa()
{
  LOADKeyCMD(); //Analisa o que esta na entrada do buffer de teclado
  //LOADKeyCMDBluetooth(); //Analisa o que esta na entrada do buffer do bluetooth
}

//Apaga o arquivo temporario
void LOADCancela()
{
  LOADRemoveTemp();
  flgEscape = true;
}

void LOADRemoveTemp()
{
  SD.remove("temp.out");
}

void LOADCOPYTEMP()
{
  // open the file named ourfile.txt
  File FOrigem = SD.open("temp.out");
  File FDestino = SD.open(ArquivoTrabalho, FILE_WRITE);

  // if the file is available, read the file
  if (FOrigem)
  {
    while (FOrigem.available())
    {
      //Serial.write();
      FDestino.write(FOrigem.read());
    }
    FOrigem.close();
    FDestino.close();
  }
}




//Finaliza o arquivo temporario copiando para arquivo final
void LOADFIMARQUIVO()
{
  Imprime(1, "Carregando Arquivo  ");
  Imprime(2, "Copiando Arquivo    ");
  //Copia o temporario para o definitivo
  LOADCOPYTEMP();
  LOADRemoveTemp();
  flgEscape = true;
}

//Comando de entrada do Teclado
void LOADKeyCMD()
{
  bool resp = false;

  //incluir busca /n

  if (strchr (BufferKeypad, '\n') != 0)
  {
    Serial.print("Comando:");
    Serial.println(BufferKeypad);

    //Funcao Cancela dados
    if (strcmp( BufferKeypad, "CANCELA;\n") == 0)
    {
      LOADCancela();
      resp = true;
    }

    //Funcao Carrega Bloco
    if (strcmp( BufferKeypad, "BLOCO=") == 0)
    {
      //FUNCMDefault();
      char Info[40];
      sprintf(Info, "0000000000000000");
      LOADBloco(Info);
      resp = true;
    }

    //Funcao Carrega Bloco
    if (strcmp( BufferKeypad, "FIMARQUIVO;\n") == 0)
    {
      LOADFIMARQUIVO();
      resp = true;
    }

    if (resp == false)
    {
      Serial.print("Comando:");
      Serial.print(BufferKeypad);
      Serial.println("Cmd n reconhecido");
      Imprime(3, "Cmd n reconhecido");
      //strcpy(BufferKeypad,'\0');
      memset(BufferKeypad, 0, sizeof(BufferKeypad));
    }
    else
    {
      //strcpy(BufferKeypad,'\0');
      memset(BufferKeypad, 0, sizeof(BufferKeypad));
    }
    //RetConsole(); //Retorno de Comando de Console
  }
}

/**************************Bloco de servidor*************************************/

void HelloClient()
{
  Serverclient.println(Produto);
  Serverclient.print("Versao");
  Serverclient.print(Versao);
  Serverclient.print(".");
  Serverclient.println(Release);

}

//Mostra o nro digitado no buffer
void Digitado()
{
  //sprintf(BufferKeypad, "%s%c  ", BufferKeypad, customKey)
  Imprime(1, "Teclado:                ");
  Imprime(2, String(BufferKeypad));
  Serial.print("Digitado:");
  Serial.println(BufferKeypad);
}


void Le_Servidor()
{
  //Ativa somente se Ethernet Ok
  if (!flgEthernetErro)
  {
    // wait for a new client:
    EthernetClient Serverclient = serverport.available();

    // when the client sends the first byte, say hello:
    if (client)
    {
      if (!gotAMessage) //Caso não tenha boas vindas
      {
        Serial.println("Nova conexao disponível");
        HelloClient();
        //AguardaCMD();
        gotAMessage = true;
      }

      // read the bytes incoming from the client:
      char customKey = client.read();
      flgRServer = true; //Levanta recebimento de informacao do servidor
      // echo the bytes back to the client:
      serverport.write(customKey);
      // echo the bytes to the server as well:
      Serial.print(customKey);

      if (customKey != NO_KEY)
      {
        //contciclo = maxciclo;//na proxima verificao atualiza a tela
        if (customKey >= '0' && customKey <= '9')
        {
          sprintf(BufferEthernet, "%s%c", BufferEthernet, customKey);
          Digitado();
        }
        if (customKey == '#') //Limpa Buffer
        {
          sprintf(BufferEthernet, "%s\n", BufferEthernet);
        }
        if (customKey == '*') //Limpa Buffer
        {
          sprintf(BufferEthernet, "");
        }

        //keyF1
        if (customKey == keyF1 ) //Menu funcoes
        {
          sprintf(BufferEthernet, "MCONFIG\n");
        }

        //keyF2
        if (customKey == keyF2 ) //Menu funcoes
        {
          sprintf(BufferEthernet, "MOPERACAO\n");
        }

        //keyenter
        if (customKey == keyenter ) //Menu funcoes
        {
          //sprintf(BufferEthernet, "MOPERACAO\n");
          Imprime(3, "Sem funcionamento    ");
        }

        //keyEsc
        if (customKey == keyesc ) //Escape no menu principal
        {
          //Reset();
        }

      }

    }
  }

}

/************************ Fim de bloco de funcoes de LOAD ************************/

int ShowHours()
{
  TempminAtual = (millis() - TempminTotal)/1000 ;
  return TempminAtual / 3600;
}

int ShowMinutes()
{
  TempminAtual = (millis() - TempminTotal)/1000 ;
  return (TempminAtual / 60) % 60;
}

int ShowSeconds()
{
  TempminAtual = (millis() - TempminTotal) / 1000;
  return TempminAtual % 60;
}

//Carrega a aplicação para o SD
void LOAD(File root, char sMSG1[20])
{
  Imprime(1, "Carregando FIRMWARE...");

  //Copia arquivo
  sprintf(ArquivoTrabalho, "%s", sMSG1);
  Imprime(2, ArquivoTrabalho);

  //Realiza operação de Loop
  LOADLoop(root, ArquivoTrabalho);
}

/*
/*Faz download do aplicativo*
void DownloadTFT(String filename){
  NexUpload nex_download(filename,10,115200);
  // put your setup code here, to run once:
  nex_download.upload();
}
*/



void MAN()
{
  //Device Console
  Serial.println("Projeto RELOGIO");
  Serial.print("Versao:");
  Serial.print(Versao);
  Serial.print(".");
  Serial.println(Release);
  Serial.println("MAN - AUXILIO MANUAL");
  Serial.println("LSTDIR - LISTA DIRETORIO");
  Serial.println("LOAD - CARREGA ARQUIVO NO SD");
  Serial.println("LOADTFT - CARREGA NO TFT");
  Serial.println("VOICEREDON - VOICE REDIRECT ");
  Serial.println("VOICEREDOFF- VOICE NORMAL ");
  Serial.println("PLAY- PLAY MUSIC ");
  Serial.println("NEXT- NEXT MUSIC ");
  Serial.println("STOP- STOP MUSIC ");  
  Serial.println("PREV- PREVIUS MUSIC "); 
  Serial.println("VOLUP- VOLUME UP ");   
  Serial.println("VOLDOWN- VOLUME DOWN ");  
  Serial.println("MSG=[texto]; - MENSAGEM NA TELA"); 
  Serial.println(" ");
}

//Comando de entrada do Teclado
void KeyCMD()
{
  bool resp = false;
  int vret = 0;
  //incluir busca /n
  if (strchr(BufferKeypad, '\n') > 0)
  {
    if ((strcmp(BufferKeypad, "\n\r") == 0) | (strcmp(BufferKeypad, "\r\n") == 0) | (strcmp(BufferKeypad, "\r") == 0) | (strcmp(BufferKeypad, "\n") == 0))
    {
      Serial.println("Comando Vazio!");
      resp = true;
    }
   
    //PLay music
    if (vret = strncmp("MAN\n", BufferKeypad, 4) == 0)
    {
        //Serial.println(Temperatura);
        MAN();
        resp = true;
    }
    
    if (vret = strncmp("PLAY\n", BufferKeypad, 5) == 0)
    {
        //Serial.println(Temperatura);
        PlayMusic();
        resp = true;
    }

    if (vret = strncmp("NEXT\n", BufferKeypad, 5) == 0)
    {
        //Serial.println(Temperatura);
        NextMusic();
        resp = true;
    }
    
    if (vret = strncmp("STOP\n", BufferKeypad, 5) == 0)
    {
        //Serial.println(Temperatura);
        StopMusic();
        resp = true;
    }

    if (vret = strncmp("PREV\n", BufferKeypad, 5) == 0)
    {
        //Serial.println(Temperatura);
        PreviusMusic();
        resp = true;
    }


    if (vret = strncmp("VOLUP\n", BufferKeypad, 6) == 0)
    {
        //Serial.println(Temperatura);
        VolUpMusic();
        resp = true;
    }

    if (vret = strncmp("VOLDOWN\n", BufferKeypad, 8) == 0)
    {
        //Serial.println(Temperatura);
        VolDownMusic();
        resp = true;
    }
    //Controle de FlagStop para comandos adicionais
    if (!flgLeituraBasica) //Caso ativo inibe leitura de campos adicionais
    {
      Serial.println("flgLeituraBasica não Ativo!");
      //Inicio
      if (vret = strncmp("INICIAR;\n", BufferKeypad, 8) == 0)
      {
        Serial.println("CMD Inicio");
        //Marcação de Inicio de tempo do programa
        PrgTemp = millis();
        //Reset();
        //CLS;
        resp = true;
      }
      Serial.print("vret:");
      Serial.println(vret);

      //FIM
      if (vret = strncmp("FIM;\n", BufferKeypad, 4) == 0)
      {
        Serial.println("CMD Fim");
        //Reset();
        //CLS;
        //WellCome();
        resp = true;
      }


      //LstDir - Lista o Diretorio
      if (vret = strncmp("LSTDIR\n", BufferKeypad, 7) == 0)
      {
        char sMSG1[16];
        strncpy(sMSG1, BufferKeypad, 7);
        Imprime(1, "LSTDIR           ");
        Imprime(2, "                 ");
        //root = card.open(sMSG1);
        root = SD.open("/");
        LstDir(root, 0);

        resp = true;
      }


      if (vret = strncmp("MSG=", BufferKeypad, 4) == 0)
      {
        //Serial.println("CMD MSG");

        //char sMSG1[20];
        String cmd = BufferKeypad;
        String params, param1;
        int posvir = cmd.indexOf("=");
        int posfim = cmd.indexOf(";");
        params = cmd.substring(posvir + 1, posfim);
        //Serial.print("Params: ");
        //Serial.println(params);

        //Serial.println("Posfim: ");
        //Serial.println(posfim);
        if (posvir > 0)
        {
          Mensagem = cmd.substring(posvir + 1, posfim );
          //Serial.print("Param1: ");
          //Serial.println(param1);

          //Imprime(1, param1);

          resp = true;
        }
      }
      

      //Run(String Arquivo)c
      //Roda o script
      if (vret = strncmp("LOADTFT(", BufferKeypad, 8) == 0)
      {
        //Serial.println("RUN achou!");
        String cmd = BufferKeypad;
        String params, param1;
        params = cmd.substring(vret + 7);
        int posvir1 = cmd.indexOf("(");
        int posvir2 = cmd.indexOf(");");
        int posfim = strncmp(BufferKeypad, "); ", 2);
        //Serial.println("Posfim: ");
        //Serial.println(posfim);
        if (posfim > 0)
        {
          //strncpy(sMSG1, &BufferKeypad[poscmd+4], posfim - (poscmd+4));
          param1 = cmd.substring(vret + 7, posvir2 - (posvir1 + 1));
          Serial.print("Carrega:");
          Serial.println(param1);
          
          //DownloadTFT(param1);
          //Imprime(1, sMSG1);
          //Imprime(2, sMSG1);
          resp = true;
        }
      }

      //Load - Carrega arquivo no SD
      if (vret = strncmp( "LOAD=", BufferKeypad, 5) == 0)
      {
        Serial.println("Load achou!");
        String cmd = BufferKeypad;
        String params;
        char param1[30];
        params = cmd.substring(vret + 4);
        int posvir1 = cmd.indexOf("=");
        int posvir2 = cmd.indexOf(";");
        //int posfim = strncmp(BufferKeypad, ";", 2);
        Serial.println("posvir2: ");
        Serial.println(posvir2);
        if (posvir2 > 0)
        {

          Arquivo1 = "/" + cmd.substring(posvir1 + 1, posvir2 - 1);
          Serial.print("LOAD:");
          Serial.println(Arquivo1);
          //Arquivo = param1;

          Arquivo1.toCharArray(param1, Arquivo1.indexOf(";"));
          LOAD(param1); //Parametro passado em Arquivo
          resp = true;
        }
      }


      //MOPERACAO
      if (vret = strncmp("MOPERACAO\n", BufferKeypad, 10) == 0)
      {
        //MOPERACAO();
        resp = true;
      }

      //MCONFIG Menu de Setup
      if (vret = strncmp("MCONFIG\n", BufferKeypad, 8) == 0)
      {
        //MCONFIG();
        resp = true;
      }

      //Redireciona Serial para voice
      if (vret = strncmp("VOICEREDON\n", BufferKeypad, 11) == 0)
      {
        //MCONFIG();
        flgRedSerial1 = true;
        Imprime(2,"VOICE COMANDO REDIRECIONADO ");
        resp = true;
      }
      //Desativa Redirecionamento de Serial para voice
      if (vret = strncmp("VOICEREDOFF\n", BufferKeypad, 12) == 0)
      {
        //MCONFIG();
        flgRedSerial1 = false;
        Imprime(2,"MODO SERIAL NORMAL          ");
        resp = true;
      }
      //MDEFAULT
      if (vret = strncmp("MDEFAULT\n", BufferKeypad, 9) == 0)
      {
        //MCONFIG();
        Serial.println("Ja em Default");

        Imprime(3, "Ja em Default");
        resp = true;
      }
      /*Bloco de tratamento do Voice*/
      if (flgRedSerial1){
        if (vret = strncmp("MDEFAULT\n", BufferKeypad, 9) == 0)
        {
          //MCONFIG();
          Serial.println("Ja em Default");

          Imprime(3, "Ja em Default");
          resp = true;
        }
      }
    }
    else
    {
      Serial.println("Flagstop ativo!");
      //resp = true;
    }

    //Verifica se houve comando valido
    if (resp == false)
    {
      Serial.print("Cmd nao reconhecido:");
      Serial.print(BufferKeypad);
      Serial.println("!");


      Imprime(3, "Cmd n reconhecido");
      //strcpy(BufferKeypad,'\0');
      memset(BufferKeypad, 0, sizeof(BufferKeypad));
      flgErro = true; //Ativa comando de erro
    }
    else
    {
      //strcpy(BufferKeypad,'\0');
      memset(BufferKeypad, 0, sizeof(BufferKeypad));
    }
  }
}


//Emula Espera do ESC
void Wait()
{
  flgWait = true;
  Serial.println("Wait();");
  //delay(500);
  Imprime(2, "ESC p/ Continuar ");
  do
  {
    Le_Teclado();
    delay(100);
  } while (flgWait == true);

}


//Analisa Entrada de Informacoes de Entrada
void Analisa()
{
  KeyCMD(); //Analisa o que esta na entrada do buffer de teclado
  //KeyCMDBluetooth(); //Analisa o que esta na entrada do buffer do bluetooth
  //KeyCMDEthernet(); //Analisa o que esta na entrada do buffer do bluetooth
}

void Le_Bluetooth(){
  char key;
  while (Bluetooth.available() > 0)
  {
    key = Bluetooth.read();

    if (key != 0)
    {
      //Serial.print(key);
      if(flgRedSerial1) { //Redirect Voice
        Serial1.print(key);
      }
      //BufferKeypad += key;
      sprintf(BufferKeypad, "%s%c", BufferKeypad, key);
    }
  }  
}

//Le registro do Serial
void Le_Serial()
{
  char key;
  while (Serial.available() > 0)
  {
    key = Serial.read();

    if (key != 0)
    {
      //Serial.print(key);
      if(flgRedSerial1) { //Redirect Voice
        Serial1.print(key);
      }
      //BufferKeypad += key;
      sprintf(BufferKeypad, "%s%c", BufferKeypad, key);
    }
  }
}




//Carrega a aplicação para o SD
void LOAD(char *ArquivoTrabalho)
{
  //Reset();//Comando de Carga Reset valores
  Imprime(1, "Carregando APP...");

  Imprime(2, ArquivoTrabalho);
  Serial.println("Carregando APP:");
  Serial.println(ArquivoTrabalho);
  //File dir = root;

  File dataFile = SD.open(ArquivoTrabalho, FILE_WRITE);
  char inByte;
  flgWait  = true;

  Serial.println("Recebendo Firmware:");
  Serial.println(' ');

  do
  {
    if (Serial.available() > 0)
    {
      inByte = Serial.read();
      //Sai quando caracter é mais
      if (inByte == '+')
      {
        flgWait = false;
        break;
      }
      else
      {
        if (dataFile)
        {
          dataFile.write(inByte);
          Serial.print(inByte);
        }
        else
        {
          Imprime(1, "Erro SD");
          Serial.println("Erro SD!");
          flgWait = false;
          flgErro = true;
          break;
        }
      }
    }
    //Le informações do teclado
    //Le_Teclado();
    //Processa o comando
    //KeyCMD();
  } while (flgWait == true);
  dataFile.close();
  Serial.println("Finalizou gravacao");
  if (flgErro == false)
  {
    Imprime(1, "Arquivo Salvo");
    Serial.println("Arquivo Salvo!");
  }
  flgWait = false;

}

//Funcao Menu Teclado, porque o teclado se comporta diferente
//Em operacoes diferentes
void Le_Teclado()
{
  //Le Teclado
  customKey = customKeypad.getKey();
  if (customKey != NO_KEY)
  {
    if (customKey >= '0' && customKey <= '9')
    {
      sprintf(BufferKeypad, "%s%c", BufferKeypad, customKey);
      //CLS();
      //Imprime(0, "KEYBOARD: ");
      Imprime(3, "Nro: " + String(BufferKeypad));
    }
    if (customKey == '#') //Limpa Buffer
    {
      sprintf(BufferKeypad, "%s\n", BufferKeypad);

    }
    if (customKey == '*') //Limpa Buffer
    {
      sprintf(BufferKeypad, "");
    }

    //keyF1
    if (customKey == keyF1 ) //Menu funcoes
    {
      sprintf(BufferKeypad, "MCONFIG\n");
    }

    //Pagina Para Baixo
    if (customKey == keydown ) //Menu funcoes
    {
      sprintf(BufferKeypad, "PAGEDOWN\n");
    }
    //Pagina Para Cima
    if (customKey == keyup ) //Pagina para cima
    {
      sprintf(BufferKeypad, "PAGEUP\n");
    }

    //ESCAPE para funcoes avancadas
    if (customKey == keyesc ) //Menu funcoes
    {
      sprintf(BufferKeypad, "MDEFAULT\n");
    }

    //keyenter
    if (customKey == keyenter ) //Inclui o Enter ao fim
    {
      //sprintf(BufferKeypad, "MOPERACAO\n");
      sprintf(BufferKeypad, "%s\n", BufferKeypad);
    }

  } //Bloco que verifica se existe alguma tecla digitada
}


void Le_Button(){
  Button = analogRead(pinbutton);
  Button = (Button<20)?0:Button;
  
  //Serial.println(Button);
}

void Le_DHT() {
  //Serial.print("   Celsius => ");
  //Serial.println(String(double(dht.celsius) / 10, 1));
  Temperatura = dht.celsius;
  //Serial.print("   Humdity => ");
  //Serial.println(String(double(dht.humidity) / 10, 1));
  Humidade = dht.humidity;
  FTemperatura();
}

//Mostra a temperatura na tela e na serial se o flg estiver habilitado
void FTemperatura()
{
  if (flgTemperatura == true)
  {
    //Temperatura atual
    char bufferTemp[20];
    char bufferHum[20];
    dtostrf(Humidade/10, 2, 1, bufferHum);
    
    dtostrf(Temperatura/10, 2, 1, bufferTemp);
    //TempminAtual = (millis() - TempminStart) / 60000;
    strInfo = String("Temp:") + String(bufferTemp) + String("C Hum:")+ String(bufferHum)+String("%");
    Imprime(2, strInfo);
    //Serial.println(strInfo);
    //Serial3.println(strInfo);
  }
}

void Le_Nextion(){
  nexLoop(nex_listen_list);
}

void Le_Voice(){
  if (Serial1.available()) {
    int inByte = Serial1.read();
    Serial.write(inByte);
  }
  
}

void Leituras()
{
  Le_Serial(); 
  Le_DHT();
  SRV_Web();
  Le_Button();
  Le_Voice();
  Le_Bluetooth();
  Le_UDP();
  Le_Servidor();
  Le_Teclado();
  Le_Nextion();

  
}

void Escritas(){
  //tData.setText("29/12/1973");
  String label;
  label = HORAATUAL + " "+ DATAATUAL;
  Imprime(3,label.c_str());
  //txtData.setText(label.c_str());
  txtData.setText(DATAATUAL.c_str());
  txtms1.setText(Mensagem.c_str());
  txtmu1.setText(Musica.c_str());
  Imprime(0,String((Button!=0)?String('\1'):" ")+ " "+ String((flgTemperatura!=0)?String('\3'):" ")); /* Parametros do relogio */

}

void loop()
{
  //Serial.println(".");
  Leituras();
  Analisa();
  Escritas();
  //Modulo de contagem de ciclos
  if (contciclo >= maxciclo)
  {
    contciclo = 0;
    //WellCome();
    //Le_Temperatura();

  }
  contciclo++;
  //txtData.setText("Press me!");
  
}
