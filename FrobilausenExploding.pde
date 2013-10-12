class FrobilausenExploding extends Song {
  PImage img;       // The source image
  int cellsize = 3; // Dimensions of each cell in the grid
  int columns, rows;   // Number of columns and rows in our system
  
  float easing = 0.1;
  float factor = 0;

  FrobilausenExploding() {
    img = cdImage;
    columns = img.width / cellsize;  // Calculate # of columns
    rows = img.height / cellsize;  // Calculate # of rows
  }
  
  String getName() {
    return "Frobilausen Exploding";
  }
  
  void on() {

  }
  
  void off() {

  }
  
  void noteOn(int channel, int pitch, int velocity) {
    float newFactor = velocity / 30.;
    factor += (newFactor - factor) * easing;
  }
  
  void noteOff(int channel, int pitch, int velocity) {
    /*float newFactor = velocity / 80.;
    factor += (newFactor - factor) * easing;*/ 
  }
  
  void draw() {
    for ( int i = 0; i < columns; i++) {
      // Begin loop for rows
      for ( int j = 0; j < rows; j++) {
        int x = i*cellsize + cellsize/2;  // x position
        int y = j*cellsize + cellsize/2;  // y position
        int loc = x + y*img.width;  // Pixel array location
        color c = img.pixels[loc];  // Grab the color
        // Calculate a z position as a function of mouseX and pixel brightness
        float z = 1 * (factor * brightness(img.pixels[loc]) - 20.0);
        // Translate to the location, set fill and stroke, and draw the rect
        pushMatrix();
        translate(x + 1, y + 30, z);
        fill(c, 204);
        noStroke();
        rectMode(CENTER);
        rect(0, 0, cellsize, cellsize);
        popMatrix();
      }
    }
    factor *= 0.94;
  }
}
