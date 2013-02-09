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
     text(score, width-50, height/15);  //number of lives
     popMatrix();
   }
   
   void drawLives(){
     pushMatrix();
     fill(255);
     image(meatLife, width/10, height/120, 38, 38);  //meatball
     text("x", width/12, height/15); //x text
     text(lives, width/25, height/15);  //number of lives
     popMatrix();
   }
}
