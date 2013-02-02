static final int FIRST_STATE = 0;
static final int GAMEPLAY_STATE = 1;
static final int FINISH_STATE = 2;
static final int STATE_COUNT = 3;

BaseState[] states;
int currentState;

void setup(){
  size(800, 600);
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
    
  }
  
  void cleanup(){
    
  }
}

class GameplayState extends BaseState{
  void setup(){
   
  }
 
  void draw(){
   
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
