/* borrowed from *@*http://www.openprocessing.org/sketch/95861*@* */
import java.util.Set;
import java.util.ConcurrentModificationException;

class Times extends Song {
  String[] letters = {"H", "E", "I", "M", "A", "T"};  
  int startseconds;
  int numRows;
  int numCols;
  int[][] squareYs;
  String[][] rectletters;
  int[] rows;
  int squareSize = 50;
  int currentI;
  int currentJ;
  int lastFrame = 0;
  float lastShuffle = 0;
  float minShuffleTime = 100;
  boolean done = false;
  Smoothie smoothie;

  String getName() {
    return "Times";
  }

  void on() {
    done = false;
    numRows = 6;
    numCols = (int)floor(width / squareSize) - 1;
    rectletters = new String[numCols][numRows];
    rows = new int[numCols];
    squareYs = new int[numCols][numRows];
    smoothie = new Smoothie(0.3);
    for (int i = 0; i < numCols; i++) {
      for (int j = 0; j < numRows; j++) {
        //set the ypositions to the starting ones.
        squareYs[i][j] = j*(squareSize + 5);
        rectletters[i][j] = letters[(j * numCols + i) % letters.length];
      }
      rows[i] = numRows - 1;
    }
    currentI = (int)random(numCols);
    lastFrame = millis();
  }
  
  void off() {

  }
  
  void chronosData(PVector vec) {
    double value = smoothie.get(vec.mag());
    if(value > 100) {
      if(millis() - lastShuffle > minShuffleTime) {
        for (int i = 0; i < numCols; i++) {
          for (int j = 0; j < numRows; j++) {
            //set the ypositions to the starting ones.
            rectletters[i][j] = letters[(int)(random(letters.length))];
          }
        }
        lastShuffle = millis();
      }
    }
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
      int currentJ = rows[currentI];
      if(currentJ >= 0) {
        squareYs[currentI][currentJ] += (200 / 5 * deltaT);
        int endY = currentJ*(squareSize + 5) + 200;
        if (squareYs[currentI][currentJ] >= endY) {
          squareYs[currentI][currentJ] = endY;
          rows[currentI]--;
          currentI = (int)random(numCols);
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
        int x = (i * (squareSize+5));
        int y = squareYs[i][j];
        rect(x, y, squareSize, squareSize);
        fill(255);
        text(rectletters[i][j], x+squareSize/2, y+squareSize - 8);
      }
    }
  }

}
