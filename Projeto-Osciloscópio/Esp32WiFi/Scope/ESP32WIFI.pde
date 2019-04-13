import java.math.BigDecimal;
import java.io.*;
import java.net.*;
import java.util.Scanner;

public class ESP32WIFI{
  
  private BufferedReader keyRead = new BufferedReader(new InputStreamReader(System.in));
  private Socket sock;
  private OutputStream ostream;
  private PrintWriter pwrite;
  private InputStream istream;
  private BufferedReader receiveRead;
  private long time = 1000000; 
  
  // PORTAS DO ESP32
  public int ground = 26;
  public int potenciometer = 4;
  public int analogReadY = 1;
  public int analogReadG = 2;
  public int analogReadB = 3;
  public int analogReadP = 4;
  public int buttonScale = 13;
  public int buttonCursor = 12;
  public int buttonOffset = 14;
  public int buttonSave = 27;
  public float espVoltage = (float) 4.69;
  
  public ESP32WIFI(String ipServer, int port){
    try {
      //configurarWiFi("192.168.2.111", 80);
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
    System.out.println("\nConectado ao Servidor de ESP32:" + ipServer + ", porta: "+port);
  }
  
  private int wifiReceive(){
    //pwrite.flush();
    testWait(time);
    
    int receiveMessage = 0;
    
    try {
      if ((receiveMessage = receiveRead.read()) != -1) {
        // COMANDO BASEADO NA MENSAGEM RECEBIDA
        return receiveMessage;
      }
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    
    return receiveMessage;
  }
  
  private int digitalRead(int pin) {
    
    pwrite.println("DR"+pin);
   
    return wifiReceive();
  }

  private int analogRead(int pin) {
    pwrite.println("AR"+pin);

    return wifiReceive();
  }
  
  private int analogReadADS(int pin) {

    pwrite.println("AD"+pin);

    return wifiReceive();
  }
  
  public void testWait(long interval){
    long start = System.nanoTime();
    long end=0;
    do{
      end = System.nanoTime();
    } while(start + interval >= end);
  }
}
