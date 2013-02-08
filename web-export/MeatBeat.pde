/* @pjs
smooth=true;
font=chubhand.ttf;
*/

static final int FIRST_STATE = 0;
static final int GAMEPLAY_STATE = 1;
static final int FINISH_STATE = 2;
static final int STATE_COUNT = 3;

static final int INITIAL_LIVES = 10;

static final int MAX_FRAME_RATE = 120;
int fps = 0;  //how many frames drawn this second  

BaseState[] states;
int currentState;

static final int HEIGHT = 600;  //screen height
static final int WIDTH = 800;  //screen width

static final int GROUND = HEIGHT - 50;

PImage meatLife;  //image instance for meat life
PShape cloudImage;  //image for the cloud

Player player;  //player instance

void setup(){
  frameRate(MAX_FRAME_RATE);
  getBeats(levelNames[0]);
  size(800, 600);
  background(255);
  currentState = FIRST_STATE;
  states = new BaseState[STATE_COUNT];
  for(int i = 0; i < states.length; i++){
    states[i] = createState(i); 
  }
  setState(FIRST_STATE);
  
  cloudImage = loadShape("cloud.svg");
  meatLife = loadImage("sprite sheets/meatball.png");
  meatFont = loadImage("sprite sheets/number font_v2.png");  //load meat font
  PFont font = createFont("chubhand.ttf", 48); 
  textFont(font, 48);
  textAlign(CENTER);
  ellipseMode(CENTER);
  rectMode(CENTER);
  states[currentState].setup();
}

void draw(){
  //fps = (fps + 1)%MAX_FRAME_RATE;  //update fps
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
  float height =  HEIGHT * 1.5 + heightOffset;
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
  fill(color(102, 153, 102));  //temp color for now
  strokeWeight(4);
  stroke(255);
  for(int i = 0; i < hills.length; i++){
    hills[i].draw();
  }
  popMatrix();
}
class BaseState{
  void setup(){}
 
  void draw(){}
  
  void cleanup(){}
  
  void keyPressed(){}
}
color[] colors = {
  //add colors here
};
class FinishState extends BaseState{
  int CHUNK_NUMBER = 4;
  MeatChunk[] chunkArray;
  Panel[] panelArray;
  float threshold = 5;
  
  float sin_offset= PI/2;
  
  void setup(){
  playSound("sounds/soundeffects/meatbeatscorescreen.ogg");
  
  }
 
  void draw(){
    background(0);
    text("Hey meatbeater! Thanks for playing!", WIDTH/2, HEIGHT/2);
    text("Total score: " + player.getScore(), WIDTH/2, HEIGHT/2 + 60);
  }
 
  void keyPressed(){
    
  }
 
  void cleanup(){
   
  } 
}
class GameplayState extends BaseState{
  /** 
    BACKGROUND VARIABLES
  **/
  int totalHills = 3;
  Hill[] hills = new Hill[totalHills];
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  int[] soundTimes;
  
  Level currentLevel;
  int currentTrackNum;
  Panel[] panelArray;
  MeatChunk[] chunkArray;
  int offset = 60;
  float thresholdMS = 650;
  int timingErrorControl = 10;
  int[] shouldCheckBeat;
  
  void setup(){
    background(0);
    
    /**
      BACKGROUND SETUP
    **/
    setupHills(hills);  //hill setup
    trees = setupTrees(totalTrees);  //tree setup

    /** LIVES **/
    player = new Player(INITIAL_LIVES,0);  //new player instance
    
//    player = new Player(INITIAL_LIVES, meatLife);  //player instance
//    player.setupLives();
    currentLevel = new Level(beatsarray,soundNames[0]);
    getBeats(levelNames[1]);
    currentTrackNum = currentLevel.getNumTracks();
    panelArray = new Panel[currentTrackNum];
    chunkArray = new MeatChunk[currentTrackNum];
    soundTimes = new int[currentTrackNum];
    shouldCheckBeat = new int[currentTrackNum];
    for(int i = 0; i < currentTrackNum; i++){
      int xpos = offset + (width - offset * 2) / (currentTrackNum - 1) * i;
      chunkArray[i] = new MeatChunk(xpos, GROUND, 0, 0, currentLevel.getTrack(i));
      panelArray[i] = new Panel(xpos, GROUND+(PANEL_HEIGHT/2));
      soundTimes[i] = millis();
      shouldCheckBeat[i] = 0;
    }
  }
 
