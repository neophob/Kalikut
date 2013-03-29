
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


