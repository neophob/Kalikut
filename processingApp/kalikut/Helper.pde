
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

color WheelInv(int WheelPos) {
  WheelPos %= 255;
  if (WheelPos < 85) {
    return color(255-WheelPos * 3, WheelPos * 3, 255);
  } 
  else if (WheelPos < 170) {
    WheelPos -= 85;
    return color(WheelPos * 3, 255, 255-WheelPos * 3);
  } 
  else {
    WheelPos -= 170; 
    return color(255, 255-WheelPos * 3, WheelPos * 3);
  }
}

color calcSmoothColor(int col1, int col2, int pos) {
  int b= col1&255;
  int g=(col1>>8)&255;
  int r=(col1>>16)&255;
  int b2= col2&255;
  int g2=(col2>>8)&255;
  int r2=(col2>>16)&255;

  int p3=pos*3;
  int oppisiteColor = 255-p3;
  r=(r*p3)/255;
  g=(g*p3)/255;
  b=(b*p3)/255;
  r+=(r2*oppisiteColor)/255;
  g+=(g2*oppisiteColor)/255;
  b+=(b2*oppisiteColor)/255;

  return color(r, g, b);
}

color mulSmooth(ColorSet cs, int pos) {
  pos %= 255;
  if (pos < 85) {
    int b= cs.getC1()&255;
    int g=(cs.getC1()>>8)&255;
    int r=(cs.getC1()>>16)&255;
    int b2= cs.getC2()&255;
    int g2=(cs.getC2()>>8)&255;
    int r2=(cs.getC2()>>16)&255;

    int p3=pos*3;
    int oppisiteColor = 255-p3;
    r=(r*p3)/255;
    g=(g*p3)/255;
    b=(b*p3)/255;
    r+=(r2*oppisiteColor)/255;
    g+=(g2*oppisiteColor)/255;
    b+=(b2*oppisiteColor)/255;

    return color(r, g, b);
  } 
  else if (pos < 170) {
    pos -= 85;
    int b= cs.getC2()&255;
    int g=(cs.getC2()>>8)&255;
    int r=(cs.getC2()>>16)&255;
    int b2= cs.getC3()&255;
    int g2=(cs.getC3()>>8)&255;
    int r2=(cs.getC3()>>16)&255;

    int p3=pos*3;
    int oppisiteColor = 255-p3;

    r=(r*p3)/255;
    g=(g*p3)/255;
    b=(b*p3)/255;
    r+=(r2*oppisiteColor)/255;
    g+=(g2*oppisiteColor)/255;
    b+=(b2*oppisiteColor)/255;

    return color(r, g, b);
  } 

  pos -= 170; 
  int b= cs.getC3()&255;
  int g=(cs.getC3()>>8)&255;
  int r=(cs.getC3()>>16)&255;
  int b2= cs.getC1()&255;
  int g2=(cs.getC1()>>8)&255;
  int r2=(cs.getC1()>>16)&255;

  int p3=pos*3;
  int oppisiteColor = 255-p3;

  r=(r*p3)/255;
  g=(g*p3)/255;
  b=(b*p3)/255;
  r+=(r2*oppisiteColor)/255;
  g+=(g2*oppisiteColor)/255;
  b+=(b2*oppisiteColor)/255;

  return color(r, g, b);
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

