PImage meatFont; //used to display the score

ArrayList digits = new ArrayList();

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
  for(int i = 0; i < digits.size(); i++){
    int digit = digits.get(i);
    PImage digitImg = numbersImg[digit];
    image(digitImg, WIDTH/2, HEIGHT/2);
  }  
}
