import java.util.Map;

class NoteRecorder {
  HashMap<Integer, Integer> notes;
  float averagePitch, averageVelocity;
  
  NoteRecorder() {
    notes = new HashMap<Integer, Integer>();
  }
  
  void calcAveragePitch() {
    int num = size();
    if(num > 0) {
      int pitches = 0, velocities = 0;
      for(Integer k: notes.keySet()) {
        pitches += k;
        velocities += notes.get(k);
      }
      averagePitch = pitches / num;
      averageVelocity = velocities / num;
    } else {
      averagePitch = 0;
      averageVelocity = 0;
    } 
  }
  
  void on(int pitch, int velocity) {
    notes.put(pitch, velocity);
    calcAveragePitch();
  }
  
  void off(int pitch) {
    notes.remove(pitch);
    calcAveragePitch();
  }
  
  int size() {
    return notes.size();
  }
}
