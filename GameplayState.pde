class GameplayState extends BaseState{
  /** 
    BACKGROUND VARIABLES
  **/
  int totalHills = 3;
  Hill[] hills = new Hill[totalHills];
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  int totalClouds = 3;
  Cloud[] clouds = new Cloud[totalClouds];
  boolean showLineOrCloud;
  int levelStart;
  static final int NEW_LEVEL_TIME = 1500;


  
  Level currentLevel;
  int currentTrackNum;
  Panel[] panelArray;
  MeatChunk[] chunkArray;
  int offset = 60;
  float thresholdMS = 650;
  int timingErrorControl = 10;
  int[] shouldCheckBeat;
  Baseline bl;
  
  void setup(){    
    /**  BACKGROUND SETUP **/
    setupHills(hills);  //hill setup
    trees = setupTrees(totalTrees);  //tree setup
    setupClouds(clouds);  //cloud setup
    setupLine();
    setNextLevel();
    playMaster();
  }
  
  void setNextLevel() {
    fist = loadImage(fists[int(random(0,fists.length))]);
    currentLevel = new Level(beatsarray);
    levelIndex++;
    getBeats(levelNames[levelIndex]); // get next level loaded
    currentTrackNum = currentLevel.getNumTracks();
    panelArray = new Panel[currentTrackNum];
    chunkArray = new MeatChunk[currentTrackNum];
    shouldCheckBeat = new int[currentTrackNum];
    bl = new Baseline();
    for(int i = 0; i < currentTrackNum; i++){
      int xpos = offset + (width - offset * 2) / (currentTrackNum - 1) * i;
      chunkArray[i] = new MeatChunk(xpos - MEAT_WIDTH/2, GROUND, 0, 0, currentLevel.getTrack(i));
      panelArray[i] = new Panel(xpos - PANEL_WIDTH/2, GROUND - 15);
      bl.addEmptyZone(xpos);
      shouldCheckBeat[i] = 0;
    }
    levelStart = millis();
  }
 
  void draw(){
      levelComplete = true;
      background(143);
      
      /** 
        BACKGROUND DRAW
      **/
      drawLine();
      if(showLineOrCloud == "true"){
        drawLine();
       }
       else{
        drawClouds(clouds);
       }
      drawHills(hills);
      drawTrees(trees);

      /** LIVES **/
      player.drawLives();
      player.drawScore();
      bl.draw();
      
      for(int i = 0; i < currentTrackNum; i++){
        panelArray[i].draw();
        shouldCheckBeat[i] = chunkArray[i].move();
        if (shouldCheckBeat[i]==1) {
          checkBeatSuccess(i);
        }
        if (chunkArray[i].state != COMPLETE) {
          levelComplete = false;
        }
      }
      /*if (shouldCheckBeat[0]==1) {
          checkBeatSuccess(0);
          //playSound(currentLevel.getTrack(0).getSound());
          //soundTimes[0] = millis();
      }*/
      if (levelComplete) {
        //setState(BETWEEN_LEVELS_STATE);
        //setState(GAMEPLAY_STATE);
        setNextLevel();
      }
      if ((millis() - levelStart) <= NEW_LEVEL_TIME) {
        image(lvlImages[levelIndex-1],WIDTH/2-100,HEIGHT/4,200,40);
      }
  }
  
 
  void keyPressed(){
    //setState(FINISH_STATE);
    //player.decreaseLives();
    for (int i = 0; i < currentLevel.getNumTracks(); i++) {
      if (key==currentLevel.getTrack(i).getKey()) {
        if (panelArray[i].offScreen) {
          panelArray[i].drawIt();
          //checkBeatSuccess(i);
        }
      }
    }
    
    if(key=='1') setNextLevel();
    if(key=='q') println(frameRate);
    if(key=='w') playSound(failsound);
    //if(key=='p') noLoop();
    if(key=='x') setState(FINISH_STATE);
    if(key=='c') player.changeScore(10);
  }
    
  void cleanup(){
   
  }
  
  boolean checkBeatSuccess(int track) {
    //int diff = abs(panelArray[track].getLastDraw() - chunkArray[track].shouldBounceAgain);
    //println(diff);
    if (!panelArray[track].offScreen) {
    //if ((abs((chunkArray[track].yPosition+MEAT_HEIGHT/2) - (panelArray[track].origY-PANEL_HEIGHT/2)) <= threshold)) {
      beatSuccess(track);
    }
    else {
      beatFailure(track);
    }
  }
  
  void beatSuccess(int track) {
    currentLevel.getTrack(track).canSound=true;
    player.changeScore(1);    
  }
  
  void beatFailure(int track) {
    player.decreaseLives();
    chunkArray[track].fail();
    playFail();
  }
  
}
