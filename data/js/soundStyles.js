var fail = new Audio("sounds/soundeffects/meatbeatfailnoise.ogg");
var intro = new Audio("/music/meatbeatintro.ogg");
var master = new Audio("music/meatbeatmaster2.ogg");

var introlength;

function playIntro() {
  intro.play();
}

function stopIntro() {
  intro.pause();
}

function playMaster() {
  master.play();
}

function stopMaster() {
  master.pause();
}

function setMaster(time) {
  master.pause();
  master.currentTime = time;
  master.play();
}

function playFail() {
  fail.play();
  fail = new Audio("sounds/soundeffects/meatbeatfailnoise.ogg");
}

function getIntroLength(duration) {
  introlength = duration;
}

function playSound(soundName) {
  var snd = new Audio(soundName); // buffers automatically when created
  if (typeof snd.loop == 'boolean')
  {
     snd.loop = true;
  }
  else
  {
    snd.addEventListener('ended', function() {
    this.currentTime = 0;
    this.play();
    }, false);
  }
  snd.play();
}
