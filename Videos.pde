class Videos {
  Movie safran, affen, jesus;
  
  Videos() {
    safran = new Movie(applet, "safran.mp4");
    affen = new Movie(applet, "affen.mp4");
    jesus = new Movie(applet, "jesus.mp4");
  }
  
  void movieEvent(Movie m) {
    m.read();
  }
}
