static final int PANEL_WIDTH = 30;
static final int PANEL_HEIGHT = 90;

class Panel{
  float xPosition, yPosition, origY;
  boolean offScreen;
  int lastDraw;
  int waitTime = 140; // ms fist on screen;
  int hold = 50; // ms between presses
  
  
  Panel(float xPosition, float yPosition){
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.origY = yPosition;
    offScreen = true;
    lastDraw = 0;
  }
  
  void getLastDraw() { // returns ms value of last time drawn
    return lastDraw;
  }
  
  void drawIt() {
    if (millis() - lastDraw >- hold) {
      offScreen = false;
      image(fist,xPosition,yPosition,PANEL_WIDTH,PANEL_HEIGHT);
      lastDraw = millis();
    }
  }
  
  void draw(){
    if(!offScreen){
      image(fist,xPosition,yPosition,PANEL_WIDTH,PANEL_HEIGHT);
      if( (millis() - lastDraw) > waitTime) {
        offScreen = true;
      }
    }
  }
}
