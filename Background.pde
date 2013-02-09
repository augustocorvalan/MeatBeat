/*********
HILL
*********/
class Hill{
  float x, y, width, height, start, stop;
  Hill(float x, float y, float width, float height, float start, float stop){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.start = start;
    this.stop = stop;
  }
  void draw(){
    arc(x, y, width, height, start, stop);
  }
}

Hill setupHill(float xOffset, float heightOffset, float widthOffset){
  float x = 2*WIDTH/10 + xOffset;
  float y = HEIGHT/10 + HEIGHT * 0.9;
  float width = WIDTH/2 + widthOffset;
  float height =  HEIGHT * 1 + heightOffset;
  float start = -PI;
  float stop = 0;
  Hill h = new Hill(x, y, width, height, start, stop);
  return h;
}


void setupHills(Hill[] hills){
  int number = hills.length;
  float xOffset = 0;
  float heightOffset = 0;
  float widthOffset = 0;
  for(int i = 0; i < number; i++){
    hills[i] = setupHill(xOffset, heightOffset, widthOffset);
    xOffset += WIDTH/number;
    heightOffset += 100;
    widthOffset += 25;
    if(int(random(2)) == 1) heightOffset *= -1;  //randomly make half shorter
    if(int(random(2)) == 1) widthOffset *= -1;  //randomly make half skinnier
  }
}

void drawHills(Hill[] hills){
  pushMatrix();
  //Style stuff
  fill(color(102, 153, 102, 200 - frameCount *0.01));  //temp color for now
  strokeWeight(4);
  stroke(200 - frameCount * 0.01);
  for(int i = 0; i < hills.length; i++){
    hills[i].draw();
  }
  popMatrix();
}

/*********
CLOUDS
*********/
class Cloud{
  int x, y, scale;
  Cloud(int x, int y, int scale){
    this.x = x;
    this.y = y;
    this.scale = scale;
  }
}

void setupClouds(Cloud[] clouds){
  for(int i = 0; i < clouds.length; i++){
    float yOffset = random(0.8, 1);
    float y = HEIGHT - HEIGHT * yOffset;
  }
}

void drawClouds(Cloud[] clouds){
  for(int i = 0; i < clouds.length; i++){
    
//    shape(cloudImage, 250, );
  }
}
