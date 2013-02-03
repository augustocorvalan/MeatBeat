class FinishState extends BaseState{
  int CHUNK_NUMBER = 4;
  MeatChunk[] chunkArray;
  Panel[] panelArray;
  float threshold = 5;
  
  float sin_offset= PI/2;
  
  void setup(){
    chunkArray = new MeatChunk[CHUNK_NUMBER];
    panelArray = new Panel[CHUNK_NUMBER];
    int offset = 60;
    for(int i = 0; i < chunkArray.length; i++){
      chunkArray[i] = new MeatChunk(offset + (width - offset * 2)/ (CHUNK_NUMBER - 1) * i,  height/2);
      chunkArray[i].velocity = .25;
      chunkArray[i].gravity = .5;
      panelArray[i] = new Panel(offset + (width - offset * 2)/ (CHUNK_NUMBER - 1) * i, height - 50);
    }
  }
 
  void draw(){
    background(0);
    stroke(255);
    line(0,height-50,width,height-50);
    for(int i = 0; i < chunkArray.length; i++){
      fill(0, 241, 177);
      ellipse(chunkArray[i].xPosition, chunkArray[i].yPosition, 25, 25);
      //chunkArray[i].velocity = sin(sin_offset);
      chunkArray[i].increment();
      if(chunkArray[i].yPosition >= 600){
         chunkArray[i].velocity = -10;
      }
      panelArray[i].draw();
   }
   rect(0,0,25,25);
   sin_offset += PI/180;
  }
 
  void keyPressed(){
    switch(key){
      case 'j':
        if(CHUNK_NUMBER >= 1){
          if(panelArray[0].canRedraw){
            panelArray[0].canRedraw = false;
            if((chunkArray[0].yPosition >= (panelArray[0].origY + threshold) && !panelArray[0].canRedraw)){
               chunkArray[0].velocity = -15;
            }
          }
        }
        break;
     case 'k':
      if(CHUNK_NUMBER >= 2){
        if(panelArray[1].canRedraw){
          panelArray[1].canRedraw = false;
          if((chunkArray[1].yPosition >= (panelArray[1].origY + threshold) && !panelArray[1].canRedraw)){
            chunkArray[1].velocity = -15;
          }
        }
      }
      break;
     case 'l':
      if(CHUNK_NUMBER >= 3){
        if(panelArray[2].canRedraw){
          panelArray[2].canRedraw = false;
          if((chunkArray[2].yPosition >= (panelArray[1].origY + threshold) && !panelArray[2].canRedraw)){
             chunkArray[2].velocity = -15;
          }
        }
      }
      break;
     case ';':
      if(CHUNK_NUMBER >= 4){
        if(panelArray[3].canRedraw){
          panelArray[3].canRedraw = false;
          if((chunkArray[3].yPosition >= (panelArray[3].origY + threshold) && !panelArray[3].canRedraw)){
             chunkArray[3].velocity = -15;
          }
        }
      }
      break; 
    }
  }
 
  void cleanup(){
   
  } 
}
