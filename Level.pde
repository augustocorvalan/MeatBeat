

class Level {
  
  int numTracks;
  Track[] tracks;
  String[] sounds;
  
  Level(float[][] beats,  String[] s) {
    sounds = s;
    numTracks = calcNumTracks(beats);
    tracks = new Track[numTracks];
    for(int i=0; i < numTracks; i++) {
      tracks[i] = new Track(beats[i],sounds[i]);
    }
  }
  
  private int calcNumTracks(float[][] beats) {
    int tracks = 0;
    for(int i=0; i<beats.length; i++) {
      if (beats[i].length > 0) {
        tracks++;
      }
    }
    return tracks;
  }
  
}
