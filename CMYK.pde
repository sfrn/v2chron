class CMYK extends Song {
  CMYK() {
    super();
  }
  
  void on() {
  }
  
  void off() {
  }

  void draw() {
    int rectwidth = width/3;
    noStroke();
    fill(#fcee2d);
    rect(0, 0, rectwidth, height);
    fill(#e6178b);
    rect(width/3, 0, rectwidth, height);
    fill(#05adeb);
    rect(2*width/3, 0, rectwidth, height);
  }
  
  String getName() {
    return "CMYK";
  }
}
