class Times extends Song {
  float threshold = 0.8;
  
  Times() {
  
  }
  
  String getName() {
    return "Times";
  }
  
  void chronosData(PVector vec) {
    threshold = (vec.x + 128) / 256.;
  }
  
  void draw() {
    if (cam1.available()) {
      cam1.read();
    }
    PImage im = cam1.get();
    
    im.resize(width, height);
    im.filter(THRESHOLD, threshold);
    tint(bassMachine.getColor());
    if(liveSound.fft.calcAvg(0, 100) > 20) {
      println("yes");
      im.blend(headImage, 0, 0, width, height,  0, 0, width, height, LIGHTEST);
    }
    image(im, 0, 0);
  }
}
