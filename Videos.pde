class Videos {
  Movie safran, affen, jesus, clue;
  
  Videos() {

    //affen = new Movie(applet, "affen.mp4");
    //jesus = new Movie(applet, "jesus.mp4");
  }
  
  void loadSafran() {
    safran = new Movie(applet, "s2.mp4");
  }
  
  void unloadSafran() {
    safran = null;
  }
  
  void loadJesus() {
    jesus = new Movie(applet, "j2.mp4");
  }
  
  void unloadJesus() {
    jesus = null;
  }
  
  void loadClue() {
    clue = new Movie(applet, "TheClue.mp4");
  }
  
  void unloadClue() {
    clue = null;
  }
  
  void movieEvent(Movie m) {
    m.read();
  }
}
