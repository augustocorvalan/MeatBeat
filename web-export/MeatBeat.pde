/* @pjs
smooth=true;
font=chubhand.ttf;
*/

static final int FIRST_STATE = 0;
static final int GAMEPLAY_STATE = 1;
static final int FINISH_STATE = 2;
static final int BETWEEN_LEVELS_STATE = 3;
static final int STATE_COUNT = 4;
static final int BPM = 110;
static final float SPB = 0.5454545;
boolean startMaster = false;

static final int INITIAL_LIVES = 20;

static final int MAX_FRAME_RATE = 120;
int fps = 0;  //how many frames drawn this second  

BaseState[] states;
int currentState;

static final int HEIGHT = 600;  //screen height
static final int WIDTH = 800;  //screen width

static final int GROUND = height - 50;

PImage meatLife;  //image instance for meat life
PImage fist;
PShape cloudImage;  //image for the cloud
PImage meatImg;  //image for bouncing meat
PImage deadMeatImg;  //inactive meat ball image
String[] fists = {"sprite sheets/fist1.png","sprite sheets/fist2.png","sprite sheets/fist3.png","sprite sheets/fist4.png","sprite sheets/fist5.png","sprite sheets/fist6.png","sprite sheets/fist7.png"};
PImage[] numbersImg = new PImage[10];  //holds the number images
PImage grillImg;
PImage replayImg;

Player player;  //player instance

int levelIndex = 0; // keeps track of current level

boolean INVINSIBLE = false;  //debugging purposes only

void setup(){
  frameRate(MAX_FRAME_RATE);
  getBeats(levelNames[levelIndex]);
  size(window.innerWidth, window.innerHeight); 
  background(255);
  currentState = FIRST_STATE;
  states = new BaseState[STATE_COUNT];
  for(int i = 0; i < states.length; i++){
    states[i] = createState(i); 
  }
  setState(FIRST_STATE);
  player = new Player(INITIAL_LIVES,0);
  
  cloudImage = loadShape("cloud.svg");
  meatLife = loadImage("sprite sheets/regularmeatball.png");
  meatImg = loadImage("sprite sheets/regularmeatball.png");
  deadMeatImg1 = loadImage("sprite sheets/coldmeatball1.png");
  deadMeatImg2 = loadImage("sprite sheets/coldmeatball2.png");
  for(int i = 0; i < 10; i++){
    numbersImg[i] = loadImage("sprite sheets/" + i + ".png"); 
  }
  meatFont = loadImage("sprite sheets/number font_v2.png");  //load meat font
  grillImg = loadImage("sprite sheets/grill.png");
  replayImg = loadImage("sprite sheets/replay.png");
  
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
    case BETWEEN_LEVELS_STATE:
      return new BetweenLevelsState();
    default:
      return null;
  } 
}
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
class BaseState{
  void setup(){}
 
  void draw(){}
  
  void cleanup(){}
  
  void keyPressed(){}
}
PImage grass = loadImage("sprite sheets/grassblock.png");
final static int GRASS_HEIGHT = GROUND;

class Baseline {
  
  int[] spaces = new int[8];
  int numSpaces = 0;
  
  
  void addEmptyZone(int xPos) {
    spaces[numSpaces] = xPos - MEAT_WIDTH/2;
    numSpaces++;
  }
  
  void draw() {
    stroke(255);
    int x1 = 0;
    for(int i=0; i < numSpaces; i++) {
      //line(x1,GROUND,spaces[i],GROUND);
      image(grass,x1,GROUND,spaces[i]-x1,GRASS_HEIGHT);
      x1 = spaces[i] + MEAT_WIDTH;
    }
    //line(x1,GROUND,WIDTH,GROUND);
    image(grass,x1,GROUND,width-x1,GRASS_HEIGHT);
  }
  
}
class BetweenLevelsState extends BaseState {
  static final int GB = 1;
  static final int H = 2;
  static final int DONE = 3;
  int xPos;
  String goodbye;
  String hello;
  int state;
  
  
  void setup(){
    xPos = 0;
    goodbye = "Goodbye Level " + levelIndex;
    hello = "Hello Level " + (levelIndex+1);
    state = GB;
  }
 
  void draw(){
    background(0);
    if (state==GB) {
      drawGB();
    }
    else if (state==H) {
      drawH();
    }
    else {
      setState(GAMEPLAY_STATE);
    }
  }
  
