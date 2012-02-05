
color Wheel(int WheelPos) {
  WheelPos %= 255;
  if (WheelPos < 85) {
    return color(WheelPos * 3, 255 - WheelPos * 3, 0);
  } 
  else if (WheelPos < 170) {
    WheelPos -= 85;
    return color(255 - WheelPos * 3, 0, WheelPos * 3);
  } 
  else {
    WheelPos -= 170; 
    return color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
}


//colorize buffer
void tintBuffer() {
  int col, rr, gg, bb, tintR, tintG, tintB;

  int tintCol = cp.getColorValue();
  tintB = tintCol & 255;
  tintCol >>= 8;
  tintG = tintCol & 255;
  tintCol >>= 8;
  tintR = tintCol & 255;

  for (int i=0; i<colorArray.length; i++) {
    col = colorArray[i];
    rr = col & 255;
    col >>= 8;
    gg = col & 255;
    col >>= 8;
    bb = col & 255;
    col >>= 8;

    rr = rr*(tintR+1) >> 8;
    gg = gg*(tintG+1) >> 8;
    bb = bb*(tintB+1) >> 8;

    //invert last color ("now")
    if (invertNow && i==colorArray.length-1) {
      rr = 256-rr;
      gg = 256-gg;
      bb = 256-bb;
    }

    //    colorArray[i] = (rr << 16) | (gg << 8) | bb;
    colorArray[i] = color(rr, gg, bb);
  }
}

void initSerial() {
  updateTextfield("Init serial port");
  try {
    lpd6803 = new Lpd6803(this, NR_OF_PIXELS);          
    this.initialized = lpd6803.ping();
    println("Ping result: "+ this.initialized);
    updateTextfield(" -> Ping result: "+ this.initialized);
  } 
  catch (NoSerialPortFoundException e) {
    updateTextfield(" -> Failed to initialize serial port!");
    println("failed to initialize serial port!");
  }
}


