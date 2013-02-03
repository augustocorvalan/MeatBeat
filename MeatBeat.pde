static final int FIRST_STATE = 0;
static final int GAMEPLAY_STATE = 1;
static final int FINISH_STATE = 2;
static final int STATE_COUNT = 3;

static final int INITIAL_LIVES = 3;

BaseState[] states;
int currentState;

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

class BaseState{
  void setup(){}
 
  void draw(){}
  
  void cleanup(){}
  
  void keyPressed(){}
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

class GameplayState extends BaseState{
//  int totalTrees = 1;
//  Tree[] trees = new Tree[totalTrees];
  
  void setup(){
    background(0);
//    trees = setupTrees(totalTrees);
  }
 
  void draw(){
      background(0);
      //BACKGROUND DRAWING
      drawHill();
//    drawTrees(trees);
  }
 
  void keyPressed(){
   
  }
 
  void cleanup(){
   
  } 
}

class FinishState extends BaseState{
  void setup(){
   
  }
 
  void draw(){
   
  }
 
  void keyPressed(){
   
  }
 
  void cleanup(){
   
  } 
}

/**
DYNAMIC BACKGROUND STUFF
**/

/**
HILLS
**/
void drawHill(){
  color green = color(50, 255, 0);
  fill(green); 
  beginShape();
  vertex(0, 70); // first point
  //the x co-ordinate of the curve start control point (P1)
  //the y co-ordinate of the curve start control point (P1)
  //the x co-ordinate of the curve end control point (P2)
  //the y co-ordinate of the curve end control point (P2)
  //the x co-ordinate of the end point (P3)
  //the y co-ordinate of the end point (P3)
  bezierVertex(25, 25, 100, 50, 50, 100);
  bezierVertex(20, 130, 75, 140, 120, 120);
  endShape();
}


/**
TREES
**/
class Tree{
  int x, y, height;
  Tree(int x, int y, int height){
    this.x = x;
    this.y = y;
    this.height = height;
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
}

Tree[] setupTrees(int treeTotal){
  int tallestTree = 175;
  int shortestTree = 75;
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
    Tree t = new Tree(x, y, height);
//    console.log("tree x:" + t.getX());
    trees[i] = t;
  }
  return trees;
}

void drawTrees(Tree[] trees){
  for(int i = 0; i < trees.length; i++){
     Tree t = trees[i];
     drawTree(t.getX(), t.getY(), t.getHeight());
  }
}

//@param height of tree
void drawTree(int x, int y, int height){
    stroke(255);
    // Let's pick an angle 0 to 90 degrees based on the mouse position
    float a = (mouseX / (float) width) * 90f;
    // Convert it to radians
    float theta = radians(a);
    // Start the tree from the bottom of the screen
    // Start the recursive branching!
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
  
class Player{
  int lives;
 
   Player(){
     lives = INITIAL_LIVES;
   } 
}

class MeatChunk{
  int xPosition, yPosition;
  
}
