
// This function sets the gravity and y-velocity of the meat given
// the desired height of the bounce and the duration of the note
function meatBounce(period, height) {
  this.g = 8 * height / (period*period); // gravity
  this.vy = -this.g * period / 2; // y-velocity
  this.y = ground; // reset y-position to ground
};
