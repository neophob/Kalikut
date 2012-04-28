private static int staticId = 0;
public class ColorSet {

  private String setName;

  private int c1;

  private int c2;

  private int c3;

  private int id;

  public ColorSet(String setName, int c1, int c2, int c3) {
    this.setName = setName;
    this.c1 = c1;
    this.c2 = c2;
    this.c3 = c3;
    this.id = staticId++;
  }

  public String getSetName() {
    return setName;
  }

  public int getC1() {
    return c1;
  }

  public int getC2() {
    return c2;
  }

  public int getC3() {
    return c3;
  }

  public int getId() {
    return id;
  }


  color calcSmoothColor(int col1, int col2, int pos) {
    int b= col1&255;
    int g=(col1>>8)&255;
    int r=(col1>>16)&255;
    int b2= col2&255;
    int g2=(col2>>8)&255;
    int r2=(col2>>16)&255;

    int p3=pos*3;
    int oppisiteColor = 255-p3;
    r=(r*p3)/255;
    g=(g*p3)/255;
    b=(b*p3)/255;
    r+=(r2*oppisiteColor)/255;
    g+=(g2*oppisiteColor)/255;
    b+=(b2*oppisiteColor)/255;

    return color(r, g, b);
  }

  color getSmoothColor(int pos) {
    pos %= 255;
    if (pos < 85) {
      return calcSmoothColor(c2, c1, pos);
    } 
    else if (pos < 170) {
      pos -= 85;
      return calcSmoothColor(c3, c2, pos);
    } 
    pos -= 170;
    return calcSmoothColor(c1, c3, pos); 
  }
}

