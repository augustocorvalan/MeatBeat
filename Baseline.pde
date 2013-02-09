PImage grass = loadImage("sprite sheets/grassblock.png");
final static int GRASS_HEIGHT = GROUND;

class Baseline {
  
  int[] spaces = new int[8];
  int numSpaces = 0;
  
  
  void addEmptyZone(int xPos) {
    spaces[numSpaces] = xPos - MEAT_WIDTH/2;
    numSpaces++;
  }
  
  void draw() {
    stroke(255);
    int x1 = 0;
    for(int i=0; i < numSpaces; i++) {
      //line(x1,GROUND,spaces[i],GROUND);
      image(grass,x1,GROUND,spaces[i]-x1,GRASS_HEIGHT);
      x1 = spaces[i] + MEAT_WIDTH;
    }
    //line(x1,GROUND,WIDTH,GROUND);
    image(grass,x1,GROUND,width-x1,GRASS_HEIGHT);
  }
  
}
