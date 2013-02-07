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
  
  MeatChunk(int xPosition, int yPosition, float g, float vy, Track t){
    this.xPosition = xPosition;
    this.yPosition = yPosition - MEAT_HEIGHT/2; // get bottom of meat ball to ground.
    this.gravity = g;
    this.velocity = vy;
    this.track = t;
    this.lastBounce = 0;
    this.bounceWait = 0;
    this.currentBeat = 0;
  }
  
  void increment(){
    this.yPosition += velocity;
    this.velocity += gravity;
  }
  
  void move() {
    if ((millis()-lastBounce) > bounceWait) {
      doBounce();
    }
    else {
      doUpdate();
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
    float period = track.getBeat(currentBeat);
    float ht = DEFAULT_BOUNCE_HEIGHT + (period * unitHeight / spb);
    bounce(period, ht);
    //setTimeout(doBounce, 1000*period); // want to wait period in milliseconds before calling again.
    currentBeat = (currentBeat + 1) % track.getBeats().length;
    bounceWait = 1000*period; // period in ms
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
  
}
