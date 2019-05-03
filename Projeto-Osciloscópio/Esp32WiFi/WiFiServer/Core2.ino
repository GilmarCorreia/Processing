
void loop2(void * z) {
  ads.begin();
  dac.begin(0x62);
  timer = micros();
  passo = 0;
  
  while (1) {
    readWiFi();
  }
}

void readWiFi() {
  b1 = digitalRead(buttonScalePort);
  b2 = digitalRead(buttonCursorPort);
  b3 = digitalRead(buttonOffsetPort);
  b4 = digitalRead(buttonSavePort);
  gnd = analogRead(groundPort);
  pot = analogRead(potenciometerPort);
  ad0 = ads.readADC_SingleEnded(0);
  ad1 = ads.readADC_SingleEnded(1);
  ad2 = ads.readADC_SingleEnded(2);
  ad3 = ads.readADC_SingleEnded(3);

  if(onda == 1)
    quadrada(0.5, 0.5);
  else if(onda == 2)
    triangular(1);
  else if(onda == 3)
    senoidal(1);
  
  /*itoa(b1,msg+1,10);
    strcat(msg,",");
    itoa(b2,msg+3,10);
    strcat(msg,",");
    itoa(b3,msg+5,10);
    strcat(msg,",");
    itoa(b4,msg+7,10);
    strcat(msg,",");
    itoa(gnd,msg+9,10);
    strcat(msg,",");
    itoa(pot,msg+strlen(msg),10);
    strcat(msg,",");
    itoa(ad0,msg+strlen(msg),10);
    strcat(msg,",");
    itoa(ad1,msg+strlen(msg),10);
    strcat(msg,",");
    itoa(ad2,msg+strlen(msg),10);
    strcat(msg,",");
    itoa(ad3,msg+strlen(msg),10);
    strcat(msg,"F");*/
}

void serverSendData() {
  clients[0].print('E');
  clients[0].print(b1);
  clients[0].print(',');
  clients[0].print(b2);
  clients[0].print(',');
  clients[0].print(b3);
  clients[0].print(',');
  clients[0].print(b4);
  clients[0].print(',');
  clients[0].print(gnd);
  clients[0].print(',');
  clients[0].print(pot);
  clients[0].print(',');
  clients[0].print(ad0);
  clients[0].print(',');
  clients[0].print(ad1);
  clients[0].print(',');
  clients[0].print(ad2);
  clients[0].print(',');
  clients[0].print(ad3);
  clients[0].println('F');
}

void clientReceiveImage(unsigned int tamanho, float* valoresCursores) {
  String str1 = String("rmfile scope-");
  String str2 = String("scope-");
  str1.concat(controlSave);
  str1.concat(".png");
  str2.concat(controlSave);
  str2.concat(".png");
  SerialConfig(str1);
  unsigned int i = 0;
  String imagem;
  
  String cursores = "cursorX1: ";
  cursores.concat(valoresCursores[0]);
  cursores.concat("ms, cursorY1: ");
  cursores.concat(valoresCursores[1]);
  cursores.concat("V, cursorX2: ");
  cursores.concat(valoresCursores[2]);
  cursores.concat("ms, cursorY2: ");
  cursores.concat(valoresCursores[3]);
  cursores.concat("V\n");
  SerialConfig("rmfile cursores.txt");
  SerialConfig("append cursores.txt", cursores);
  File file = SD.open(caminho + str2, FILE_APPEND);

  double sdArm = (double)micros();
  Serial.print("transmitindo ");
  Serial.print(tamanho);
  Serial.println(" bytes ...");
  
  while (clients[0].available()) {
    unsigned int r = clients[0].read();
    //Serial.println(i++);
    
    if (!file) {
      Serial.println("Failed to open file for appending");
      return;
    }
    if(i<tamanho)
      file.print((char)r);
    i++;
  }
  file.close();
  Serial.print("Tempo de armazenamento de ");
  Serial.print(i);
  Serial.print(" bytes: ");
  double finish = (double)micros();
  Serial.print((double)(finish-sdArm));
  Serial.println(" micro seconds (us)");
  Serial.print((double(i)/(finish-sdArm))*1000000.0);
  Serial.println(" bytes/s");
  
  controlSave++;
  SerialConfig("ls");
}
