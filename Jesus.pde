class Jesus extends Explosion {
  Jesus() {
    super();
  }
  
  void on() {
    videos.loadJesus();
    videos.jesus.loop();
    super.on();
    isIntro = false;
  }
  
  void off() {
    videos.jesus.stop();
    videos.unloadJesus();
    super.off();
  }

  void setCellSize(int newSize) {
    cellsize = max(newSize, 5); 
    columns = img.width / cellsize;  // Calculate # of columns
    rows = img.height / cellsize;  // Calculate # of rows
  }
  
  void doImage() {
    img = videos.jesus;
  }
  
  void draw() {
    img.loadPixels();
    super.draw();
  }
  
  String getName() {
    return "Jesus";
  }
}

