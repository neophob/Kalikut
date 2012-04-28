private static int staticId = 0;
public class ColorSet {

  private String setName;

  private int id;

  private int[] colors;
  
  private int boarderCount;

  public ColorSet(String setName, int[] colors) {
    this.setName = setName;
    this.id = staticId++;
    this.colors = colors.clone();
    this.boarderCount = 255 / colors.length;
  }

  public String getSetName() {
    return setName;
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
  
  
  color calcSmoothColor(int col1, int col2, int pos) {
    int b= col1&255;
    int g=(col1>>8)&255;
    int r=(col1>>16)&255;
    int b2= col2&255;
    int g2=(col2>>8)&255;
    int r2=(col2>>16)&255;

    int p3=pos*colors.length;
    int oppisiteColor = 255-p3;
    r=(r*p3)/255;
    g=(g*p3)/255;
    b=(b*p3)/255;
    r+=(r2*oppisiteColor)/255;
    g+=(g2*oppisiteColor)/255;
    b+=(b2*oppisiteColor)/255;

    return color(r, g, b);
  }
  
}

