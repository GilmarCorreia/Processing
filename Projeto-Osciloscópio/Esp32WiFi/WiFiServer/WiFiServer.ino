#include <WiFi.h>
#include <Wire.h>
#include <Adafruit_ADS1015.h>

const char* ssid     = "GilPhone";
const char* password = "yyyb4545";
//const char* ssid     = "NetGil";
//const char* password = "551138920891";
const int javaPort = 80;
const int tsPort = 81; 
char c;
boolean b1,b2,b3,b4; 
unsigned int gnd, pot, ad0,ad1,ad2,ad3;

Adafruit_ADS1115 ads(0x48);

WiFiServer server(javaPort);


void setup(){
  //Serial.begin(115200);
  pinMode(13,INPUT);
  pinMode(12,INPUT);
  pinMode(14,INPUT);
  pinMode(27,INPUT);

  // We start by connecting to a WiFi network

  //Serial.println();
  //Serial.println();
  //Serial.print("Connecting to ");
  //Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    //Serial.print(".");
  }

  //Serial.println("");
  //Serial.println("WiFi connected.");
  //Serial.println("IP address: ");
  //Serial.println(WiFi.localIP());
  server.begin();

  xTaskCreatePinnedToCore(loop2, "loop2", 8192, NULL, 1, NULL, 0);
  delay(1);
}

void loop(){
  WiFiClient client = server.available();
  
  
  if (client) {                           
    while (client.connected()) { 
      if (client.available()) {           
        c = client.read();
        if(c == 'U'){
          client.print('E');
          client.print(b1);
          client.print(',');
          client.print(b2);
          client.print(',');
          client.print(b3);
          client.print(',');
          client.print(b4);
          client.print(',');
          client.print(gnd);
          client.print(',');
          client.print(pot);
          client.print(',');
          client.print(ad0);
          client.print(',');
          client.print(ad1);
          client.print(',');
          client.print(ad2);
          client.print(',');
          client.print(ad3);
          client.println('F'); 
        }
      }
    }
    client.stop();
  }
} 

void readWiFi(){  
  b1 = digitalRead(13);
  b2 = digitalRead(12);
  b3 = digitalRead(14);
  b4 = digitalRead(27);
  gnd = analogRead(36);
  pot = analogRead(32);
  ad0 = ads.readADC_SingleEnded(0);
  ad1 = ads.readADC_SingleEnded(1);
  ad2 = ads.readADC_SingleEnded(2);
  ad3 = ads.readADC_SingleEnded(3);
}

void loop2(void * z){
  ads.begin();
 
  while(1){
    readWiFi();
  }
}
