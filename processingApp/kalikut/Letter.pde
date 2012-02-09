
public void initLetter() {
  String letters = "KALIKUTn";
  int totalWidth = 0; 
  //init array
  letterWidth = new int[letters.length()];

  //get width of each char
  for (int i=0; i<letters.length(); i++) {
    String s = ""+letters.charAt(i);
    if (s.equals("n")) {
      s = "now";
    }

    int w = int(textWidth(s));
    println(s+" width: "+w);
    letterWidth[i] = w;
    totalWidth += w;
  }

  PGraphics pg;
  pg=createGraphics(totalWidth, 200, JAVA2D);

  pg.beginDraw();
  pg.background(color(255,255,0));
  pg.fill(color(0,0,255));
  pg.text("KALIKUT now",50 ,20);
  pg.textFont(fontA, 120);
  pg.textSize(140);
  
  pg.endDraw();
  logoImg = pg;
//  logoImg = createImage(totalWidth, 200, RGB);
//  logoImg.text("KALIKUT now");
}



public void drawLetter() {
  image(logoImg, 30, 120);
}
