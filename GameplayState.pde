class GameplayState extends BaseState{
//  int totalTrees = 1;
//  Tree[] trees = new Tree[totalTrees];
  Particle[] particles = new Particle[detail+1];
  int tracks = 0;
  
  void setup(){
    background(0);
//    particles = setupHill();
//    trees = setupTrees(totalTrees);
    for(int i=0; i<beats.length; i++) {
      if (beats[i].length > 0) {
        tracks++;
      }
    }
  }
 
  void draw(){
      background(0);
      //BACKGROUND DRAWING
//      drawHill(particles);
//    drawTrees(trees);
  }
 
  void keyPressed(){
   
  }
 
  void cleanup(){
   
  } 
}
