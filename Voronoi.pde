class Particle
{
  float x, y;
  color c;
  PVector vel;

  Particle(float maxSpeed)    // constructor
  {
    x = random(width);
    y = random(height);
    c = color(random(64, 228), random(128, 192), random(128, 255));
    vel = new PVector(random(-maxSpeed, maxSpeed), random(-maxSpeed, maxSpeed));
  }
  
  void accelerate(float xx, float yy) {
    float sx = Math.signum(vel.x);
    float sy = Math.signum(vel.y);
    vel.x += sx * xx;
    vel.y += sy * yy;
  }

  void move()   // move and bounce
  {
    x += vel.x;
    y += vel.y;
    if ((x<0) || (x>width))  vel.x *= -1;
    if ((y<0) || (y>height)) vel.y *= -1;
  }
}

class Voronoi extends Song {
  Particle[] dots;
  int dotSize = 4;
  int maxDots = 32;
  int animDots = 8;
  float maxSpeed = 4.2;
  float start = 0;

  Voronoi() {
  }

  String getName() {
    return "Voronoi";
  }

  void draw() {
    drawRegions();
    moveDots();
  }

  void on() {
    dots = new Particle[maxDots];
    for (int i=0; i<maxDots; i++)   dots[i] = new Particle(maxSpeed);
    start = millis();
    animDots = 32;
    colorizeDots (24);  // transparent
  }

  void off() {
  }

  //-----------------------------------------------------------
  void moveDots()
  {
    for (int i=0; i<animDots; i++) {
      dots[i].move();
      dots[i].vel.x *= 0.95;
      dots[i].vel.y *= 0.95;
    }
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    float amount = map(velocity / 30., 0, 4.2, 1, 3);
    for(int i = 0; i < maxDots; i++) {
      dots[i].accelerate(random(amount), random(amount));
    }
  }
  
  //-----------------------------------------------------------
  void colorizeDots(int transparency)
  {
    for (int i=0; i<maxDots; i++)
      dots[i].c = color(random(64, 228), random(128, 192), random(128, 255), transparency);
  }

  void drawRegions()
  {
    int pixelOffset = 0;
    float dx, dy, d = 0;
    loadPixels(); // must call before using pixels[]

    for (int y=0; y<height; y++)
    {
      for (int x=0; x<width; x++)
      {
        float minDist = 1E12;
        int closest = 0;
        for (int i=0; i<animDots; i++)
        {
          Particle p = dots[i];

          dx = sq(p.x - x);
          if (dx < minDist)
          { 
            dy = sq(p.y - y);
            if (dy < minDist)
            {
              d = dx+dy;
              if (d < minDist)
              {
                closest = i;
                minDist = d;
              }
            }
          }
        }
        // pixels[] is about 10x faster as point(x,y) 
        pixels[pixelOffset] = dots[closest].c;
        //      pixels[pixelOffset] = dots[closest].c*int(sqrt(minDist))/100000;
        pixelOffset++;
      }
    }
    updatePixels(); // display picture
  }
}

