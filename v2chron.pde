PImage headImage;
PImage cdImage;
PImage duererImage;
PImage qrCode;

ArrayList<Song> songs;
Song song;
LiveSound liveSound;
BassMachine bassMachine;
Chronos chronos;
Camera camera;
Midi midi;
Videos videos;

float FPS = 25;

PApplet applet;

void setup() {
  size(1024, 768, P3D);

  frameRate(FPS);
  
  applet = this;

  camera = new Camera();  
  liveSound = new LiveSound();
  bassMachine = new BassMachine();
  chronos = new Chronos();
  midi = new Midi();
  videos = new Videos();
  
  qrCode = loadImage("./qrcode.png");
  
  headImage = loadImage("./Plane_Kopf600.png");
  headImage.resize(width, height);
  
  cdImage = loadImage("./cd.png");
  cdImage.resize(width, height);
  
  duererImage = loadImage("./Duererfrei.png");
  //duererImage.resize(width, height);
  //duererImage.filter(GRAY);
  
  songs = new ArrayList<Song>();
  songs.add(new Nix());
  songs.add(new FrobilausenExploding());
  songs.add(new Childrens());
  songs.add(new Parents());
  songs.add(new VideoExploding());
  songs.add(new Tetris());
  songs.add(new Jesus());
  songs.add(new QRCode());
  
  printSongs();
  song = songs.get(0);
  song.on();
  
  colorMode(HSB);
}

void printSongs() {
  for(int i = 0; i < songs.size(); i++) {
    println("{" + (i+1) + "} " + songs.get(i).getName());
  }
}

void movieEvent(Movie m) {
  videos.movieEvent(m);
}

void draw() {
//  liveSound.step();
  chronos.step();
  song.draw();
}

void chooseSong(int i) {
  if(songs.size() <= i) {
    println("Song "+(i+1)+" does not exist");
  } else {
    song.off();
    song = songs.get(i);
    song.on();
    println("Chose song "+(i+1)+" ("+song.getName()+")");
  }
}

void keyPressed() {
  if(key >= '0' && key <= '9') {
    int i = key - '1';
    chooseSong(i);
  } else {
    song.keyPressed(key);
  }
}

