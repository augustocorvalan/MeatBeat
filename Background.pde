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

void drawHill(Particle[] particles) {
  
//    int x = round(WIDTH*0.5);
  int x = 0;
  int y = round(HEIGHT*0.2);
  float w = WIDTH;
  float h = HEIGHT - HEIGHT*0.2;
  color blue = color(0, 170, 187, 0);
  color green = color(0, 200, 250, 0);  
  int y_axis = 1;
  setGradient(x, y, w, h, blue, green, y_axis);
  
  int len = particles.length;          
//  var current, previous, next;
//      
//  for(int i = 0; i < len; i++ ) {
//    current = particles[i];
//    previous = particles[i-1];
//    next = particles[i+1];
//    
//    if (previous && next) {
//      
//      var forceY = 0;
//      
//      forceY += -DENSITY * ( previous.y - current.y );
//      forceY += DENSITY * ( current.y - next.y );
//      forceY += DENSITY/15 * ( current.y - current.original.y );
//      
//      current.velocity.y += - ( forceY / current.mass ) + current.force.y;
//      current.velocity.y /= FRICTION;
//      current.force.y /= FRICTION;
//      current.y += current.velocity.y;
//      
//      var distance = DistanceBetween( mp, current );
//      
//      if( distance < AOE ) {
//        var distance = DistanceBetween( mp, {x:current.original.x, y:current.original.y} );
//        
//        ms.x = ms.x * .98;
//        ms.y = ms.y * .98;
//        
//        current.force.y += (MOUSE_PULL * ( 1 - (distance / AOE) )) * ms.y;
//      }
//      
//      // cx, cy, ax, ay
//      context.quadraticCurveTo(previous.x, previous.y, previous.x + (current.x - previous.x) / 2, previous.y + (current.y - previous.y) / 2);
//    } 
//  }
  
}


void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ){
  // calculate differences between color components 
  float deltaR = red(c2)-red(c1);
  float deltaG = green(c2)-green(c1);
  float deltaB = blue(c2)-blue(c1);
  
  int Y_AXIS = 1;
  int X_AXIS = 2;
  // choose axis
  if(axis == Y_AXIS){
    /*nested for loops set pixels
     in a basic table structure */
    // column
    for (int i=x; i<=(x+w); i++){
      // row
      for (int j = y; j<=(y+h); j++){
        color c = color(
          (red(c1)+(j-y)*(deltaR/h)),
          (green(c1)+(j-y)*(deltaG/h)),
          (blue(c1)+(j-y)*(deltaB/h)) 
        );
        set(i, j, c);
      }
    }  
  }  
  else if(axis == X_AXIS){
    // column 
    for (int i=y; i<=(y+h); i++){
      // row
      for (int j = x; j<=(x+w); j++){
        color c = color(
          (red(c1)+(j-x)*(deltaR/h)),
          (green(c1)+(j-x)*(deltaG/h)),
          (blue(c1)+(j-x)*(deltaB/h)) 
        );
        set(j, i, c);
      }
    }  
  }
}

//void quadraticBezierVertex(cpx, cpy, x, y) {
//  var cp1x = prevX + 2.0/3.0*(cpx - prevX);
//  var cp1y = prevY + 2.0/3.0*(cpy - prevY);
//  var cp2x = cp1x + (x - prevX)/3.0;
//  var cp2y = cp1y + (y - prevY)/3.0;
// 
//  // finally call cubic Bezier curve function
//  bezierVertex(cp1x, cp1y, cp2x, cp2y, x, y);
//};
