//ESP32SERIAL esp32 = new ESP32SERIAL();
ESP32WIFI esp32 = new ESP32WIFI("192.168.43.108",80);

String folder = "Laboratório1/scope-";

float offsetY = 0;
float offsetX = 0;
float trigger = 2.5;

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

void settings() {
  size(w, h);
}

void setup(){
  frameRate(10000000);
  tela = new Screen(new Signal[]{amarelo,verde,azul,rosa},new int[]{w,h});
  initialTime = System.nanoTime(); 
}

void draw(){
  //long teste = System.nanoTime();
  tela.plot(); 
  tela.update();
  //println(System.nanoTime()-teste);
}

void mouseClicked(){
  tela.clicked();
}
