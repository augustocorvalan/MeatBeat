class TitleState extends BaseState{
  int startTime;
  PImage logo = loadImage("sprite sheets/logo.png");
  PImage play = loadImage("sprite sheets/play.png");
  void setup(){
    background(255, 0, 0);
//    text("MeatBeat: The Test Title Screen", width/2, height/2);
    playIntro();
  }
 
  void draw(){
        fill(100);
        rect(width/2, height/2.5, width/1.5, width/1.8, 20);
        rect(width/2.05, height*0.865, width/5.4, height/6, 5);
        image(logo, width/8, -width/16, width*3/4, width*3/4);
        image(play, width/2.7, height*3/4, width/4, height/4);
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
