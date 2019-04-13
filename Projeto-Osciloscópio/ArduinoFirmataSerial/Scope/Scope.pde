import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Arduino uno = new Arduino(this,Arduino.list()[0],57600);

String folder = "Laboratório1/scope-";

int ground = 0;
int analogReadY = 1;
int analogReadG = 2;
int analogReadB = 3;
int analogReadP = 4;
int buttonScale = 13;
int buttonCursor = 12;
int buttonOffset = 11;
int buttonSave = 10;

float offsetY = 0;
float offsetX = 0;
float arduinoVoltage = 4.69;
float trigger = 2.5;

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
  uno.pinMode(buttonScale,Arduino.INPUT);
  uno.pinMode(buttonCursor,Arduino.INPUT);
  uno.pinMode(buttonSave,Arduino.INPUT);
  uno.pinMode(buttonOffset,Arduino.INPUT);
  initialTime = System.nanoTime(); 
}

void draw(){
  tela.plot(); 
  tela.update();
}

void mouseClicked(){
  tela.clicked();
}
