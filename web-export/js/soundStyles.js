
function playSound(soundName) {
  var snd = new Audio(soundName); // buffers automatically when created
  snd.play();
}
