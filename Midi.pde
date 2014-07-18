import themidibus.*;

class Midi {
  MidiBus bus;
  
  Midi() {
    MidiBus.list();
    bus = new MidiBus(applet, "Cable [hw:1,0,0]", -1);
  } 
} 

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  /*println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);*/
  song.noteOn(channel, pitch, velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  /*println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);*/
  song.noteOff(channel, pitch, velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
 /* println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);*/
  song.controllerChange(channel, number, value);
}

