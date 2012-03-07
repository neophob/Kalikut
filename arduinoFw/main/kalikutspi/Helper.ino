unsigned int Color(byte r, byte g, byte b) {
  //Take the lowest 5 bits of each value and append them end to end
  return( ((unsigned int)g & 0x1F )<<10 | ((unsigned int)b & 0x1F)<<5 | (unsigned int)r & 0x1F);
}

// --------------------------------------------
//     Input a value 0 to 95 to get a color value.
//     The colours are a transition r - g -b - back to r
// --------------------------------------------
unsigned int Wheel(byte WheelPos) {
  byte r,g,b;
  switch(WheelPos >> 5) {
  case 0:
    r=31- WheelPos % 32;   //Red down
    g=WheelPos % 32;      // Green up
    b=0;                  //blue off
    break; 
  case 1:
    g=31- WheelPos % 32;  //green down
    b=WheelPos % 32;      //blue up
    r=0;                  //red off
    break; 
  case 2:
    b=31- WheelPos % 32;  //blue down 
    r=WheelPos % 32;      //red up
    g=0;                  //green off
    break; 
  }
  return(Color(r,g,b));
}

int ff;

// --------------------------------------------
//     do some animation until serial data arrives
// --------------------------------------------
void rainbow() {
  
    ff++;
  if (ff>31) ff=0;

  for (int i=0; i < strip.numPixels(); i++) {
    //strip.setPixelColor(i, Wheel( i % 96));
//    strip.setPixelColor(i, Color(ff,0,0));
//    strip.setPixelColor(i, Color(0,ff,0));    
//    strip.setPixelColor(i, Color(0,0,ff));    
//    strip.setPixelColor(i, Color(ff,0,ff));    
//    strip.setPixelColor(i, Color(0,ff,ff));    
    strip.setPixelColor(i, Color(ff,ff,ff));    
  }    

      strip.show();
  delay(50);  //remove this delay to check the max cpu setting

/*
  k++;
  if (k>20) {
    k=0;
    j++;
    if (j>96) {  // 3 cycles of all 96 colors in the wheel
      j=0; 
    }

    for (int i=0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel((i + j) % 96));
    }
    strip.show();
  }*/
}

// --------------------------------------------
//     create initial image
// --------------------------------------------
void showInitImage() {
  for (int i=0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, Wheel( i % 96));    
  }    
  // Update the strip, to start they are all 'off'
  strip.show();
}

