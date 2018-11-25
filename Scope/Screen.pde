
public class Screen{
 
  // -------------------------------- ATRIBUTES --------------------------------
  
  private int[] bgColor = new int[3];
  private int xSize, ySize;
  private int xGridSize, yGridSize, initialX, initialY, zeroX, zeroY;
  private Channel channels[] = new Channel[4];
  private Signal signals[] = new Signal[4];
  private boolean controlPlot = true, plot = false;

  
  // ------------------------------- CONSTRUTORS -------------------------------
  
  public Screen(Signal[] signals, int[] dimensions){
    this(signals,new int[] {0,0,0}, dimensions);
  }
  
  public Screen(Signal[] signals, int[] coloring, int[] size){
    setColor(coloring);
    setSize(size);
    setSignals(signals);
    setScreen(getBGColor(),getSignals());
  }
  
  // --------------------------- GETTERS AND SETTERS --------------------------
  
  private void setColor(int[] coloring){
    for(int i=0;i<3;i++)
      this.bgColor[i] = coloring[i];
  }
  
  private void setSize(int[] dimensions){
      this.xSize = dimensions[0];
      this.ySize = dimensions[1];
      setGridSizeX(dimensions[0]);
      setGridSizeY(dimensions[1]);
  }
  
  private void setGridSizeX(int x){
    this.xGridSize = x;
  }
  
  private void setGridSizeY(int y){
    this.yGridSize = y;
  }
  
  private void setInitialPositionX(int x){
      this.initialX= x;
  }
  
  private void setInitialPositionY(int y){
      this.initialY = y;
  }
  
  private void setZeroZero(int x, int y){
      zeroX = x;
      zeroY = y;
  }
  
  private void setSignals(Signal[] signals){
      for (int i =0;i<signals.length;i++)
          this.signals[i] = signals[i];
      this.signals = signals;
  }
  
  public int[] getBGColor(){
    return this.bgColor;
  }
  
  public int getR(){
    return this.bgColor[0];
  }
  
  public int getG(){
    return this.bgColor[1];
  }
  
  public int getB(){
    return this.bgColor[2];
  }
  
  public int getSizeX(){
      return this.xSize;
  }
  
  public int getSizeY(){
      return this.ySize;
  }
  
  public int getGridSizeX(){
      return this.xGridSize;
  }
  
  public int getGridSizeY(){
      return this.yGridSize;
  }
   
  public int getInitialX(){
      return this.initialX;
  }
  
  public int getInitialY(){
      return this.initialY;
  }
  
  public int getZeroX(){
      return this.zeroX;
  }
  
  public int getZeroY(){
      return this.zeroY;
  }
  
  public Signal[] getSignals(){
      return this.signals;
  }
  
  // -------------------------------- METHODS ---------------------------------

  private void setScreen(int[] coloring, Signal[] signals){
      int distance = 400;
      int margins = 50;
      background(coloring[0],coloring[1],coloring[2]);
      margins(new int[] {190,190,190},margins,new int[] {0,0,0}, distance);
      channels(distance, signals);
      lines();
      scales(distance,margins);
  }
  
  private void margins(int[] marginColor, int stkW, int[] fillColor, int distance){
      // MARGENS
      stroke(marginColor[0],marginColor[1],marginColor[2]);
      strokeWeight(stkW);
      fill(fillColor[0],fillColor[1],fillColor[1]);
      rect(0, 0, getSizeX()-1, getSizeY()-1); 
      
      // MARGEM ADICIONAL A DIREITA
      fill(marginColor[0],marginColor[1],marginColor[2]);
      strokeWeight(0);
      rect(getSizeX()-distance, 0, distance, getSizeY()); 
      
      // SETANDO O TAMANHO OFICIAL DO GRID, ASSIM COMO A POSIÇÃO (0,0);

      setGridSizeX(getSizeX()-(stkW/2)-distance);
      setGridSizeY(getSizeY()-2*(stkW/2));
      
      setInitialPositionX(stkW/2);
      setInitialPositionY(stkW/2);
      setZeroZero((getGridSizeX()/2)+initialX-1,(getGridSizeY()/2)+initialY-1);
  }
    
  private void lines(){
      
      int linesX = 8;
      int linesY = 6;
      
      stroke(255);
      strokeWeight(3);
      line(getInitialX(),getZeroY(),getGridSizeX()+getInitialX(),getZeroY()-1);
      line(getZeroX()-1,getInitialY(),getZeroX()-1,getInitialY()+getGridSizeY()-1);
      
      stroke(255);
      strokeWeight(0);
      
      for(int j = getZeroY()+(getGridSizeY()/(linesY*2));j<(getGridSizeY()+getInitialY());j+=(getGridSizeY()/(linesY*2)))
        line(getInitialX(),j,getGridSizeX()+getInitialX(),j);
      
      for(int j = getZeroY()-(getGridSizeY()/(linesY*2));j>getInitialY();j-=(getGridSizeY()/(linesY*2)))
        line(getInitialX(),j,getGridSizeX()+getInitialX(),j);
      
      for(int i = getZeroX()+(getGridSizeX()/(linesX*2));i<(getGridSizeX()+getInitialX());i+=(getGridSizeX()/(linesX*2)))
        line(i,getInitialY(),i,getGridSizeY()+getInitialY());
      
      for(int i = getZeroX()-(getGridSizeX()/(linesX*2));i>getInitialX();i-=(getGridSizeX()/(linesX*2)))
        line(i,getInitialY(),i,getGridSizeY()+getInitialY());
  }
  
