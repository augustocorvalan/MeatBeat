char[] keyVals = {'q','w','e','r','t','y'};

class Track {
  
  float[] beats;
  char keyVal;
  
  Track(float[] beatmatrix, char kv) {
    beats = beatmatrix;
    //beats[0] = beats[0] - SPB/2;
    keyVal = kv;
    canSound = true;
  }
  
  float[] getBeats() {
    return beats;
  }
  
  float getBeat(int i) {
    return beats[i];
  }
  
  char getKey() {
    return keyVal;
  }
  
}
