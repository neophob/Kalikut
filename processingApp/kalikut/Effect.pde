private static final int MAX_EFFECT=9;

private static final int FX_HOTEL = 5;
private static final int FX_FIRE = 8;

private static final int FIRE_BUFFER = 4;

private int[] fireColors;
private int[] fireBuffer;

void initGenerator() {
  //---------------------------
  //setup fire
  fireColors = new int[256];
  fireBuffer = new int[(NR_OF_PIXELS_X+FIRE_BUFFER)*NR_OF_PIXELS_Y];

  for (int i = 0; i < 32; ++i) {
    /* black to blue, 32 values*/
    fireColors[i]=color(i<<1, 0, 0);

    /* blue to red, 32 values*/
    fireColors[i + 32]=color(64 - (i << 1), 0, i << 3);

    /*red to yellow, 32 values*/
    fireColors[i + 64]=color(0, i << 3, 255);

    /* yellow to white, 162 */
    fireColors[i + 96]=color(i << 2, 255, 255);
    fireColors[i + 128]=color(64+(i << 2), 255, 255);
    fireColors[i + 160]=color(128+(i << 2), 255, 255);
    fireColors[i + 192]=color(192+i, 255, 255);
    fireColors[i + 224]=color(224+i, 255, 255);
  }
}

//generate buffer
void generator() {

  if (mode==FX_FIRE) {
    updateFireBuffer();
  }

  int a=0;
  for (int x=0; x<NR_OF_PIXELS_X; x++) {
    for (int y=0; y<NR_OF_PIXELS_Y; y++) {
      int i = y*NR_OF_PIXELS_X+x;

      switch(mode) {
      case 0:
        colorArray[i] = Wheel((frame-a)*2);
        a+=1;
        break;

      case 1:
        colorArray[i] = Wheel(frame);
        break;

      case 2:
        if (((frame-x)>>4)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 
        else {
          colorArray[i] = color(255, 255, 255);
        }
        break;

      case 3:
        if ((frame-x>>1)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 
        else {
          colorArray[i] = color(255, 255, 255);
        }
        break;

      case 4:
        colorArray[i] = color(255, 255, 255);
        break;

      case FX_HOTEL:
        if (y>0) {
          colorArray[i] = colorArray[x];
          break;
        }
        int r=int(random(25));
        colorArray[i] = color(255, 255, 255);
        if (x==4 || x==6) {        
          if (r==2) {
            colorArray[i] = color(0, 0, 0);
          }
        }
        break;

      case 6:
        if (beat.isKick() || beat.isHat() || beat.isSnare()) {
          colorArray[i] = color(255, 255, 255);
        } 
        else {
          colorArray[i] = color(0, 0, 0);
        }
        break;

      case 7:
        int c = int(in.mix.level()*soundSensitive.getValue());
        if (c>255) c=255;
        colorArray[i] = color(c, c, c);
        break;

      case FX_FIRE:
        int fireOfs = y*(NR_OF_PIXELS_X+FIRE_BUFFER)+x+FIRE_BUFFER;
        colorArray[i] = fireColors[ fireBuffer[fireOfs] ];
        break;

      case 9:
        if (y>0) {   
          long l = colorArray[x]&0xffffff;
          if (l>0) {
            colorArray[i] = color(0, 0, 0);
          } else {
            colorArray[i] = color(255, 255, 255);
          }
          break;
        }
        if ((frame-i>>2)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 
        else {
          colorArray[i] = color(255, 255, 255);
        }
        break;
      }
      
      
    }
  }

  //very seldom in hotel mode, make everything black
  int r=int(random(77));
  if (mode == FX_HOTEL && r==34) {
    for (int i=0; i<NR_OF_PIXELS_X*NR_OF_PIXELS_Y; i++) {
      colorArray[i] = color(0, 0, 0);
    }
  }
}


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

