import java.math.BigDecimal;
import java.io.*;
import java.net.*;
import java.util.Scanner;
import java.awt.image.*;
import javax.imageio.ImageIO;
import java.nio.ByteBuffer;
import java.nio.file.*;
import java.util.zip.*;

public class ESP32WIFI extends Thread{
  private Socket sock;
  private OutputStream ostream;
  private PrintWriter pwrite;
  private InputStream istream;
  private BufferedReader receiveRead;
  private int c[] = new int[200];
  private int data[] = new int[10];
  private volatile boolean exit = false;
  
  // PORTAS DO ESP32
  public int buttonScale = 0;
  public int buttonCursor = 1;
  public int buttonOffset = 2;
  public int buttonSave = 3;
  public int ground = 4;
  public int potenciometer = 5;
  public int analogReadY = 6;
  public int analogReadG = 7;
  public int analogReadB = 8;
  public int analogReadP = 9;
  public float espVoltage = (float) 3.27;
  public int bitsAR = 4096; 
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
  
  private void wifiReceive(){   
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
          data[count]=data[count]*10+(c[n]-'0');
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
    //println(data[pin]);
    return data[pin];
  }
  
  @Override
  public void run() {
    while(true){
      if(!exit)
        update();
    }
  }
  
  public synchronized void update(){
    pwrite.println("U");
    wifiReceive();
  }
    
  public void sendImage(String file){
    pwrite.print('I');
    File img = new File("C:\\Users\\Gilmar Jeronimo\\Documents\\Documentos\\Projetos\\GitHub\\GIL GIT\\Processing\\Projeto-Osciloscópio\\Esp32WiFi\\Scope\\"+file);
    //println(img.length());
    pwrite.print(img.length());
    pwrite.print('I');
    pwrite.print(tela.round(map(tela.cursorX1,tela.getInitialX(),tela.getInitialX()+tela.getGridSizeX(),-tela.constX*scaleX/1000000,tela.constX*scaleX/1000000),1));
    pwrite.print(',');
    pwrite.print(tela.round(map(tela.cursorY1,tela.getInitialY()+tela.getGridSizeY(),tela.getInitialY(),-6.09090*scaleY,6.09090*scaleY),3));
    pwrite.print(',');
    pwrite.print(tela.round(map(tela.cursorX2,tela.getInitialX(),tela.getInitialX()+tela.getGridSizeX(),-tela.constX*scaleX/1000000,tela.constX*scaleX/1000000),1));
    pwrite.print(',');
    pwrite.print(tela.round(map(tela.cursorY2,tela.getInitialY()+tela.getGridSizeY(),tela.getInitialY(),-6.09090*scaleY,6.09090*scaleY),3));
    pwrite.print('I');

    try{      
      FileReader scope = new FileReader("C:\\Users\\Gilmar Jeronimo\\Documents\\Documentos\\Projetos\\GitHub\\GIL GIT\\Processing\\Projeto-Osciloscópio\\Esp32WiFi\\Scope\\"+file); 
      int intch;
      while ((intch = scope.read()) != -1) {
        pwrite.print((char)intch);
      }
     
      System.out.println("Flushed: " + System.currentTimeMillis());
      
      int received;
      do {
        received = receiveRead.read();
        println("esperando");
      } while (received !='F') ;
      
      System.out.println("Closing: " + System.currentTimeMillis());
      scope.close();
    } catch (Exception e){
      println(e);
    }
  }
}
