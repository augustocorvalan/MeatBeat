class Player{
   int lives;
   int score;
   
   Player(int lives, int score){
     this.lives = lives;
     this.score = score;
   }
   
   void decreaseLives(){
     lives--;
     if(lives<=0) setState(FINISH_STATE);; // should have endGame();
   }
   
   int getLives(){
     return lives;
   }
   
   int getScore() {
     return score;
   }
   
   int changeScore(int change) {
     score = score + change;
   }
   
   void drawScore(){
     pushMatrix();
     fill(255);
     text(score, WIDTH-50, HEIGHT/15);  //number of lives
     popMatrix();
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