  void draw(){
      background(0);
          
      /** 
        BACKGROUND DRAW
      **/
      //drawHills(hills);
//      drawTrees(trees);

      /** LIVES **/
      player.drawLives();
      player.drawScore();
      
      stroke(255);
      line(0,GROUND,width,GROUND);  // line possibly temp for location of GROUND.
      
      for(int i = 0; i < currentTrackNum; i++){
        shouldCheckBeat[i] = chunkArray[i].move();
        panelArray[i].draw();
      }
      if (shouldCheckBeat[0]==1) {
          checkBeatSuccess(0);
          playSound(currentLevel.getTrack(0).getSound());
          //soundTimes[0] = millis();
      }
  }
 
  void keyPressed(){
    //setState(FINISH_STATE);
    //player.decreaseLives();
    
    for (int i = 0; i < currentLevel.getNumTracks(); i++) {
      if (key==currentLevel.getTrack(i).getKey()) {
        if (panelArray[i].offScreen) {
          panelArray[i].drawIt();
          //checkBeatSuccess(i);
        }
      }
    }
    
    if(key=='q') println(frameRate);
    if(key=='w') playSound(failsound);
  }
    
  void cleanup(){
   
  }
  
  boolean checkBeatSuccess(int track) {
    int diff = abs(panelArray[track].getLastDraw() - chunkArray[track].shouldBounceAgain);
    //println(diff);
    if (diff <= thresholdMS) {
    //if ((abs((chunkArray[track].yPosition+MEAT_HEIGHT/2) - (panelArray[track].origY-PANEL_HEIGHT/2)) <= threshold)) {
      beatSuccess(track);
    }
    else {
      beatFailure(track);
    }
  }
  
  void beatSuccess(int track) {
    //playSound(currentLevel.getTrack(track).getSound());
    //chunkArray[track].track.canSound=true;
    currentLevel.getTrack(track).canSound=true;
    player.changeScore(1);
    //chunkArray[track].canBounce=true;
    
  }
  
  void beatFailure(int track) {
    //playSound(failsound);
    //chunkArray[track].track.canSound=false;
    currentLevel.getTrack(track).canSound=false;
    player.decreaseLives();
    chunkArray[track].fail();
  }
  
}
String[] levelNames = {"sounds/testmidi/samplemeatbeatbeat.mid",
                       "sounds/testmidi/TwoTrackBasicBeat.mid"};
                       
String[][] soundNames = { {"music/meatbeatkick.ogg","music/meatbeatkick.ogg","music/meatbeatkick.ogg"},
                          {"music/meatbeatkick.ogg","music/meatbeatkick.ogg"}};

String failsound = "sounds/soundeffects/meatbeatfailnoise.ogg";
                          
float[][] level1 = { {0,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727,0.272727,0.545454,0.545454,0.545454,0.272727},
                     {9.272718,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908,1.090908},
                     {17.727255,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454,0.545454},
                     {},{},{},{},{}
                   };

float[][][] levelBeats = {level1, level1, level1};
                       
/*Level buildLevel(int levelNum) {
  getBeats(levelNames[levelNum]);
  float[][] lvlBeats = getBeats(levelNames[levelNum]);
  lvlBeats = beats;
  Level newLevel = new Level(lvlBeats,soundNames[levelNum]);
  return newLevel;
}*/

int calcNumTracks(float[][] beatarray) {
    int tracks = 0;
    for(int i=0; i<beatarray.length; i++) {
      if (beatarray[i].length > 0) {
        tracks++;
      }
    }
    return tracks;
}

class Level {
  
  int numTracks;
  Track[] tracks;
  
  Level(float[][] beats,  String[] sounds) {
    numTracks = calcNumTracks(beats);
    tracks = new Track[numTracks+1];
    for(int i=0; i < numTracks; i++) {
      tracks[i] = new Track(beats[i],sounds[i],keyVals[i]);
    }
  }
  
  Track getTrack(int trackNum) {
    return tracks[trackNum];
  }
  
  int getNumTracks() {
    return numTracks;
  }
  
  Track[] getTracks() {
    return tracks;
  }
  
}
static final int MEAT_WIDTH = 25;
static final int MEAT_HEIGHT = 25;
static final int DEFAULT_BOUNCE_HEIGHT = 0;   