  void drawGB() {
    fill(255);
    if (xPos <= width + 200) {
      text(goodbye, xPos, height/2);  //number of lives
      xPos = xPos + 10;
    }
    else {
      state = H;
      xPos = 0;
    }
  }
  
  void drawH() {
    fill(255);
    if (xPos <= width + 200) {
      text(hello, xPos, height/2);  //number of lives
      xPos = xPos + 10;
    }
    else  {
      state = DONE;
    }
  }
  
  void cleanup(){}
  
  void keyPressed(){}
  
}
class ColorWheel{
  float offset;
  float intensity;
 
   ColorWheel(){
     this.offset = 0;
     this.intensity = 360;
   }
   
   ColorWheel(float offset, float intensity){
      this.offset = offset;
      this.intensity = intensity;
   }
   
   /*void draw(float x, float y){
     colorMode(HSB, 360);
     float radius = 400;
     for(int i = 0; i < 360; i++){
       float angle = i * PI/180;
       stroke(i + 1, 360, 360);
       fill(i + 1, 360, 360);
       //line(x, y, x + (radius * cos(angle)), y + (radius * sin(angle)));
       //line(0,i,radius, i);
       arc(x,y,radius,radius,angle, angle+=PI/180);
     }
     colorMode(RGB);
   }*/
   
   color[] getColor(){
     colorMode(HSB,360);
     color[] colorArray = new color[3];
     colorArray[0] = color((offset%360), intensity, 100);
     colorArray[1] = color(((offset + 120)%360), intensity, 100);
     colorArray[2] = color(((offset + 240)%360), intensity, 70);
     offset++;
     intensity++;
     colorMode(RGB);
     return colorArray;
   }
}
class FinishState extends BaseState{
  int CHUNK_NUMBER = 4;
  MeatChunk[] chunkArray;
  Panel[] panelArray;
  float threshold = 5;
  
  float sin_offset= PI/2;
  
  void setup(){
  playSound("sounds/soundeffects/meatbeatscorescreen.ogg");
  setupScore();
}
 
  void draw(){
    background(0);
    text("Hey meatbeater! Thanks for playing!", width/2, height/5);
//    text("Total score: " + player.getScore(), WIDTH/2, HEIGHT/2 + 60);
    drawScore();
    
  }
 
  void keyPressed(){
    if(key=='r') { setState(GAMEPLAY_STATE); }
  }
 
  void cleanup(){
   
  } 
}
class GameplayState extends BaseState{
  /** 
    BACKGROUND VARIABLES
  **/
  int totalHills = width * 0.00375;
  Hill[] hills = new Hill[totalHills];
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  int totalClouds = 3;
  Cloud[] clouds = new Cloud[totalClouds];
  boolean showLineOrCloud;
  ColorWheel cw;
  color[] c;
  int levelStart;
  static final int NEW_LEVEL_TIME = 1500;
  
  Level currentLevel;
  int currentTrackNum;
  Panel[] panelArray;
  MeatChunk[] chunkArray;
  int offset = 60;
  float thresholdMS = 550;
  int timingErrorControl = 10;
  int[] shouldCheckBeat;
  Baseline bl;
  
  int colorShifter;
  
  void setup(){    
    /**  BACKGROUND SETUP **/
    setupHills(hills);  //hill setup
    trees = setupTrees(totalTrees);  //tree setup
    setupClouds(clouds);  //cloud setup
    cw = new ColorWheel(42f,50f);
    colorShifter=1;
    setupLine();
    setNextLevel();
    playMaster();
  }
  
  void setNextLevel() {
    fist = loadImage(fists[int(random(0,fists.length))]);
    currentLevel = new Level(beatsarray);
    levelIndex++;
    getBeats(levelNames[levelIndex]); // get next level loaded
    currentTrackNum = currentLevel.getNumTracks();
    panelArray = new Panel[currentTrackNum];
    chunkArray = new MeatChunk[currentTrackNum];
    shouldCheckBeat = new int[currentTrackNum];
    bl = new Baseline();
    for(int i = 0; i < currentTrackNum; i++){
      int xpos = offset + (width - offset * 2) / (currentTrackNum - 1) * i;
      chunkArray[i] = new MeatChunk(xpos - MEAT_WIDTH/2, GROUND, 0, 0, currentLevel.getTrack(i));
      panelArray[i] = new Panel(xpos - PANEL_WIDTH/2, GROUND - 15);
      bl.addEmptyZone(xpos);
      shouldCheckBeat[i] = 0;
    }
    levelStart = millis();
  }
 
