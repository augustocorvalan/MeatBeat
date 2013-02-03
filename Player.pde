class Player{
  int lives;
   boolean lifeDrop = true;
   Player(int lives){
     this.lives = lives;
   }
   void decreaseLives(){  //method to be called in tandem with drawing
     lifeDrop = true;
   }
   boolean isLifeDecreased(){
     return lifeDrop;
   }
   void setDecreasedLives(){  //method actually decreases life counter
     lives--;
     lifeDrop = false;
   }
   int getLives(){
     return lives;
   }
}

void drawLives(PImage lifeImg){
  int x = 0;
  int y = 0;
  int lifeWidth = 606;  //original image width
  int lifeHeight = 612;  //original image height
  int lives = player.getLives();
  for(int i = 0; i < lives; i++){
    image(lifeImg, x, y, lifeWidth/12, lifeHeight/12);
    x += lifeWidth/12 + 5;
    //start a new row
    if(i == 4){
      x = 0;
      y += lifeHeight/12 + 5;
    }
  }
}
