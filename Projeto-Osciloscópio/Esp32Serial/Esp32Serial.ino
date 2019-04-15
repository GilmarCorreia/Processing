
#include <Wire.h>
#include <Adafruit_ADS1015.h>

Adafruit_ADS1115 ads(0x48);


void setup(){
  Serial.begin(230400);
  pinMode(13,INPUT);
  pinMode(12,INPUT);
  pinMode(14,INPUT);
  pinMode(27,INPUT);
  
  ads.begin();
}

int value = 0;
char c[6];
void loop(){
  int i = 0;
  
  if (Serial.available()>0) {             // if there's bytes to read from the client,
  
    c[i] = Serial.read();
    
    if(c[0] != 'A' || c[0] == 'D'){
      while (Serial.available()>0 && c[i]!='F') {
        i++;
        c[i] = Serial.read();
      }
        
      int receiveMessage = 0;
      for(int k = 2; k < i;k++)
        receiveMessage = receiveMessage*10+(int)(c[k]-'0');
      
      int16_t sendMessage = 0;
      if(c[0] == 'D' && c[1] == 'R')
        sendMessage = digitalRead(receiveMessage);       
      else if(c[0] == 'A' && c[1] == 'R')
        sendMessage = analogRead(receiveMessage);       
      else if(c[0] == 'A'&& c[1] == 'D')
        sendMessage = ads.readADC_SingleEnded(receiveMessage);    
      
      
      // IMPRIMIR MENSAGEM RECEBIDA
      //for(int k = 0; k < i;k++){
      //  if(k<=1)  
      //    Serial1.print((char)(c[k]));
      //  else
      //    Serial1.print((int)(c[k]-'0'));
      //}
      

      Serial.print('E');
      Serial.print(sendMessage);
      Serial.print('F');
      delay(100);
    } 
  }
}
