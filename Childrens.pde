/*
  heavily based on:
  
  "Experimental Drops" by Roberto Cezar Bianchini, licensed under Creative Commons Attribution-Share Alike 3.0 and GNU GPL license.
  Work: http://openprocessing.org/visuals/?visualID= 103927  
  License: 
  http://creativecommons.org/licenses/by-sa/3.0/
  http://creativecommons.org/licenses/GPL/2.0/
*/

class Childrens extends Song {
  int             MAX_NUMBER_OF_DROPS  = 50;
  ArrayList<Drop> drops;
  NoteRecorder recorder;
  
  int state;
  final int S_NORMAL = 1;
  final int S_DROP = 2;
  
  final float DEFAULT_BG = 0.1;
  final float BG_MULT = 1.1;
  float bg;
  
  String getName() {
    return "Childrens";
  }
   
  Childrens() {
    drops        = new ArrayList<Drop>();
    background(0);
  }
  
  void on() {
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
        println("pitch " + pitch + " velo " + velocity + " ==> radius speed " + radiusSpeed + " radius "+ radius); 
        drops.add(new Drop(int(random(6)), radius, int(random(width)), int(random(height)), radiusSpeed, alphaSpeed));
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
 
 
class Drop {
  // Note about shapes:
  // 0 => Circle, defaultShape
  // 1 => Rectangle
  // 2 => Triangle
 
  int   shape;
  int   px, py;
  float radius;
  float radiusSpeed, fillAlphaSpeed, strokeAlphaSpeed;
  float red, green, blue, fillAlpha, strokeAlpha;
  float cos30;
  
  public Drop(int _shape, float _radius, int _px, int _py, float _radiusSpeed, float alphaSpeed) {
    shape            = _shape;
    radius           = _radius;
    px               = _px;
    py               = _py;
    radiusSpeed      = _radiusSpeed;
    fillAlphaSpeed   = alphaSpeed;
    strokeAlphaSpeed = 0.7F * alphaSpeed;
    fillAlpha        = 255;
    strokeAlpha      = 255;
    cos30            = radians(30);
 
    if (radius <= 5) {
      red   = map(_py, height, 0, 0, 255);
      green = random(0, 255);
      blue  = map(_px, width, 0, 0, 255);     
    } else if (radius > 5 && radius <= 15) {
      red   = random(0, 255);
      green = map(_px, width, 0, 0, 255);
      blue  = map(_py, height, 0, 0, 255);
    } else {
      red   = map(_px, width, 0, 0, 255);
      green = map(_py, height, 0, 0, 255);
      blue  = random(0, 255);
    }
  }
   
  public boolean finished() { return strokeAlpha < 0; }
 
   
  public void update() {
    radius      += radiusSpeed;
    fillAlpha   -= fillAlphaSpeed;
    strokeAlpha -= strokeAlphaSpeed;
  }
 
 
  public void render() {
    stroke(red, green, blue, strokeAlpha);
    strokeWeight(3);
    fill(red, green, blue, fillAlpha);
     
    // I hate magic numbers, but that will have to do for now
    switch (shape) {
      // CIRCLE
      case 0:  
        ellipse(px, py, radius, radius); 
      break;
       
      // RECTANGLE
      case 1:  
        rectMode(CENTER);
        rect(px, py, radius, radius);
      break;
 
      // TRIANGLE
      // Note: the vertices of the equilateral triangle are calculated using some relations between
      //       the apothem position and the circle on which the triangle is inscribed.
      // Reference: http://www.vitutor.com/geometry/plane/equilateral_triangle.html
      case 2:  
        triangle(px + radius * cos30, py + radius * 0.5F,
                 px, py - radius * 0.5F,
                 px - radius * cos30, py + radius * 0.5F);
        break;
      default:
         int sides = shape + 2; 
         beginShape();
         float fx = 0, fy = 0;
         for(int i = 0; i<sides ; i++) {
           if(i == 0) {
             fx = px + sin(TWO_PI/sides*i) * radius;
             fy = py + cos(TWO_PI/sides*i) * radius;
           }
           vertex(px + sin(TWO_PI/sides*i) * radius, py + cos(TWO_PI/sides*i) * radius);
         }
         vertex(fx, fy);
         endShape();
    }
  }

}

