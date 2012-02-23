
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
  //TODO use alpha value
  int tintCol = 0xff000000 | cp.getColorValue();

  for (int i=0; i<colorArray.length; i++) {

    int col = 0xff000000 | colorArray[i];

    int blendedColor;
    if (tintCol == 0x0ffffffff) {
      blendedColor = col;
    } 
    else {
      blendedColor = blendColor(tintCol, col, MULTIPLY);
    }

    //invert last color ("now")
    if (invertNow && i==NR_OF_PIXELS_X-1) {
      blendedColor = blendColor(blendedColor, 0xffffffff, DIFFERENCE);
    }

    colorArray[i] = blendedColor;
  }
}

void initSerial() {
  updateTextfield("Init serial port");
  try {
    lpd6803 = new Lpd6803(this, NR_OF_PIXELS_X*NR_OF_PIXELS_Y);          
    this.initialized = lpd6803.ping();
    println("Ping result: "+ this.initialized);
    updateTextfield(" -> Ping result: "+ this.initialized);
  } 
  catch (NoSerialPortFoundException e) {
    updateTextfield(" -> Failed to initialize serial port!");
    println("failed to initialize serial port!");
  }
}

