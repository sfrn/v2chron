class BassMachine {
  float avgValue = 0, h = 0, s = 0, b = 0;
 
  void drawFreqBackground(float average) {
    if(average > 20 && average > avgValue * 2) {
      //if(avgValue == 0) avgValue = average;
      //else avgValue = avgValue * 1.1;
      avgValue = average;
    }
   //fill(h, s, map(avgValue, 0, 100, 0, 255), 128);
    h = (h + 0.5) % 255;
    s = (125 + ((s + 0.5) % 125));
    avgValue *= 0.95;
  }
  
  color getColor() {
    float avg = liveSound.fft.calcAvg(0, 100); 
    drawFreqBackground(avg);
    return color(h, map(avgValue, 0, 100, 0, 255), map(avgValue, 0, 100, 255, 0));
    //return color(0, 0, 255);
  }
}
