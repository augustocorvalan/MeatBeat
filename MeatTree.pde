/**
TREES
**/
static final float BPM = 120;
int counter = 0; //keeps count of frame rate
int length;

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
  int tallestTree = 100;
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
  translate(0, HEIGHT-50);
  counter++;
  float constant = 0.25; //constant to slow down bps artificially
  float bps = BPM/60; 
  length = trees.length;
  for(int i = 0; i < length; i++){
   Tree t = trees[i];
   float angle = t.getAngle();
   drawTree(t.getX(), t.getY(), t.getHeight(), i, angle);
   //Update the tree angle
   float buffer = (BPM/60) / frameRate / 8  * 2 * PI; //slow down bpm by this much
   angle += buffer;
   t.setAngle(angle);
  }
  popMatrix();
  //reset counter
  if(counter >= frameCount/(BPM/60)) counter = 0;
}

//@param height of tree
void drawTree(int x, int y, int height, int i, float angle){
  stroke(255, 255*sin(angle), 255*sin(angle));
  strokeWeight(3 + cos(angle));
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  int amplitude = 400;
  float a =  (amplitude*sin(angle)/ (float) width)  * 45f;
  // Convert it to radians
  int gap = WIDTH/(length+1);
  translate(gap, 0);
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