  private void channels(int distance, Signal[] signals){
      int space = 20;
      int len = (distance-(5*space))/4;
      int hei = (5*space)+30;
      
      if(channels[0]==null){
        channels[0] = new Channel(getSizeX()-distance+space,getSizeY()-180,len,hei,new int[]{255,255,0});
        channels[1] = new Channel(getSizeX()-distance+2*space+len,getSizeY()-180,len,hei,new int[]{0,255,0});
        channels[2] = new Channel(getSizeX()-distance+3*space+2*len,getSizeY()-180,len,hei,new int[]{30,144,255});
        channels[3] = new Channel(getSizeX()-distance+4*space+3*len,getSizeY()-180,len,hei,new int[]{255,0,144});
      }
      else{
        for(int i=0;i<4;i++)
          channels[i].setChannel();
      }
      
      for(int i=0;i<4;i++)
          channels[i].setSignal(signals[i]);
  }
  
  public void scales(int distance, int margins){
      int space = 20;
      int hei = 100;
      
      rect(getSizeX()-distance+space,margins,(distance-2*space),hei);
      
      fill(255);
      textSize(28);
      float textXW = textWidth("Scale X: ");
      float textXH = textAscent() - textDescent();
      float textYW = textWidth("Scale Y: ");
      float textYH = textAscent() - textDescent();
      
      int textSpace = (hei - (int)textXH - (int)textYH)/3;
      
      text("Scale X: ", getSizeX()-distance+2*space,margins+22+textSpace);
      text("Scale Y: ", getSizeX()-distance+2*space,margins+2*22+2*textSpace);
      
      text(round(scaleX/((float)1000000000),3)+" s/Div", getSizeX()-distance+2*space+textXW,margins+22+textSpace);
      text(round(scaleY,3)+" V/Div", getSizeX()-distance+2*space+textYW,margins+2*22+2*textSpace);
  }
  
  public double round(double value, int places) {
  
      long factor = (long) Math.pow(10, places);
      value = value * factor;
      long tmp = Math.round(value);
      return (double) tmp / factor;
  }

  public void update(){
      for(int i=0;i<4;i++)
        channels[i].setOverMouse();
          
      long scaleXnew = mapX(uno.analogRead(4));
      float scaleYnew = mapY(uno.analogRead(5));
      
      if((scaleXnew != scaleX) || (scaleYnew != scaleY)){
          scaleX = scaleXnew;
          scaleY = scaleYnew;
          clear();
      }
  }
  
  public long mapX(float scaleYnew){
      float max = (float)(1024/8);    
      
      if(scaleYnew<max)
          return (long)((float)0.01*(float)1000000000); 
      else if(scaleYnew<2*max)
          return (long)((float)0.05*(float)1000000000);
      else if(scaleYnew<3*max)
          return (long)((float)0.1*(float)1000000000);
      else if(scaleYnew<4*max)
          return (long)((float)0.5*(float)1000000000);
      else if(scaleYnew<5*max)
          return (long)((float)1*(float)1000000000);
      else if(scaleYnew<6*max)
          return (long)((float)2*(float)1000000000);
      else if(scaleYnew<7*max)
          return (long)((float)5*(float)1000000000);
      
      return (long)((float)10*(float)1000000000);          
  }
  
  public float mapY(float scaleYnew){
      float max = (float)(1024/8);    
      
      if(scaleYnew<max)
          return 0.001; 
      else if(scaleYnew<2*max)
          return 0.01;
      else if(scaleYnew<3*max)
          return 0.1;
      else if(scaleYnew<4*max)
          return 0.5;
      else if(scaleYnew<5*max)
          return 1.0;
      else if(scaleYnew<6*max)
          return 2.0;
      else if(scaleYnew<7*max)
          return 5.0;
      
      return 10.0;          
  }
  
  public void clicked(){
      for(int i=0;i<4;i++)
        channels[i].setMouseClicked();
  }
  
  public void plot(){
      long nano = System.nanoTime();
      
      if(plot == false){
          for(int j=0;j<2;j++){
              for(int i = 0;i<4;i++)
                  signals[i].getInput(nano);
          }
          plot = true;
      }
      else{
          for(int i=0;i<4;i++){
              float x = (signals[i].getMemoryX());
              float y = (signals[i].getMemoryY());
              float xprime = (signals[i].getX(nano));
              float yprime = (signals[i].getY());
              if((x> getInitialX() && x< (getGridSizeX()+getInitialX()))&&(y > getInitialY() && y < getGridSizeY()+getInitialY()) && (xprime> getInitialX() && xprime< (getGridSizeX()+getInitialX()))&&(yprime > getInitialY() && yprime < (getGridSizeY()+getInitialY())) && controlPlot && channels[i].wasClicked){
                  fill(channels[i].getColorR(),channels[i].getColorG(),channels[i].getColorB());
                  stroke(channels[i].getColorR(),channels[i].getColorG(),channels[i].getColorB());
                  strokeWeight(4);
                  line(x,y,xprime,yprime);
              }
          }
          controlPlot = true;
      }
  }
  
  public void clear(){
      initialTime = System.nanoTime();
      for (int i = 0; i<4; i++){
        if (signals[i].data != null)
            signals[i].data.setX(getZeroX()); 
      }
      controlPlot = false;
      setScreen(getBGColor(),signals);
  }

  @Override 
  public String toString(){
    return ("Tela: \n x: " + getSizeX() + "\n y: " + getSizeY() + 
            "\n R: " + getR() + ", G: " + getG() + ", B: " + getB() + "\n");
  }
 
}
