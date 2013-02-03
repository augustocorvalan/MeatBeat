//WAVE SETTING VARIABLES
float density = .75;
float friction = 1.14;
float mouse_pull = 0.09; // The strength at which the mouse pulls particles within the AOE
int aoe = 200; // Area of effect for mouse pull
int detail = round( WIDTH / 60 ); // The number of particles used to build up the wave
float water_density = 1.07;
float air_density = 1.02;
int twitch_interval = 2000; // The interval between random impulses being inserted into the wave to keep it moving


/**
 HILLS
 **/

class Particle {
  int x, y, origX, origY, forceX, forceY, mass;
  float vX, vY;
  Particle(int x, int y, int origX, int origY, float vX, float vY, int forceX, int forceY, int mass){
    this.x = x;
    this.y = y;
    this.origX = origX;
    this.origY = origY;
    this.vX = vX;
    this.vY = vY;
    this.forceX = forceX;
    this.forceY = forceY;
    this.mass = mass;
  }
}

Particle[] setupHill(){ 
  /** Wave settings */
  float density = .75;
  float friction = 1.14;
  float mouse_pull = 0.09; // The strength at which the mouse pulls particles within the AOE
  int aoe = 200; // Area of effect for mouse pull
  int detail = round( WIDTH / 60 ); // The number of particles used to build up the wave
  float water_density = 1.07;
  float air_density = 1.02;
  int twitch_interval = 2000; // The interval between random impulses being inserted into the wave to keep it moving
    
  Particle[] particles = new Particle[detail+1];      
  // Generate our wave particles
  for(int i = 0; i < particles.length; i++) {
    int x = round(WIDTH / (detail-4) * (i-2));
    int y = round(HEIGHT*0.5);
    int originalX = 0;
    int originalY = round(HEIGHT * 0.5);
    float velocityX = 0;
    float velocityY = floor(random(0, 3));
    int forceX = 0;
    int forceY = 0;
    int mass = 10;
    particles[i] = new Particle(x, y, originalX, originalY, velocityX, velocityY, forceX, forceY, mass);
  }
  return particles; 
}

void drawHill() {

}

