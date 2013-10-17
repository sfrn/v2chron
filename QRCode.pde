class QRCode extends Song {
  String getName() { return "QR Code"; }

  void on() {

  }
  
  void off() {
  }
  
  void draw() {
    background(0);
    image(qrCode,0, 0);
  }  
}
