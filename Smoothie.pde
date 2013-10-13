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
    float ret = 0;
    if (oldData == 0) {
      ret = newData;
    } else {
      ret = oldData + alpha * (newData - oldData);
    }
    oldData = newData;
    return ret;
  }
}

