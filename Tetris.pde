class Tetris extends Song {
  Tetris() {
  }
  
  void on() {
    open(new String [] { sketchPath("tetris") });
  }
  
  void off() {
    open(new String [] { sketchPath("killtetris") });
  }
  
  void draw() {
    background(0);
  }
  
  String getName() {
    return "Tetris";
  }
}
