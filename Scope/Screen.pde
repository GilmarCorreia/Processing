import static javax.swing.JOptionPane.*;

public class Screen{
 
  // -------------------------------- ATRIBUTES --------------------------------
  
  private int[] bgColor = new int[3];
  private int xSize, ySize;
  private int xGridSize, yGridSize, initialX, initialY, zeroX, zeroY;
  private Channel channels[] = new Channel[4];
  private Signal signals[] = new Signal[4];
  private boolean controlPlot = true, plot = false, buttonControlScale = false, buttonControlSave = false, buttonControlCursor = false,buttonControlOffset = false , cursorControl = false;
  private int controlScale = 0, controlCursor = 0, controlSave=0, controlOffset = 0;
  private float cursorX1, cursorX2, cursorY1, cursorY2, DX=0, DY=0;
  
  private float textXW , textXH ,textYW ,textYH , textX1W ,textX1H ,textX2W ,textX2H, textY1W , textY1H , textY2W , textY2H ,textDXW ,textDXH,textDYW, textDYH, textScaleX, textOffsetYW, textOffsetYH, textOffsetXW, textOffsetXH;
  
  private float savePot = 511.5;
  
  final int linesX = 8;
  final int linesY = 6;
  
  public final float constY, constX;
  
  // ------------------------------- CONSTRUTORS -------------------------------
  
  public Screen(Signal[] signals, int[] dimensions){
    this(signals,new int[] {0,0,0}, dimensions);
  }
  
