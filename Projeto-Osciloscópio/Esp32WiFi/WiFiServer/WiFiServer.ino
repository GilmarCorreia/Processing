#include <WiFi.h>
#include <Wire.h>
#include <Adafruit_ADS1015.h>
#include <Adafruit_MCP4725.h>
#include "FS.h"
#include "SD.h"
#include "SPI.h"

// CAMINHO PARA O CARTÃO SD
  String caminho = "/";
  int controlSave = 0;

// VARIÁVEIS DA CONEXÃO WIFI
  //const char* ssid     = "GilPhone";
  //const char* password = "yyyb4545";
  const char* ssid     = "NetGil";
  const char* password = "551138920891";
  const int javaPort = 80;
  const int tsPort = 81;
  WiFiServer server(javaPort);
  WiFiClient clients[2] = {NULL};
  
  String apiKey = "NSTEN0TRURC965W3";       //trocar pela API Write
  const char* serverThingSpeak = "api.thingspeak.com";

// VARIÁVEIS PARA RECEBER O ENVIAR POR WI-FI
  char c;
  boolean b1, b2, b3, b4;
  unsigned int gnd, pot, ad0, ad1, ad2, ad3;
  char msg[200] = "E";
  //String imagem;

// PORTAS UTILIZADAS DO ARDUINO
  int groundPort = 36;
  int potenciometerPort = 32;
  int buttonScalePort = 13;
  int buttonCursorPort = 12;
  int buttonOffsetPort = 14;
  int buttonSavePort = 27;

// DEFININDO ADC da ADAFRUIT
  Adafruit_ADS1115 ads(0x48);
  
// DEFININDO DAC DA ADAFRUIT E SEUS PARÂMETROS
  Adafruit_MCP4725 dac;

  int onda = 1; //ONDA 1 ATIVA A ONDA QUADRADA, 2 ATIVA A TRIANGULAR E 3 ATIVA A SENOIDAL.
  double timer;
  uint16_t passo = 0;

void setup() {
  Serial.begin(115200);

  // SETANDO PORTAS DE SAÍDA DIGITAL PARA BOTÕES DO OSCILOSCÓPIO
    pinMode(buttonScalePort, INPUT);
    pinMode(buttonCursorPort, INPUT);
    pinMode(buttonOffsetPort, INPUT);
    pinMode(buttonSavePort, INPUT);

  // We start by connecting to a WiFi network
    Serial.println();
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);

  // INICIALIZAÇÃO DA COMUNICAÇÃO WIFI
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }

    Serial.println("");
    Serial.println("WiFi connected.");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
    server.begin();

  // INICIALIZANDO FUNÇÃO PARA RODAR NO SEGUNDO CORE DA ESP
    xTaskCreatePinnedToCore(loop2, "loop2", 8192, NULL, 1, NULL, 0);
    delay(1);

  // CONFIGURAÇÕES PARA CARTÃO SD
    //Serial.begin(115200);
    if (!SD.begin()) {
      Serial.println("Módulo SD Falhou");
      return;
    }
    uint8_t cardType = SD.cardType();
  
    if (cardType == CARD_NONE) {
      Serial.println("Nenhum SD conectado");
      return;
    }

    Serial.print("Tipo do Cartão SD: ");
    if (cardType == CARD_MMC) {
      Serial.println("MMC");
    } else if (cardType == CARD_SD) {
      Serial.println("SDSC");
    } else if (cardType == CARD_SDHC) {
      Serial.println("SDHC");
    } else {
      Serial.println("UNKNOWN");
    }

    uint64_t cardSize = SD.cardSize() / (1024 * 1024);
    Serial.printf("Tamanho do Cartão SD: %lluMB\n", cardSize);
    Serial.println();
  
    Serial.print(caminho + ": "); 
}

void loop() {
  clients[0] = server.available();
  
  //ThingSpeak(false);
      
  if (clients[0]) {
    
    while (clients[0].connected()) {
      
      //ThingSpeak(true);
      
      if (clients[0].available()) {

        c = clients[0].read();
        
        if (c == 'U') 
          serverSendData();
        else if (c == 'I') {
          unsigned int tamanho = 0;
          do{
            c = clients[0].read();
            if(c!='I')
              tamanho = tamanho*10 + (c-'0');
          } while(c != 'I');
          float valorCursor[4]={0};
          int k = 0;
          int count = 1;
          int sign = 1;
          boolean decimal = false;
          do{
            c = clients[0].read();
            if(c=='-' || c =='-')
              sign = -1;
            else{
              if(c!='I' && c!=','){
                if(c!='.' && !decimal)
                  valorCursor[k] = valorCursor[k]*10 + (c-'0');
                else if(c=='.')
                  decimal = true;
                else if(decimal){
                  float soma = (float)(c-'0');
                  for(int a = 0;a<count;a++)
                    soma = soma/10; 
                  count++;
                  valorCursor[k] = valorCursor[k] + soma;
                }
              }
              else{
                valorCursor[k] *=sign;
                k++;
                sign = 1;
                count = 1;
                decimal = false;
              }
            }
          } while(c != 'I');
          clientReceiveImage(tamanho, valorCursor);
          clients[0].println('F');
        }
        //else if (c == 'C') {}

      }  
      
    }
    
    clients[0].stop();
    Serial.println("Client Disconnected.");
    
  }
}   
