import oscP5.*;
import netP5.*;
import javax.swing.SwingUtilities;

class OSC {
  OscP5 oscp5;
  
  OSC() {
    oscp5 = new OscP5(applet, 12000);  
  }
  
  void oscEvent(OscMessage msg) {
    /* print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    print(" addrpattern: "+msg.addrPattern());
    println(" typetag: "+msg.typetag());
    String pattern = msg.addrPattern();
    if(msg.typetag().equals("f") && msg.get(0).floatValue() > 0) {
      // only react to presses, not releases
      if(pattern.equals("/songs/fadeout")) {
        initiateFadeout();
      } else if(pattern.startsWith("/songs/choose/")) {
        String[] splitted = pattern.split("/");
        try {
          int row = Integer.parseInt(splitted[3]); // row from the bottom edge, 1..3
          int col = Integer.parseInt(splitted[4]); // col from the left edge, 1..3
          int rowFromTop = 4 - row; // we want to start counting in the left top edge.
          int songIndex = (rowFromTop - 1) * 3 + (col - 1); // from left to right, then the rows.
          println("choose from osc: " + songIndex);
          // Attention: This is very bad. But less bad than calling `chooseSong()` here, because
          // this runs into some weird threading issues. It seems like `oscEvent` is called in an
          // OSC thread, and if we modify the song from here, the main processing drawing thread
          // dies pretty reliably. So, we set `nextSongToChoose` here, and the main drawing thread
          // calls `chooseSong` then. Ideally, this would use `SwingUtilities.invokeLater`, or
          // a synchronized queue. But it seems like this works for now.
          nextSongToChoose = songIndex;
        } catch(Exception e) {
          println("Malformed message: " + pattern + "; error: " + e);
        }
      }
    }
  }
}

void oscEvent(OscMessage msg) {
  osc.oscEvent(msg);
}
