//einem BEWEGUNGSGENERATOR (strobo1, strobo2, hotel, one char, randomchar, funny)

private static final int GEN_ANIM_NOTHING = 1;
private static final int GEN_ANIM_STROBO1 = 2;
private static final int GEN_ANIM_STROBO2 = 3;
private static final int GEN_ANIM_ONE_CHAR = 4;
private static final int GEN_ANIM_RANDOM_CHAR = 5;
private static final int GEN_ANIM_FUNNY = 6;
private static final int GEN_ANIM_HOTEL = 7;
private static final int GEN_ANIM_KNIGHTRIDER = 8;
private static final int GEN_ANIM_FLIPPER = 9;
private static final int GEN_ANIM_FADER = 10;
private static final int GEN_ANIM_INVERTER = 11;
private static final int GEN_ANIM_STROBO_H = 12;
private static final int GEN_ANIM_STROBO_H2 = 13;

private static final int MAX_ANIMATION = 12;

private List<Integer[]> funnyWords;
private int selectedRandomChar = 0;
private int selectedRandomWord = 0;
private int krDirection = 0;
private int krPos = 0;
private int stroboCount;

void generateAnimation() {

  //return if nothing todo!
  if (genAnim == GEN_ANIM_NOTHING) {
    return;
  }

  int globalDelayLocal = globalDelayInv/2;
  if (globalDelayLocal==0) {
    globalDelayLocal = 1;
  }
  int globalDelayLocal4 = 1+globalDelayInv/6;
  if (globalDelayLocal4==0) {
    globalDelayLocal4 = 1;
  }


  if (frame%globalDelayInv==0) {
    selectedRandomChar = int(random(STR_YONAS.length()));
    selectedRandomWord = int(random(funnyWords.size()));
  }

  int fadrCol = color((frame*globalDelay)%256, (frame*globalDelay)%256, (frame*globalDelay)%256); 
  
  //do some pre loop calculations
  switch(genAnim) {
    //  case GEN_ANIM_HOTEL:
    //    if (int(random(77))==34) {
    //very seldom in hotel mode, make everything black
    //      clearAllChars();
    //    }
    //    break;

  case GEN_ANIM_KNIGHTRIDER:
    if (frame%globalDelayInv==0) {
      if (krDirection == 0) {
        krPos++;
        if (krPos == 7) {
          krDirection=1;
        }
      } 
      else {
        krPos--;
        if (krPos == 0) {
          krDirection=0;
        }
      }
    }
    break;
  }


  //apply effect
  for (int x=0; x<NR_OF_PIXELS_X; x++) {
    for (int y=0; y<NR_OF_PIXELS_Y; y++) {
      int i = y*NR_OF_PIXELS_X+x;

      switch(genAnim) {

      case GEN_ANIM_STROBO1:
        if (((frame-x)/globalDelayInv)%2==0) {
          colorArray[i] = color(0, 0, 0);
        } 
        break;

      case GEN_ANIM_STROBO2:
        if (((frame-x)>>globalDelayLocal4)%2==0) {
          colorArray[i] = color(0, 0, 0);
        } 
        break;

        //      case GEN_ANIM_HOTEL:
        //      //TODO
        //        break;

      case GEN_ANIM_ONE_CHAR:
        if (invertEffect) {
          if ((frame/globalDelayLocal-x)%STR_YONAS.length()==1) {
            colorArray[i] = color(0, 0, 0);
          }
        } 
        else {
          if ((frame/globalDelayLocal-x)%STR_YONAS.length()!=1) {
            colorArray[i] = color(0, 0, 0);
          }
        }
        break;

      case GEN_ANIM_RANDOM_CHAR: //Random char
        if (invertEffect) {
          if (x==selectedRandomChar) {
            colorArray[i] = 0;
          }
        } 
        else {
          if (x!=selectedRandomChar) {
            colorArray[i] = 0;
          }
        }
        break;

      case GEN_ANIM_FUNNY:
        boolean clear = true;
        for (int ii: funnyWords.get(selectedRandomWord)) {
          if (ii==x) {
            clear=false;
          }
        }
        if (clear) {
          colorArray[i] = 0;
        }
        break;

      case GEN_ANIM_KNIGHTRIDER:
        if (invertEffect) {
          if (x==krPos) {
            colorArray[i] = color(0, 0, 0);
          }
        } 
        else {
          if (x!=krPos) {
            colorArray[i] = color(0, 0, 0);
          }
        }      
        break;

      case GEN_ANIM_FLIPPER:
        if (((frame-i)/globalDelayInv)%2==0) {
          colorArray[i] = color(0, 0, 0);
        } 
        break;

      case GEN_ANIM_FADER:
        colorArray[i] = blendColor(fadrCol, 0xff000000 | colorArray[i], MULTIPLY);
        break;

      case GEN_ANIM_INVERTER:
        if (y>=(NR_OF_PIXELS_Y/2)) {
          int col = colorArray[i];
          int rr=255-((col>>16)&0xff);
          int gg=255-((col>>8)&0xff);
          int bb=255-(col&0xff);
          colorArray[i] = color(rr, gg, bb);
        }
        break;

      case GEN_ANIM_STROBO_H:
        if (((frame-y)>>globalDelayLocal4)%2==0) {
          colorArray[i] = color(0, 0, 0);
        }
        break;

      case GEN_ANIM_STROBO_H2:
        if (invertEffect) {
          if (((frame-y)>>globalDelayLocal4)%(NR_OF_PIXELS_Y+1)!=y) {
            colorArray[i] = color(0, 0, 0);
          }
        } 
        else {
          if (((frame-y)>>globalDelayLocal4)%(NR_OF_PIXELS_Y+1)==y) {
            colorArray[i] = color(0, 0, 0);
          }
        }            
        break;
      }
    }
  }
  //println(frame);

}


//black baby!
void clearAllChars() {
  for (int i=0; i<NR_OF_PIXELS_X*NR_OF_PIXELS_Y; i++) {
    colorArray[i] = color(0, 0, 0);
  }
}  


void setupAnimation() {
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
}

