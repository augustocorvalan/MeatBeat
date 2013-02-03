class Player{
   ArrayList<Life> lives;
   Player(int number, PImage lifeImage){
     this.lives = new ArrayList();
     for(int i = 0; i < number; i++){
       this.lives.add(new Life(lifeImage));
     }
   }
   void decreaseLives(){
       lives.get(lives.size() - 1).setAlive(false);  //mark the last life for destruction
   }
   ArrayList getLives(){
     return lives;
   }
  void setupLives(){
    int x = 0;
    int y = 0;
    for(int i = 0; i < lives.size(); i++){
      Life life = lives.get(i);
      life.setX(x);
      life.setY(y);
      x += life.getTrueWidth() + 5;
      //start a new row
      if(i == 4){
        x = 0;
        y += life.getTrueHeight() + 5;
      }
    }
  }
  void drawLives(){
    for(int i = 0; i < lives.size(); i++){
      pushMatrix();
      Life life = lives.get(i);
      int x = life.getX();
      int y = life.getY();
      int op = life.getOpacity();
      PImage img = life.getImage();
      int width = life.getTrueWidth();
      int height = life.getTrueHeight();
      if(life.isAlive() == false){
        if(op <= 155){  //if it's barely visible, remove it
          lives.remove(i);
        } else{
          op -= 10;
          life.setOpacity(op);
          tint(255, op);
        }
      }
      image(img, x, y, width, height);
      popMatrix();
    }
    tint(255, 255);  //bring back transparency
  }
}

class Life{
  int x, y, opacity;
  PImage lifeImg;
  int lifeWidth = 606;  //original image width
  int lifeHeight = 612;  //original image height
  boolean alive;  //is life marked for destruction?
  Life(PImage img){
    this.x = 0;
    this.y = 0;
    this.opacity = 255;
    this.lifeImg = img;
    alive = true;
  }
  void setX(int x){
    this.x = x;
  }
  void setY(int y){
    this.y = y;
  }
  void setOpacity(int op){
    this.opacity = op;
  }
  int getX(){
    return x;
  }
  int getY(){
    return y;
  }
  int getOpacity(){
    return opacity;
  }
  PImage getImage(){
    return lifeImg;
  }
  int getTrueWidth(){  //cut these meatballs down a size
    return lifeWidth/12;
  }
  int getTrueHeight(){
    return lifeHeight/12;
  }
  boolean isAlive(){
    return alive;
  }
  void setAlive(boolean b){
    alive = b;
  }
}

//void drawLives(PImage lifeImg){
//  int x = 0;
//  int y = 0;
//  int lifeWidth = 606;  //original image width
//  int lifeHeight = 612;  //original image height
//  int lives = player.getLives();
//  for(int i = 0; i < lives; i++){
//    image(lifeImg, x, y, lifeWidth/12, lifeHeight/12);
//    x += lifeWidth/12 + 5;
//    //start a new row
//    if(i == 4){
//      x = 0;
//      y += lifeHeight/12 + 5;
//    }
//  }
//}
