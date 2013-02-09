char[] keyVals = {'j','k','l',';','a','s','d','f'};

class Track {
  
  float[] beats;
  char keyVal;
  
  Track(float[] beatmatrix, char kv) {
    beats = beatmatrix;
    //beats[0] = beats[0] - SPB/2;
    println(beats[0]);
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
