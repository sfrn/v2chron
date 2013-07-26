class Times extends Song {
  float threshold = 0.8;
  Smoothie smoothie;
  
  Times() {
    
  }
  
  String getName() {
    return "Times";
  }
  
  void on() {
    camera.start();
    smoothie = new Smoothie(3);
  }
  
  void off() {
    camera.stop();
  }
  
  void chronosData(PVector vec) {
  //  threshold = (smoothie.get(vec.x) + 128) / 256.;
    threshold = (vec.x + 128) / 256.;
  }
  
  void draw() {
    if (camera.cam1.available()) {
      camera.cam1.read();
    }
    PImage im = camera.cam1.get();
    
    im.resize(width, height);
    im.filter(THRESHOLD, threshold);
    tint(bassMachine.getColor());
    /*if(liveSound.fft.calcAvg(0, 100) > 20) {
      im.blend(headImage, 0, 0, width, height,  0, 0, width, height, LIGHTEST);
    }*/
    image(im, 0, 0);
  }
}
