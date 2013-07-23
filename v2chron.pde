import processing.video.*;

PImage headImage;
PImage cdImage;

Capture cam1;
ArrayList<Song> songs;
Song song;
LiveSound liveSound;
BassMachine bassMachine;
Chronos chronos;

PApplet applet;

void setup() {
  size(1024, 768);
  println(Capture.list());
  applet = this;

  
  cam1 = new Capture(this, 320, 240, 15);
  cam1.start();
  
  liveSound = new LiveSound();
  bassMachine = new BassMachine();
  chronos = new Chronos();
  
  headImage = loadImage("./Plane_Kopf600.png");
  headImage.resize(width, height);
  
  cdImage = loadImage("./cd.png");
  cdImage.resize(width, height);
  
  songs = new ArrayList<Song>();
  songs.add(new Times());
  
  song = songs.get(0);
  
  colorMode(HSB);
} 

void draw() {
  liveSound.step();
  chronos.step();
  song.draw();
}

void keyPressed() {
  if(key >= '0' && key <= '9') {
    int i = key - '0';
    if(songs.size() <= i) {
      println("Song "+i+" does not exist");
    } else {
      song = songs.get(i);
      println("Chose song "+i+" ("+song.getName()+")");
    }
  }
}

