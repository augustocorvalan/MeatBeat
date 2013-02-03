class GameplayState extends BaseState{
//  int totalTrees = 1;
//  Tree[] trees = new Tree[totalTrees];
  int tracks = 0;
  PImage[] numbers = new PImage[10];  //holds the meat numbers
  
  void setup(){
    background(0);
//    trees = setupTrees(totalTrees);
    numbers = cutUpNumbers(meatFont);
  }
 
  void draw(){
      background(0);
      //BACKGROUND DRAWING
//    drawTrees(trees);
      //LIVES
      drawLives(meatLife);
  }
 
  void keyPressed(){
   setState(FINISH_STATE);
  }
 
  void cleanup(){
   
  } 
}
