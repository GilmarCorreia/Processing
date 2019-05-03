const float pi = 3.141593;

void quadrada(float freq, float dutyCicle){
  float periodo = (1/freq)*1000000;
  
  if (micros()-timer < (periodo*dutyCicle))
    dac.setVoltage((uint16_t)4095,false);
  else if(micros()-timer < periodo)  
    dac.setVoltage((uint16_t)0,false);
  else 
    timer = micros();  
}

void triangular(float freq){
  float periodo = (1/freq)*1000000;

  //Serial.println(passo);
  if (micros()-timer < periodo*0.5)
    dac.setVoltage(passo++,true);
  else if(micros() - timer < periodo)
    dac.setVoltage(passo--,true);
  else{
    passo =0;
    timer = micros();
  }
}

void senoidal(float freq){
  float periodo = (1/freq)*1000000;
  
  if (micros()-timer < periodo){
    dac.setVoltage(4095*(0.5*(sin(passo * freq *(2.0*pi)/1650.0)+1)),true);
     ////Serial.println(4095*(0.5*(sin(i*(2.0*pi)/1650.0)+1)));
    passo++;  
  }
  else {
     passo=0;
     timer = micros();
  }
}
