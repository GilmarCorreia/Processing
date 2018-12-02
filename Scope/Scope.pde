import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Arduino uno = new Arduino(this,Arduino.list()[0],57600);
RunProgram teste = new RunProgram();

int ground = 0;
int analogReadY = 1;
int analogReadG = 2;
int analogReadB = 3;
int analogReadP = 4;
int button = 13;
float arduinoVoltage = 4.66;

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
  uno.pinMode(button,Arduino.INPUT);
  uno.pinMode(1,Arduino.OUTPUT);
  initialTime = System.nanoTime(); 
}

void draw(){
  //thread("run");
  tela.plot(); 
  tela.update();
}

void mouseClicked(){
  tela.clicked();
}

void run(){
    uno.digitalWrite(1,Arduino.HIGH);
    delay(1000);
    uno.digitalWrite(1,Arduino.LOW);
    delay(1000);
}
