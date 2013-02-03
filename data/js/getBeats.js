
function loadRemote(path, callback) {
  var fetch = new XMLHttpRequest();
  fetch.open("GET", path);
  fetch.overrideMimeType("text/plain; charset=x-user-defined");
  fetch.onreadystatechange = function() {
    if (this.readyState === 4 && this.status === 200) {
      /* munge response into a binary string */
      var t = this.responseText || "" ;
      var ff = [];
      var mx = t.length;
      var scc= String.fromCharCode;
      for (var z = 0; z < mx; z++) {
        ff[z] = scc(t.charCodeAt(z) & 255);
      }
      callback(ff.join(""));
    }
  }
  fetch.send();
}

function getBeats(file, callback) {
  loadRemote(file, function(data) {

    var midiFile = MidiFile(data);
    var metaTrack = midiFile.tracks[0];
    var track = midiFile.tracks[1];
    var ticksPerBeat = midiFile.header.ticksPerBeat;
    var secondsPerBeat = 120;
    var midi2beat = [36, 37, 38, 39, 40, 41, 42, 43];
    var beatInd = [0, 0, 0, 0, 0, 0, 0, 0];
    beats = [[0], [0], [0], [0], [0], [0], [0], [0]]; //GLOBAL so processing can hit it
    var i, j, n;

    // get info in terms of ticks
    n = track.length;
    for (i = 0; i < n; ++i) {
      if (track[i].deltaTime) {
        for (j = 0; j < beats.length; ++j) {
          beats[j][beatInd[j]] += track[i].deltaTime;
        }
      }
      if (track[i].subtype === "noteOn") {
        var beatTrackNumber = midi2beat.indexOf(track[i].noteNumber);
        if (beatTrackNumber < 0)
          throw new Error("Bad note number: " + track[i].noteNumber);
        beatInd[beatTrackNumber] += 1;
        beats[beatTrackNumber].push(0);
      }
    }
    for (j = 0; j < beats.length; ++j) {
      beats[j].pop();
    }

    // convert tick info to time in seconds
    n = metaTrack.length;
    for (i = 0; i < n; ++i) {
      var e = metaTrack[i];
      if (e.type === "meta" && e.subtype === "setTempo") {
        secondsPerBeat = e.microsecondsPerBeat / 1e6;
      }
    }
    if (!secondsPerBeat) secondsPerBeat = 60 / 120;

    var secondsPerTick = secondsPerBeat / ticksPerBeat;
    for (j = 0; j < beats.length; ++j) {
      n = beats[j].length;
      for (i = 0; i < n; ++i) {
        beats[j][i] *= secondsPerTick;
      }
    }
    callback(beats);
  });
}

// Usage:
// getBeats("TwoTrack8measuresofEighthNotes.mid", console.log.bind(console));
