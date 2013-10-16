class VideoExploding extends Explosion {
  VideoExploding() {
    super();
  }
  
  void on() {
    videos.loadSafran();
    videos.safran.loop();
    super.on();
    isIntro = false;
  }
  
  void off() {
    videos.safran.stop();
    videos.unloadSafran();
    super.off();
  }
  
  void doImage() {
    img = videos.safran;
  }
  
  void draw() {
    img.loadPixels();
    super.draw();
  }
  
  String getName() {
    return "Video Exploding";
  }
}

