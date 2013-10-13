import java.util.Set;
import java.util.ConcurrentModificationException;

class Times extends Song {
  float threshold = 0.8;
  Smoothie smoothie;
  NoteRecorder recorder;
  
  float factor = 1.0;
  boolean hadAMajor = false;
  
  Times() {
    
  }
  
  String getName() {
    return "Times";
  }
  
  void on() {
    camera.start();
    smoothie = new Smoothie(0.15);
    recorder = new NoteRecorder();
    factor = 1.0;
  }
  
  void off() {
    camera.stop();
  }
  
  void chronosData(PVector vec) {
    threshold = map((smoothie.get(vec.x) + 128) / 256., 0, 1, .1, 1) * factor;
    //threshold = map((vec.x + 128) / 256., 0, 1, .1, 1);
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    recorder.on(pitch, velocity);
  }
  
  void noteOff(int channel, int pitch, int velocity) {
    recorder.off(pitch);
  }
  
  final float BASS_THRESHOLD = 0.7;
  color col;
      
  boolean isAMajor() {
    boolean a=false, cis=false, e=false;
    for(Integer note : recorder.notes.keySet()) { // TODO: optimization?
      switch(note % 12) {
        case 9: // A
          a = true;
          break;
        case 1: // C#
          cis = true;
          break; 
        case 4: // E
          e = true;
          break;
        default:
          return false;
      }
    }
    return a && cis && e;
  }
  
  float lastBassNotes = MAX_INT;
  
  float INCREASE = 0.02;
  
  void draw() {
    if (camera.cam1.available()) {
      camera.cam1.read();
      // workaround for https://github.com/processing/processing/issues/1852.html
      camera.cam1.loadPixels();
    }
    PImage im = camera.cam1.get();
    
    im.resize(width, height);
    im.filter(THRESHOLD, threshold);
    
    // ending detector
    boolean isA = false;
    try {
      isA = isAMajor();
    } catch (ConcurrentModificationException e) {
      println("Ignored ConcurrentModification");
    }
    if(isA) {
      //factor *= 0.99;
      if(!hadAMajor) println("A detected ...");
      factor += INCREASE;
      hadAMajor = true;
    } else if(hadAMajor) {
      factor -= INCREASE;
      if(abs(factor - 1) < 0.01) {
        factor = 1.0;
        hadAMajor = false;
        println("Back to reality.");
      } 
    }
        
    float val = 0;
    if(recorder.bassNotes > 0) {
      val = map(recorder.bassNotes * recorder.averageVelocity, 0, recorder.bassNotes * 127, 0, 1);
      if(recorder.bassNotes < lastBassNotes) {
        val = 0;
        lastBassNotes = recorder.bassNotes;
      } 
    }
    tint(bassMachine.getColor(val));
    if(val >= BASS_THRESHOLD) {
      im.blend(headImage, 0, 0, width, height,  0, 0, width, height, LIGHTEST);
    }
    image(im, 0, 0);
  }
}
