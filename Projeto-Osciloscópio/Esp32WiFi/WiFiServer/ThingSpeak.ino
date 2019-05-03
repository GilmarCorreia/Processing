bool dados;

void ThingSpeak(bool data1){
    if(data1)
      dados = true;
    else
      dados = false;  
      
    if(clients[1].connect(serverThingSpeak,javaPort)){
      String postStr = apiKey;
             postStr +="&amp;field1=";
             postStr += String(dados);
             //postStr +="&amp;field2=";
             //postStr += String(digitalRead(14));
             //postStr +="&amp;field3=";
             //postStr += String(umidadeSolo);
             postStr += "\r\n\r\n";
   
       clients[1].print("POST /update HTTP/1.1\n");
       clients[1].print("Host: api.thingspeak.com\n");
       clients[1].print("Connection: close\n");
       clients[1].print("X-THINGSPEAKAPIKEY: "+apiKey+"\n");
       clients[1].print("Content-Type: application/x-www-form-urlencoded\n");
       clients[1].print("Content-Length: ");
       clients[1].print(postStr.length());
       clients[1].print("\n\n");
       clients[1].print(postStr);
     }
}
