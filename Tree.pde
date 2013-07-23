class Tree extends Song {
  int levelsMax = 8;
  float initialLength = 160;
  
  float angleMin = PI/24;
  float angleMax = PI/6;
  int pointColor = color(27, 25, 9);
  
  float currentAngle = 0;
  int currentLevels = 0;
  
  color back = color(255, 255, 255);
  float nextDec = 0;
  
  Smoothie smoothie;
  
  String getName() {
    return "Tree";
  }
  
  void on() {
    background(255);
  }
  void off() {}
  
  Tree() {
    smoothie = new Smoothie(10);
  }
  
  void chronosData(PVector vec) {
    currentAngle = map(smoothie.get(vec.x), -128, 127, angleMin, angleMax);
  }
  
  void simpleRecursiveTree (int levels, float length, float angle) {
    if (levels>0) {  //check if there are any levels left to render
      //first branch
      pushMatrix();           //save current transformation matrix
      rotate (angle);         //rotate new matrix to make it point to the right
      line (0, 0, 0, -length);   //draw line "upwards"
      pushMatrix();           //save current (e.g. new) matrix
      translate(0, -length);   //move the origin to the branch end
      scale (0.85f);          //scale down. fun fact - it scales down also the stroke weight!
      simpleRecursiveTree (levels-1, length, angle);  //call the recursive function again
      popMatrix();            //return to the matrix of the current line
      popMatrix();            //return to the original matrix
      //second branch - the same story
      pushMatrix();
      rotate (-angle);
      line (0, 0, 0, -length);
      pushMatrix();
      translate(0, -length);
      scale (0.85f);
      simpleRecursiveTree (levels-1, length, angle);
      popMatrix();
      popMatrix();
    }
  }
  
  public void draw() {
    stroke(pointColor);
    strokeWeight(3);
    background(back);
  
    if(liveSound.fft.calcAvg(0, 100) > 10 && currentLevels < levelsMax) {
      back = color(random(255), random(255), random(255), random(128));
      currentLevels++;
      nextDec = millis() + random(500, 1000);
    }
    
    if(millis() >= nextDec && currentLevels > 0) {
      nextDec = millis() + random(500, 1000);
      currentLevels--;
    }
  
    pushMatrix(); //save the world transformation matrix
    translate (width/2, height); //move the origin to the middle / bottom
    simpleRecursiveTree (currentLevels, initialLength, currentAngle); //draw first two branches - stems
    popMatrix(); //return to the world coordinate system
  }
}

