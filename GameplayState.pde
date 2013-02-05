class GameplayState extends BaseState{
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  PImage[] numbers = new PImage[10];  //holds the meat numbers
  Level currentLevel;
  int currentTrackNum;
  Panel[] panelArray;
  MeatChunk[] chunkArray;
  int offset = 60;
  float threshold = 5;
  
  void setup(){
    background(0);
    //trees = setupTrees(totalTrees);  //tree setup
//    numbers = cutUpNumbers(meatFont);
//    player = new Player(INITIAL_LIVES, meatLife);  //player instance
//    player.setupLives();
    //float[][] beats = {{0,0},{0,0}}
    //getBeats("sounds/testmidi/samplemeatbeatbeat.mid",console.log.bind(console));
   // beatsarray = getBeats("sounds/testmidi/samplemeatbeatbeat.mid",console.log.bind(console));
    ///println(beatstest[1][1]);
    //var thebeats = getBeats("sounds/testmidi/samplemeatbeatbeat.mid",console.log.bind(console));
    //println("hello");
    //println(beatsPerMinute);
    //println(beats[0][1]);
    currentLevel = new Level(beatsarray,soundNames[0]);
    currentTrackNum = currentLevel.getNumTracks();
    panelArray = new Panel[currentTrackNum];
    chunkArray = new MeatChunk[currentTrackNum];
    for(int i = 0; i < currentTrackNum; i++){
      int xpos = offset + (width - offset * 2) / (currentTrackNum - 1) * i;
      chunkArray[i] = new MeatChunk(xpos,  height/2, .5, .25);
      panelArray[i] = new Panel(xpos, height - 50);
    }
  }
 
  void draw(){
      background(0);
      for(int i = 0; i < currentTrackNum; i++){
        panelArray[i].draw();
        ellipse(chunkArray[i].xPosition, chunkArray[i].yPosition, 25, 25);
        chunkArray[i].increment();
        if(chunkArray[i].yPosition >= 600){
           chunkArray[i].velocity = -10;
        }
      }
      
      //BACKGROUND DRAWING
    //drawTrees(trees);
      //LIVES
//      player.drawLives();
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
