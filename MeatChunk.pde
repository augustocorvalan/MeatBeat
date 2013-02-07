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
