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
  void drawLives(){
    pushMatrix();
    fill(255);
    image(meatLife, WIDTH/10, HEIGHT/120, 38, 38);  //meatball
    text("x", WIDTH/12, HEIGHT/15); //x text
    text(lives, WIDTH/25, HEIGHT/15);  //number of lives
    popMatrix();
  }
}
