String[] levelNames = {"music/L1.mid","music/LEVEL02.mid","music/LEVEL03.mid","music/LEVEL04.mid","music/LEVEL05.mid","music/LEVEL06.mid","music/LEVEL07.mid"};
String[] lvlImages = {loadImage("sprite sheets/level1.png"),loadImage("sprite sheets/level2.png"),loadImage("sprite sheets/level3.png"),loadImage("sprite sheets/level4.png"),loadImage("sprite sheets/level5.png"),loadImage("sprite sheets/level6.png"),loadImage("sprite sheets/level7.png")};

int[] lvlTimes = {0,64*SPB,128*SPB,256*SPB,512*SPB,768*SPB};

String failsound = "sounds/soundeffects/meatbeatfailnoise.ogg";
                   
static final Level level1;

float[][][] levelBeats = {level1, level1, level1};
                       
/*Level buildLevel(int levelNum) {
  getBeats(levelNames[levelNum]);
  float[][] lvlBeats = getBeats(levelNames[levelNum]);
  lvlBeats = beats;
  Level newLevel = new Level(lvlBeats,soundNames[levelNum]);
  return newLevel;
}*/

int calcNumTracks(float[][] beatarray) {
    int tracks = 0;
    for(int i=0; i<beatarray.length; i++) {
      if (beatarray[i].length > 0) {
        tracks++;
      }
    }
    return tracks;
}

class Level {
  
  int numTracks;
  Track[] tracks;
  
  Level(float[][] beats) {
    numTracks = calcNumTracks(beats);
    tracks = new Track[numTracks+1];
    for(int i=0; i < numTracks; i++) {
      if(levelIndex==0)
        beats[i][0] = beats[i][0] - SPB/2;
      if(levelIndex==2)
        beats[i][0] = beats[i][0] + SPB*0.25;
      if(levelIndex==3)
        beats[i][0] = beats[i][0] + SPB;
      if(levelIndex==4)
        beats[i][0] = beats[i][0] - SPB/2;
      tracks[i] = new Track(beats[i],keyVals[i]);
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
  
}
