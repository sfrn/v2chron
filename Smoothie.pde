/* smoothens your data */
class Smoothie {
  ArrayList<Float> data;
  int n;
  
  Smoothie(int n) {
    data = new ArrayList<Float>(n);
    this.n = n;
  }
  
  float get(float newData) {
    if(data.size() >= n) {
      //full array yes
      data.remove(0);
    } 
    data.add(newData);
    float sum = 0;
    for(Float f : data) {
      sum += f;
    }
    return sum / data.size();
  }
}
