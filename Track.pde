class Track {
  
  float[] beats;
  String sound;
  
  Track(float[] beatmatrix, String s) {
    beats = beatmatrix;
    sound = s;
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
  
}