  void draw(){
      levelComplete = true;
      colorShifter--;
      if(colorShifter == 0) {
        c = cw.getColor();
        colorShifter=5;
      }
      background(c[1]);
      
      /** 
        BACKGROUND DRAW
      **/
      drawLine();
      if(showLineOrCloud == "true"){
        drawLine();
       }
       else{
        drawClouds(clouds,c);
       }
      drawHills(hills,c);
      drawTrees(trees,c);

      /** LIVES **/
      player.drawLives();
      player.drawScore();
      bl.draw();
      
      for(int i = 0; i < currentTrackNum; i++){
        panelArray[i].draw();
        shouldCheckBeat[i] = chunkArray[i].move();
        if (shouldCheckBeat[i]==1) {
          checkBeatSuccess(i);
        }
        if (chunkArray[i].state != COMPLETE) {
          levelComplete = false;
        }
      }
      /*if (shouldCheckBeat[0]==1) {
          checkBeatSuccess(0);
          //playSound(currentLevel.getTrack(0).getSound());
          //soundTimes[0] = millis();
      }*/
      if (levelComplete) {
        //setState(BETWEEN_LEVELS_STATE);
        //setState(GAMEPLAY_STATE);
        setNextLevel();
      }
      if ((millis() - levelStart) <= NEW_LEVEL_TIME) {
        image(lvlImages[levelIndex-1], width/2-100, height/4,400,80);
      }
  }
  
 
  void keyPressed(){
    for (int i = 0; i < currentLevel.getNumTracks(); i++) {
      if (key==currentLevel.getTrack(i).getKey()) {
        if (panelArray[i].offScreen) {
          panelArray[i].drawIt();
        }
      }
    }
    
    if(key=='p') noLoop();
  }
    
  void cleanup(){
    stopMaster();
  }
  
  boolean checkBeatSuccess(int track) {
    int diff = abs(panelArray[track].getLastDraw() - chunkArray[track].previousBounceTime);
    //if (!panelArray[track].offScreen) {
    //if ((abs((chunkArray[track].yPosition+MEAT_HEIGHT/2) - (panelArray[track].origY-PANEL_HEIGHT/2)) <= threshold)) {
    if( abs(diff) <= thresholdMS) {
      beatSuccess(track);
    }
    else {
      beatFailure(track);
    }
  }
  
  void beatSuccess(int track) {
    currentLevel.getTrack(track).canSound=true;
    player.changeScore(1);    
  }
  
  void beatFailure(int track) {
    player.decreaseLives();
    chunkArray[track].fail();
    //playFail();
  }
  
}
String[] levelNames = {"music/L1.mid","music/LEVEL02.mid","music/LEVEL03.mid","music/LEVEL04.mid","music/LEVEL05.mid","music/LEVEL06.mid","music/LEVEL07.mid"};
String[] lvlImages = {loadImage("sprite sheets/level1.png"),loadImage("sprite sheets/level2.png"),loadImage("sprite sheets/level3.png"),loadImage("sprite sheets/level4.png"),loadImage("sprite sheets/level5.png"),loadImage("sprite sheets/level6.png"),loadImage("sprite sheets/level7.png")};

int[] lvlTimes = {0,64*SPB,128*SPB,256*SPB,512*SPB,768*SPB};

String failsound = "sounds/soundeffects/meatbeatfailnoise.ogg";
                   
