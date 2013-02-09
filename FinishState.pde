class FinishState extends BaseState{
  int CHUNK_NUMBER = 4;
  MeatChunk[] chunkArray;
  Panel[] panelArray;
  float threshold = 5;
  
  float sin_offset= PI/2;
  
  void setup(){
  playSound("sounds/soundeffects/meatbeatscorescreen.ogg");
  setupScore();
}
 
  void draw(){
    background(0);
    text("Hey meatbeater! Thanks for playing!", WIDTH/2, HEIGHT/5);
//    text("Total score: " + player.getScore(), WIDTH/2, HEIGHT/2 + 60);
    drawScore();
    
  }
 
  void keyPressed(){
    if(key=='r') { setState(GAMEPLAY_STATE); }
  }
 
  void cleanup(){
   
  } 
}
