//einen FARBGENERATOR hast (Rainbow, rainbow soli, solid, fire, rgb color)

private static final int GEN_COL_RAINBOW = 1;
private static final int GEN_COL_RAINBOW_SOLID = 2;
private static final int GEN_COL_SOLID = 3;
private static final int GEN_COL_FIRE = 4;
private static final int GEN_COL_RGBCOL = 5;

private static final int FIRE_BUFFER = 4;

private int[] fireColors;
private int[] fireBuffer;
private int[] rgbColBuffer = new int[NR_OF_PIXELS_X];

void generateColor() {
  if (genColor==GEN_COL_FIRE) {
    updateFireBuffer();
  }

  if (frame%10==1) {
    for (int x=0; x<NR_OF_PIXELS_X; x++) {
      int rnd = int(random(3));
      switch (rnd) {
      case 0:
        rgbColBuffer[x] = color(0, 0, 255);
        break;

      case 1: 
        rgbColBuffer[x] = color(255, 0, 0);
        break;

      default:
        rgbColBuffer[x] = color(0, 255, 0);
        break;
      }
    }
  }

  int a=0;
  for (int x=0; x<NR_OF_PIXELS_X; x++) {
    for (int y=0; y<NR_OF_PIXELS_Y; y++) {
      int i = y*NR_OF_PIXELS_X+x;

      switch(genColor) {
      case GEN_COL_RAINBOW: //Rainbow
        colorArray[i] = Wheel(frame-a*8);
        a+=1;
        break;

      case GEN_COL_RAINBOW_SOLID: //Rainbow Solid
        colorArray[i] = Wheel(frame);
        break;

      case GEN_COL_SOLID: //Solid
        colorArray[i] = color(255, 255, 255);
        break;

      case GEN_COL_FIRE:
        int fireOfs = y*(NR_OF_PIXELS_X+FIRE_BUFFER)+x+FIRE_BUFFER;
        colorArray[i] = fireColors[ fireBuffer[fireOfs] ];
        break;

      case GEN_COL_RGBCOL:
        colorArray[i] = rgbColBuffer[x];
        break;
      }
    }
  }
}


void setupColor() {
  //setup fire
  fireColors = new int[256];
  fireBuffer = new int[(NR_OF_PIXELS_X+FIRE_BUFFER)*NR_OF_PIXELS_Y];

  for (int i = 0; i < 32; ++i) {
    /* black to blue, 32 values*/
    fireColors[i]=color(i<<1, 0, 0);

    /* blue to red, 32 values*/
    fireColors[i + 32]=color(i << 3, 0, 64 - (i << 1));

    /*red to yellow, 32 values*/
    fireColors[i + 64]=color(255, i << 3, 0);

    /* yellow to white, 162 */
    fireColors[i + 96]=color(255, 255, i << 2);
    fireColors[i + 128]=color(255, 255, 64+(i << 2));
    fireColors[i + 160]=color(255, 255, 128+(i << 2));
    fireColors[i + 192]=color(255, 255, 192+i);
    fireColors[i + 224]=color(255, 255, 224+i);
  }
}


//fire fx
void updateFireBuffer() {
  int ofs;

  //seed
  for (int y=0; y<NR_OF_PIXELS_Y; y++) {
    ofs = y*(NR_OF_PIXELS_X+FIRE_BUFFER);
    int rnd = int(random(16));
    /* the lower the value, the intense the fire, compensate a lower value with a higher decay value*/
    if (rnd > 8) {
      fireBuffer[ofs] = 255;
    } 
    else {
      fireBuffer[ofs] = 0;
    }
  }

  //calculate
  for (int y=0; y<NR_OF_PIXELS_Y; y++) {
    ofs = y*(NR_OF_PIXELS_X+FIRE_BUFFER);
    for (int x=0; x<FIRE_BUFFER+NR_OF_PIXELS_X-1; x++) {
      int a = (fireBuffer[ofs+x] + fireBuffer[ofs+x+1])/2;
      if (y>0) {
        a += (fireBuffer[x] + fireBuffer[x+1])/2;
        a/=2;
      }
      if (a>1) {
        a--;
      }
      fireBuffer[ofs+x+1]=a;
    }
  }
}

