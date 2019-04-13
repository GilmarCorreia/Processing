/*
WiFi Web Server LED Blink

A simple web server that lets you blink an LED via the web.
This sketch will print the IP address of your WiFi Shield (once connected)
to the Serial monitor. From there, you can open that address in a web browser
to turn on and off the LED on pin 5.

If the IP address of your shield is yourAddress:
http://yourAddress/H turns the LED on
http://yourAddress/L turns it off

This example is written for a network using WPA encryption. For
WEP or WPA, change the Wifi.begin() call accordingly.

Circuit:
* WiFi shield attached
* LED attached to pin 5

created for arduino 25 Nov 2012
by Tom Igoe

ported for sparkfun esp32 
31.01.2017 by Jan Hendrik Berlin

*/

#include <WiFi.h>
#include <Wire.h>
#include <Adafruit_ADS1015.h>


//const char* ssid     = "GilPhone";
//const char* password = "yyyb4545";
const char* ssid     = "NetGil";
const char* password = "551138920891";
const int javaPort = 80;
const int tsPort = 81; 

Adafruit_ADS1115 ads(0x48);

WiFiServer server(javaPort);

void setup(){
  Serial.begin(230400);
  pinMode(13,INPUT);
  pinMode(12,INPUT);
  pinMode(14,INPUT);
  pinMode(27,INPUT);

  // We start by connecting to a WiFi network
  
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
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
  ads.begin();
}

int value = 0;
char c[4];
void loop(){
  WiFiClient client = server.available();   // listen for incoming clients
  
  //Serial.println(ads.readADC_SingleEnded(0));
  
  if (client) {                             // if you get a client,
    Serial.println("New Client.");           // print a message out the serial port
    String currentLine = "";                // make a String to hold incoming data from the client
    while (client.connected()) {    // loop while the client's connected
      int i = 0;
      if (client.available()) {             // if there's bytes to read from the client,
  
        c[i] = client.read();
    
        if(c[0] == 'A' || c[0] == 'D'){
          while (client.connected() && c[i-1] != '\n' && c[i-1] != '\0') {
            if(client.available())
              c[++i] = client.read();
          }
          
          
          for(int k = 0; k < i;k++){
            if(k<=1)  
              Serial.print(c[i]);
            else
              Serial.print((int)(c[i]-'0'));
          }
          Serial.println();
          
          int receiveMessage = 0;
          for(int k = 2; k < i;k++)
            receiveMessage = receiveMessage*10+(int)(c[k]-'0');

          int sendMessage = 0;
          if(c[0] == 'D' && c[1] == 'R'){
            sendMessage = digitalRead(receiveMessage);       
          }
          else if(c[0] == 'A' && c[1] == 'R')
            sendMessage = analogRead(receiveMessage);       
          else if(c[0] == 'A'&& c[1] == 'D')
            sendMessage = ads.readADC_SingleEnded(receiveMessage);    

          Serial.print("Mensagem enviada: ");
          Serial.println(sendMessage);
          client.println(sendMessage);
        } 

        client.println(0);
        
      }
    }
    // close the connection:
    client.stop();
    Serial.println("Client Disconnected.");
  }

} 
