import controlP5.*;

/**
 * Words. 
 * 
 * The text() function is used for writing words to the screen. 
 */

private PFont fontA;
private final String strKali = "KALIKUTn";
private int frame;

//gui
private ControlP5 cp5;
private RadioButton modeButton;
private ColorPicker cp;
private Slider slider;

//internal fx
private int mode=0;

//buffer
private int[] colorArray;  

void setup() {
  size(800, 400);
  background(0);

  // Load the font. Fonts must be placed within the data 
  // directory of your sketch. 
  fontA = loadFont("PTSans-Bold-120.vlw");

  // Set the font and its size (in units of pixels)
  textFont(fontA, 120);
  colorArray = new color[strKali.length()];
  smooth();
  initGui();
  
  frameRate(25);
}


void draw() {
  background(0);
  
  //generate buffer content
  generator();
  
  //tint buffer
  tintBuffer();

  String wrote="";
  int sw = 0;
  for (int i=0; i<strKali.length(); i++) {
    
    fill(colorArray[i]);
    text(""+strKali.charAt(i), 30+sw, 130);

    wrote += strKali.charAt(i);
    sw=int(textWidth(wrote));
    
    //simulate space
    if (i==6) sw+=40;
  }
  text("ow", 70+sw, 130);
  frame++;
}
