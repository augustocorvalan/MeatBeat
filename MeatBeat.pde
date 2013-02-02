int FIRST_STATE = 0;
int STATE_COUNT = 1;

BaseState[] states;
int currentState;

void setup(){
  size(800, 600);
  currentState = FIRST_STATE;
  states = new BaseState[STATE_COUNT];
  for(int i = 0; i < states.length; i++){
    states[i] = BaseState.createState(i); 
  }
  setState(FIRST_STATE);
}

void draw(){
  states[currentState].draw();
}

void setState(int state){
  states[currentState].cleanup();
  currentState = state;
  states[currentState].setup();
}

class BaseState{
  void setup(){}
 
  void draw(){}
  
  void cleanup(){}
  
  void keyPressed(){}
  
  static BaseState createState(int state){
    switch(state){
      case FIRST_STATE:
        return new TitleState();
      default:
        return null;
    } 
  }
  
}

class TitleState extends BaseState{
  void setup(){
    //background(255, 0, 0);
  }
 
  void draw(){
  }
  
  void keyPressed(){
    
  }
  
  void cleanup(){
    
  }
}
