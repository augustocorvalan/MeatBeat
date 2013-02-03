String[] levelNames = {"sounds/testmidi/samplemeatbeatbeat.mid",
                       "sounds/testmidi/TwoTrackBasicBeat.mid"};
                       
String[][] soundNames = { {"music/meatbeatkick.ogg","music/meatbeatkick.ogg"},
                          {"music/meatbeatkick.ogg","music/meatbeatkick.ogg"}};
                       
Level buildLevel(int levelNum) {
  getBeats(levelNames[levelNum]);
  float[][] lvlBeats = getBeats(levelNames[levelNum]);
  lvlBeats = beats;
  Level newLevel = new Level(lvlBeats,soundNames[levelNum]);
  return newLevel;
}

class Level {
  
  int numTracks;
  Track[] tracks;
  
  Level(float[][] beats,  String[] sounds) {
    numTracks = calcNumTracks(beats);
    tracks = new Track[numTracks];
    for(int i=0; i < numTracks; i++) {
      tracks[i] = new Track(beats[i],sounds[i]);
    }
  }
  
  Track getTrack(int trackNum) {
    return tracks[trackNum];
  }
  
  int getNumTracks() {
    return numTracks;
  }
  
  Track[] getTracks() {
    return tracks;
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
