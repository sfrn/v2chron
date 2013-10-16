class Videos {
  Movie safran, affen, jesus;
  
  Videos() {

    //affen = new Movie(applet, "affen.mp4");
    //jesus = new Movie(applet, "jesus.mp4");
  }
  
  void loadSafran() {
    safran = new Movie(applet, "jesus.mp4");
  }
  
  void unloadSafran() {
    safran = null;
  }
  
  void movieEvent(Movie m) {
    m.read();
  }
}
