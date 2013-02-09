class ColorWheel{
  float offset;
  float intensity;
 
   ColorWheel(){
     this.offset = 0;
     this.intensity = 360;
   }
   
   ColorWheel(float offset, float intensity){
      this.offset = offset;
      this.intensity = intensity;
   }
   
   /*void draw(float x, float y){
     colorMode(HSB, 360);
     float radius = 400;
     for(int i = 0; i < 360; i++){
       float angle = i * PI/180;
       stroke(i + 1, 360, 360);
       fill(i + 1, 360, 360);
       //line(x, y, x + (radius * cos(angle)), y + (radius * sin(angle)));
       //line(0,i,radius, i);
       arc(x,y,radius,radius,angle, angle+=PI/180);
     }
     colorMode(RGB);
   }*/
   
   color[] getColor(){
     colorMode(HSB,360);
     color[] colorArray = new color[3];
     colorArray[0] = color(offset, intensity, 360);
     colorArray[1] = color(offset + 120, intensity, 360);
     colorArray[2] = color(offset + 240, intensity, 360);
     offset++;
     colorMode(RGB);
   }
}
