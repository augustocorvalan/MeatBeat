
function playSound(var soundName) {
  var snd = new Audio(soundName); // buffers automatically when created
  snd.currentTime=0;
  snd.play();
}