import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.math.BigDecimal; 
import java.io.*; 
import java.net.*; 
import java.util.Scanner; 
import static javax.swing.JOptionPane.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Scope extends PApplet {

//ESP32SERIAL esp32 = new ESP32SERIAL();
ESP32WIFI esp32 = new ESP32WIFI("192.168.43.108",80);

String folder = "Laboratório1/scope-";

float offsetY = 0;
float offsetX = 0;
float trigger = 2.5f;

Screen tela;
int w = 1450;
int h = 720;

long initialTime = 0;
long scaleX = (long)(2*(1000000000));
float scaleY = 1;
    
Signal amarelo = new Signal(esp32.analogReadY);
Signal verde = new Signal(esp32.analogReadG);
Signal azul = new Signal(esp32.analogReadB);
Signal rosa = new Signal(esp32.analogReadP);

public void settings() {
  size(w, h);
}

public void setup(){
  frameRate(10000000);
  tela = new Screen(new Signal[]{amarelo,verde,azul,rosa},new int[]{w,h});
  initialTime = System.nanoTime(); 
}

public void draw(){
  //long teste = System.nanoTime();
  tela.plot(); 
  tela.update();
  //println(System.nanoTime()-teste);
}

public void mouseClicked(){
  tela.clicked();
}

public class Channel extends Counter{
  
  // -------------------------------- ATRIBUTES --------------------------------
  
  private int posX, posY, sizeX, sizeY;
  private boolean pressed, wasClicked = false, isOver=false;
  private int R,G,B, colorR, colorG, colorB;
  private String count = null;
  public Signal signal = null;
  
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
     text = textWidth(PApplet.parseChar(counter+48));
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
  
  public void setSignal(Signal data){
      signal = data;
  }
  
  @Override
  public String toString(){
     return (getCounter()); 
  }

}

public class Coordinate{
  
  // -------------------------------- ATRIBUTES --------------------------------
  
  private float x,y;
  
  // ------------------------------- CONSTRUTORS -------------------------------
  
  public Coordinate(float x, float y){
    setX(x);
    setY(y);
  }
  
  // --------------------------- GETTERS AND SETTERS --------------------------
  
  public void setPos(float x, float y){
    setX(x);
    setY(y);
  }
  
  public void setX(float x){
    this.x = x;
  }
  
  public void setY(float y){
    this.y = y;
  }  
  
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y; 
  }
  
  // -------------------------------- METHODS ---------------------------------
  
}

public static abstract class Counter{
  
   static int counter = 1;
   
   public static void add(){
       counter++; 
   }
   
}





public class ESP32WIFI{
  private Socket sock;
  private OutputStream ostream;
  private PrintWriter pwrite;
  private InputStream istream;
  private BufferedReader receiveRead;
  private int c[] = new int[200];
  private int data[] = new int[10];
  
  // PORTAS DO ESP32
  public int ground = 4;
  public int potenciometer = 5;
  public int analogReadY = 6;
  public int analogReadG = 7;
  public int analogReadB = 8;
  public int analogReadP = 9;
  public int buttonScale = 0;
  public int buttonCursor = 1;
  public int buttonOffset = 2;
  public int buttonSave = 3;
  public float espVoltage = (float) 3.3f;
  public int bitsAR = 12; 
  public int bitsAD = 17536; // Valor máximo de leitura para 3.3V
  
