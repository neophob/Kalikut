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

private List<Integer[]> funnyWords;
private int selectedRandomChar = 0;
private int selectedRandomWord = 0;
private int krDirection = 0;
private int krPos = 0;

void generateAnimation() {

  //return if nothing todo!
  if (genAnim == GEN_ANIM_NOTHING) {
    return;
  }

  if (frame%10==1) {
    selectedRandomChar = int(random(STR_KALIKUT.length()));
    selectedRandomWord = int(random(funnyWords.size()));
  }

  int hotelRandom=int(random(25));


  for (int x=0; x<NR_OF_PIXELS_X; x++) {
    for (int y=0; y<NR_OF_PIXELS_Y; y++) {
      int i = y*NR_OF_PIXELS_X+x;

      switch(genAnim) {

      case GEN_ANIM_STROBO1:
        if (((frame-x)>>4)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 
        break;

      case GEN_ANIM_STROBO2:
        if ((frame-x>>1)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 
        break;

      case GEN_ANIM_HOTEL:
        if (x==4 && hotelRandom==2 || x==6 && hotelRandom==4) {
          colorArray[i] = color(0, 0, 0);
        }
        break;

      case GEN_ANIM_ONE_CHAR:
        if ((frame/4-x)%STR_KALIKUT.length()!=1) {
          colorArray[i] = color(0, 0, 0);
        }
        break;

      case GEN_ANIM_RANDOM_CHAR: //Random char
        if (x!=selectedRandomChar) {
          colorArray[i] = 0;
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
        if (x!=krPos) {
          colorArray[i] = color(0, 0, 0);
        }
        break;

      case GEN_ANIM_FLIPPER:
        if (y>0) {   
          long l = colorArray[x]&0xffffff;
          if (l>0) {
            colorArray[i] = color(0, 0, 0);
          } 
          break;
        }
        if ((frame-i>>2)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 

        break;
      }
    }
  }
  //println(frame);

  switch(genAnim) {
  case GEN_ANIM_HOTEL:
    if (int(random(77))==34) {
      //very seldom in hotel mode, make everything black
      clearAllChars();
    }
    break;

  case GEN_ANIM_KNIGHTRIDER:
    if (frame%5==1) {
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

