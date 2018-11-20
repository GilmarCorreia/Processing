
public class Screen{
 
  // -------------------------------- ATRIBUTES --------------------------------
  
  private int[] bgColor = new int[3];
  private int xSize, ySize;
  private int xGridSize, yGridSize, initialX, initialY, zeroX, zeroY;
  private Channel channels[] = new Channel[4];
  private Signal signals[] = new Signal[4];
  
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

      stroke(255);
      strokeWeight(3);
      line(getInitialX(),getZeroY(),getGridSizeX()+getInitialX(),getZeroY()-1);
      line(getZeroX()-1,getInitialY(),getZeroX()-1,getInitialY()+getGridSizeY()-1);
      
      stroke(255);
      strokeWeight(0);
      
      for(int j = getZeroY()+75;j<(getGridSizeY()+getInitialY());j+=75)
        line(getInitialX(),j,getGridSizeX()+getInitialX(),j);
      
      for(int j = getZeroY()-75;j>getInitialY();j-=75)
        line(getInitialX(),j,getGridSizeX()+getInitialX(),j);
      
      for(int i = getZeroX()+75;i<(getGridSizeX()+getInitialX());i+=75)
        line(i,getInitialY(),i,getGridSizeY()+getInitialY());
      
      for(int i = getZeroX()-75;i>getInitialX();i-=75)
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
      rect(getSizeX()-distance+space,margins,getSizeX()-space,100);
  }
  
  public void update(){
      for(int i=0;i<4;i++)
        channels[i].setOverMouse();
  }
  
  public void clicked(){
      for(int i=0;i<4;i++)
        channels[i].setMouseClicked();
  }
  
  public void plot(){
      for(int i=0;i<4;i++){
        if(channels[i].wasClicked){
          fill(channels[i].getColorR(),channels[i].getColorG(),channels[i].getColorB());
          stroke(channels[i].getColorR(),channels[i].getColorG(),channels[i].getColorB());
          strokeWeight(0);
          ellipse((int)(channels[i].signal.getX())+getZeroX(),getZeroY()-(int)(channels[i].signal.getY()),2,2);
        }
      }
  }
  
  public void clear(){
    setScreen(getBGColor(),signals);
  }

  @Override 
  public String toString(){
    return ("Tela: \n x: " + getSizeX() + "\n y: " + getSizeY() + 
            "\n R: " + getR() + ", G: " + getG() + ", B: " + getB() + "\n");
  }
 
}
