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
  float fps = 0;
  boolean showDots = true;
  boolean showFPS = true;
  boolean showPsycho = false;

  Voronoi() {
  }

  String getName() {
    return "Voronoi";
  }

  void draw() {
    drawRegions();
    if (showDots) drawDots();
    if (!mousePressed) moveDots();  // pause animation
  }

  void on() {
    dots = new Particle[maxDots];
    for (int i=0; i<maxDots; i++)   dots[i] = new Particle(maxSpeed);
    start = millis();
    swapMode();
  }

  void off() {
  }

  void drawDots()
  {
    for (int i=0; i<animDots; i++)
    {
      Particle s = dots[i];
      fill(s.c, 128);
      stroke(66);
      ellipse(s.x, s.y, dotSize, dotSize);
    }
  }
  //-----------------------------------------------------------
  void moveDots()
  {
    for (int i=0; i<animDots; i++)
      dots[i].move();
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
  //-----------------------------------------------------------
  void swapMode()
  {
    showPsycho = !showPsycho;
    showDots = !showPsycho;
    showFPS = !showPsycho;
    if (showPsycho)
    {
      animDots = 32;
      colorizeDots (24);  // transparent
    }
    else
    {
      animDots = 8;
      colorizeDots (255);  // opaque
    }
    frameCount = 1;
    start = millis();
  }
}

