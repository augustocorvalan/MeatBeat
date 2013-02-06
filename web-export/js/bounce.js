var screenWidth = 800, screenHeight = 600;
var lastT = 0;
var ground = screenHeight - 50;
var unitHeight = 300;
var bpm = 60;
var secondsPerBeat = 60 / bpm;

var ctx = document.createElement("canvas").getContext("2d");
document.body.appendChild(ctx.canvas);
ctx.canvas.width = screenWidth;
ctx.canvas.height = screenHeight;

var meat = {
  x: screenWidth / 2,
  y: ground,
  vy: 0,
  vx: 0,
  g: 0 // gravity, i.e. y-acceleration
};

meat.bounce = function(period, height) {
  this.g = 8 * height / (period*period);
  this.vy = -this.g * period / 2;

  this.y = ground; // reset y to ground to prevent drifting
};

meat.update = function(dt) {
  // Euler integration (should be changed to Verlet or something)
  this.vy += this.g * dt;
  this.y += this.vy * dt;
};

var beat = [ 1, 0.5, 0.5, 2 ];

/****************************************/


function update(dt) {
  meat.update(dt);
}

function draw(ctx) {
  ctx.clearRect(0,0, ctx.canvas.width, ctx.canvas.height);
  ctx.fillRect(meat.x - 15, meat.y - 15, 30, 30);
}

function loop() {
  var dt = Date.now() - lastT;
  lastT += dt;
  
  update(dt/1000);
  draw(ctx);
  
  setTimeout(loop, 1000 / 60); // 30 fps
}


function load() {
  var i = 0;
  function doBounce() {
    var period = beat[i] * secondsPerBeat;
    meat.bounce(period, beat[i] * unitHeight);
    setTimeout(doBounce, 1000*period);
    i = (i + 1) % beat.length;
  }

  lastT = Date.now();
  doBounce();
  loop();
}

load();