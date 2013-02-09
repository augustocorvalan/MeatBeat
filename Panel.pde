static final int PANEL_WIDTH = 50;
static final int PANEL_HEIGHT = 10;

class Panel{
  float xPosition, yPosition, origY;
  int opacity;
  boolean offScreen;
  int lastDraw;
  int waitTime = 200; // ms between allowable presses
  
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
    fill(213, 143, 45, opacity);
    rect(xPosition, yPosition, PANEL_WIDTH, PANEL_HEIGHT);
    lastDraw = millis();
  }
  
  void draw(){
    if(!offScreen){
      noStroke();        
      fill(213, 143, 45, opacity);
      rect(xPosition, yPosition, PANEL_WIDTH, PANEL_HEIGHT);
      if( (millis() - lastDraw) > waitTime) {
        offScreen = true;
        //opacity = 255;
        //yPosition = origY;
      }
    }
  }
}
