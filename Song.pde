abstract class Song {
  abstract void draw();
  
  abstract String getName();
  abstract void on();
  abstract void off();
  
  void chronosData(PVector vec) {
  }
  
  void noteOn(int channel, int pitch, int velocity) {};
  void noteOff(int channel, int pitch, int velocity) {};
  void controllerChange(int channel, int number, int value) {};
  void keyPressed(char key) {}
}
