#include "Nextion.h"
#include "NexUpload.h"
#include <SPI.h>
#include <TimeLib.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <DTime.h>
#include <SDHT.h>
#include <SD.h>
#include <Keypad.h>
#include "SerialMP3Player.h"

//****************** Defines ******************
#define TX 14
#define RX 15

//*************** Descricao do Produto *********************
char Versao = '0';  //Controle de Versao do Firmware
char Release = '1'; //Controle Revisao do Firmware
char Produto[20] = { "Relogio"};
char Empresa[20] = {"Maurinsoft"};

/*Controle de contagem de ciclos*/
const float maxciclo  = 9000;
float contciclo = 0; //Contador de Ciclos de Repeticao

//Flags de Controle
bool OperflgLeitura = false;
byte flgEscape = 0; //Controla Escape
byte flgEnter = 0; //Controla Escape
byte flgTempo = 0; //Controle de Tempo e 

//****************** Variaveis Globais ******************
//Variaveis associadas ao SD CARD
Sd2Card card;
SdVolume volume;
File root; //Pasta root
File farquivo; //Arquivo de gravacao
char ArquivoTrabalho[40]; //Arquivo de trabalho a ser carregado
File myFile;


//Buffer do Teclado e Input
char customKey;
char BufferKeypad[40]; //Buffer de Teclado
//BufferBluetooth
char BufferBluetooth[40]; //Buffer do bluetooth
char BufferEthernet[40]; //Buffer do 


/*Variaveis do Nextion*/
NexPage pageSplash    = NexPage(0, 0, "splash");
NexPage pageMain    = NexPage(0, 1, "main");
NexButton btEntrar = NexButton(0, 1, "btentrar");
NexButton btMainSetup = NexButton(1, 4, "b0");
NexText tData = NexText(1, 2, "t3");
char buffer[100] = {0};

/*
 * Register a button object to the touch event list.  
 */
NexTouch *nex_listen_list[] = 
{
    &pageSplash,
    &btEntrar,
    &btMainSetup,
    NULL
};

/*Variavies associadas ao MP3*/
SerialMP3Player mp3(RX,TX);



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

/*HORA ATUAL*/
String HORAATUAL;
String DATAATUAL;

/*Faz download do aplicativo*/
void DownloadTFT(){
  NexUpload nex_download("nex.tft",10,115200);
  // put your setup code here, to run once:
  nex_download.upload();
}

/*
 * Button component pop callback function. 
 * In this example,the button's text value will plus one every time when it is released. 
 */
void btEntrarCallback(void *ptr)
{
  Serial.println("btEntrar Click");
    
}
void btMainSetupCallback(void *ptr)
{
  Serial.println("btMainSetup Click");
    
}

void pageSplashCallback(void *ptr)
{
  Serial.println("page Splash Click");
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

void Start_SD()
{
  Serial.print("Start SD card...");

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
}

void Start_Nextion(){
    Imprime(2, " Start NEXTION    ");
    Serial.println("Start Nextion...");
    /* Set the baudrate which is for debug and communicate with Nextion screen. */
    nexInit();

    /* Register the pop event callback function of the current button component. */
    pageSplash.attachPop(pageSplashCallback);
    btEntrar.attachPop(btEntrarCallback, &btEntrar);
    btMainSetup.attachPop(btMainSetupCallback, &btMainSetup);
}

void Start_NTP()
{
  Imprime(2, "  Start NTP         ");
  Serial.println("Start NTP...");
  EthernetUdp.begin(localPort);
  Serial.println("waiting for sync");
  setSyncProvider(getNtpTime);
}


void Start_Ethernet()
{
  Imprime(2, " Start ETHERNET      ");
  Serial.println("Start Ethernet...");
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
  sprintf(myIP,"%d.%d.%d.%d",Ethernet.localIP()[0],Ethernet.localIP()[1],Ethernet.localIP()[2],Ethernet.localIP()[3]);
  Serial.println(myIP);
}


void Start_MP3(){
  Imprime(2, " Start MP3           ");
  Serial.println("Start MP3...");
  mp3.showDebug(1);       // print what we are sending to the mp3 board.

  //Serial.begin(9600);     // start serial interface
  mp3.begin(9600);        // start mp3-communication
  delay(500);             // wait for init

  mp3.sendCommand(CMD_SEL_DEV, 0, 2);   //select sd-card
  delay(500);             // wait for init
}





void setup()
{
  Start_Serial();
  Start_LCD();
  Wellcome();
  Start_Nextion();  
  Start_Ethernet();
  Start_NTP();
  Start_SD();
  Start_MP3();
  char info[20];
  sprintf(info,"IP:%s     ",myIP);
  Imprime(1, info);
  Serial.println("Start Complete!");
  delay(2000);
  Imprime(2,"                     ");

}

/*Mostra a pagina principal do site*/
void PageIndex(EthernetClient client )
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
            PageIndex(client);
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
  Serial.println("LOAD - CARREGA ARQUIVO");
  Serial.println(" ");
}

//Comando de entrada do Teclado
void KeyCMD()
{
  bool resp = false;

  //incluir busca /n
  if (strchr (BufferKeypad, '\n') != 0)
  {
    Serial.print("Comando:");
    Serial.println(BufferKeypad);

    

    //LstDir - Lista o Diretorio
    if (strcmp( BufferKeypad, "LSTDIR;\n") == 0)
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



    //MAN
    if (strcmp( BufferKeypad, "MAN;\n") == 0)
    {
      //Serial.println(Temperatura);
      MAN();
      resp = true;
    }



    //Load - Carrega arquivo no SD
    if (strncmp( "LOAD=",BufferKeypad, 5) == 0)
    {
      char sMSG1[16];
      //strncpy(sMSG1, BufferKeypad, 7);
      strncpy(sMSG1, &BufferKeypad[6], strlen(BufferKeypad) - 6);
      //Imprime(0, sMSG1);
      //root = card.open(sMSG1);
      root = SD.open("/");
      LOAD(root, sMSG1);

      resp = true;
    }

    //MDEFAULT
    if (strcmp( BufferKeypad, "MDEFAULT\n") == 0)
    {
      //MCONFIG();
      Serial.println("Ja em Default");
      Imprime(3, "Ja em Default");
      resp = true;
    }

    //Verifica se houve comando valido
    if (resp == false)
    {
      Serial.print("Comando:");
      Serial.println(BufferKeypad);
      Serial.println("Cmd nao reconhecido");
      Imprime(3, "Cmd n reconhecido");
      //strcpy(BufferKeypad,'\0');
      memset(BufferKeypad, 0, sizeof(BufferKeypad));
    }
    else
    {
      //strcpy(BufferKeypad,'\0');
      memset(BufferKeypad, 0, sizeof(BufferKeypad));
    }
  }

}



//Analisa Entrada de Informacoes de Entrada
void Analisa()
{
  KeyCMD(); //Analisa o que esta na entrada do buffer de teclado
  //KeyCMDBluetooth(); //Analisa o que esta na entrada do buffer do bluetooth
  //KeyCMDEthernet(); //Analisa o que esta na entrada do buffer do bluetooth
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
      Serial.print(key);
      //BufferKeypad += key;
      sprintf(BufferKeypad, "%s%c", BufferKeypad, key);
    }
  }
}




void Leituras()
{
  Le_Serial(); 
  SRV_Web();
  nexLoop(nex_listen_list);
  Le_UDP();
  Le_Servidor();
  
}

void Escritas(){
  //tData.setText("29/12/1973");
  String label;
  label = HORAATUAL + " "+ DATAATUAL;
  Imprime(3,label.c_str());
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
  
}
