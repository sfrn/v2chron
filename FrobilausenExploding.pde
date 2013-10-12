class FrobilausenExploding extends Song {
  PImage img;       // The source image
  int cellsize = 25; // Dimensions of each cell in the grid
  float newCellSize = 25;
  int columns, rows;   // Number of columns and rows in our system

  float easing = 0.1;
  float factor = 3;
  float delta = 0.01;

  int notes = 0;

  FrobilausenExploding() {
    img = duererImage;
    setCellSize(cellsize);
  }

  void setCellSize(int newSize) {
    cellsize = max(newSize, 3); 
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

    newCellSize = int(constrain(velocity / 5., 3, 25));
    //hasBegun = true;
    notes += 1;
  }

  void noteOff(int channel, int pitch, int velocity) {
    notes -= 1;
  }

  void keyPressed(char key) {
  }

  void draw() {
    delta = factor;    
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
        c = color(hue(c) * random(1 - delta, 1 + delta), 
        saturation(c), //* random(1 - delta, 1 + delta),
        brightness(c)); //* random(1 - delta, 1+ delta));

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

    factor *= 0.95;
    newCellSize *= 0.95;
  }
}

