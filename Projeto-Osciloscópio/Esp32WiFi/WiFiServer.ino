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

void loop(){
  WiFiClient client = server.available();   // listen for incoming clients
  
  //Serial.println(ads.readADC_SingleEnded(0));
  
  if (client) {                             // if you get a client,
    Serial.println("New Client.");           // print a message out the serial port
    String currentLine = "";                // make a String to hold incoming data from the client
    while (client.connected()) {            // loop while the client's connected
      if (client.available()) {             // if there's bytes to read from the client,
        uint8_t c[4];
        client.read(c,4);

        if()
        Serial.println((char)c[0]);

        /*
        if(c == 'A' || c == 'R' || c == 'D' || c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9'){
          Serial.println(c);
          if(c.charAt(0) == 'D' && c.charAt(1) == 'R')
            client.println(digitalRead(c.toInt()));       
          else if(c.charAt(0) == 'A' && c.charAt(1) == 'R')
            client.println(analogRead(c.toInt()));       
          else if(c.charAt(0) == 'A'&& c.charAt(1) == 'D' && c.charAt(2) == 'R')
            client.println(ads.readADC_SingleEnded(c.toInt()));       
          else
            client.println(0);
        } 
        */

        client.println(0);
        
      }
    }
    // close the connection:
    client.stop();
    Serial.println("Client Disconnected.");
  }

}
