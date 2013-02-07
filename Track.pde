char[] keyVals = {'j','k','l',';','a','s','d','f'};

class Track {
  
  float[] beats;
  String sound;
  char keyVal;
  
  Track(float[] beatmatrix, String s, char kv) {
    beats = beatmatrix;
    sound = s;
    keyVal = kv;
  }
  
  String getSound() {
    return sound;
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