  public ESP32WIFI(String ipServer, int port){
    try {
      configurarWiFi(ipServer, port);
    } catch (UnknownHostException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
  
  private void configurarWiFi(String ipServer, int port) throws UnknownHostException, IOException {
    sock = new Socket(ipServer, port);
    ostream = sock.getOutputStream();
    pwrite = new PrintWriter(ostream, true);
    istream = sock.getInputStream();
    receiveRead = new BufferedReader(new InputStreamReader(istream));
    //println("\nConectado ao Servidor de ESP32:" + ipServer + ", porta: "+port);
  }
  
  private void wifiReceive2(){    
    try{
      int n = 0; 
      do{
        c[n] = receiveRead.read();
      } while (c[n]!='E');
      
      int count = 0;
      data[count]=0;
        
       
      do {
        n++;
        c[n] = receiveRead.read();
        
        if(c[n]!=',' && c[n]!='F')
          data[count]=data[count]*10+(int)(c[n]-'0');
        else{
          if(c[n]!='F'){
            count++;
            data[count]=0;
          }
        }
        
      } while (c[n]!='F') ;
      
      
    } catch (IOException e){
      println(e);
    }
  }
  
  private int readPin(int pin) {
    return data[pin];
  }
  
  public void update(){
    pwrite.println("U");
    wifiReceive2();
  }
}


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
  
  private float savePot = 511.5f;
  
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
    
    constY = linesY + ((float)((int)(getGridSizeY()%(2*linesY)))/((float)((int)(getGridSizeY()/(2*linesY)))))/2.0f;
    constX = linesX + ((float)((int)(getGridSizeX()%(2*linesX)))/((float)((int)(getGridSizeX()/(2*linesX)))))/2.0f;
    
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
      text("Y1: "+round(map(cursorY1,getInitialY()+getGridSizeY(),getInitialY(),-6.09090f*scaleY,6.09090f*scaleY),3)+" V",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+3*textSpace);
      text("Y2: "+round(map(cursorY2,getInitialY()+getGridSizeY(),getInitialY(),-6.09090f*scaleY,6.09090f*scaleY),3)+" V",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+4*textSpace);
      text("DX: "+round(abs(DX/1000000.0f),3)+" ms",getSizeX()-distance+2*space,margins+heightBoxScale+space+textX1H+textX2H+textY1H+textY2H+textDXH+5*textSpace);
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

      esp32.update();    

      for(int i=0;i<4;i++)
        channels[i].setOverMouse();
      
      
      // CONTROLE DE APERTAR OS BOTÕES
      
      if(esp32.readPin(esp32.buttonScale) == 1 && buttonControlScale == false){
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
   
      if(esp32.readPin(esp32.buttonScale) == 0 && buttonControlScale == true)
          buttonControlScale = false;
          
      if(esp32.readPin(esp32.buttonCursor) == 1 && buttonControlCursor == false){
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
   
      if(esp32.readPin(esp32.buttonCursor) ==0 && buttonControlCursor == true)
          buttonControlCursor = false;
      
      if(esp32.readPin(esp32.buttonSave) == 1 && buttonControlSave == false){
          buttonControlSave = true;
          showMessageDialog(null, "Esse save irá sobreescrever arquivos", "Salvando o Frame", INFORMATION_MESSAGE);
          save(folder+controlSave+".png");
          controlSave++;
          clear();
      }
   
      if(esp32.readPin(esp32.buttonSave) == 0 && buttonControlSave == true)
          buttonControlSave = false;
          
      if(esp32.readPin(esp32.buttonOffset) == 1 && buttonControlOffset == false){
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
   
      if(esp32.readPin(esp32.buttonOffset) == 0 && buttonControlOffset == true)
          buttonControlOffset = false;
      
      long scaleXnew = scaleX;
      float scaleYnew = scaleY;
      
      float cursorX1new = cursorX1;
      float cursorX2new = cursorX2;
      float cursorY1new = cursorY1;
      float cursorY2new = cursorY2;
      
      DX = map(cursorX2,getInitialX(),getInitialX()+getGridSizeX(),-constX*scaleX,constX*scaleX)-map(cursorX1,getInitialX(),getInitialX()+getGridSizeX(),-constX*scaleX,constX*scaleX);
      DY = map(cursorY2,getInitialY()+getGridSizeY(),getInitialY(),-6.09090f*scaleY,6.09090f*scaleY)-map(cursorY1,getInitialY()+getGridSizeY(),getInitialY(),-6.09090f*scaleY,6.09090f*scaleY); 
      
      float offsetX_new = offsetX;
      float offsetY_new = offsetY;
      
      // CONTROLE DO POTENCIÔMETRO DE ESCALA E CURSOR
      
      if((controlScale%8)==0){
          cursorControl = false;
          scaleXnew = mapX(esp32.readPin(esp32.potenciometer));
      }
      else if((controlScale%8)==1)
          scaleYnew = mapY(esp32.readPin(esp32.potenciometer));
      else if((controlScale%8)==2){
          if(!cursorControl)
              save("background.png");
          cursorControl = true;
          cursorX1new = mapCursorX(esp32.readPin(esp32.potenciometer));
      }
      else if((controlScale%8)==3)
          cursorX2new = mapCursorX(esp32.readPin(esp32.potenciometer));
      else if((controlScale%8)==4)
          cursorY1new = mapCursorY(esp32.readPin(esp32.potenciometer));
      else if((controlScale%8)==5)
          cursorY2new = mapCursorY(esp32.readPin(esp32.potenciometer)); 
      else if((controlScale%8)==6)
          offsetY_new = mapOffsetY(esp32.readPin(esp32.potenciometer));
      else if((controlScale%8)==7)
          offsetX_new = mapOffsetX(esp32.readPin(esp32.potenciometer));
      
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
      return (int)map(pot,0,(float)(Math.pow(2,esp32.bitsAR)),getInitialX(),getInitialX()+getGridSizeX());
  }
  
  public float mapCursorY(int pot){
      return (int)map(pot,0,(float)(Math.pow(2,esp32.bitsAR)),getInitialY(),getInitialY()+getGridSizeY());
  }
  
  public long mapX(float scaleYnew){
      float max = (float)(Math.pow(2,esp32.bitsAR)/8);    
      
      if(scaleYnew<max)
          return (long)((float)0.01f*(float)1000000000); 
      else if(scaleYnew<2*max)
          return (long)((float)0.05f*(float)1000000000);
      else if(scaleYnew<3*max)
          return (long)((float)0.1f*(float)1000000000);
      else if(scaleYnew<4*max)
          return (long)((float)0.5f*(float)1000000000);
      else if(scaleYnew<5*max)
          return (long)((float)1*(float)1000000000);
      else if(scaleYnew<6*max)
          return (long)((float)2*(float)1000000000);
      else if(scaleYnew<7*max)
          return (long)((float)5*(float)1000000000);
      
      return (long)((float)10*(float)1000000000);          
  }
  
  public float mapY(float scaleYnew){
      float max = (float)(Math.pow(2,esp32.bitsAR)/8);    

      if(scaleYnew<max)
          return 0.005f; 
      else if(scaleYnew<2*max)
          return 0.01f;
      else if(scaleYnew<3*max)
          return 0.05f;
      else if(scaleYnew<4*max)
          return 0.1f;
      else if(scaleYnew<5*max)
          return 0.5f;
      else if(scaleYnew<6*max)
          return 1.0f;
      else if(scaleYnew<7*max)
          return 2.0f;
      
      return 5.0f;          
  }
  
  public float mapOffsetY(float pot){
      return (float)round(map(pot,0,(float)(Math.pow(2,esp32.bitsAR)),-esp32.espVoltage,esp32.espVoltage),1);
  }
  
  public float mapOffsetX(float pot){
      savePot = pot;
      return (float)round(map(pot,0,(float)(Math.pow(2,esp32.bitsAR)),-constX*scaleX/1000000.0f,constX*scaleX/1000000.0f),1);
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
          float dataY = ((esp32.readPin(this.getAnalogPort())/(float)(esp32.bitsAD))*esp32.espVoltage);
          float gnd = ((esp32.readPin(esp32.ground)/(float)(Math.pow(2,esp32.bitsAR)))*esp32.espVoltage);
          dataY = map(dataY-gnd+offsetY,-6.09090f*scaleY,6.09090f*scaleY,(tela.getInitialY()+tela.getGridSizeY())-1,tela.getInitialY());
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
public class Trigger{
  
  // -------------------------------- ATRIBUTES --------------------------------
  
  
  
  
  // ------------------------------- CONSTRUTORS -------------------------------
   public Trigger(){
     
     
   }
   
   
   // --------------------------- GETTERS AND SETTERS --------------------------
   
   
   // -------------------------------- METHODS --------------------------------- 
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Scope" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
