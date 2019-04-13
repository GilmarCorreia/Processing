public class Signal{
  
  // -------------------------------- ATRIBUTES --------------------------------
  
  private int max = 100000;
  private float[][] memory = new float[max][2];
  private int writeMemory = 0;
  private int readMemoryX = 0,readMemoryY = 0;
  private int analogPort;
  public Coordinate data;
  
  // ------------------------------- CONSTRUTORS -------------------------------
  
  public Signal(int analogPort){
      clearMemory();
      setAnalogPort(analogPort);
      //setMemory(data);
  }
  
  // --------------------------- GETTERS AND SETTERS --------------------------
  
  private void setAnalogPort(int analogPort){
     this.analogPort = analogPort;
  }
  
  private int getAnalogPort(){
    return this.analogPort; 
  }
  
  public void setMemory(Coordinate data){
    if(writeMemory<max){
      this.memory[writeMemory][0] = data.getX();  
      this.memory[writeMemory][1] = data.getY(); 
      writeMemory++;
    }
    else{
      this.memory[writeMemory-1][0] = data.getX(); 
      this.memory[writeMemory-1][1] = data.getY(); 
    }
  }
  
  //public void setWriteMemory(){
  //    this.writeMemory = 1;  
  //}
  
  //public void setReadMemory(){
  //    this.readMemoryX = 0; 
  //    this.readMemoryY = 0; 
  //}
  
  public void clearMemory(){
    for(int i = 0;i<memory.length;i++){
      memory[i][0] = 0;
      memory[i][1] = 0;
    }
  }
  
  // -------------------------------- METHODS --------------------------------- 
  
  
  public void getInput(long nano){
      if (data != null){   
          float dataX = map((nano-initialTime+(offsetX*1000000)),0,tela.constX*scaleX,tela.getZeroX(),(tela.getGridSizeX()+tela.getInitialX()-1));
          float dataY = ((uno.analogRead(this.getAnalogPort())/1023.0)*arduinoVoltage);
          float gnd = ((uno.analogRead(ground)/1023.0)*arduinoVoltage);
          dataY = map(dataY-gnd+offsetY,-6.09090*scaleY,6.09090*scaleY,(tela.getInitialY()+tela.getGridSizeY())-1,tela.getInitialY());
          this.data.setX(dataX);
          this.data.setY(dataY);
      }
      else
          data = new Coordinate(tela.getZeroX(),tela.getZeroY());
      
      setMemory(data);
  }
  
  public float getMemoryX(){
      return this.memory[writeMemory-1][0];
  }
  
  public float getMemoryY(){
      return this.memory[writeMemory-1][1];
  }
  
  public long getWriteMemory(){
      return writeMemory; 
  }
  
  public float getX(long nano){      
    this.getInput(nano);
    
    if(this.data.getX() >= tela.getGridSizeX()+tela.getInitialX()){
      tela.clear();
      data.setX(tela.getZeroX());
    }
      
    return this.data.getX();
  }
  
  public float getY(){
    return this.data.getY();
  }
  
  public float getAllX(){
    if(readMemoryX<max)
      readMemoryX++;
    return this.memory[readMemoryX-1][0];   
  }
  
  public float getAllY(){
    if(readMemoryY<max)
      readMemoryY++;
    
    return this.memory[readMemoryY-1][1];   
  }
  
  //@Override
  //public void run(){
  //  try {
  //    while(true){
  //      this.data.setPos(data.getX()+0.0005,data.getY()+0.0005);
  //      this.setMemory(this.data);
  //      println(this.data.getX(), ", ", this.data.getY());
  //    }
  //  } finally {
  //    print(data.getX(), ", ", data.getY());
  //  }
  //}
  
  
}
