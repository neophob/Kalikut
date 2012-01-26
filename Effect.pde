//generate buffer
void generator() {

  for (int i=0; i<strKali.length(); i++) {

    switch(mode) {
    case 0:
      colorArray[i] = Wheel(frame+i*8);
      break;

    case 1:
      colorArray[i] = Wheel(frame);
      break;

    case 2:
      if ((i+frame>>4)%2==1) {
        colorArray[i] = color(0, 0, 0);
      } 
      else {
        colorArray[i] = color(255, 255, 255);
      }
      break;

    case 3:
      if ((i+frame>>1)%2==1) {
        colorArray[i] = color(0, 0, 0);
      } 
      else {
        colorArray[i] = color(255, 255, 255);
      }
      break;

    case 4:
      colorArray[i] = color(255, 255, 255);
      break;

    case 5:      
      colorArray[i] = color(255, 255, 255);
      if (i==4 || i==6) {
        int r=int(random(25));
        if (r==2) {
          colorArray[i] = color(0, 0, 0);
        }
      }
      break;
    }
  }
}

//colorize buffer
void tintBuffer() {
  int col, rr, gg, bb, tintR, tintG, tintB;
  
  int tintCol = cp.getColorValue();
  tintR = tintCol & 255;
  tintCol >>= 8;
  tintG = tintCol & 255;
  tintCol >>= 8;
  tintB = tintCol & 255;
  
  for (int i=0; i<colorArray.length; i++) {
    col = colorArray[i];
    rr = col & 255;
    col >>= 8;
    gg = col & 255;
    col >>= 8;
    bb = col & 255;
    col >>= 8;

    rr = rr*(tintR+1) >> 8;
    gg = gg*(tintG+1) >> 8;
    bb = bb*(tintB+1) >> 8;

    //    colorArray[i] = (rr << 16) | (gg << 8) | bb;
    colorArray[i] = color(rr, gg, bb);
  }
}

