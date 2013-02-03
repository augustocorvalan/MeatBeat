class FinishState extends BaseState{
  int CHUNK_NUMBER = 4;
  MeatChunk[] chunkArray;
  
  float sin_offset= PI/2;
  
  void setup(){
    chunkArray = new MeatChunk[4];
    int offset = 20;
    for(int i = 0; i < chunkArray.length; i++){
      chunkArray[i] = new MeatChunk(offset + (width - (2 * offset)) * i/CHUNK_NUMBER,  height/2);
      chunkArray[i].velocity = .25;
      chunkArray[i].gravity = .5;
    }
  }
 
  void draw(){
    background(0);
    for(int i = 0; i < chunkArray.length; i++){
      fill(0, 241, 177);
      ellipse(chunkArray[i].xPosition, chunkArray[i].yPosition, 25, 25);
      //chunkArray[i].velocity = sin(sin_offset);
      chunkArray[i].increment();
      if(chunkArray[i].yPosition >= 600){
         chunkArray[i].velocity = -10;
      }
   }
   sin_offset += PI/180;
  }
 
  void keyPressed(){
   
  }
 
  void cleanup(){
   
  } 
}
