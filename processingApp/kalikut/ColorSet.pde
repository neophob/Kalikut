private static int staticId = 0;
public class ColorSet {
     
    private String setName;
    
    private int r;
    
    private int g;
    
    private int b;

    private int id;
    
    public ColorSet(String setName, int r, int g, int b) {
      this.setName = setName;
      this.r = r;
      this.g = g;
      this.b = b;
      this.id = staticId++;
    }
    
    public String getSetName() {
      return setName; 
    }
    
    public int getR() {
      return r;
    }
    
    public int getG() {
      return g;
    }
    
    public int getB() {
      return b;
    }

    public int getId() {
      return id;
    }
    
}


