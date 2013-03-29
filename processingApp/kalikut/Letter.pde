private PGraphics pg;

//pixel size of the font
private static final int FONT_HEIGHT = 84;
//y offset where the image begins
private static final int FONT_Y_OFS = 26;

private static final int IMAGE_Y_SIZE = 120;
private int totalWidth = 0; 

public void initLetter() {
  //init array
  letterWidth = new int[STR_YONAS.length()];

  //get width of each char
  for (int i=0; i<STR_YONAS.length(); i++) {
    String s = ""+STR_YONAS.charAt(i);
    int w = int(textWidth(s));    
    letterWidth[i] = w;
    totalWidth += w;
  }

  pg=createGraphics(totalWidth, 120, JAVA2D);
  pg.beginDraw();
  pg.background(color(0, 0, 0));
  pg.fill(color(255, 255, 255));
  pg.textFont(fontA, IMAGE_Y_SIZE);
  pg.textSize(IMAGE_Y_SIZE);
  pg.text(STR_YONAS, 0, 110);
  pg.endDraw();

  logoImg = createImage(totalWidth, IMAGE_Y_SIZE, ARGB);
  logoImg.loadPixels();
  pg.loadPixels();

  //copy text
  for (int i=0; i<pg.pixels.length; i++) {
    logoImg.pixels[i] = pg.pixels[i];
  }

  pg.updatePixels();
  logoImg.updatePixels();
}

private static final int XOFS = 40;

public void drawLetter() {
  pg.beginDraw();
  pg.smooth();
  pg.noStroke();
  pg.background(0);

//  int ydelta = IMAGE_Y_SIZE/NR_OF_PIXELS_Y+6;
  int ydelta = FONT_HEIGHT/NR_OF_PIXELS_Y;
  
  int xofs=0;
  int yofs=FONT_Y_OFS; //26 is the y ofset of the font
  int srcOfs=0;
  
  for (int y=0; y<NR_OF_PIXELS_Y; y++) {
    xofs=0;
    for (int x=0; x<NR_OF_PIXELS_X; x++) {
      pg.fill(getSimulated5BitColor(srcOfs++));

      //special handle the now here, now has only one segment
      if (x==NR_OF_PIXELS_X-1) {
        if (y==0) {
          pg.rect(xofs, FONT_Y_OFS, letterWidth[x], FONT_HEIGHT);
        }
      } 
      else {
        //draw a regular segment
        pg.rect(xofs, yofs, letterWidth[x], yofs+ydelta);
      }      
      xofs += letterWidth[x];
    }
    yofs += ydelta;
  }
  pg.endDraw();

  pg.blend(logoImg, 0, 0, totalWidth, IMAGE_Y_SIZE, 0, 0, totalWidth, IMAGE_Y_SIZE, MULTIPLY);
  image(pg, XOFS, 0);
}

static final int SHIFT_COL = 3; //8bpp-3bpp=5bpp, tadaaa

//return a 15bpp color instead a 24bpp color
color getSimulated5BitColor(int ofs) {
  int col = colorArray[ofs];

  int r = (int) ((col>>16) & 255);
  int g = (int) ((col>>8)  & 255);
  int b = (int) ( col      & 255);

  r >>= SHIFT_COL;
  g >>= SHIFT_COL;
  b >>= SHIFT_COL;
  r <<= SHIFT_COL;
  g <<= SHIFT_COL;
  b <<= SHIFT_COL;

  return color(r, g, b);
}

