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
    
}


