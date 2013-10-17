class VideoExploding extends Explosion {
  VideoExploding() {
    super();
  }
  
  void on() {
    videos.loadSafran();
    videos.safran.loop();
    super.on();
    isIntro = false;
    //minFactor = 1;
  }
  
  void off() {
    videos.safran.stop();
    videos.unloadSafran();
    super.off();
  }

  void setCellSize(int newSize) {
    cellsize = max(newSize, 3); 
    columns = img.width / cellsize;  // Calculate # of columns
    rows = img.height / cellsize;  // Calculate # of rows
  }
  
  void doImage() {
    img = videos.safran;
  }
  
  void draw() {
    img.loadPixels();
    super.draw();
  }
  
  String getName() {
    return "Safran Exploding";
  }
}

