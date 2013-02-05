class MeatChunk{
  int xPosition, yPosition;
  float gravity;
  float velocity;
  
  MeatChunk(int xPosition, int yPosition, float g, float vy){
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    gravity = g;
    velocity = vy; 
  }
  
  void increment(){
    yPosition += velocity;
    velocity += gravity;
  }
}
