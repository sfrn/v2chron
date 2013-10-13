/*
  heavily based on:
  
  "Experimental Drops" by Roberto Cezar Bianchini, licensed under Creative Commons Attribution-Share Alike 3.0 and GNU GPL license.
  Work: http://openprocessing.org/visuals/?visualID= 103927  
  License: 
  http://creativecommons.org/licenses/by-sa/3.0/
  http://creativecommons.org/licenses/GPL/2.0/
*/

abstract class DropSong extends Song {
  int             MAX_NUMBER_OF_DROPS  = 50;
  ArrayList<Drop> drops;
  NoteRecorder recorder;
  
  int state;
  final int S_NORMAL = 1;
  final int S_DROP = 2;
  
  final float DEFAULT_BG = 0.1;
  final float BG_MULT = 1.1;
  float bg;
  
  abstract String getName();
  abstract Drop getDrop(int _shape, float _radius, int _px, int _py, float _radiusSpeed, float alphaSpeed);
   
  DropSong() {

  }
  
  void on() {
    drops        = new ArrayList<Drop>();
    background(0);
    recorder = new NoteRecorder();
    state = S_NORMAL;
  }
  
  void off() {
  }
  
  void draw() {
    switch(state) {
      case S_NORMAL:
        background(0);
        break;
        
      case S_DROP:
        bg *= BG_MULT;
        background(bg);
        break;
    }
    
    for (int i = 0; i < drops.size(); i++) {
      drops.get(i).update();
      drops.get(i).render();
    }
     
    for (int i = 0; i < drops.size(); i++)
      if (drops.get(i).finished())
        drops.remove(i);
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    if(state == S_DROP) {
      println("state changed to normal");
      state = S_NORMAL;
    } else {
      //recorder.on(pitch, velocity);
      if(drops.size() < MAX_NUMBER_OF_DROPS) {
        /*
        Pitches: C4 = 60
                 C2 = 36
                 C6 = 84
        */
        // the deeper, the slower
        float radiusSpeed = map(pitch, 36, 84, 0.5, 2.5);
        float alphaSpeed = map(pitch, 36, 84, 1.5, 3.5);
        // the louder, the bigger
        float radius = map(velocity, 0, 100, 2, 30);
        //println("pitch " + pitch + " velo " + velocity + " ==> radius speed " + radiusSpeed + " radius "+ radius); 
        drops.add(getDrop(int(random(6)), radius, int(random(radius, width - radius)), int(random(radius, height - radius)), radiusSpeed, alphaSpeed));
      }
    }
  }
  
  void noteOff(int channel, int pitch, int velocity) {
   // recorder.off(pitch);
  }
  
  void keyPressed(char key) {
    if(key == ' ' && state == S_NORMAL) {
      println("state change to drop");
      state = S_DROP;
      bg = DEFAULT_BG;
    }
  }
}
 
 
abstract class Drop {
  abstract boolean finished();
  abstract void update();
  abstract void render();
}


