static final int FIRST_STATE = 0;
static final int GAMEPLAY_STATE = 1;
static final int FINISH_STATE = 2;
static final int STATE_COUNT = 3;

static final int INITIAL_LIVES = 3;

BaseState[] states;
int currentState;

//static final int BPM = 1/secondsPerBeat*60; //BRING THIS BACK WHEN SERVER IS ON
static final int BPM = 110;

static final int HEIGHT = 600;
static final int WIDTH = 800;

void setup(){
  size(800, 600);
  background(255);
  currentState = FIRST_STATE;
  states = new BaseState[STATE_COUNT];
  for(int i = 0; i < states.length; i++){
    states[i] = createState(i); 
  }
  setState(FIRST_STATE);
  
  
  PFont font = loadFont("CalcitePro-Regular-48.vlw"); 
  textFont(font, 72);
  textAlign(CENTER);
  
}

void draw(){
  states[currentState].draw();
}

void setState(int state){
  states[currentState].cleanup();
  currentState = state;
  states[currentState].setup();
}

void keyPressed(){
  states[currentState].keyPressed(); 
}

BaseState createState(int state){
  switch(state){
    case FIRST_STATE:
      return new TitleState();
    case GAMEPLAY_STATE:
      return new GameplayState();
    case FINISH_STATE:
      return new FinishState();
    default:
      return null;
  } 
}
//WAVE SETTING VARIABLES
float density = .75;
float friction = 1.14;
float mouse_pull = 0.09; // The strength at which the mouse pulls particles within the AOE
int aoe = 200; // Area of effect for mouse pull
int detail = round( WIDTH / 60 ); // The number of particles used to build up the wave
float water_density = 1.07;
float air_density = 1.02;
int twitch_interval = 2000; // The interval between random impulses being inserted into the wave to keep it moving


/**
 HILLS
 **/
class Particle {
  int x, y, origX, origY, forceX, forceY, mass;
  float vX, vY;
  Particle(int x, int y, int origX, int origY, float vX, float vY, int forceX, int forceY, int mass){
    this.x = x;
    this.y = y;
    this.origX = origX;
    this.origY = origY;
    this.vX = vX;
    this.vY = vY;
    this.forceX = forceX;
    this.forceY = forceY;
    this.mass = mass;
  }
}

Particle[] setupHill(){ 
  /** Wave settings */
  float density = .75;
  float friction = 1.14;
  float mouse_pull = 0.09; // The strength at which the mouse pulls particles within the AOE
  int aoe = 200; // Area of effect for mouse pull
  int detail = round( WIDTH / 60 ); // The number of particles used to build up the wave
  float water_density = 1.07;
  float air_density = 1.02;
  int twitch_interval = 2000; // The interval between random impulses being inserted into the wave to keep it moving
    
  Particle[] particles = new Particle[detail+1];      
  // Generate our wave particles
  for(int i = 0; i < particles.length; i++) {
    int x = round(WIDTH / (detail-4) * (i-2));
    int y = round(HEIGHT*0.5);
    int originalX = 0;
    int originalY = round(HEIGHT * 0.5);
    float velocityX = 0;
    float velocityY = floor(random(0, 3));
    int forceX = 0;
    int forceY = 0;
    int mass = 10;
    particles[i] = new Particle(x, y, originalX, originalY, velocityX, velocityY, forceX, forceY, mass);
  }
  return particles; 
}

void drawHill(Particle[] particles) {
  
//    int x = round(WIDTH*0.5);
  int x = 0;
  int y = round(HEIGHT*0.2);
  float w = WIDTH;
  float h = HEIGHT - HEIGHT*0.2;
  color blue = color(0, 170, 187, 0);
  color green = color(0, 200, 250, 0);  
  int y_axis = 1;
  setGradient(x, y, w, h, blue, green, y_axis);
  
  int len = particles.length;          
//  var current, previous, next;
//      
//  for(int i = 0; i < len; i++ ) {
//    current = particles[i];
//    previous = particles[i-1];
//    next = particles[i+1];
//    
//    if (previous && next) {
//      
//      var forceY = 0;
//      
//      forceY += -DENSITY * ( previous.y - current.y );
//      forceY += DENSITY * ( current.y - next.y );
//      forceY += DENSITY/15 * ( current.y - current.original.y );
//      
//      current.velocity.y += - ( forceY / current.mass ) + current.force.y;
//      current.velocity.y /= FRICTION;
//      current.force.y /= FRICTION;
//      current.y += current.velocity.y;
//      
//      var distance = DistanceBetween( mp, current );
//      
//      if( distance < AOE ) {
//        var distance = DistanceBetween( mp, {x:current.original.x, y:current.original.y} );
//        
//        ms.x = ms.x * .98;
//        ms.y = ms.y * .98;
//        
//        current.force.y += (MOUSE_PULL * ( 1 - (distance / AOE) )) * ms.y;
//      }
//      
//      // cx, cy, ax, ay
//      context.quadraticCurveTo(previous.x, previous.y, previous.x + (current.x - previous.x) / 2, previous.y + (current.y - previous.y) / 2);
//    } 
//  }
  
}