class MeatChunk{
  int xPosition, yPosition;
  float gravity;
  float velocity;
  Track track;
  int lastBounce;
  int bounceWait;
  int currentBeat;
  float unitHeight = height / 3;
  int shouldBounceAgain;
  boolean canBounce;
  int beatAtFail;
  int opacity;
  int timeReturnFromFail;
  
  MeatChunk(int xPosition, int yPosition, float g, float vy, Track t){
    this.xPosition = xPosition;
    this.yPosition = yPosition - MEAT_HEIGHT/2; // get bottom of meat ball to ground.
    this.gravity = g;
    this.velocity = vy;
    this.track = t;
    this.lastBounce = millis();
    this.bounceWait = t.getBeat(0)*1000;
    this.currentBeat = 0;
    this.shouldBounceAgain = 0;
    this.canBounce = true;
    this.beatAtFail = 0;
    this.opacity = 255;
    this.timeReturnFromFail = 0;
  }
  
  void increment(){
    this.yPosition += velocity;
    this.velocity += gravity;
  }
  
  int move() {
    draw();
    if(millis() > shouldBounceAgain) {
      updateCurrentBeat();
      doBounce();
      if(!canBounce & (millis() >= timeReturnFromFail)) {
        opacity = 255;
        canBounce = true;
        return 0;  // NOT IN PLAY YET.
      }
      if(canBounce)
        return 1;  // RETURN 1 IF GAMEPLAY STATE SHOULD CHECK IF BEAT WAS HIT
      else
        return 0;
    }
    else {
      doUpdate();
      return 0; // RETURN 0 IF GAMEPLAY STATE SHOULD NOT CHECK IF BEAT WAS HIT
    }
  }
  
  void draw() {
    fill(255, 51, 51, opacity);
    ellipse(xPosition, yPosition, MEAT_WIDTH, MEAT_HEIGHT);
  }
  
  void bounce(float period, float h) {
    this.gravity = 8 * h / (period*period);
    this.velocity = -this.gravity * period / 2;
    this.yPosition = GROUND - MEAT_HEIGHT/2; // reset y to ground to prevent drifting
  }
  
  void update(float dt) {
    // Euler integration (should be changed to Verlet or something)
    int steps = 12;  // more steps makes integration smoother. if we can afford it we shouldd do it.
    float delta = dt/steps;
    for(int i=0; i<steps;i++) {
      this.velocity += this.gravity * delta;
      this.yPosition += this.velocity * delta;
    }
  }
  
  void doBounce() {
    lastBounce = millis();
    //playSound(track.getSound());
    float period = track.getBeat(currentBeat);
    float ht = DEFAULT_BOUNCE_HEIGHT + (period * unitHeight / spb);
    bounce(period, ht);
    //setTimeout(doBounce, 1000*period); // want to wait period in milliseconds before calling again.
    bounceWait = (int)(1000*period); // period in ms
    shouldBounceAgain = lastBounce + bounceWait;
  }
  
  void doUpdate() {
    float dt = 1 / frameRate;
    update(dt);
    //setTimeout(loop, 1000 / 60); // 30 fps
  }
  
  int getBounceWait() {
    return bounceWait;
  }
  
  int getLastBounce() {
    return lastBounce;
  }
  
  void fail() {
    canBounce = false;
    //beatAtFail = currentBeat;
    //shouldBounceAgain = millis() + 1000*(track.getBeat(beatAtFail) + track.getBeat(beatAtFail+1) + track.getBeat(beatAtFail+2));
    timeReturnFromFail = millis() + 1000*spb*3;//(track.getBeat(beatAtFail) + track.getBeat(beatAtFail+1) + track.getBeat(beatAtFail+2));
    //yPosition = GROUND - MEAT_HEIGHT/2;
    //velocity = 0;
    //gravity = 0;
    //updateCurrentBeat();
    //updateCurrentBeat();
    opacity = 50;
  }
  
  void updateCurrentBeat() {
    currentBeat = (currentBeat + 1) % track.getBeats().length;
  }
  
}
PImage meatFont; //used to display the score 

PImage[] cutUpNumbers(PImage font){
  int totalNumbers = 10;
  PImage[] numbers = new PImage[totalNumbers];
  int xOffset = 120;
  int yOffset = 180;
  int x = 0;
  for(int i = 0; i < totalNumbers; i++){
    numbers[i] = font.get(x, 180, xOffset, yOffset);
    x += xOffset;  
  }
  return numbers;
}

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
  int x, y, height;
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
//    int x = floor(random(xMin, xMax));
//    x += 100;
    int y = HEIGHT - height;
    //increase the x range
