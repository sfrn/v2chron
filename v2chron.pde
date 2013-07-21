/*
 Safran visuals v2 based on:
 
 
 ------------------------------------------
 Get acceleration data from Chronos watch.
 Taken from info posted at: http://e2e.ti.com/support/microcontrollers/msp43016-bit_ultra-low_power_mcus/f/166/t/32714.aspx
 
 Based off of the latest Python code on the Chronos wiki that I wrote.
 
 Copyright (c) 2010 Sean Brewer 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 If you want you may contact me at seabre986@gmail.com
 or on reddit: seabre
 
 Modications made by Oliver Smith to provide graphics 
 http://chemicaloliver.net
 -----------------------------------------------
 
 and code from https://gist.github.com/cjimmy/b5a36b689365498506d6
 */

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

LiveSound live;
BassMachine bassMachine;

boolean justStarted = false;
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
  
  live = new LiveSound();
  bassMachine = new BassMachine();

  System.setProperty("gnu.io.rxtx.SerialPorts", "/dev/ttyACM0");
  println(Serial.list());
  chronos = new Serial(this, "/dev/ttyACM0", 115200);

  //Start the access point..
  chronos.write(startAccessPoint);


  //Until the port is still availible...
  //Send data request to chronos.
  chronos.write(accDataRequest);
  justStarted = true;
  
  colorMode(HSB);
} 

float angle = 0;
float angleSlope = 0;

PVector offset = new PVector(0, 0, 0);
PVector lastReal = null;
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

float threshold = 0.8;

int signum(float f) {
  if (f > 0) return 1;
  if (f < 0) return -1;
  return 0;
} 

void draw() {
  live.step();
  
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
    // this is a hack that reads the first three bytes
    // to get the normal 7-byte reading aligned.
    // For some reason, it repeats the first three bytes on program startup
    // NOTE: It may not happen to you. just delete this block if so.
    if (justStarted) {
      justStarted = false;
      byte[] dummyBuffer = new byte[3];
      chronos.readBytes(dummyBuffer);
    }

    for (int i = 0; i < 7; i++) {
      buf[i] = (byte)chronos.read();
    }
    
    if (buf[3] == 1) {
      PVector vec = new PVector(buf[4], buf[5], buf[6]);
      lastReal = vec.get();
      vec.add(offset);
       //unjitter(vec);

      //angleSlope += map(x, -128, 127, -4.0, 4.0);
      float newAngle = map(vec.x, -128, 127, -180, 180);
      threshold = 1.0 * (vec.x + 128) / 256;
//      println("x" + vec.x + " y" + vec.y + " z"+vec.z);
    } else if((buf[3] & 0xf0) != 0) {
      // button press! todo: distinguish press/release
      String button = "";
      switch(buf[3] & 0xf0) {
        case 0x10: button = "*"; break;
        case 0x20: button = "#"; break;
        case 0x30: button = "up"; break;
        default: button = "?";
      }
      if(button.equals("#") && lastReal != null) {
        // # button: set offset
        offset = lastReal.get();
        offset.mult(-1);
      }
    }
    chronos.write(accDataRequest);
  }

  if (cam1.available()) {
    cam1.read();
  }
  PImage im = cam1.get();
  
  im.resize(1024, 768);
  im.filter(THRESHOLD, threshold);
  translate(width/2, height/2);
  //println("my angle is " + angle);
  rotate(angle*TWO_PI/360);
  translate(-width/2, -height/2);
  
  tint(bassMachine.getColor());
  
  image(im, 0, 0);
}

void exit() {
  //chronos.stop();
  super.exit();
}

