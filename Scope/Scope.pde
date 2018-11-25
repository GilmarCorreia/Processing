import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Arduino uno = new Arduino(this,Arduino.list()[0],57600);
int analogReadY = 0;
int analogReadG = 1;
int analogReadB = 2;
int analogReadP = 3;

Screen tela;
int w = 1450;
int h = 720;

long initialTime = 0;
long scaleX = (long)(2*(1000000000));
float scaleY = 1;
    
Signal amarelo = new Signal(analogReadY);
Signal verde = new Signal(analogReadG);
Signal azul = new Signal(analogReadB);
Signal rosa = new Signal(analogReadP);

void settings() {
  size(w, h);
}

void setup(){
  frameRate(100000);
  tela = new Screen(new Signal[]{amarelo,verde,azul,rosa},new int[]{w,h});
  initialTime = System.nanoTime(); 
}

void draw(){
  
  tela.plot();
  tela.update();
}

void mouseClicked(){
  tela.clicked();
}
