class GameplayState extends BaseState{
//  int totalTrees = 1;
//  Tree[] trees = new Tree[totalTrees];
  Particle[] particles = new Particle[detail+1];
  
  void setup(){
    background(0);
//    particles = setupHill();
//    trees = setupTrees(totalTrees);
  }
 
  void draw(){
      background(0);
      //BACKGROUND DRAWING
//      drawHill(particles);
//    drawTrees(trees);
  }
 
  void keyPressed(){
   setState(FINISH_STATE);
  }
 
  void cleanup(){
   
  } 
}
