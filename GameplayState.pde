class GameplayState extends BaseState{
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  int tracks = 0;
  PImage[] numbers = new PImage[10];  //holds the meat numbers
  
  void setup(){
    background(0);
    trees = setupTrees(totalTrees);  //tree setup
//    numbers = cutUpNumbers(meatFont);
    player = new Player(INITIAL_LIVES, meatLife);  //player instance
    player.setupLives();
    println(calcNumTracks(getBeats("sounds/testmidi/samplemeatbeatbeat.mid",console.log.bind(console))));
  }
 
  void draw(){
      background(0);
      //BACKGROUND DRAWING
      drawTrees(trees);
      //LIVES
      player.drawLives();
  }
 
  void keyPressed(){
//   setState(FINISH_STATE);
    player.decreaseLives();
  }
 
  void cleanup(){
   
  } 
}
