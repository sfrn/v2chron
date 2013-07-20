import processing.video.*;
import processing.serial.*;

Capture cam1;

//Take what we know about the packets for starting the access point
//and put it in its integer representation
int startAccessPointNum[] = {
  255, 7, 3
};
//Take what we know about the packets for aquiring data from the chronos
//and put it in its integer representation
int accDataRequestNum[] = {
  255, 8, 7, 0, 0, 0, 0
};

int stopAccessPointNum[] = {
  255, 7, 3, 255, 9, 3
};

//Convert it all to bytes so that watch will understand
//what we're talking about..
byte startAccessPoint[] = byte(startAccessPointNum);
byte accDataRequest[] = byte(accDataRequestNum);
byte stopAccessPoint[] = byte(stopAccessPointNum);

Serial chronos;

void setup() {
  size(1024, 768);
  println(Capture.list());
  cam1 = new Capture(this, 320, 240, 15);
  cam1.start();

  System.setProperty("gnu.io.rxtx.SerialPorts", "/dev/ttyACM0");
  println(Serial.list());
  chronos = new Serial(this, "/dev/ttyACM0", 115200);

  //Start the access point..
  chronos.write(startAccessPoint);


  //Until the port is still availible...
  //Send data request to chronos.
  chronos.write(accDataRequest);
} 

float angle = 0;
float angleSlope = 0;

float oldX=0, oldY=0, oldZ=0;

void unjitter(PVector vec) {
  /*float tmp;
  tmp = vec.x;
  vec.x = 9*vec.x + 0.5 * oldX;
  oldX = vec.x;
  
  tmp = vec.y;
  vec.y = 9*vec.y + 0.5 * oldY;
  oldY = vec.y;
  
  tmp = vec.z;
  vec.z = 9*vec.z + 0.5 * oldZ;
  oldZ = vec.z;*/
}

void draw() {
  if (chronos.available() >= 0) {
    //Accelerometer data is 7 bytes long. This looks really lame, but it works.
    byte[] buf = new byte[7];  
    //boolean gotInvalidData = false;
    /*for (int i = 0; i < 7; i++) {
      int data = chronos.read();
     /* if(data == -1) {
        gotInvalidData = true;
      }/
      buf[i] = (byte)data;
    }*/
    for (int i = 0; i < 7; i++) {
      buf[i] = (byte)chronos.read();
    }
    
    if (buf[3] == 1) {
     /* PVector vec = new PVector(buf[4], buf[5], buf[6]);
      unjitter(vec);*/
      
      byte x = buf[4];
      angleSlope += map(x, -128, 127, -4.0, 4.0);
      


      //draw y line
      byte y = buf[5];
      
      //draw z line
      byte z = buf[6];
      println("x" + x + " y" + y + " z"+z);
    } else {
      chronos.write(accDataRequest);
    }
    angle += angleSlope;
    angleSlope = angleSlope;
  }

  if (cam1.available()) {
    cam1.read();
  }
  PImage im = cam1.get();
  im.resize(1024, 768);
  im.filter(THRESHOLD, 0.8);
  translate(width/2, height/2);
  rotate(angle*TWO_PI/360);
  translate(-width/2, -height/2);
  image(im, 0, 0);
}

void exit() {
  //chronos.stop();
  super.exit();
}

