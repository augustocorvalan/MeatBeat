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

static final int INITIAL_LIVES = 100;

static final int MAX_FRAME_RATE = 120;
int fps = 0;  //how many frames drawn this second  

BaseState[] states;
int currentState;

static final int HEIGHT = 600;  //screen height
static final int WIDTH = 800;  //screen width

static final int GROUND = HEIGHT - 50;

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
  size(800, 600);
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
