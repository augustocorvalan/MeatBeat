

class Level {
  
  int numTracks;
  Track[] tracks;
  
  
  Level(float[][] beats,  ) {
    numTracks = calcTracks();
  
  }
  
  int calcTracks() {
    int tracks = 0;
    for(int i=0; i<beats.length; i++) {
      if (beats[i].length > 0) {
        tracks++;
      }
    }
    return tracks;
  }
  
}
