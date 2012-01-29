int MAX_EFFECT=6;

//generate buffer
void generator() {

  //for each buffer
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
      int r=int(random(25));
      colorArray[i] = color(255, 255, 255);
      if (i==4 || i==6) {        
        if (r==2) {
          colorArray[i] = color(0, 0, 0);
        }
      }
      break;

    case 6:
      if (beat.isKick()) {
        colorArray[i] = color(255, 255, 255);
      } else {
        colorArray[i] = color(0,0,0);
      }
      break;
      
    case 7:
      int c = int(in.mix.level()*soundSensitive.getValue());
      if (c>255) c=255;
      colorArray[i] = color(c,c,c);
      break;
      
    }
  }

  //very seldom in hotel mode, make everything black
  int r=int(random(77));
  if (mode == 5 && r==34) {
    for (int i=0; i<strKali.length(); i++) {
      colorArray[i] = color(0, 0, 0);
    }
  }
}