  public Screen(Signal[] signals, int[] coloring, int[] size){
    textSize(28);
    textXW = textWidth("Scale X: ");
    textXH = textAscent() - textDescent();
    textYW = textWidth("Scale Y: ");
    textYH = textAscent() - textDescent();
    
    textX1W = textWidth("X1: ");
    textX1H = textAscent() - textDescent();
        
    textX2W = textWidth("X2: ");
    textX2H = textAscent() - textDescent();
    
    textY1W = textWidth("Y1: ");
    textY1H = textAscent() - textDescent();
    
    textY2W = textWidth("Y2: ");
    textY2H = textAscent() - textDescent();
    
    textDXW = textWidth("DX: ");
    textDXH = textAscent() - textDescent();
    
    textDYW = textWidth("DY: ");
    textDYH = textAscent() - textDescent();
  
    textScaleX = textWidth("0.001 s/Div ");
    
    textOffsetYW = textWidth("Offset Y: ");
    textOffsetYH = textAscent() - textDescent();
    
    textOffsetXW = textWidth("Offset X: ");
    textOffsetXH = textAscent() - textDescent();
    
    setColor(coloring);
    setSize(size);
    
    constY = linesY + ((float)((int)(getGridSizeY()%(2*linesY)))/((float)((int)(getGridSizeY()/(2*linesY)))))/2.0;
    constX = linesX + ((float)((int)(getGridSizeX()%(2*linesX)))/((float)((int)(getGridSizeX()/(2*linesX)))))/2.0;
    
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
      int space = 20;
          
      int heightBoxScale = 100;
          
      int heightBoxChannels = (5*space)+30;
      int lenghtBoxChannels = (distance-(5*space))/4;
      int marginY_Channels = 180;
      
      int heightBoxCursors = (getSizeY()-(marginY_Channels+space)) - (margins+heightBoxScale+space);
      
      background(coloring[0],coloring[1],coloring[2]);
      margins(new int[] {190,190,190},margins,new int[] {0,0,0}, distance);
      
      cursorX1=getZeroX();
      cursorX2=getZeroX(); 
      cursorY1=getZeroY(); 
      cursorY2=getZeroY();
      
      channels(distance,space,lenghtBoxChannels,heightBoxChannels,marginY_Channels,signals);
      lines(8,6);
      scales(distance,margins,space,heightBoxScale);
      cursors(distance,margins,space,heightBoxCursors,heightBoxScale);
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
    
  private void lines(int linesX, int linesY){
      
      
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
  
  private void channels(int distance, int space, int lenghtBox, int heightBox, int marginY, Signal[] signals){
      
      if(channels[0]==null){
        channels[0] = new Channel(getSizeX()-distance+space,getSizeY()-marginY,lenghtBox,heightBox,new int[]{255,255,0});
        channels[1] = new Channel(getSizeX()-distance+2*space+lenghtBox,getSizeY()-marginY,lenghtBox,heightBox,new int[]{0,255,0});
        channels[2] = new Channel(getSizeX()-distance+3*space+2*lenghtBox,getSizeY()-marginY,lenghtBox,heightBox,new int[]{30,144,255});
        channels[3] = new Channel(getSizeX()-distance+4*space+3*lenghtBox,getSizeY()-marginY,lenghtBox,heightBox,new int[]{255,0,144});
      }
      else{
        for(int i=0;i<4;i++)
          channels[i].setChannel();
      }
      
      for(int i=0;i<4;i++)
          channels[i].setSignal(signals[i]);
  }
  
  private void scales(int distance, int margins, int space, int heightBox){
      
      rect(getSizeX()-distance+space,margins,(distance-2*space),heightBox);
      
      fill(255);
      
      int textSpace = (heightBox - (int)textXH - (int)textYH)/3;
      textSize(28);
      text("Scale X: ", getSizeX()-distance+2*space,margins+22+textSpace);
      text("Scale Y: ", getSizeX()-distance+2*space,margins+2*22+2*textSpace);
      
      text(round(scaleX/((float)1000000000),3)+" s/Div ", getSizeX()-distance+2*space+textXW,margins+22+textSpace);
      text(round(scaleY,3)+" V/Div ", getSizeX()-distance+2*space+textYW,margins+2*22+2*textSpace);
      
      fill(0,130,0);
      stroke(190);
      strokeWeight(1);
      rect(getSizeX()-distance+3*space+textXW+textScaleX-15,margins+22,40,textXH,3);
      rect(getSizeX()-distance+3*space+textXW+textScaleX-15,margins+2*22+textSpace,40,textYH,3);
      
      fill(0,255,0);
      
      if((controlScale%8)==0)
        rect(getSizeX()-distance+3*space+textXW+textScaleX-15,margins+22,40,textXH,3);
      else if((controlScale%8)==1)
        rect(getSizeX()-distance+3*space+textYW+textScaleX-15,margins+2*22+textSpace,40,textYH,3);
  }
  
  private void cursors(int distance, int margins, int space,int heightBox, int heightBoxScale){
      fill(0);
      stroke(0);
      strokeWeight(0);
      rect(getSizeX()-distance+space,margins+heightBoxScale+space,(distance-2*space),heightBox);
   
      int textSpace = (heightBox - (int)textX1H - (int)textX2H - (int)textY1H - (int)textY2H - (int)textDXH - (int)textDYH -(int) textOffsetYH -(int) textOffsetXH)/9;
      
      fill(255);
      textSize(28);
      text("X1: "+round(map(cursorX1,getInitialX(),getInitialX()+getGridSizeX(),-constX*scaleX/1000000,constX*scaleX/1000000),1)+" ms",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textSpace);
      text("X2: "+round(map(cursorX2,getInitialX(),getInitialX()+getGridSizeX(),-constX*scaleX/1000000,constX*scaleX/1000000),1)+" ms",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+2*textSpace);
      text("Y1: "+round(map(cursorY1,getInitialY()+getGridSizeY(),getInitialY(),-6.09090*scaleY,6.09090*scaleY),3)+" V",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+3*textSpace);
      text("Y2: "+round(map(cursorY2,getInitialY()+getGridSizeY(),getInitialY(),-6.09090*scaleY,6.09090*scaleY),3)+" V",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+4*textSpace);
      text("DX: "+round(abs(DX/1000000.0),3)+" ms",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+5*textSpace);
      text("DY: "+round(abs(DY),3)+" V",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+textDYH+6*textSpace);
      text("Offset Y: "+round(offsetY,1)+" V",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+textDYH+textOffsetYH+7*textSpace);
      text("Offset X: "+round(offsetX,1)+" ms",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+textDYH+textOffsetYH+textOffsetXH+8*textSpace);
      
      fill(0,130,0);
      stroke(190);
      strokeWeight(1);
      rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textSpace,40,textX1H,3);
      rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+2*textSpace,40,textX2H,3);
      rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+textX2H+3*textSpace,40,textY1H,3);
      rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+textX2H+textY1H+4*textSpace,40,textY2H,3);
      rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+textDYH+7*textSpace,40,textOffsetYH,3);
      rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+textDYH+textOffsetYH+8*textSpace,40,textOffsetXH,3);
      
      fill(0,255,0);
      if((controlScale%8)==2)
          rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textSpace,40,textX1H,3);
      else if((controlScale%8)==3)
          rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+2*textSpace,40,textX2H,3);
      else if((controlScale%8)==4)
          rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+textX2H+3*textSpace,40,textY1H,3);
      else if((controlScale%8)==5)
          rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+textX2H+textY1H+4*textSpace,40,textY2H,3);
      else if((controlScale%8)==6)
          rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+textDYH+7*textSpace,40,textOffsetYH,3);
      else if((controlScale%8)==7)
          rect(getSizeX()-distance+3*space+textWidth("Scale X: ")+textScaleX-15,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+textDYH+textOffsetYH+8*textSpace,40,textOffsetXH,3);
          
      if(cursorControl)
          setCursors();
  }
  
  private void setCursors(){
      stroke(255,235,0);
      strokeWeight(2);
      line(cursorX1,getInitialY(),cursorX1,getInitialY()+getGridSizeY());
      line(cursorX2,getInitialY(),cursorX2,getInitialY()+getGridSizeY());
      line(getInitialX(),cursorY1,getInitialX()+getGridSizeX(),cursorY1);
      line(getInitialX(),cursorY2,getInitialX()+getGridSizeX(),cursorY2);
  }

  public void update(){
      for(int i=0;i<4;i++)
        channels[i].setOverMouse();
      
      // CONTROLE DE APERTAR OS BOTÕES
      
      if(uno.digitalRead(buttonScale) == 1 && buttonControlScale == false){
          buttonControlScale = true;
          
          if(controlCursor == 0 && controlOffset == 0){
              if(controlScale<1)
                  controlScale++;
              else
                  controlScale = 0;
              clear();
          }
          else if(controlCursor != 0){
              if(controlScale<5)
                  controlScale++;
              else
                  controlScale = 2;
              background(loadImage("background.png"));
          }
          else if(controlOffset != 0){
              if (controlScale<7)
                  controlScale++;
              else 
                  controlScale = 6;
              clear();
          }
      }
   
      if(uno.digitalRead(buttonScale) == 0 && buttonControlScale == true)
          buttonControlScale = false;
          
      if(uno.digitalRead(buttonCursor) == 1 && buttonControlCursor == false){
          buttonControlCursor = true;
          if(controlCursor == 0 && controlOffset == 0)
              controlScale = 2;
          else{
              controlScale = 0;
              controlCursor = -1;
              controlOffset = 0;
              clear();
          }
          controlCursor++;
      }
   
      if(uno.digitalRead(buttonCursor) ==0 && buttonControlCursor == true)
          buttonControlCursor = false;
      
      if(uno.digitalRead(buttonSave) == 1 && buttonControlSave == false){
          buttonControlSave = true;
          showMessageDialog(null, "Esse save irá sobreescrever arquivos", "Salvando o Frame", INFORMATION_MESSAGE);
          save(folder+controlSave+".png");
          controlSave++;
          clear();
      }
   
      if(uno.digitalRead(buttonSave) == 0 && buttonControlSave == true)
          buttonControlSave = false;
          
      if(uno.digitalRead(buttonOffset) == 1 && buttonControlOffset == false){
          buttonControlOffset = true;
          if(controlOffset == 0 && controlCursor == 0)
              controlScale = 6;
          else{
              controlCursor = 0;
              controlScale = 0;
              controlOffset = -1;   
          }
          controlOffset++;
          clear();
      }
   
      if(uno.digitalRead(buttonOffset) == 0 && buttonControlOffset == true)
          buttonControlOffset = false;
      
      long scaleXnew = scaleX;
      float scaleYnew = scaleY;
      
      float cursorX1new = cursorX1;
      float cursorX2new = cursorX2;
      float cursorY1new = cursorY1;
      float cursorY2new = cursorY2;
      
      DX = map(cursorX2,getInitialX(),getInitialX()+getGridSizeX(),-constX*scaleX,constX*scaleX)-map(cursorX1,getInitialX(),getInitialX()+getGridSizeX(),-constX*scaleX,constX*scaleX);
      DY = map(cursorY2,getInitialY()+getGridSizeY(),getInitialY(),-6.09090*scaleY,6.09090*scaleY)-map(cursorY1,getInitialY()+getGridSizeY(),getInitialY(),-6.09090*scaleY,6.09090*scaleY); 
      
      float offsetX_new = offsetX;
      float offsetY_new = offsetY;
      
      // CONTROLE DO POTENCIÔMETRO DE ESCALA E CURSOR
      
      if((controlScale%8)==0){
          cursorControl = false;
          scaleXnew = mapX(uno.analogRead(5));
      }
      else if((controlScale%8)==1)
          scaleYnew = mapY(uno.analogRead(5));
      else if((controlScale%8)==2){
          if(!cursorControl)
              save("background.png");
          cursorControl = true;
          cursorX1new = mapCursorX(uno.analogRead(5));
      }
      else if((controlScale%8)==3)
          cursorX2new = mapCursorX(uno.analogRead(5));
      else if((controlScale%8)==4)
          cursorY1new = mapCursorY(uno.analogRead(5));
      else if((controlScale%8)==5)
          cursorY2new = mapCursorY(uno.analogRead(5)); 
      else if((controlScale%8)==6)
          offsetY_new = mapOffsetY(uno.analogRead(5));
      else if((controlScale%8)==7)
          offsetX_new = mapOffsetX(uno.analogRead(5));
      
      // CLEAR AS TELAS
      
      if((scaleXnew != scaleX) || (scaleYnew != scaleY)){
          scaleX = scaleXnew;
          scaleY = scaleYnew;
          offsetX = mapOffsetX(savePot);
          offsetX_new = offsetX;
          clear();
      }
      
      if((cursorX1new != cursorX1) || (cursorX2new != cursorX2) || (cursorY1new != cursorY1) || (cursorY2new != cursorY2)){
          cursorX1 = cursorX1new; 
          cursorX2 = cursorX2new;
          cursorY1 = cursorY1new;
          cursorY2 = cursorY2new;
          
          int distance = 400;
          int margins = 50;
          int space = 20;
          
          int heightBoxScale = 100;
              
          int marginY_Channels = 180;
          
          int heightBoxCursors = (getSizeY()-(marginY_Channels+space)) - (margins+heightBoxScale+space);
          
          background(loadImage("background.png"));
          scales(distance,margins,space,heightBoxScale);
          cursors(distance,margins,space,heightBoxCursors,heightBoxScale);
      }
      
      if((offsetY_new != offsetY) || (offsetX_new != offsetX)){
          offsetY = offsetY_new;
          offsetX = offsetX_new;
          clear();  
      }
      
  }
  
  public int mapCursorX(int pot){
      return (int)map(pot,0,1023,getInitialX(),getInitialX()+getGridSizeX());
  }
  
  public float mapCursorY(int pot){
      return (int)map(pot,0,1023,getInitialY(),getInitialY()+getGridSizeY());
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
          return 0.005; 
      else if(scaleYnew<2*max)
          return 0.01;
      else if(scaleYnew<3*max)
          return 0.05;
      else if(scaleYnew<4*max)
          return 0.1;
      else if(scaleYnew<5*max)
          return 0.5;
      else if(scaleYnew<6*max)
          return 1.0;
      else if(scaleYnew<7*max)
          return 2.0;
      
      return 5.0;          
  }
  
  public float mapOffsetY(float pot){
      return (float)round(map(pot,0,1023,-arduinoVoltage,arduinoVoltage),1);
  }
  
  public float mapOffsetX(float pot){
      savePot = pot;
      return (float)round(map(pot,0,1023,-constX*scaleX/1000000.0,constX*scaleX/1000000.0),1);
  }
  
  public void plot(){     
      if(!cursorControl){
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
  
  public void clicked(){
      for(int i=0;i<4;i++)
        channels[i].setMouseClicked();
  }
  
  public double round(double value, int places) {
      // Baseado de: https://stackoverflow.com/questions/13749336/truncate-double-value-to-6-decimal-places
      long factor = (long) Math.pow(10, places);
      value = value * factor;
      long tmp = Math.round(value);
      return (double) tmp / factor;
  }
  
  @Override 
  public String toString(){
    return ("Tela: \n x: " + getSizeX() + "\n y: " + getSizeY() + 
            "\n R: " + getR() + ", G: " + getG() + ", B: " + getB() + "\n");
  }
 
}
