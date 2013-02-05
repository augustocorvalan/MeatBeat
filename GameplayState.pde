class GameplayState extends BaseState{
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  PImage[] numbers = new PImage[10];  //holds the meat numbers
  Level currentLevel;
  int currentTrackNum;
  Panel[] panelArray;
  int offset = 60;
  
  void setup(){
    background(0);
    //trees = setupTrees(totalTrees);  //tree setup
//    numbers = cutUpNumbers(meatFont);
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
    for(int i = 0; i < currentTrackNum; i++){
      panelArray[i] = new Panel(offset + (width - offset * 2)/ (currentTrackNum - 1) * i, height - 50);
    }
  }
 
  void draw(){
      background(0);
      for(int i = 0; i < currentTrackNum; i++){
        panelArray[i].draw();
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
            playSound(currentLevel.getTrack(0).getSound());
          }
        }
        break;
     case 'k':
      if(currentTrackNum >= 2){
        if(panelArray[1].canRedraw){
          panelArray[1].canRedraw = false;
        }
      }
      break;
     case 'l':
      if(currentTrackNum >= 3){
        if(panelArray[2].canRedraw){
          panelArray[2].canRedraw = false;
        }
      }
      break;
     case ';':
      if(currentTrackNum >= 4){
        if(panelArray[3].canRedraw){
          panelArray[3].canRedraw = false;
        }
      }
      break; 
    }
  }
 
  void cleanup(){
   
  } 
}
