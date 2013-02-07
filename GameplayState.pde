class GameplayState extends BaseState{
  /** 
    BACKGROUND VARIABLES
  **/
  int totalHills = 3;
  Hill[] hills = new Hill[totalHills];
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  
  Level currentLevel;
  int currentTrackNum;
  Panel[] panelArray;
  MeatChunk[] chunkArray;
  int offset = 60;
  float thresholdMS = 100;
  
  void setup(){
    background(0);
    
    /**
      BACKGROUND SETUP
    **/
    setupHills(hills);  //hill setup
//    trees = setupTrees(totalTrees);  //tree setup

    /** LIVES **/
    player = new Player(INITIAL_LIVES);  //new player instance
    
//    player = new Player(INITIAL_LIVES, meatLife);  //player instance
//    player.setupLives();
    currentLevel = new Level(beatsarray,soundNames[0]);
    getBeats(levelNames[1]);
    currentTrackNum = currentLevel.getNumTracks();
    panelArray = new Panel[currentTrackNum];
    chunkArray = new MeatChunk[currentTrackNum];
    for(int i = 0; i < currentTrackNum; i++){
      int xpos = offset + (width - offset * 2) / (currentTrackNum - 1) * i;
      chunkArray[i] = new MeatChunk(xpos, GROUND, 0, 0, currentLevel.getTrack(i));
      panelArray[i] = new Panel(xpos, GROUND+(PANEL_HEIGHT/2));
    }
  }
 
  void draw(){
      background(0);
          
      /** 
        BACKGROUND DRAW
      **/
      //drawHills(hills);
//      drawTrees(trees);

      /** LIVES **/
      player.drawLives();
      
      stroke(255);
      line(0,GROUND,width,GROUND);  // line possibly temp for location of GROUND.
      
      for(int i = 0; i < currentTrackNum; i++){
        fill(255, 51, 51);
        ellipse(chunkArray[i].xPosition, chunkArray[i].yPosition, MEAT_WIDTH, MEAT_HEIGHT);
        chunkArray[i].move();
        panelArray[i].draw();
      }
  }
 
  void keyPressed(){
    //setState(FINISH_STATE);
    //player.decreaseLives();
    
    for (int i = 0; i < currentLevel.getNumTracks(); i++) {
      if (key==currentLevel.getTrack(i).getKey()) {
        if (panelArray[i].offScreen) {
          panelArray[i].drawIt();
          checkBeatSuccess(i);
        }
      }
    }
    
    if(key=='q') println(frameRate);
  }
    
  void cleanup(){
   
  }
  
  boolean checkBeatSuccess(int track) {
    if ((abs(panelArray[track].getLastDraw() - (chunkArray[track].getLastBounce()+chunkArray[track].getBounceWait())) <= thresholdMS)) {
    //if ((abs((chunkArray[track].yPosition+MEAT_HEIGHT/2) - (panelArray[track].origY-PANEL_HEIGHT/2)) <= threshold)) {
      beatSuccess(track);
    }
    else {
      beatFailure(track);
    }
  }
  
  void beatSuccess(int track) {
    playSound(currentLevel.getTrack(track).getSound());
  }
  
  void beatFailure(int track) {
    
  }
  
}
