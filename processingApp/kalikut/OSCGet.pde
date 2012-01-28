
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());

  if (theOscMessage.checkTypetag("f")) {

    int currentCol = cp.getColorValue();
    int tintB = currentCol & 255;
    currentCol >>= 8;
    int tintG = currentCol & 255;
    currentCol >>= 8;
    int tintR = currentCol & 255;

    if (theOscMessage.checkAddrPattern("/knbr")) {
      float val = theOscMessage.get(0).floatValue();
      tintR = int(val*255);      
      cp.setColorValue(color(tintR, tintG, tintB));
    }
    if (theOscMessage.checkAddrPattern("/knbg")) {
      float val = theOscMessage.get(0).floatValue();
      tintG = int(val*255);
      cp.setColorValue(color(tintR, tintG, tintB));
    }
    if (theOscMessage.checkAddrPattern("/knbb")) {
      float val = theOscMessage.get(0).floatValue();
      tintB = int(val*255);
      cp.setColorValue(color(tintR, tintG, tintB));
    }
  }

  if (theOscMessage.checkTypetag("i")) {
    if (theOscMessage.checkAddrPattern("/mode")) {
      int val = theOscMessage.get(0).intValue();
      if (val>=0 && val <=MAX_EFFECT) {
        modeButton.activate(val);
      }
    }
  }
}

