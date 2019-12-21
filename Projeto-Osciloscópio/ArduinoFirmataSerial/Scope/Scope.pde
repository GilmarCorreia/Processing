import processing.serial.*;

// Configurando a comunicação serial com o Arduino
ArduinoSerial unoScope = new ArduinoSerial(this,0,57600,true);

// Configurando o folder 
String folder = "Laboratório1/scope-";

// Definindo o offset dos canais
float offsetY = 0;
float offsetX = 0;

// Definindo a voltagem do trigger
float trigger = 2.5;

// Configurando o tamanho a tela
Screen tela;
int w = 1450;
int h = 720;

// Configurando o tempo inicial
long initialTime = 0;

// configurando as variáveis de escala de tempo e voltagem 
long scaleX = (long)(2*(1000000000));
float scaleY = 1;

//    
Signal amarelo = new Signal(0);
Signal verde = new Signal(1);
Signal azul = new Signal(2);
Signal rosa = new Signal(3);

void settings() {
  size(w, h);
}

void setup(){
  frameRate(100000);
  tela = new Screen(new Signal[]{amarelo,verde,azul,rosa},new int[]{w,h});
  initialTime = System.nanoTime(); 
  unoScope.start();
}

void draw(){
  //long it = System.nanoTime();
  tela.plot();
  tela.update();
  //println(System.nanoTime() - it);
}

void mouseClicked(){
  tela.clicked();
}
