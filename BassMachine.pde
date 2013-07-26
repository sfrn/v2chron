class BassMachine {
  float avgValue = 0, h = 0, s = 0, b = 0;
  float prev = 0;
 
  void drawFreqBackground(float average) {
    if(average != prev) {
      //if(avgValue == 0) avgValue = average;
      //else avgValue = avgValue * 1.1;
      if(average != 0) {
        avgValue = average;
      }
      prev = average;
    }
   //fill(h, s, map(avgValue, 0, 100, 0, 255), 128);
    h = (h + 0.5) % 255;
    s = (125 + ((s + 0.5) % 125));
    avgValue *= 0.95;
  }
  
  color getColor(float avg) {
    drawFreqBackground(avg);
    return color(h, map(avgValue, 0, 1, 0, 255), map(avgValue, 0, 1, 255, 0));
    //return color(0, 0, 255);
  }
}
