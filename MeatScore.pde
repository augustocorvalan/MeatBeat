PImage meatFont; //used to display the score

ArrayList digits = new ArrayList();

int GRILLDIMENSIONS = 500;
int MEATX = 124 * 0.75;
int MEATY = 180 * 0.75;

void setupScore(){
  int score = player.getScore();
  if(score == 0){
    digits.add(0);
  } else{
    while(score > 0) {
      digit = floor(score % 10);
      digits.add(digit);
      score = floor(score / 10);
    }
  } 
}

void drawScore(){
  //draw background grill
  image(grillImg, WIDTH/5, HEIGHT/5, GRILLDIMENSIONS, GRILLDIMENSIONS);
  for(int i = 0; i < digits.size(); i++){
    int digit = digits.get(i);
    PImage digitImg = numbersImg[digit];
    int offset = 1.58;
    image(digitImg, WIDTH/offset - (i * MEATX), HEIGHT/2, MEATX, MEATY);
  }  
}
