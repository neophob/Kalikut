private static final int MAX_EFFECT=9;

private static final int FX_HOTEL = 5;
private static final int FX_FIRE = 8;

private static final int FIRE_BUFFER = 4;

private int[] fireColors;
private int[] fireBuffer;

private List<Integer[]> funnyWords;

void initGenerator() {
  //---------------------------
  //setup fire
  fireColors = new int[256];
  fireBuffer = new int[(NR_OF_PIXELS_X+FIRE_BUFFER)*NR_OF_PIXELS_Y];

  funnyWords = new ArrayList<Integer[]>();
  funnyWords.add(new Integer[] { 
    0, 1, 4
  } 
  );  //KAK
  funnyWords.add(new Integer[] { 
    1, 2, 4
  } 
  );  //ALK
  funnyWords.add(new Integer[] { 
    1, 2, 4, 7
  } 
  );  //ALK NOW
  funnyWords.add(new Integer[] { 
    1, 2, 3
  } 
  );  //ALI  
  funnyWords.add(new Integer[] { 
    1, 4, 5, 6
  } 
  );  //AKUT  
  funnyWords.add(new Integer[] { 
    2, 3, 4
  } 
  );  //LIK
  funnyWords.add(new Integer[] { 
    0, 1, 6
  } 
  );  //KAT  
  funnyWords.add(new Integer[] { 
    1, 2, 5
  } 
  );  //ALU
  funnyWords.add(new Integer[] { 
    3, 4
  } 
  );  //IK
  funnyWords.add(new Integer[] { 
    1, 3, 6
  } 
  );  //AIT  
  funnyWords.add(new Integer[] { 
    0, 1, 2, 6
  } 
  );  //KALT
  funnyWords.add(new Integer[] { 
    1, 2, 6
  } 
  );  //ALT
  funnyWords.add(new Integer[] { 
    1, 4, 6
  } 
  );  //AKT
  funnyWords.add(new Integer[] { 
    1, 4, 6, 7
  } 
  );  //AKT NOW  
  funnyWords.add(new Integer[] { 
    0, 1, 2, 4
  } 
  );  //KALK
  funnyWords.add(new Integer[] { 
    0, 3, 4, 6
  } 
  );  //KIKT  

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
      case 0: //Rainbow
        colorArray[i] = Wheel(frame-a*8);
        a+=1;
        break;

      case 1: //Rainbow Solid
        colorArray[i] = Wheel(frame);
        break;

      case 2: //Strobo 1
        if (((frame-x)>>4)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 
        else {
          colorArray[i] = color(255, 255, 255);
        }
        break;

      case 3: //Strobo 2
        if ((frame-x>>1)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 
        else {
          colorArray[i] = color(255, 255, 255);
        }
        break;

      case 4: //Solid
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

      case 6: //Beat
        if (beat.isKick() || beat.isHat() || beat.isSnare()) {
          colorArray[i] = color(255, 255, 255);
        } 
        else {
          colorArray[i] = color(0, 0, 0);
        }
        break;

      case 7: //volume
        int c = int(in.mix.level()*soundSensitive.getValue());
        if (c>255) c=255;
        colorArray[i] = color(c, c, c);
        break;

      case FX_FIRE:
        int fireOfs = y*(NR_OF_PIXELS_X+FIRE_BUFFER)+x+FIRE_BUFFER;
        colorArray[i] = fireColors[ fireBuffer[fireOfs] ];
        break;

      case 9: //Test
        if (y>0) {   
          long l = colorArray[x]&0xffffff;
          if (l>0) {
            colorArray[i] = color(0, 0, 0);
          } 
          else {
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

      case 10: //RGB Color
        if (frame%10==1) {
          if (y>0) {
            colorArray[i] = colorArray[x];
            break;
          }

          int rnd = int(random(3));
          switch (rnd) {
          case 0:
            colorArray[x] = color(0, 0, 255);
            break;

          case 1: 
            colorArray[x] = color(255, 0, 0);
            break;

          default:
            colorArray[x] = color(0, 255, 0);
            break;
          }
        }
        break;

      case 11: //One Char
        if ((frame/4-x)%STR_KALIKUT.length()==1) {
          colorArray[i] = color(255, 255, 255);
        } 
        else {
          colorArray[i] = color(0, 0, 0);
        }
        break;

      case 12: //Random Char
        // this fx is not done in this loop
        break;

      case 13: //Funny
        // this fx is not done in this loop     
        break;
      }
    }
  }

  //not single characte post fx

  switch(mode) {
  case FX_HOTEL:
    if (int(random(77))==34) {
      //very seldom in hotel mode, make everything black
      clearAllChars();
    }
    break;

  case 12: //Random char
    if (frame%10==1) {
      clearAllChars();
      int selectedChar = int(random(STR_KALIKUT.length()));
      int col = color(random(255), random(255), random(255));
      colorArray[selectedChar] = col;
      if (NR_OF_PIXELS_Y>1) {
        colorArray[selectedChar+NR_OF_PIXELS_X] = col;
      }
    }
    break;

  case 13: //Funny
    if (frame%10==1) {
      clearAllChars();
      int selectedWord = int(random(funnyWords.size()));
      int col = color(random(255), random(255), random(255));

      for (int i: funnyWords.get(selectedWord)) {
        colorArray[i] = col;
        if (NR_OF_PIXELS_Y>1) {
          colorArray[i+NR_OF_PIXELS_X] = col;
        }
      }
    }
    break;
  }
}

//black baby!
void clearAllChars() {
  for (int i=0; i<NR_OF_PIXELS_X*NR_OF_PIXELS_Y; i++) {
    colorArray[i] = color(0, 0, 0);
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

