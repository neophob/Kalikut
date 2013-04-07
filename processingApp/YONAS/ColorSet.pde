private static int staticId = 0;
public class ColorSet {

  private String name;

  private int id;

  private int[] colors;
  
  private int boarderCount;

  public ColorSet(String name, int[] colors) {
    this.name = name;
    this.id = staticId++;
    this.colors = colors.clone();
    this.boarderCount = 255 / colors.length;
  }

  public String getName() {
    return name;
  }

  public int getId() {
    return id;
  }

  public int getRandomColor() {
    int rnd = int(random(colors.length));    
    return this.colors[rnd];
  }

  color getSmoothColor(int pos) {
    pos %= 255;
    int ofs=0;
    while (pos > boarderCount) {
      pos -= boarderCount;
      ofs++;
    }
    
    int targetOfs = (ofs+1)%colors.length;
    //println("ofs:"+ofs+" targetofs:"+targetOfs);    
    return calcSmoothColor(colors[targetOfs], colors[ofs], pos);
  }
  
  
  private color calcSmoothColor(int col1, int col2, int pos) {
    int b= col1&255;
    int g=(col1>>8)&255;
    int r=(col1>>16)&255;
    int b2= col2&255;
    int g2=(col2>>8)&255;
    int r2=(col2>>16)&255;

    int mul=pos*colors.length;
    int oppisiteColor = 255-mul;
    r=(r*mul)/255;
    g=(g*mul)/255;
    b=(b*mul)/255;
    r+=(r2*oppisiteColor)/255;
    g+=(g2*oppisiteColor)/255;
    b+=(b2*oppisiteColor)/255;

    return color(r, g, b);
  }
  
}


void initColorset() {
  colorSet.add( new ColorSet("RGB", new int[] { 
    color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)
  } 
  ));
  colorSet.add( new ColorSet("MiamiVice", new int[] { 
    color(27, 227, 255), color(255, 130, 220), color(255, 255, 255)
  } 
  ));
  colorSet.add( new ColorSet("LeBron", new int[] { 
    color(62, 62, 62), color(212, 182, 0), color(255, 255, 255)
  } 
  ));
  colorSet.add( new ColorSet("ML581AT", new int[] { 
    color(105, 150, 85), color(242, 106, 54), color(255, 255, 255)
  } 
  ));
  colorSet.add( new ColorSet("Neon", new int[] { 
    color(50, 50, 40), color(113, 113, 85), color(180, 220, 0)
  } 
  ));
  colorSet.add( new ColorSet("Rasta", new int[] { 
    color(220, 50, 60), color(240, 203, 88), color(60, 130, 94)
  }
  ));
  colorSet.add( new ColorSet("Brazil", new int[] { 
    color(0, 140, 83), color(46, 0, 228), color(223, 234, 0)
  } 
  ));
  colorSet.add( new ColorSet("MIUSA", new int[] { 
    color(80, 75, 70), color(26, 60, 83), color(160, 0, 40)
  } 
  ));
  colorSet.add( new ColorSet("Simpson", new int[] { 
    color(#d9c23e), color(#a96a95), color(#7d954b), color(#4b396b)
  } 
  ));
  colorSet.add( new ColorSet("Kitty", new int[] { 
    color(#9f456b), color(#4f7a9a), color(#e6c84c)
  } 
  ));
  colorSet.add( new ColorSet("Kitty HC", new int[] { 
    color(#c756a7), color(#e0dd00), color(#c9cdd0)
  } 
  ));
  colorSet.add( new ColorSet("Smurf", new int[] { 
    color(#44bdf4), color(#e31e3a), color(#e8b118), color(#1d1628), color(#ffffff)
  } 
  )); 
  colorSet.add( new ColorSet("Lantern", new int[] { 
    color(#0d9a0d), color(#000000), color(#ffffff)
  } 
  )); 
  colorSet.add( new ColorSet("Fame 575", new int[] { 
    color(#540c0d), color(#fb7423), color(#f9f48e), color(#4176c4), color(#5aaf2e)
  } 
  ));
  colorSet.add( new ColorSet("CGA", new int[] { 
    color(#d3517d), color(#15a0bf), color(#ffc062)
  } 
  ));  
  colorSet.add( new ColorSet("B&W", new int[] { 
    color(#000000), color(#ffffff)
  } 
  ));    
  colorSet.add( new ColorSet("Civil", new int[] { 
    color(#362F2D), color(#4C4C4C), color(#94B73E), color(#B5C0AF), color(#FAFDF2)
  } 
  ));  
  colorSet.add( new ColorSet("Dribble", new int[] { 
    color(#3D4C53), color(#70B7BA), color(#F1433F), color(#E7E1D4), color(#FFFFFF)
  } 
  ));  
  colorSet.add( new ColorSet("Castle", new int[] { 
    color(#4B345C), color(#946282), color(#E5A19B)
  } 
  ));  
  colorSet.add( new ColorSet("Fizz", new int[] { 
    color(#04BFBF), color(#F7E967), color(#588F27)
  } 
  ));    
}
