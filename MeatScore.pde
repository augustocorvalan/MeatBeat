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
  image(grillImg, width/2 - GRILLDIMENSIONS/2, height/5, GRILLDIMENSIONS, GRILLDIMENSIONS);
  //draw replay image
  image(replayImg, width/13, height/4, 150, 150);
  for(int i = 0; i < digits.size(); i++){
    int digit = digits.get(i);
    PImage digitImg = numbersImg[digit];
    image(digitImg, width/2 - MEATX/2*i - i*50, 2 * height/5 + MEATY/2, MEATX, MEATY);
  }  
}
