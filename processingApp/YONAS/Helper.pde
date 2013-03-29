static final int COL_RGB=1;
static final int COL_RBG=2; 
static final int COL_BRG=3; 
static final int COL_BGR=4; 
static final int COL_GBR=5; 
static final int COL_GRB=6; 

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

static byte[] convertBufferTo24bit(int[] data, int colorFormat) throws IllegalArgumentException {
  int targetBuffersize = data.length;

  int[] r = new int[targetBuffersize];
  int[] g = new int[targetBuffersize];
  int[] b = new int[targetBuffersize];

  splitUpBuffers(targetBuffersize, data, colorFormat, r, g, b);

  int ofs=0;
  byte[] buffer = new byte[targetBuffersize*3];
  for (int i=0; i<targetBuffersize; i++) {
    buffer[ofs++] = (byte)r[i];
    buffer[ofs++] = (byte)g[i];
    buffer[ofs++] = (byte)b[i];
  }

  return buffer;
}


static void splitUpBuffers(int targetBuffersize, int[] data, int colorFormat, int[] r, int[] g, int[] b) {
  int ofs = 0;
  int tmp;
  for (int n=0; n<targetBuffersize; n++) {
    //one int contains the rgb color
    tmp = data[ofs];

    switch (colorFormat) {
    case COL_RGB:
      r[ofs] = (int) ((tmp>>16) & 255);
      g[ofs] = (int) ((tmp>>8)  & 255);
      b[ofs] = (int) ( tmp      & 255);                       
      break;
    case COL_RBG:
      r[ofs] = (int) ((tmp>>16) & 255);
      b[ofs] = (int) ((tmp>>8)  & 255);
      g[ofs] = (int) ( tmp      & 255);                       
      break;
    case COL_BRG:
      b[ofs] = (int) ((tmp>>16) & 255);
      r[ofs] = (int) ((tmp>>8)  & 255);
      g[ofs] = (int) ( tmp      & 255);
      break;
    case COL_BGR:
      b[ofs] = (int) ((tmp>>16) & 255);
      g[ofs] = (int) ((tmp>>8)  & 255);
      r[ofs] = (int) ( tmp      & 255);
      break;
    case COL_GBR:
      g[ofs] = (int) ((tmp>>16) & 255);
      b[ofs] = (int) ((tmp>>8)  & 255);
      r[ofs] = (int) ( tmp      & 255);
      break;
    case COL_GRB:
      g[ofs] = (int) ((tmp>>16) & 255);
      r[ofs] = (int) ((tmp>>8)  & 255);
      b[ofs] = (int) ( tmp      & 255);
      break;
    }
    ofs++;
  }
}



