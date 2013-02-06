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
  float threshold = 25;
  
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
        /*if(chunkArray[i].yPosition >= 600){
           chunkArray[i].velocity = -10;
        }*/
      }
  }
 
  void keyPressed(){
    //setState(FINISH_STATE);
    //player.decreaseLives();
    switch(key){
      case 'j':
        if(currentTrackNum >= 1){
          if(panelArray[0].canRedraw){
            panelArray[0].drawIt();
            if((abs((chunkArray[0].yPosition+MEAT_HEIGHT/2) - (panelArray[0].origY-PANEL_HEIGHT/2)) <= threshold)) { //&& !panelArray[0].canRedraw)){
               //chunkArray[0].velocity = -15;
               playSound(currentLevel.getTrack(0).getSound());
            }
          }
        }
        break;
     case 'k':
      if(currentTrackNum >= 2){
        if(panelArray[1].canRedraw){
          panelArray[1].canRedraw = false;
          if((abs((chunkArray[1].yPosition+MEAT_HEIGHT/2) - (panelArray[1].origY-PANEL_HEIGHT/2)) <= threshold)) {
               //chunkArray[1].velocity = -15;
               playSound(currentLevel.getTrack(1).getSound());
          }
        }
      }
      break;
     case 'l':
      if(currentTrackNum >= 3){
        if(panelArray[2].canRedraw){
          panelArray[2].canRedraw = false;
          if((abs((chunkArray[2].yPosition+MEAT_HEIGHT/2) - (panelArray[2].origY-PANEL_HEIGHT/2)) <= threshold)) {
               //chunkArray[2].velocity = -15;
               playSound(currentLevel.getTrack(2).getSound());
          }
        }
      }
      break;
     case ';':
      if(currentTrackNum >= 4){
        if(panelArray[3].canRedraw){
          panelArray[3].canRedraw = false;
          if((chunkArray[3].yPosition >= (panelArray[3].origY + threshold) && !panelArray[3].canRedraw)){
               //chunkArray[3].velocity = -15;
               playSound(currentLevel.getTrack(3).getSound());
          }
        }
      }
      break;
     case 'q': println(frameRate); break;
    }
  }
    
  void cleanup(){
   
  } 
}
