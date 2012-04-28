
color calcColor(int col1, int pos) {
  int b= col1&255;
  int g=(col1>>8)&255;
  int r=(col1>>16)&255;

  int p3=pos*3;
  r=(r*p3)/255;
  g=(g*p3)/255;
  b=(b*p3)/255;

  return color(r, g, b);
}

color mulX(ColorSet cs, int pos) {
  pos %= 255;
  if (pos < 85) {
    return calcColor(cs.getC1(), pos);
  } 
  else if (pos < 170) {
    pos -= 85;
    return calcColor(cs.getC2(), pos);
  } 
  pos -= 170;
  return calcColor(cs.getC3(), pos);
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

color mul(ColorSet cs, int pos) {
  pos %= 255;
  if (pos < 85) {
    return calcSmoothColor(cs.getC2(), cs.getC1(), pos); //0-255
  } 
  else if (pos < 170) {
    pos -= 85;
    return calcSmoothColor(cs.getC3(), cs.getC2(), pos); //255-512
  } 
  pos -= 170;
  return calcSmoothColor(cs.getC1(), cs.getC3(), pos); //512-0
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

