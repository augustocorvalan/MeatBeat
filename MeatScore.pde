PImage meatFont; //used to display the score

//Stack s;

void displayScore(){
  int score = player.getScore();
  if(score == 0){
  
  } else{
    while(score > 0) {
     digit = score%10;
     println("score is " + digit);
//     s.push(digit);
     score -= digit;
    }
  } 
}
