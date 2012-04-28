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

