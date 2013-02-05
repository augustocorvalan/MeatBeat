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
  float threshold = 5;
  
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
    //float[][] beats = {{0,0},{0,0}}
    //beats = getBeats("sounds/testmidi/samplemeatbeatbeat.mid",console.log.bind(console));
   // beatsarray = getBeats("sounds/testmidi/samplemeatbeatbeat.mid",console.log.bind(console));
    //println(beatstest[1][1]);
    //var thebeats = getBeats("sounds/testmidi/samplemeatbeatbeat.mid",console.log.bind(console));
    //println("hello");
    //println(beatsPerMinute);
    //println(beatsarray[1][0]);
    currentLevel = new Level(levelBeats[0],soundNames[0]);
    currentTrackNum = currentLevel.getNumTracks();
    panelArray = new Panel[currentTrackNum];
    chunkArray = new MeatChunk[currentTrackNum];
    for(int i = 0; i < currentTrackNum; i++){
      int xpos = offset + (width - offset * 2) / (currentTrackNum - 1) * i;
      chunkArray[i] = new MeatChunk(xpos,  height/2);
      chunkArray[i].velocity = .25;
      chunkArray[i].gravity = .5;
      panelArray[i] = new Panel(xpos, height - 50);
    }
  }
 
  void draw(){
      background(0);
      
      /** 
        BACKGROUND DRAW
      **/
      drawHills(hills);
//      drawTrees(trees);

      /** LIVES **/
      player.drawLives();
      
      for(int i = 0; i < currentTrackNum; i++){
        panelArray[i].draw();
        ellipse(chunkArray[i].xPosition, chunkArray[i].yPosition, 25, 25);
        chunkArray[i].increment();
        if(chunkArray[i].yPosition >= 600){
           chunkArray[i].velocity = -10;
        }
      }
    
      //LIVES

  }
 
  void keyPressed(){
    //setState(FINISH_STATE);
    //player.decreaseLives();
    switch(key){
      case 'j':
        if(currentTrackNum >= 1){
          if(panelArray[0].canRedraw){
            panelArray[0].canRedraw = false;
            if((chunkArray[0].yPosition >= (panelArray[0].origY + threshold) && !panelArray[0].canRedraw)){
               chunkArray[0].velocity = -15;
               playSound(currentLevel.getTrack(0).getSound());
            }
          }
        }
        break;
     case 'k':
      if(currentTrackNum >= 2){
        if(panelArray[1].canRedraw){
          panelArray[1].canRedraw = false;
          if((chunkArray[1].yPosition >= (panelArray[1].origY + threshold) && !panelArray[1].canRedraw)){
               chunkArray[1].velocity = -15;
               playSound(currentLevel.getTrack(1).getSound());
          }
        }
      }
      break;
     case 'l':
      if(currentTrackNum >= 3){
        if(panelArray[2].canRedraw){
          panelArray[2].canRedraw = false;
          if((chunkArray[2].yPosition >= (panelArray[2].origY + threshold) && !panelArray[2].canRedraw)){
               chunkArray[2].velocity = -15;
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
               chunkArray[3].velocity = -15;
               playSound(currentLevel.getTrack(3).getSound());
          }
        }
      }
      break;
    }
  }
    
  void cleanup(){
   
  } 
}
