PImage headImage;
PImage cdImage;

ArrayList<Song> songs;
Song song;
LiveSound liveSound;
BassMachine bassMachine;
Chronos chronos;
Camera camera;

PApplet applet;

void setup() {
  size(1024, 768);
  
  applet = this;

  camera = new Camera();  
  liveSound = new LiveSound();
  bassMachine = new BassMachine();
  chronos = new Chronos();
  
  headImage = loadImage("./Plane_Kopf600.png");
  headImage.resize(width, height);
  
  cdImage = loadImage("./cd.png");
  cdImage.resize(width, height);
  
  songs = new ArrayList<Song>();
  songs.add(new Times());
  songs.add(new Parents());
  songs.add(new Tree());
  
  song = songs.get(0);
  song.on();
  
  colorMode(HSB);
} 

void draw() {
  liveSound.step();
  chronos.step();
  song.draw();
}

void keyPressed() {
  if(key >= '0' && key <= '9') {
    int i = key - '1';
    if(songs.size() <= i) {
      println("Song "+i+" does not exist");
    } else {
      song.off();
      song = songs.get(i);
      song.on();
      println("Chose song "+i+" ("+song.getName()+")");
    }
  }
}

