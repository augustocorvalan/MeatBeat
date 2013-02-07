static final int PANEL_WIDTH = 50;
static final int PANEL_HEIGHT = 10;

class Panel{
  float xPosition, yPosition, origY;
  float angle = 0;
  float levelInterval = .5;
  int opacity;
  //int opacityInterval = round(255/frameRate);
  boolean offScreen;
  int lastDraw;
  int waitTime = 100; // ms between allowable presses
  
  Panel(float xPosition, float yPosition){
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.origY = yPosition;
    opacity = 255;
    offScreen = true;
    lastDraw = 0;
  }
  
  void getLastDraw() { // returns ms value of last time drawn
    return lastDraw;
  }
  
  void drawIt() {
    offScreen = false;
    lastDraw = millis();
    fill(213, 143, 45, opacity);
    rect(xPosition, yPosition, PANEL_WIDTH, PANEL_HEIGHT); 
  }
  
  void draw(){
    if(!offScreen){
      noStroke();        
      fill(213, 143, 45, opacity);
      rect(xPosition, yPosition, PANEL_WIDTH, PANEL_HEIGHT);
      //yPosition = yPosition + levelInterval;
      //opacity = opacity - opacityInterval;
      //if(yPosition >= origY + frameRate * levelInterval){
      if( (millis() - lastDraw) > waitTime) {
        offScreen = true;
        //opacity = 255;
        //yPosition = origY;
      }
    }
  }
}
