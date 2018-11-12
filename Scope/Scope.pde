import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

//Arduino uno = new Arduino(this,Arduino.list()[1],57600);
Screen tela;
int w = 1450;
int h = 720;

float i1 = 0, j1 =0,i2 = 0, j2 =0,i3 = 0, j3 =0,i4 = 0, j4 =0;
Coordinate canal1 = new Coordinate(i1,j1);
Coordinate canal2 = new Coordinate(i2,j2);
Coordinate canal3 = new Coordinate(i3,j3);
Coordinate canal4 = new Coordinate(i4,j4);

Signal amarelo = new Signal(canal1);
Signal verde = new Signal(canal2);
Signal azul = new Signal(canal3);
Signal rosa = new Signal(canal4);

void settings() {
  size(w, h);
}

void setup(){
  frameRate(100000);
  tela = new Screen(new Signal[]{amarelo,verde,azul,rosa},new int[]{w,h});
}

void draw(){
  
  if(i1<200 && j1<200){
    canal1.setPos(i1+=0.05,j1+=0.05);
    amarelo.setMemory(canal1);
    canal2.setPos(i2+=0.02,j2-=0.05);
    verde.setMemory(canal2);
    canal3.setPos(i3-=0.05,j3-=0.05);
    azul.setMemory(canal3);
    canal4.setPos(i4-=0.03,j4+=0.02);
    rosa.setMemory(canal4);
  }
  else{
    tela.clear();
  }
  
  tela.plot();
  
  tela.update();
}

void mouseClicked(){
  tela.clicked();
}
