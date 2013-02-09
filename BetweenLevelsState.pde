class BetweenLevelsState extends BaseState {
  static final int GB = 1;
  static final int H = 2;
  static final int DONE = 3;
  int xPos;
  String goodbye;
  String hello;
  int state;
  
  
  void setup(){
    xPos = 0;
    goodbye = "Goodbye Level " + levelIndex;
    hello = "Hello Level " + (levelIndex+1);
    state = GB;
  }
 
  void draw(){
    background(0);
    if (state==GB) {
      drawGB();
    }
    else if (state==H) {
      drawH();
    }
    else {
      setState(GAMEPLAY_STATE);
    }
  }
  
  void drawGB() {
    fill(255);
    if (xPos <= width + 200) {
      text(goodbye, xPos, height/2);  //number of lives
      xPos = xPos + 10;
    }
    else {
      state = H;
      xPos = 0;
    }
  }
  
  void drawH() {
    fill(255);
    if (xPos <= width + 200) {
      text(hello, xPos, height/2);  //number of lives
      xPos = xPos + 10;
    }
    else  {
      state = DONE;
    }
  }
  
  void cleanup(){}
  
  void keyPressed(){}
  
}
