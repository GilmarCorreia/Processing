import java.math.BigDecimal;
import java.io.*;
import java.net.*;
import java.util.Scanner;

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
  public float espVoltage = (float) 3.3;
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
