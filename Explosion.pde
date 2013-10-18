/* This is heavily based on "Explode" by bettsina walkinson, licensed under Creative Commons Attribution-Share Alike 3.0 and GNU GPL license.
Work: http://openprocessing.org/visuals/?visualID=30940  
License: 
http://creativecommons.org/licenses/by-sa/3.0/
http://creativecommons.org/licenses/GPL/2.0/
*/
abstract class Explosion extends Song {
  PImage img;       // The source image
  int cellsize; // Dimensions of each cell in the grid
  float newCellSize;
  int columns, rows;   // Number of columns and rows in our system
  float minFactor;

  Smoothie smoothie, csmoothie;
  NoteRecorder recorder;
  float factor;
  float delta;
  
  float alpha;
  
  boolean isIntro;
  boolean fadeOut;
  AntiPuke antiPuke;

  Explosion() {
  }

  void setCellSize(int newSize) {
    cellsize = max(newSize, 3); 
    columns = img.width / cellsize;  // Calculate # of columns
    rows = img.height / cellsize;  // Calculate # of rows
  }

  abstract String getName();
  
  abstract void doImage();

  void on() {
    doImage();
    smoothie = new Smoothie(0.1);
    csmoothie = new Smoothie(0.6);
    recorder = new NoteRecorder();
    antiPuke = new AntiPuke(false);
    cellsize = 25;
    newCellSize = 25;
    factor = 3;
    delta = 0.5;
    alpha = 1;
    isIntro = true;
    fadeOut = false;
    minFactor = 3;
    setCellSize(cellsize);
  }

  void off() {
  }

  void noteOn(int channel, int pitch, int velocity) {
    float newFactor = velocity / 30.;
    factor = smoothie.get(newFactor);

    newCellSize = int(constrain(velocity / 5., 3, 25));
    recorder.on(pitch, velocity);
    
    if(isIntro && isAMajor()) { 
      isIntro = false;
      println("Intro is over, switch to main");
    }
  }

  void chronosData(PVector vec) {
    delta = max(0, map(csmoothie.get(vec.mag()), 30, 120, 0, 2));
  }
  
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

  void noteOff(int channel, int pitch, int velocity) {
    recorder.off(pitch);
  }

  void keyPressed(char key) {
    if(key == ' ') {
      println("now fading out ...");
      fadeOut = true;
    }
  }

  void draw() {    
    background(0);
    boolean canChangeColors = antiPuke.isSane();
    
    for ( int i = 0; i < columns; i++) {
      // Begin loop for rows
      for ( int j = 0; j < rows; j++) {
        int x = i*cellsize + cellsize/2;  // x position
        int y = j*cellsize + cellsize/2;  // y position
        int loc = x + y*img.width;  // Pixel array location
        color c = img.pixels[loc];  // Grab the color
        // Calculate a z position as a function of mouseX and pixel brightness
        float z = factor * brightness(img.pixels[loc]) - 20.0;
        // Translate to the location, set fill and stroke, and draw the rect
        // All that color-changing is a bit pukey, so wait a sane amount of time.
        if(canChangeColors) {
          c = color(hue(c) * random(1 - delta*2, 1 + delta*2), 
                saturation(c) * random(1 - delta, 1 + delta),
                brightness(c) * random(1 - delta, 1 + delta));
        }
        if(fadeOut) {
          c = color(hue(c), saturation(c), alpha * brightness(c));
        }

        pushMatrix();
        translate(x + 1, y + 30, z);
        fill(c, 204);
        noStroke();
        rectMode(CENTER);
        rect(0, 0, cellsize, cellsize);
        popMatrix();
      }
    }

    setCellSize(int(newCellSize));
   
    if(isIntro) {
      // as long as we are in the intro, don't get too small
      newCellSize = max(newCellSize * 0.95, 10);
      factor = max(factor * 0.95, minFactor);
    } else {
      factor *= 0.95;
      newCellSize *= 0.95;
      // slooowly decrease the delta
      delta *= 0.9999999;
    }
    if(fadeOut) {
      alpha *= 0.95;
    }
  }
}

