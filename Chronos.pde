/*
 mostly based on code from:
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
 ---------------------------------------------
 and code from https://gist.github.com/cjimmy/b5a36b689365498506d6
 
 Many thanks!
*/

import processing.serial.*;

class Chronos {
  boolean justStarted = true;
  PVector offset = new PVector(0, 0, 0);
  PVector lastReal = null;
  
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
  
  Serial port;
  
  Chronos() {
    System.setProperty("gnu.io.rxtx.SerialPorts", "/dev/ttyACM0");
    println(Serial.list());
    port = new Serial(applet, "/dev/ttyACM0", 115200);

    //Start the access point..
    port.write(startAccessPoint);
  
    //Until the port is still availible...
    //Send data request to chronos.
    port.write(accDataRequest);
  }
  
  void step() {
    if (port.available() >= 0) {
      //Accelerometer data is 7 bytes long. This looks really lame, but it works.
      byte[] buf = new byte[7];  
      // this is a hack that reads the first three bytes
      // to get the normal 7-byte reading aligned.
      // For some reason, it repeats the first three bytes on program startup
      // NOTE: It may not happen to you. just delete this block if so.
      if (justStarted) {
        justStarted = false;
        byte[] dummyBuffer = new byte[3];
        port.readBytes(dummyBuffer);
      }
  
      for (int i = 0; i < 7; i++) {
        buf[i] = (byte)port.read();
      }
      
      if (buf[3] == 1) {
        PVector vec = new PVector(buf[4], buf[5], buf[6]);
        lastReal = vec.get();
        vec.add(offset);
        song.chronosData(vec);
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
          println("calibrated to " + offset);
        }
      }
      port.write(accDataRequest);
    }
  }
}
