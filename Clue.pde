class Clue extends Song {
  Clue() {
    super();
    videos.loadClue();
  }
  
  void on() {
    videos.clue.loop();
  }
  
  void off() {
    videos.clue.stop();
  }

  void draw() {
    image(videos.clue, 0, 0, width, height);
  }
  
  String getName() {
    return "Clue";
  }
}
