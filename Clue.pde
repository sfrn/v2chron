class Clue extends Song {
  Clue() {
    super();
  }
  
  void on() {
    videos.loadClue();
    videos.clue.loop();
  }
  
  void off() {
    videos.clue.stop();
    videos.unloadClue();
  }

  void draw() {
    image(videos.clue, 0, 0);
  }
  
  String getName() {
    return "Clue";
  }
}
