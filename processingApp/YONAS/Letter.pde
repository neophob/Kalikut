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
      pg.fill(colorArray[srcOfs++]);
      pg.rect(xofs, yofs, letterWidth[x], yofs+ydelta);      
      xofs += letterWidth[x];
    }
    yofs += ydelta;
  }
  pg.endDraw();

  pg.blend(logoImg, 0, 0, totalWidth, IMAGE_Y_SIZE, 0, 0, totalWidth, IMAGE_Y_SIZE, MULTIPLY);
  image(pg, XOFS_TEXT, 0);
}


