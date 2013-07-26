import java.util.Map;

class NoteRecorder {
  HashMap<Integer, Integer> notes;
  float averagePitch, averageVelocity;
  int bassNotes;
  
  final int BASS_THRESHOLD = 48; // < C3
  
  NoteRecorder() {
    notes = new HashMap<Integer, Integer>();
    bassNotes = 0;
  }
  
  void calcAveragePitch() {
    int num = size();
    if(num > 0) {
      int pitches = 0, velocities = 0;
      for(Integer k: notes.keySet()) { // TODO: optimization?
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
    if(pitch <= BASS_THRESHOLD)
      bassNotes++;
  }
  
  void off(int pitch) {
    notes.remove(pitch);
    calcAveragePitch();
    if(pitch <= BASS_THRESHOLD)
      bassNotes--;
  }
  
  int size() {
    return notes.size();
  }
}
