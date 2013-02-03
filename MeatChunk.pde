class MeatChunk{
  int xPosition, yPosition;
  float gravity;
  float velocity;
  
  MeatChunk(int xPosition, int yPosition){
    this.xPosition = xPosition;
    this.yPosition = yPosition; 
  }
  
  void increment(){
    yPosition += velocity;
    velocity += gravity;
  }
}
