/* borrowed from *@*http://www.openprocessing.org/sketch/95861*@* */
import java.util.Set;
import java.util.ConcurrentModificationException;

class Times extends Song {
  String[] letters = {"T", "I", "M", "E", "S"};  
  int startseconds;
  int numRows = 6;
  int numCols = 10;
  int[][] squareYs = new int[numCols][numRows];
  String[][] rectletters = new String[numCols][numRows];
  int squareSize = 50;
  int currentI = 9;
  int currentJ = 5;
  int lastFrame = 0;
  boolean done = false;

  String getName() {
    return "Times";
  }

  void on() {
    done = false;
    currentI = 9;
    currentJ = 5;
    for (int i = 0; i < numCols; i++) {
      for (int j = 0; j < numRows; j++) {
        //set the ypositions to the starting ones.
        squareYs[i][j] = j*(squareSize + 5);
        rectletters[i][j] = letters[int(random(letters.length))];
      }
    }
  }
  
  void off() {

  }

  void draw() {
    background(255);
    rectMode(CORNER);
    int now = millis();
    float deltaT = (float)(now - lastFrame) / 1000;
    lastFrame = now;
    int mspassed = now - startseconds;
    //keep track of time.
    if (mspassed >= 1000) {
      //a second has passed.
      startseconds = now;
    }

    if (!done) {
      //make the current rectangle fall
      squareYs[currentI][currentJ] += (200 / 5 * deltaT);
      int endY = currentJ*(squareSize + 5) + 200;
      if (squareYs[currentI][currentJ] >= endY) {
        squareYs[currentI][currentJ] = endY;
        currentJ--;
        if (currentJ < 0) {
          currentI--;
          if (currentI < 0) {
            done = true;
          }
          currentJ = 5;
        }
      }
    }

    textAlign(CENTER);
    textSize(squareSize * 0.9);
    //draw all the rectangles
    for (int i = 0; i < numCols; i++) {
      for (int j = 0; j < numRows; j++) {
        //set the ypositions to the starting ones.
        fill(0);
        noStroke();
        int x = 150 + (i * (squareSize+5));
        int y = squareYs[i][j];
        rect(x, y, squareSize, squareSize);
        fill(255);
        text(rectletters[i][j], x+squareSize/2, y+squareSize - 8);
      }
    }
  }

}
