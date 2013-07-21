import ddf.minim.analysis.*;
import ddf.minim.*;

class LiveSound {
  Minim minim;
  AudioInput in;
  FFT fft;

  LiveSound () {
    minim = new Minim(this);
    in = minim.getLineIn();
    
    fft = new FFT(in.bufferSize(), in.sampleRate());
    fft.logAverages(60, 2);
  }
  
  void step() {
    fft.forward(in.mix);
  }
}
