
public class Channel extends Counter{
  
  // -------------------------------- ATRIBUTES --------------------------------
  
  private int posX, posY, sizeX, sizeY;
  private boolean pressed, wasClicked = false, isOver=false;
  private int R,G,B, colorR, colorG, colorB;
  private String count = null;
  private Signal signal = null;
  
  // ------------------------------- CONSTRUTORS -------------------------------
  
  public Channel(int x, int y, int sizeX, int sizeY, int[] channelColor){
      setPosition(x,y);  
      setSize(sizeX,sizeY);
      setPressed(false);
      setColor(230,230,230);
      setChannelColor(channelColor[0],channelColor[1],channelColor[2]);
      setChannel();
      add();
  }
 
  // --------------------------- GETTERS AND SETTERS --------------------------
  
  private void setPosition(int x, int y){
       this.posX = x;
       this.posY = y;
  }
  
  private void setSize(int len, int hei){
       this.sizeX = len;
       this.sizeY = hei;
  }
  
  private void setPressed(boolean pressed){
       this.pressed = pressed;
  }
  
  private void setColor(int r, int g, int b){
      this.R = r;
      this.G = g;
      this.B = b;
  }
  
  private void setChannelColor(int r, int g, int b){
      this.colorR = r;
      this.colorG = g;
      this.colorB = b;
  }
  
  private void setCounter(int count){
     this.count = (""+count);    
  }
    
  public int getPosX(){
       return this.posX;
  }
  
  public int getPosY(){
       return this.posY;
  }
  
  public int getSizeX(){
       return this.sizeX;
  }
  
  public int getSizeY(){
       return this.sizeY;
  }
  
  public boolean isPressed(){
       return this.pressed; 
  }
  
  private int getR(){
       return this.R; 
  }
  
  private int getG(){
       return this.G; 
  }
  
  private int getB(){
       return this.B; 
  }
  
  public int getColorR(){
       return this.colorR; 
  }
  
  public int getColorG(){
       return this.colorG; 
  }
  
  public int getColorB(){
       return this.colorB; 
  }
  
  private String getCounter(){
       return count;
  }
  // -------------------------------- METHODS ---------------------------------
 
  public void setChannel(){
     fill(getR(),getG(), getB());
     strokeWeight(0);
     rect(getPosX(),getPosY(),getSizeX(),getSizeY(),50);
      
     fill(0);
     textSize(16);
     float text = textWidth("channel");
     int rest = getSizeX() - (int)text;
      
     text("channel",getPosX()+(rest/2),getPosY()+35);
       
     textSize(72);
     text = textWidth(char(counter+48));
     rest = getSizeX() - (int)text;
     
     if(getCounter()==null){
       setCounter(counter);
       text(counter,getPosX()+(rest/2),getPosY()+getSizeY()-25);
     }
     else
       text(getCounter(),getPosX()+(rest/2),getPosY()+getSizeY()-25);
  }
  
  public void setOverMouse(){
    
    if(mouseX >= getPosX() && mouseX <= (getPosX()+getSizeX()) && mouseY >= getPosY() && mouseY <= (getPosY()+getSizeY()))
      isOver=true;
    else
      isOver = false;
      
    if(!wasClicked){
      strokeWeight(0);
      
      if(isOver){
        stroke(colorR,colorG,colorB); 
        setColor(colorR,colorG,colorB);
      }
      else{
        stroke(230);   
        setColor(230,230,230);
      }
      
      setChannel();
    }
    
  }
  
  public void setMouseClicked(){
    
    if(isOver){
      strokeWeight(0);
    
      if(!wasClicked){
        stroke(colorR,colorG,colorB); 
        setColor(colorR,colorG,colorB);
        wasClicked = true;
      }
      else{
        stroke(230);   
        setColor(230,230,230);
        wasClicked = false;
      }
      setChannel();
    }
  }
  
  void setSignal(Signal data){
      signal = data;
  }
  
  @Override
  public String toString(){
     return (getCounter()); 
  }

}
