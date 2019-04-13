
public class Coordinate{
  
  // -------------------------------- ATRIBUTES --------------------------------
  
  private float x,y;
  
  // ------------------------------- CONSTRUTORS -------------------------------
  
  public Coordinate(float x, float y){
    setX(x);
    setY(y);
  }
  
  // --------------------------- GETTERS AND SETTERS --------------------------
  
  public void setPos(float x, float y){
    setX(x);
    setY(y);
  }
  
  public void setX(float x){
    this.x = x;
  }
  
  public void setY(float y){
    this.y = y;
  }  
  
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y; 
  }
  
  // -------------------------------- METHODS ---------------------------------
  
}
