static final int MEAT_WIDTH = 25;
static final int MEAT_HEIGHT = 25;
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
  int bounceWait;
  int currentBeat;
  float unitHeight = height / 3;
  int shouldBounceAgain;
  boolean active;
  int opacity;
  int timeReturnFromFail;
  int failTime;
  int state;
  
  MeatChunk(int xPosition, int yPosition, float g, float vy, Track t){
    this.xPosition = xPosition;
    this.yPosition = yPosition - MEAT_HEIGHT/2; // get bottom of meat ball to ground.
    this.gravity = g;
    this.velocity = vy;
    this.track = t;
    this.lastBounce = millis();
    this.bounceWait = t.getBeat(0)*1000;
    this.currentBeat = -1;
    this.shouldBounceAgain = millis() + spb*1000;
    makeInActive();
    this.timeReturnFromFail = millis() + 64000*spb;
    this.failTime = 0;
    state = BOUNCING;
  }
  
  void increment(){
    this.yPosition += velocity;
    this.velocity += gravity;
  }
  
  int move() {
    if (state != COMPLETE) {
      draw();
      if(millis() > shouldBounceAgain) { // ball should be bouncing
        updateCurrentBeat();
        doBounce();
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
    opacity = 50;
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
    float period = track.getBeat(currentBeat);
    float ht = DEFAULT_BOUNCE_HEIGHT + (period * unitHeight / currentSPB);
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
    makeInActive();
    failTime = millis();
    shouldBounceAgain = failTime + 2000*currentSPB;    // start bouncing in ghost mode after two beats
    timeReturnFromFail = failTime + 4000*currentSPB;   // become active again after four beats
    updateCurrentBeat();
    updateCurrentBeat();
    //state = IN_HELL;
    yPosition = HEIGHT + MEAT_HEIGHT/2;
    velocity = (GROUND + 1.5*MEAT_HEIGHT)/-8.5f;
    gravity = 0;
    //returnFromHell();
  }
  
  void returnFromHell() {
    /*if ((millis() - failTime) >= TIME_IN_HELL) {
      yPosition = yPosition + velocity;
      println("returning" + yPosition);
    }*/
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
