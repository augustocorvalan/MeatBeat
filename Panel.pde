static final int PANEL_WIDTH = 30;
static final int PANEL_HEIGHT = 90;

class Panel{
  float xPosition, yPosition, origY;
  boolean offScreen;
  int lastDraw;
  int waitTime = 100; // ms between allowable presses
  
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
    offScreen = false;
    image(fist,xPosition,yPosition,PANEL_WIDTH,PANEL_HEIGHT);
    lastDraw = millis();
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
