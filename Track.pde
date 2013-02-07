char[] keyVals = {'j','k','l',';','a','s','d','f'};

class Track {
  
  boolean canSound;
  float[] beats;
  String sound;
  char keyVal;
  
  Track(float[] beatmatrix, String s, char kv) {
    beats = beatmatrix;
    sound = s;
    keyVal = kv;
    canSound = true;
  }
  
  String getSound() {
    if (canSound) {
      return sound;
    }
    else {
      return failsound;
    }
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
