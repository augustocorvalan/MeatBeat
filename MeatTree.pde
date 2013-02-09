/**
TREES
**/
static final float BPM = 110;
int counter = 0; //keeps count of frame rate
int length;
//colors for tree
int treeRed = 155;
int treeGreen = 155;
int treeBlue = 155;  
String colorConstant = "red"; //keeps track of which color not to vary

class Tree{
  int x, y, height, opacity, stroke;
  float angle;
  Tree(int x, int y, int height){
    this.x = x;
    this.y = y;
    this.height = height;
    angle = 60;
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
  void setOpacity(int op){
    this.opacity = op;
  }
  int getOpacity(){
    return opacity;
  }
  void setStroke(int str){
    stroke = str;
  }
  int getStroke(){
    return stroke;
  }
}

Tree[] setupTrees(int treeTotal){
  int tallestTree = 100;
  int shortestTree = 55;
//  int xMin = -WIDTH + 30;
//  int xMax = 0;
  int x = 0;
  Tree[] trees = new Tree[treeTotal]; 
  for(int i = 0; i < treeTotal; i++){
    //randomly generate height and x between range 
    int height = floor(random(shortestTree, tallestTree));
    int y = height - height;
    trees[i] = new Tree(x, y, height);
    trees[i].setOpacity(random(75, 200));  //randomize tree opacity
    trees[i].setStroke(random(5, 10));  //randomize stroke
    //randomly assign some trees a different starting angle
    if(random(0, treeTotal/3) == 1) trees[i].setAngle(30);   
  }
  return trees;
}

void drawTrees(Tree[] trees, color[] c){
  pushMatrix();
  translate(0, height-50);
  counter++;
  float constant = 0.25; //constant to slow down bps artificially
  float bps = BPM/60; 
  length = trees.length;
  for(int i = 0; i < length; i++){
   Tree t = trees[i];
   float angle = t.getAngle();
   drawTree(t, i, angle, c);
   //Update the tree angle
   float buffer = (BPM/60) / frameRate / 8  * 2 * PI; //slow down bpm by this much
   angle += buffer;
   t.setAngle(angle);
  }
  popMatrix();
  //once we're done drawing, set stroke back to normal
  stroke(255);
}

//@param height of tree
void drawTree(Tree t, int i, float angle, color[] c){
  int x = t.getX();
  int y = t.getY();
  int height = t.getHeight();
  int opacity = t.getOpacity();
  int str = t.getStroke();
//  int stroke = t.getStroke();
  //TODO: NOT DRY, FIX LATER
//  float red, green, blue;
//  if(colorConstant.equals("red")){
//    red = treeRed;
//    green = treeGreen*sin(angle);
//    blue = treeBlue*sin(angle);
//  } else if(colorConstant.equals("green")){
//    red = treeRed*sin(angle);
//    green = treeGreen;
//    blue = treeBlue*sin(angle);
//  } else{
//    red = treeRed*sin(angle);
//    green = treeGreen*sin(angle);
//    blue = treeBlue;
//  }
//  float alpha = 200 - frameCount * 0.1;
  if(alpha <= 0) return;  //if tree opacity is invisible, don't draw
  stroke(c[2]);
  strokeWeight(str);
  int amplitude = 400;
  float a =  (amplitude*sin(angle)/ (float) width)  * 45f;
  // Convert it to radians
  int gap = width/(length+1);
  translate(gap, 0);
  float theta = radians(a);
  // Start the recursive branching!
  //0 - 45
  branch(height, theta);
  strokeWeight(1);
}  

void branch(float h, float theta) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 10) {
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

