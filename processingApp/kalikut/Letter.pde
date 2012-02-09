PGraphics pg;

public void initLetter() {
  String letters = "KALIKUTn";
  int totalWidth = 0; 
  //init array
  letterWidth = new int[letters.length()];

  //get width of each char
  for (int i=0; i<letters.length(); i++) {
    String s = ""+letters.charAt(i);
    if (s.equals("n")) {
      s = "now ";
    }

    int w = int(textWidth(s));
    println(s+" width: "+w);
    letterWidth[i] = w;
    totalWidth += w;
  }

  pg=createGraphics(totalWidth, 120, JAVA2D);
  pg.beginDraw();
  pg.background(color(0, 0, 0));
  pg.fill(color(255, 255, 255));
  pg.textFont(fontA, 120);
  pg.textSize(120);
  pg.text("KALIKUT now", 0, 110);
  pg.endDraw();
  logoImg = pg;
}

private static final int OFS = 40;

public void drawLetter() {
  pg.beginDraw();
  pg.background(0);
//pg.image(logoImg, 0, 0);

  int ofs=0;
  for (int i=0; i<colorArray.length; i++) {
    pg.fill(colorArray[i]);

    pg.rect(ofs, 0, letterWidth[i], 50);
    ofs += letterWidth[i];
  }
  pg.blend(logoImg, 0, 0, logoImg.width, logoImg.height, 0, 0, logoImg.width, logoImg.height, ADD);

  pg.endDraw();
  image(pg, OFS, 0);
}

