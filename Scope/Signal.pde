
public class Signal{
  
  // -------------------------------- ATRIBUTES --------------------------------
  
  private int max = 1000;
  private float[][] memory = new float[max][2];
  private int writeMemory = 0;
  private int readMemoryX = 0,readMemoryY = 0;
  
  
  // ------------------------------- CONSTRUTORS -------------------------------
  
  public Signal(Coordinate channel){
      clearMemory();
      setMemory(channel);
  }
  
  // --------------------------- GETTERS AND SETTERS --------------------------
  
  public void setMemory(Coordinate channel){
    if(writeMemory<max){
      this.memory[writeMemory][0] = channel.getX();  
      this.memory[writeMemory][1] = channel.getY(); 
      writeMemory++;
    }
    else{
      this.memory[writeMemory-1][0] = channel.getX(); 
      this.memory[writeMemory-1][1] = channel.getY(); 
    }
  }
  
  public void clearMemory(){
    for(int i = 0;i<memory.length;i++){
      memory[i][0] = 0;
      memory[i][1] = 0;
    }
  }
  
  // -------------------------------- METHODS --------------------------------- 
  
  public float getX(){
    return this.memory[writeMemory-1][0];   
  }
  
  public float getY(){
    return this.memory[writeMemory-1][1];   
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
}
