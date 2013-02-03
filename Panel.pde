class Panel{
  float xPosition, yPosition, origY;
  float levelInterval = (PI/2)/frameRate;
  float angle = 0;
  float levelInterval = .5;
  int opacity;
  int opacityInterval = 255/frameRate;
  boolean canRedraw;
  boolean canRepress;
  
  Panel(float xPosition, float yPosition){
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.origY = yPosition;
    opacity = 255;
    canRedraw = true;
  }
  
  void draw(){
    if(!canRedraw){
      noStroke();        fill(213, 143, 45, opacity);
      rect(xPosition, yPosition, 50, 20);
      yPosition = yPosition + levelInterval;
      opacity = opacity - opacityInterval;
      if(yPosition >= origY + frameRate * levelInterval){
        canRedraw = true;
        opacity = 255;
        yPosition = origY;
      }
    }
  }
}