//    xMin += 100;
//    xMax += 100;
    trees[i] = new Tree(x, y, height);
    //randomly assign some trees a different starting angle
    if(random(0, treeTotal/3) == 1) trees[i].setAngle(30);   
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
  //once we're done drawing, set stroke back to normal
  stroke(255);
}

//@param height of tree
void drawTree(int x, int y, int height, int i, float angle){
  //TODO: NOT DRY, FIX LATER
  float red, green, blue;
  if(colorConstant.equals("red")){
    red = treeRed;
    green = treeGreen*sin(angle);
    blue = treeBlue*sin(angle);
  } else if(colorConstant.equals("green")){
    red = treeRed*sin(angle);
    green = treeGreen;
    blue = treeBlue*sin(angle);
  } else{
    red = treeRed*sin(angle);
    green = treeGreen*sin(angle);
    blue = treeBlue;
  }
  stroke(red, green, blue, 50);
  strokeWeight(8 + frameCount*0.001);
  int amplitude = 400;
  float a =  (amplitude*sin(angle)/ (float) width)  * 45f;
  // Convert it to radians
  int gap = WIDTH/(length+1);
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
  if (h > 8) {
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

static final int PANEL_WIDTH = 50;
static final int PANEL_HEIGHT = 10;

class Panel{
  float xPosition, yPosition, origY;
  float angle = 0;
  float levelInterval = .5;
  int opacity;
  //int opacityInterval = round(255/frameRate);
  boolean offScreen;
  int lastDraw;
  int waitTime = 100; // ms between allowable presses
  
  Panel(float xPosition, float yPosition){
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.origY = yPosition;
    opacity = 255;
    offScreen = true;
    lastDraw = 0;
  }
  
  void getLastDraw() { // returns ms value of last time drawn
    return lastDraw;
  }
  
  void drawIt() {
    offScreen = false;
    fill(213, 143, 45, opacity);
    rect(xPosition, yPosition, PANEL_WIDTH, PANEL_HEIGHT);
    lastDraw = millis();
  }
  
  void draw(){
    if(!offScreen){
      noStroke();        
      fill(213, 143, 45, opacity);
      rect(xPosition, yPosition, PANEL_WIDTH, PANEL_HEIGHT);
      //yPosition = yPosition + levelInterval;
      //opacity = opacity - opacityInterval;
      //if(yPosition >= origY + frameRate * levelInterval){
      if( (millis() - lastDraw) > waitTime) {
        offScreen = true;
        //opacity = 255;
        //yPosition = origY;
      }
    }
  }
}
class Player{
   int lives;
   int score;
   
   Player(int lives, int score){
     this.lives = lives;
     this.score = score;
   }
   
   void decreaseLives(){
     lives--;
     if(lives<=0) setState(FINISH_STATE);; // should have endGame();
   }
   
   int getLives(){
     return lives;
   }
   
   int getScore() {
     return score;
   }
   
   int changeScore(int change) {
     score = score + change;
   }
   
   void drawScore(){
     pushMatrix();
     fill(255);
     text(score, WIDTH-50, HEIGHT/15);  //number of lives
     popMatrix();
   }
   
   void drawLives(){
     pushMatrix();
     fill(255);
     image(meatLife, WIDTH/10, HEIGHT/120, 38, 38);  //meatball
     text("x", WIDTH/12, HEIGHT/15); //x text
     text(lives, WIDTH/25, HEIGHT/15);  //number of lives
     popMatrix();
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
char[] keyVals = {'j','k','l',';','a','s','d','f'};

class Track {
  
  boolean canSound;
  float[] beats;
  String sound;
  char keyVal;
  
  Track(float[] beatmatrix, String s, char kv) {
    beats = beatmatrix;
    sound = s;
    keyVal = kv;
    canSound = true;
  }
  
  String getSound() {
    if (canSound) {
      return sound;
    }
    else {
      return failsound;
    }
  }
  
  float[] getBeats() {
    return beats;
  }
  
  float getBeat(int i) {
    return beats[i];
  }
  
  char getKey() {
    return keyVal;
  }
  
}

