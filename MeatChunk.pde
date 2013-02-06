class MeatChunk{
  int xPosition, yPosition;
  float gravity;
  float velocity;
  int lastFrame;
  Track track;
  int lastBounce;
  int bounceWait;
  int currentBeat;
  int unitHeight = HEIGHT / 2;
  int ground = HEIGHT - 15;
  
  MeatChunk(int xPosition, int yPosition, float g, float vy, Track t){
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.gravity = g;
    this.velocity = vy;
    this.lastFrame = 0;
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
    this.yPosition = ground; // reset y to ground to prevent drifting
  }
  
  void update(float dt) {
    // Euler integration (should be changed to Verlet or something)
    this.velocity += this.gravity * dt;
    this.yPosition += this.velocity * dt;
  }
  
  void doBounce() {
    lastBounce = millis();
    float period = track.getBeat(currentBeat);
    bounce(period, track.getBeat(currentBeat) * unitHeight);
    //setTimeout(doBounce, 1000*period); // want to wait period in milliseconds before calling again.
    currentBeat = (currentBeat + 1) % track.getBeats().length;
    bounceWait = 1000*period; // period in ms.
  }
  
  void doUpdate() {
    int dt = millis() - lastFrame;
    lastFrame += dt;
    update(dt/1000);
    //setTimeout(loop, 1000 / 60); // 30 fps
  }
  
}
