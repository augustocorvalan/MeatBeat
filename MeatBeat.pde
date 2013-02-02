int FIRST_STATE = 0;
int GAMEPLAY_STATE = 1;
int FINISH_STATE = 2;
int STATE_COUNT = 3;

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
      case GAMEPLAY_STATE:
        return new GameplayState();
      case FINISH_STATE:
        return new FinishState();
      default:
        return null;
    } 
  }
  
}

class TitleState extends BaseState{
  void setup(){
    
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
