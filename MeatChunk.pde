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
        setMaster(0);
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
    opacity = 50;
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
    shouldBounceAgain = failTime + track.getBeat(currentBeat+1);// + track.getBeat(currentBeat+2);    // start bouncing in ghost mode after two beats
    timeReturnFromFail = failTime + 4000*SPB;   // become active again after four beats
    expectedMusicTime = expectedMusicTime + track.getBeat(currentBeat-1);
    updateCurrentBeat();
    //state = IN_HELL;
    yPosition = HEIGHT + MEAT_HEIGHT/2;
    velocity = (GROUND + MEAT_HEIGHT)/-8.5f;
    gravity = 0;
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
