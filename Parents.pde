/*
  heavily based on:
  
  "Experimental Drops" by Roberto Cezar Bianchini, licensed under Creative Commons Attribution-Share Alike 3.0 and GNU GPL license.
  Work: http://openprocessing.org/visuals/?visualID= 103927  
  License: 
  http://creativecommons.org/licenses/by-sa/3.0/
  http://creativecommons.org/licenses/GPL/2.0/
*/

class Parents extends Song {
  int             MAX_NUMBER_OF_DROPS  = 50;
  ArrayList<Drop> drops;
  
  Smoothie smoothie;
  
  String getName() {
    return "Parents";
  }
   
  Parents() {
    drops        = new ArrayList<Drop>();
    smoothie = new Smoothie(10);
    background(0);
  }
  
  void on() {
  }
  
  void off() {
  }
  
  void draw() {
    background(0);
   
    for (int i = 0; i < drops.size(); i++) {
      drops.get(i).update();
      drops.get(i).render();
    }
     
    for (int i = 0; i < drops.size(); i++)
      if (drops.get(i).finished())
        drops.remove(i);
        
  }

  PVector lastMin = null, lastMax = null;
  float lastMinMS = 0;
  
  float maxR=0;
  
  void chronosData(PVector vec) {
    float mag = vec.mag();
    mag = smoothie.get(mag);
    maxR = max(maxR, mag);
    if(random(maxR*maxR) < mag*mag && drops.size() < MAX_NUMBER_OF_DROPS) {
      drops.add(new Drop(int(random(6)), random(2, 21), int(random(width)), int(random(height)), random(1, 2), random(2, 3)));
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

