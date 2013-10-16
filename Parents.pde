class Parents extends DropSong {
  boolean gain;
  int red, green, blue;

  Parents() {
    super();
  }

  void on() {
    super.on();
    gain = false;
    red = 255;
    green = 255;
    blue = 255;
  }

  String getName() {
    return "Parents";
  }

  Drop getDrop(int _shape, float _radius, int _px, int _py, float _radiusSpeed, float alphaSpeed) {
    return new ParentsDrop(this, _shape, _radius, _px, _py, _radiusSpeed, alphaSpeed);
  }

  void noteOn(int channel, int pitch, int velocity) {
    //recorder.on(pitch, velocity);
    if (drops.size() < MAX_NUMBER_OF_DROPS) {
      /*
        Pitches: C4 = 60
       C2 = 36
       C6 = 84
       */
      // the deeper, the slower
      float radiusSpeed = map(pitch, 36, 84, 0.5, 1);
      float alphaSpeed = map(pitch, 36, 84, 1, 1.5);
      // the louder, the bigger
      float radius = map(velocity, 0, 100, 50, 100);
      //println("pitch " + pitch + " velo " + velocity + " ==> radius speed " + radiusSpeed + " radius "+ radius); 
      drops.add(getDrop(int(random(10)), radius, int(random(radius, width - radius)), int(random(radius, height - radius)), radiusSpeed, alphaSpeed));
    }
  }

  void doDrop() {
    gain = true;
  }

  void draw() {
    super.draw();
    if (gain) {
      red *= 0.999;
       green *= 0.999;
       blue *= 0.999;
    }
  }
}

class ParentsDrop extends Drop {

  int   shape;
  int   px, py;
  float radius;
  float radiusSpeed, fillAlphaSpeed, strokeAlphaSpeed;
  float red, green, blue, fillAlpha, strokeAlpha;
  float cos30;

  boolean knall = false;
  Parents parents;

  public ParentsDrop(Parents _parent, int _shape, float _radius, int _px, int _py, float _radiusSpeed, float alphaSpeed) {
    parents = _parent;
    shape            = _shape;
    radius           = _radius;
    px               = _px;
    py               = _py;
    radiusSpeed      = _radiusSpeed;
    fillAlphaSpeed   = alphaSpeed;
    strokeAlphaSpeed = 0.7F * alphaSpeed;
    fillAlpha        = 0;
    strokeAlpha      = 0;
    cos30            = radians(30);
  }

  public boolean finished() { 
    return radius < 3;
  }


  public void update() {
    if (parents.gain) {
      radius += radiusSpeed * 1.5;
    } 
    else {
      radius      -= radiusSpeed;
    }
    fillAlpha   += fillAlphaSpeed;
    strokeAlpha += strokeAlphaSpeed;
  }


  public void render() {
    colorMode(RGB);
    //stroke(red, green, blue, strokeAlpha);
    strokeWeight(0);
    fill(parents.red, parents.green, parents.blue, fillAlpha);

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
      /* case 2:  
       triangle(px + radius * cos30, py + radius * 0.5F,
       px, py - radius * 0.5F,
       px - radius * cos30, py + radius * 0.5F);
       break;*/
      // NO TRIANGLES BECAUSE WE HATE TRIANGLES
    default:
      int sides = shape + 2; 
      beginShape();
      float fx = 0, fy = 0;
      for (int i = 0; i<sides ; i++) {
        if (i == 0) {
          fx = px + sin(TWO_PI/sides*i) * radius;
          fy = py + cos(TWO_PI/sides*i) * radius;
        }
        vertex(px + sin(TWO_PI/sides*i) * radius, py + cos(TWO_PI/sides*i) * radius);
      }
      vertex(fx, fy);
      endShape();
    }
    colorMode(HSB);
  }
}

