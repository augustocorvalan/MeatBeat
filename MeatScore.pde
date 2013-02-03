PImage meatFont; //used to display the score 

PImage[] cutUpNumbers(PImage font){
  int totalNumbers = 10;
  PImage[] numbers = new PImage[totalNumbers];
  int xOffset = 120;
  int yOffset = 180;
  int x = 0;
  for(int i = 0; i < totalNumbers; i++){
    numbers[i] = font.get(x, 180, xOffset, yOffset);
    x += xOffset;  
  }
  return numbers;
}