static final Level level1;

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
  
  Level(float[][] beats) {
    numTracks = calcNumTracks(beats);
    tracks = new Track[numTracks+1];
    for(int i=0; i < numTracks; i++) {
      if(levelIndex==0)
        beats[i][0] = beats[i][0] - SPB/2;
      if(levelIndex==3)
        beats[i][0] = beats[i][0] + SPB;
      if(levelIndex==4)
        beats[i][0] = beats[i][0] - SPB/2;
      tracks[i] = new Track(beats[i],keyVals[i]);
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
static final int MEAT_WIDTH = 75;
static final int MEAT_HEIGHT = 75;
static final int DEFAULT_BOUNCE_HEIGHT = 0;
static final int TIME_IN_HELL = 500;
static final int BOUNCING = 1;
static final int IN_HELL = 2;
static final int RISING = 3;
static final int COMPLETE = 4;

class MeatChunk{
  int xPosition, yPosition;
  float gravity;
  float velocity;
  Track track;
  int lastBounce;
  float bounceWait;
  int currentBeat;
  float unitHeight = height / 3;
  int shouldBounceAgain;
  boolean active;
  int opacity;
  int timeReturnFromFail;
  int failTime;
  int state;
  int lastMove;
  int framingError;
  int currentError;
  int[] bounceTimes;
  boolean correctError;
  int expectedMusicTime;
  PImage drawImg;
  int lastBlueSwitch;
  int previousBounceTime;
  
  MeatChunk(int xPosition, int yPosition, float g, float vy, Track t){
    this.xPosition = xPosition;
    this.yPosition = yPosition - MEAT_HEIGHT/2; // get bottom of meat ball to ground.
    this.gravity = g;
    this.velocity = vy;
    this.track = t;
    this.lastBounce = millis();
    this.bounceWait = 0;
    this.currentBeat = 0;
    makeInActive();
    if(INVINSIBLE){  //for debugging purposes only, take out later
      this.timeReturnFromFail = millis() + 300000*SPB;
    } else{
      this.timeReturnFromFail = millis() + 4000*SPB;
    } 
    this.failTime = 0;
    state = BOUNCING;
    lastMove = millis();
    framingError = 0;
    correctError = true;
    /*bounceTimes = new int[track.getBeats().length];
    bounceTimes[0] = lastUpdate + track.getBeat(0)*1000;
    for (int i=1; i<bounceTimes.length; i++) {
      bounceTimes[i] = bounceTimes[i-1] + track.getBeat(i)*1000;
      println(bounceTimes[i]);
    }*/
    this.shouldBounceAgain = 0;
    expectedMusicTime = master.currentTime;
    lastBlueSwitch = 0;
    drawImg = deadMeatImg1;
  }
  
  void increment(){
    this.yPosition += velocity;
    this.velocity += gravity;
  }
  
  int move() {
    if (state != COMPLETE) {
      draw();
      lastMove = millis();
      //if(millis() >= bounceTimes[currentBeat]) {
      if (millis() >= shouldBounceAgain) {
        //framingError += currentError;
        float diff = 0;
        if (currentBeat != 0) {
          expectedMusicTime = expectedMusicTime + track.getBeat(currentBeat-1);
          diff = master.currentTime - expectedMusicTime;
          //println("diff = " + diff);
        }
        currentError = abs(millis() - shouldBounceAgain);
        doBounce(diff);
        updateCurrentBeat();
        if(!active && millis() >= timeReturnFromFail) { // ball has had two test bounces. maybe change this system to actually be about current beat. makes more sense.
          makeActive();
          return 0;  // NOT IN PLAY YET. give player a bounce to recover.
        }
        if(active)
          return 1;  // RETURN 1 IF GAMEPLAY STATE SHOULD CHECK IF BEAT WAS HIT
        else
          return 0;
      }
      else {
        doUpdate();
        return 0; // RETURN 0 IF GAMEPLAY STATE SHOULD NOT CHECK IF BEAT WAS HIT
      }
    }
  }
  
  void makeActive() {
    active = true;
    opacity = 255;
  }
  
  void makeInActive() {
    active = false;
    drawImg = deadMeatImg1;
  }
  
  void draw() {
    if(active){
      drawImg = meatImg;
    }
    else if(drawImg == deadMeatImg1 && (millis() - lastBlueSwitch) >= 250) {
      drawImg = deadMeatImg2;
      lastBlueSwitch = millis();
    }
    else if(drawImg == deadMeatImg2 && (millis() - lastBlueSwitch) >= 250){
      drawImg = deadMeatImg1;
      lastBlueSwitch = millis();
    }
    image(drawImg, xPosition, yPosition, MEAT_WIDTH, MEAT_HEIGHT);
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
  
  void doBounce(float timeError) {
    //correctError = !correctError;
    if (currentBeat==0 && levelIndex ==1)
      float period = track.getBeat(currentBeat);
    else
      float period = track.getBeat(currentBeat) - timeError;
    float ht = DEFAULT_BOUNCE_HEIGHT + (period * unitHeight / SPB);
    bounce(period, ht);
    //setTimeout(doBounce, 1000*period); // want to wait period in milliseconds before calling again.
    bounceWait = (int)(1000*period); // period in ms
    lastBounce = millis();
    previousBounceTime = shouldBounceAgain;
    shouldBounceAgain = lastBounce + bounceWait;// - timeError*2;
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
    makeInActive();
    failTime = millis();
    //shouldBounceAgain = failTime + track.getBeat(currentBeat+1);// + track.getBeat(currentBeat+2);    // start bouncing in ghost mode after two beats
    timeReturnFromFail = failTime + 4000*SPB;   // become active again after four beats
    //expectedMusicTime = expectedMusicTime + track.getBeat(currentBeat-1);
    //updateCurrentBeat();
    //state = IN_HELL;

    //yPosition = HEIGHT + MEAT_HEIGHT;
    //velocity = 0;
    //gravity = 0;

    //playFail();
  }
  
  void updateCurrentBeat() {
    if ((currentBeat+1)==track.getBeats().length) {
      state = COMPLETE;
    }
    else {
      currentBeat++;
    }
  }
  
}
PImage meatFont; //used to display the score

ArrayList digits = new ArrayList();

int GRILLDIMENSIONS = 500;
int MEATX = 124 * 0.75;
int MEATY = 180 * 0.75;

void setupScore(){
  int score = player.getScore();
  if(score == 0){
    digits.add(0);
  } else{
    while(score > 0) {
      digit = floor(score % 10);
      digits.add(digit);
      score = floor(score / 10);
    }
  }
}

void drawScore(){
  //draw background grill
  image(grillImg, width/2 - GRILLDIMENSIONS/2, height/5, GRILLDIMENSIONS, GRILLDIMENSIONS);
  for(int i = 0; i < digits.size(); i++){
    int digit = digits.get(i);
    PImage digitImg = numbersImg[digit];
    image(digitImg, width/2 - MEATX/2*i - i*50, 2 * height/5 + MEATY/2, MEATX, MEATY);
  }  
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

static final int PANEL_WIDTH = 30;
static final int PANEL_HEIGHT = 90;

class Panel{
  float xPosition, yPosition, origY;
  boolean offScreen;
  int lastDraw;
  int waitTime = 140; // ms fist on screen;
  int hold = 50; // ms between presses
  
  
  Panel(float xPosition, float yPosition){
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.origY = yPosition;
    offScreen = true;
    lastDraw = 0;
  }
  
  void getLastDraw() { // returns ms value of last time drawn
    return lastDraw;
  }
  
  void drawIt() {
    if (millis() - lastDraw >- hold) {
      offScreen = false;
      image(fist,xPosition,yPosition,PANEL_WIDTH,PANEL_HEIGHT);
      lastDraw = millis();
    }
  }
  
  void draw(){
    if(!offScreen){
      image(fist,xPosition,yPosition,PANEL_WIDTH,PANEL_HEIGHT);
      if( (millis() - lastDraw) > waitTime) {
        offScreen = true;
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
     if(lives<=0) setState(FINISH_STATE); // should have endGame();
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
     text(score, width-50, height/15);  //number of lives
     popMatrix();
   }
   
   void drawLives(){
     pushMatrix();
     fill(255);
     image(meatLife, width/10, height/120, 38, 38);  //meatball
     text("x", width/12, height/15); //x text
     text(lives, width/25, height/15);  //number of lives
     popMatrix();
   }
}
class TitleState extends BaseState{
  int startTime;
  String[] quotes = {"When Meat Attacks", "Meat me at the Meat shop","The Meatshop Chronicles","Meat and Destroy","Meat and Prejudice","The Meat Files","Meatocracy","To Meat or not to Meat","Baconbacond and bacon","Meat Zone 2","Mega Meat","Meating of the Meats","Meatups","Meat Raider","That's a Meat","Beauty and the Meat","The pen is not Beatlier than the Meat","M for Meatdetta", "I came here to Beat Meat and chew bubble gum. I'm out of gum..."};
  int quote;
  String word;
  PImage logo;
  void setup(){
    background(200, 0, 0);
    playIntro();
    quote = int(random(quotes.length-1));
    fill(255);
    text(quotes[quote], width/2, height*7/8);
    logo = loadImage("sprite sheets/logo.png");
    imageMode(CENTER);
  }
 
  void draw(){
    background(200, 0, 0);
    image(logo, width/2, height/2, (700/860) * width * 3/4, (860/700) * height * 3/4);
    fill(255);
    text(quotes[quote], width/2, height*7/8);
}
 
  void keyPressed(){
      if(key=='p') stopIntro();
      else if(key=='o') playMaster();
      else if(key=='y') playIntro();
      else
        setState(GAMEPLAY_STATE);
  }

  void cleanup(){
    stopIntro();
    imageMode(CORNER);
  }
}
char[] keyVals = {'q','w','e','r','t','y'};

class Track {
  
  float[] beats;
  char keyVal;
  
  Track(float[] beatmatrix, char kv) {
    beats = beatmatrix;
    //beats[0] = beats[0] - SPB/2;
    keyVal = kv;
    canSound = true;
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

