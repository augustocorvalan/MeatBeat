class MeatChunk{
  int xPosition, yPosition;
  float gravity;
  float velocity;
  float lastTime;
  Track track;
  
  MeatChunk(int xPosition, int yPosition, float g, float vy, Track t){
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.gravity = g;
    this.velocity = vy;
    this.lastTime = 0;
    this.track = t;
  }
  
  void increment(){
    this.yPosition += velocity;
    this.velocity += gravity;
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
    this.lastTime = Date.now();
    var period = t.getBeats();
    bounce(period, t.getBeat(i) * unitHeight);
    setTimeout(doBounce, 1000*period);
    i = (i + 1) % beat.length;
  }
}
