import java.util.HashSet;

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
  float lastBack = 0;
  
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
    notes = new HashSet<Integer>();
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
  
  int MIN_PITCH = 0;
  int MAX_PITCH = 46;
  int MIN_VELOCITY = 64;
  int MIN_CHANGE = 400;
  
  HashSet<Integer> notes;
  
  void noteOn(int channel, int pitch, int velocity) {
    if(pitch >= MIN_PITCH && pitch <= MAX_PITCH && velocity > MIN_VELOCITY) {
      if(millis() >= lastBack + MIN_CHANGE) {
        back = color(random(255), random(255), random(255), random(128));
        lastBack = millis();
      }
      if(currentLevels < levelsMax) {
        currentLevels++;
        nextDec = millis() + random(500, 1000);
      } 
    }
    notes.add(pitch);
  }
  
  void noteOff(int channel, int pitch, int velocity) {
    notes.remove((Integer)pitch);
  }
    
  public void draw() {
    stroke(pointColor);
    strokeWeight(3);
    background(back);
  
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

