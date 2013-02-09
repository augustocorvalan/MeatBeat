class TitleState extends BaseState{
  int startTime;
  void setup(){
    background(255, 0, 0);
    text("MeatBeat: The Test Title Screen", width/2, height/2);
    playIntro();
  }
 
  void draw(){
  }
  
  void keyPressed(){
      if(key=='p') stopIntro();
      else if(key=='o') playMaster();
      else if(key=='y') playIntro();
      else
      setState(GAMEPLAY_STATE);
  }
  
  void cleanup(){
    stopIntro();
  }
}
