import processing.video.*;

class Camera {
  Capture cam1;
  
  Camera() {
    println(Capture.list());
    cam1 = new Capture(applet, 320, 240, 15);
  }
  
  void start() {
    cam1.start();
  }
  
  void stop() {
    cam1.stop();
  }
}
