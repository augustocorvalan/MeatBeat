/* @pjs
smooth=true;
font=chubhand.ttf;
*/

static final int FIRST_STATE = 0;
static final int GAMEPLAY_STATE = 1;
static final int FINISH_STATE = 2;
static final int BETWEEN_LEVELS_STATE = 3;
static final int STATE_COUNT = 4;

static final int INITIAL_LIVES = 10;

static final int MAX_FRAME_RATE = 30;
int fps = 0;  //how many frames drawn this second  

BaseState[] states;
int currentState;

static final int HEIGHT = 600;  //screen height
static final int WIDTH = 800;  //screen width

static final int GROUND = HEIGHT - 50;

PImage meatLife;  //image instance for meat life
PShape cloudImage;  //image for the cloud

Player player;  //player instance

int levelIndex = 0; // keeps track of current level
int currentSPB;

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
    case BETWEEN_LEVELS_STATE:
      return new BetweenLevelsState();
    default:
      return null;
  } 
}
