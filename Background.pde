/*********
HILL
*********/
class Hill{
  float x, y, w, h, start, stop;
  Hill(float x, float y, float w, float h, float start, float stop){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.start = start;
    this.stop = stop;
  }
  void draw(){
    arc(x, y, w, h, start, stop);
  }
}

Hill setupHill(float xOffset, float heightOffset, float widthOffset){
  float x = 2*width/10 + xOffset;
  float y = height/10 + height * 0.9;
  float hillWidth = width/2 + widthOffset;
  float hillHeight =  height * 1 + heightOffset;
  float start = -PI;
  float stop = 0;
  Hill h = new Hill(x, y, hillWidth, hillHeight, start, stop);
  return h;
}


void setupHills(Hill[] hills){
  int number = hills.length;
  float xOffset = 0;
  float heightOffset = 0;
  float widthOffset = 0;
  for(int i = 0; i < number; i++){
    hills[i] = setupHill(xOffset, heightOffset, widthOffset);
    xOffset += width/number;
    heightOffset += 100;
    widthOffset += 25;
    if(int(random(2)) == 1) heightOffset *= -1;  //randomly make half shorter
    if(int(random(2)) == 1) widthOffset *= -1;  //randomly make half skinnier
  }
}

void drawHills(Hill[] hills, color[] c){
  pushMatrix();
  //Style stuff
  fill(c[0]);  //temp color for now
  strokeWeight(4);
  stroke(c[2]);
  for(int i = 0; i < hills.length; i++){
    hills[i].draw();
  }
  popMatrix();
}

/*********
CLOUDS
*********/
class Cloud{
  int x, y, scale, rate, baseWidth, baseHeight;
  Cloud(int x, int y, int scale){
    this.x = x;
    this.y = y;
    this.scale = scale;
    baseWidth = baseHeight = 100;
  }
  int setX(int x){
    this.x = x;
  }
  void getX(){
    return x;
  }
  int setY(int y){
    this.y = y;
  }
  void getY(){
    return y;
  }
  int getRate(){
    return rate;
  }
  void setRate(int rate){
    this.rate = rate;
  }
  int getWidth(){
    return baseWidth * scale;
  }
  int getHeight(){
    return baseHeight * scale;
  }
}

void setupClouds(Cloud[] clouds){
  for(int i = 0; i < clouds.length; i++){
    clouds[i] = setupCloud();
  }
}

Cloud setupCloud(){
  int x = -200 - floor(random(50,100));
  float yOffset = random(0.6, 1);
  int y = height - height * yOffset;
  float rateOffset = random(300, 800);
  int baseRate = BPM;
  int rt = baseRate/rateOffset;
  Cloud cloud = new Cloud(x, y, 1);
  cloud.setRate(rt);
  return cloud;
}

void drawClouds(Cloud[] clouds, color[] c){
  colorMode(HSB, 360);
  fill(c[2]);
  stroke(c[2]);
  for(int i = 0; i < clouds.length; i++){
    Cloud cloud = clouds[i];
    cloudHeight = cloud.getHeight();
    shape(cloudImage, cloud.getX(), cloud.getY(), cloud.getWidth(), cloud.getHeight());
    cloud.setX(cloud.getRate() + cloud.getX());
    if(cloud.getX() > width + cloud.getWidth()){  //if a cloud nears the edge of the screen, add another
      clouds[i] = setupCloud();
    }
  }
  colorMode(RGB);
}
/*********
LINES
*********/
/**************
Ascending Lines
**************/
int number = 20;
float[] as;
float[] rate;

void setupLine(){
   as = new float[number];
   rate = new float[number];
   for(int i = 0; i < number; i++){
     as[i] = height/2 * random(1, 10);
     rate[i] = random(1,2);
   } 
}

void drawLine(){
 pushMatrix();
 strokeWeight(4);
  for(int i = 0; i < number; i++){
    line(0, as[i], width, as[i]);
      as[i] = as[i] - rate[i] * BPM/150;
    if(as[i] < 0)
      as[i] = height/2 * random(1,10);
  }
   popMatrix();
}