void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ){
  // calculate differences between color components 
  float deltaR = red(c2)-red(c1);
  float deltaG = green(c2)-green(c1);
  float deltaB = blue(c2)-blue(c1);
  
  int Y_AXIS = 1;
  int X_AXIS = 2;
  // choose axis
  if(axis == Y_AXIS){
    /*nested for loops set pixels
     in a basic table structure */
    // column
    for (int i=x; i<=(x+w); i++){
      // row
      for (int j = y; j<=(y+h); j++){
        color c = color(
          (red(c1)+(j-y)*(deltaR/h)),
          (green(c1)+(j-y)*(deltaG/h)),
          (blue(c1)+(j-y)*(deltaB/h)) 
        );
        set(i, j, c);
      }
    }  
  }  
  else if(axis == X_AXIS){
    // column 
    for (int i=y; i<=(y+h); i++){
      // row
      for (int j = x; j<=(x+w); j++){
        color c = color(
          (red(c1)+(j-x)*(deltaR/h)),
          (green(c1)+(j-x)*(deltaG/h)),
          (blue(c1)+(j-x)*(deltaB/h)) 
        );
        set(j, i, c);
      }
    }  
  }
}

//void quadraticBezierVertex(cpx, cpy, x, y) {
//  var cp1x = prevX + 2.0/3.0*(cpx - prevX);
//  var cp1y = prevY + 2.0/3.0*(cpy - prevY);
//  var cp2x = cp1x + (x - prevX)/3.0;
//  var cp2y = cp1y + (y - prevY)/3.0;
// 
//  // finally call cubic Bezier curve function
//  bezierVertex(cp1x, cp1y, cp2x, cp2y, x, y);
//};
class BaseState{
  void setup(){}
 
  void draw(){}
  
  void cleanup(){}
  
  void keyPressed(){}
}
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
class GameplayState extends BaseState{
//  int totalTrees = 1;
//  Tree[] trees = new Tree[totalTrees];
  Particle[] particles = new Particle[detail+1];
  int tracks = 0;
  
  void setup(){
    background(0);
//    particles = setupHill();
//    trees = setupTrees(totalTrees);
    playSound();
    playSound();
    playSound();
  }
 
  void draw(){
      background(0);
      //BACKGROUND DRAWING
//      drawHill(particles);
//    drawTrees(trees);
  }
 
  void keyPressed(){
   
  }
  
  void calcTracks() {
    for(int i=0; i<beats.length; i++) {
      if (beats[i].length > 0) {
        tracks++;
      }
    }
  }
 
  void cleanup(){
   
  } 
}
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
/**
TREES
**/
static final float BPM = 120;
int counter = 0; //keeps count of frame rate

class Tree{
  int x, y, height;
  float angle;
  Tree(int x, int y, int height){
    this.x = x;
    this.y = y;
    this.height = height;
    //randomly assign some trees a non-zero angle
//    if(random(0, 6) == 
    angle = 0;
  }
  int getX(){
    return x;
  }
  int getY(){
    return y;
  }
  int getHeight(){
    return height;
  }
  void setAngle(float angle){
    this.angle = angle;
  }
  float getAngle(){
    return angle;
  }
}

Tree[] setupTrees(int treeTotal){
  int tallestTree = 175;
  int shortestTree = 55;
  int xMin = -WIDTH + 30;
  int xMax = 0;
  Tree[] trees = new Tree[treeTotal]; 
  for(int i = 0; i < treeTotal; i++){
    //randomly generate height and x between range 
    int height = floor(random(shortestTree, tallestTree));
    int x = floor(random(xMin, xMax));
//    console.log("random x:" + x);
    int y = HEIGHT - height;
    //increase the x range
    xMin += 100;
    xMax += 100;
    trees[i] = new Tree(x, y, height);
//    console.log("tree x:" + t.getX());
  }
  return trees;
}

void drawTrees(Tree[] trees){
  pushMatrix();
  translate(0, 550);
  counter++;
  float constant = 0.25; //constant to slow down bps artificially
  float bps = BPM/60; 
  for(int i = 0; i < trees.length; i++){
   Tree t = trees[i];
   float angle = t.getAngle();
   drawTree(t.getX(), t.getY(), t.getHeight(), i, angle);
   //Update the tree angle
   float buffer = (BPM/60) / frameRate / 4  * 2 * PI; //slow down bpm by this much
   angle += buffer;
   t.setAngle(angle);
  }
  popMatrix();
  //reset counter
  if(counter >= frameCount/(BPM/60)) counter = 0;
}

//@param height of tree
void drawTree(int x, int y, int height, int i, float angle){
  stroke(255,255,255);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  int amplitude = 400;
  float a =  (amplitude*sin(angle)/ (float) width)  * 45f;
  // Convert it to radians
  translate(100 + 100 * i, 0);
  float theta = radians(a);
  // Start the tree from the bottom of the screen
  // Start the recursive branching!
  //0 - 45
  branch(height, theta);
}  

void branch(float h, float theta) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
 
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h, theta);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h, theta);
    popMatrix();
  }
}

class Player{
  int lives;
 
   Player(){
     lives = INITIAL_LIVES;
   } 
}

class TitleState extends BaseState{
  void setup(){
    background(255, 0, 0);
    text("MeatBeat: The Test Title Screen", width/2, height/2);
    
  }
 
  void draw(){
  }
  
  void keyPressed(){
    //TEST REMOVE
    setState(GAMEPLAY_STATE);
  }
  
  void cleanup(){
    
  }
}

