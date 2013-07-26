/* smoothens your data.
   code from http://blog.thomnichols.org/2011/08/smoothing-sensor-data-with-a-low-pass-filter */
class Smoothie {
  float oldData;
  float alpha;
  
  Smoothie(float alpha) {
    this.alpha = alpha;
    this.oldData = 0;
  }
  
  float get(float newData) {
    if(oldData == 0) return newData;
    else return oldData + alpha * (newData - oldData); 
  }
}
