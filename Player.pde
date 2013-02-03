class Player{
  int lives;
 
   Player(int lives){
     this.lives = lives;
   }
   void decreaseLives(){
     lives--;
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
    image(lifeImg, x, 0, lifeWidth/10, lifeHeight/10);
    x += lifeWidth/10 + 5;
  }
}
