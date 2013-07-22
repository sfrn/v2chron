import processing.video.*;

PImage headImage;
PImage cdImage;

Capture cam1;
Song song;
LiveSound liveSound;
BassMachine bassMachine;
Chronos chronos;

PApplet applet;

void setup() {
  size(1024, 768);
  println(Capture.list());
  applet = this;
  
  song = new Times();
  
  cam1 = new Capture(this, 320, 240, 15);
  cam1.start();
  
  liveSound = new LiveSound();
  bassMachine = new BassMachine();
  chronos = new Chronos();
  
  headImage = loadImage("./Plane_Kopf600.png");
  headImage.resize(width, height);
  
  cdImage = loadImage("./cd.png");
  cdImage.resize(width, height);
 
  colorMode(HSB);
} 

void draw() {
  liveSound.step();
  chronos.step();
  song.draw();
}

