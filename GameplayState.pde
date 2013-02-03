class GameplayState extends BaseState{
//  int totalTrees = 1;
//  Tree[] trees = new Tree[totalTrees];
  
  void setup(){
    background(0);
//    trees = setupTrees(totalTrees);
  }
 
  void draw(){
      background(0);
      //BACKGROUND DRAWING
      drawHill();
//    drawTrees(trees);
  }
 
  void keyPressed(){
    setState(FINISH_STATE);
  }
 
  void cleanup(){
   
  } 
}
