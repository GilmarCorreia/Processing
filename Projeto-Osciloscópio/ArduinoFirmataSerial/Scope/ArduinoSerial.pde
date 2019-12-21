public class ArduinoSerial extends Arduino{
  
  // ================================= Atributes =================================
  private int buttonScale, buttonCursor, buttonOffset, buttonSave;
  private int analogReadY, analogReadG, analogReadB, analogReadP;
  private int ground;
  private int potenciometer;
  private float arduinoVoltage;
  private int bitsAR, bitsAD;
  private boolean ADS1X15;
  private float[] arduinoInputs = new float[10];
  
  // ================================ Constructor ================================ 
  public ArduinoSerial(PApplet proc, int port,int baudrate, boolean ADS1X15){
    super(proc,Serial.list()[port],baudrate);
    setButtonsPort(13,12,11,10);
    setGroundPort(0);
    setPotPort(1);
    setADS1X15(ADS1X15);
    
    if (getADS1X15())
      setProbePorts(10,11,12,13);
    else
      setProbePorts(2,3,4,5);
      
    setArduinoVoltage((float)4.719);
    setBitsAR(1024);
    setBitsAD( (int) ( ( getArduinoVoltage()*32768.0 ) / 6.144 ) ); // Valor máximo de leitura para 5.0V
    
    pinMode(getButtonScalePort(),Arduino.INPUT);
    pinMode(getButtonCursorPort(),Arduino.INPUT);
    pinMode(getButtonOffsetPort(),Arduino.INPUT);
    pinMode(getButtonSavePort(),Arduino.INPUT);
  }
  
  public ArduinoSerial(PApplet proc, boolean ADS1015){
    this(proc,0,57600,ADS1015);
  }
  
  // ============================== Setter e Getters =============================
  
  private void setButtonsPort(int port1, int port2, int port3, int port4){
    setButtonScalePort(port1);
    setButtonCursorPort(port2);
    setButtonOffsetPort(port3);
    setButtonSavePort(port4);
  }
  
  private void setButtonScalePort(int port){
    this.buttonScale = port;
  }
  
  private void setButtonCursorPort(int port){
    this.buttonCursor = port;
  }
  
  private void setButtonOffsetPort(int port){
    this.buttonOffset = port;
  }
  
  private void setButtonSavePort(int port){
    this.buttonSave = port;
  }
  
  private void setADS1X15(boolean isConnected){
    this.ADS1X15 = isConnected;  
  }
  
  private void setProbePorts(int ad0, int ad1, int ad2, int ad3){
    setYellowProbe(ad0);
    setGreenProbe(ad1);
    setBlueProbe(ad2);
    setPinkProbe(ad3);
  }
  
  private void setYellowProbe(int port){
    this.analogReadY=port;
  }
  
  private void setGreenProbe(int port){
    this.analogReadG=port;
  }
  
  private void setBlueProbe(int port){
    this.analogReadB=port;
  }
  
  private void setPinkProbe(int port){
    this.analogReadP=port;
  }
  
  private void setGroundPort(int port){
    this.ground = port;
  }
  
  private void setPotPort(int port){
   this.potenciometer = port; 
  }
  
  private void setArduinoVoltage(float voltage){
   this.arduinoVoltage = voltage; 
  }
  
  private void setBitsAR(int bits){
   this.bitsAR = bits; 
  }
  
  private void setBitsAD(int bits){
   this.bitsAD = bits; 
  }
  
  public int getButtonScalePort(){
    return this.buttonScale; 
  }
  
  public int getButtonCursorPort(){
    return this.buttonCursor; 
  }
  
  public int getButtonOffsetPort(){
    return this.buttonOffset; 
  }
  
  public int getButtonSavePort(){
    return this.buttonSave; 
  }
  
  public int getButtonScale(){
    return (int)this.arduinoInputs[0]; 
  }
  
  public int getButtonCursor(){
    return (int)this.arduinoInputs[1]; 
  }
  
  public int getButtonOffset(){
    return (int)this.arduinoInputs[2]; 
  }
  
  public int getButtonSave(){
    return (int)this.arduinoInputs[3]; 
  }
  
  public boolean getADS1X15(){
    return this.ADS1X15;  
  }
  
  public float getProbe(int probe){
    if (probe == 0)
      return getYellowProbe();
    else if (probe == 1)
      return getGreenProbe();
    else if (probe == 2)
      return getBlueProbe();
    else if (probe == 3)
      return getPinkProbe();
      
    return -1.0;
  }
  
  public float getYellowProbe(){
    if(getADS1X15())
      return map(this.arduinoInputs[4],0,getBitsAD(),0,getArduinoVoltage());
    else
      return map(this.arduinoInputs[4],0,getBitsAR(),0,getArduinoVoltage());
  }
  
  public float getGreenProbe(){
    if(getADS1X15())
      return map(this.arduinoInputs[5],0,getBitsAD(),0,getArduinoVoltage());
    else
      return map(this.arduinoInputs[5],0,getBitsAR(),0,getArduinoVoltage());
  }
  
  public float getBlueProbe(){
    if(getADS1X15())
      return map(this.arduinoInputs[6],0,getBitsAD(),0,getArduinoVoltage());
    else
      return map(this.arduinoInputs[6],0,getBitsAR(),0,getArduinoVoltage());  
  }
  
  public float getPinkProbe(){
    if(getADS1X15())
      return map(this.arduinoInputs[7],0,getBitsAD(),0,getArduinoVoltage());
    else
      return map(this.arduinoInputs[7],0,getBitsAR(),0,getArduinoVoltage());
  }
  
  public float getGround(){
    return map(this.arduinoInputs[8],0,getBitsAR(),0,getArduinoVoltage());  
  }
  
  public int getPot(){
    return (int)this.arduinoInputs[9];  
  }
  
  public float getArduinoVoltage(){
    return this.arduinoVoltage; 
  }
  
  public int getBitsAR(){
    return this.bitsAR;  
  }
 
  public int getBitsAD(){
    return this.bitsAD;  
  }
  
  @Override
  public void run(){
    while(true){
      arduinoInputs[0] = digitalRead(getButtonScalePort());
      arduinoInputs[1] = digitalRead(getButtonCursorPort());
      arduinoInputs[2] = digitalRead(getButtonOffsetPort());
      arduinoInputs[3] = digitalRead(getButtonSavePort());
      arduinoInputs[4] = analogRead(this.analogReadY);
      arduinoInputs[5] = analogRead(this.analogReadG);
      arduinoInputs[6] = analogRead(this.analogReadB);
      arduinoInputs[7] = analogRead(this.analogReadP);
      arduinoInputs[8] = analogRead(this.ground);
      arduinoInputs[9] = analogRead(this.potenciometer);
      long time = System.nanoTime();
      while(System.nanoTime() - time < 1000){}
    }
  }
  
  // =================================== Methods =================================
}
