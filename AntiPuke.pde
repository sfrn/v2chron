/* limit events to a certain framerate.
   call `isSane()` every frame, it returns a boolean. */
class AntiPuke {
  int waitFrames;
  int framesWaited = 0;
  
  AntiPuke(float waitSeconds) {
    waitFrames = int(frameRate * waitSeconds);
  }
  
  boolean isSane() {
    if(framesWaited >= waitFrames) {
      framesWaited = 0; 
      return true;
    } else {
      framesWaited++;
      return false;
    }
  }
} 
