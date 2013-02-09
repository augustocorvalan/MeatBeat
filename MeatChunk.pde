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
  int lastUpdate;
  int framingError;
  int currentError;
  int[] bounceTimes;
  boolean correctError;
  
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
      this.timeReturnFromFail = millis() + 128000*SPB;
    } else{
      this.timeReturnFromFail = millis() + 4000*SPB;
    } 
    this.failTime = 0;
    state = BOUNCING;
    lastUpdate = millis();
    framingError = 0;
    correctError = true;
    /*bounceTimes = new int[track.getBeats().length];
    bounceTimes[0] = lastUpdate + track.getBeat(0)*1000;
    for (int i=1; i<bounceTimes.length; i++) {
      bounceTimes[i] = bounceTimes[i-1] + track.getBeat(i)*1000;
      println(bounceTimes[i]);
    }*/
    this.shouldBounceAgain = 0;
  }
  
  void increment(){
    this.yPosition += velocity;
    this.velocity += gravity;
  }
  
  int move() {
    if (state != COMPLETE) {
      draw();

      //if( currentError <= 5 || currentError >= 500 ) { // ball should be bouncing
      //if(millis() >= bounceTimes[currentBeat]) {
        if ((shouldBounceAgain - millis()) <= 9  || millis() >= shouldBounceAgain) {
        //framingError += currentError;
        currentError = abs(millis() - shouldBounceAgain);
        doBounce(currentError);
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
    opacity = 50;
  }
  
  void draw() {
//    fill(255, 51, 51, opacity);
//    ellipse(xPosition, yPosition, MEAT_WIDTH, MEAT_HEIGHT);
    PImage drawImg;
    if(active){
      drawImg = meatImg;
    } else{
      drawImg = deadMeatImg;
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
  
  void doBounce(int timeError) {
    if (timeError > 500) timeError = 0;
    //correctError = !correctError;
    println(timeError/1000f);
    float period = track.getBeat(currentBeat);
    float ht = DEFAULT_BOUNCE_HEIGHT + (period * unitHeight / SPB);
    bounce(period, ht);
    //setTimeout(doBounce, 1000*period); // want to wait period in milliseconds before calling again.
    bounceWait = (int)(1000*period); // period in ms
    lastBounce = millis();
    if (correctError) {
      shouldBounceAgain = lastBounce + bounceWait;// - timeError;
    }
    else {
      shouldBounceAgain = lastBounce + bounceWait;
    }
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
    shouldBounceAgain = failTime + 2000*SPB;    // start bouncing in ghost mode after two beats
    timeReturnFromFail = failTime + 4000*SPB;   // become active again after four beats
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
