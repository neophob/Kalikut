import controlP5.*;

/**
 * Words. 
 * 
 * The text() function is used for writing words to the screen. 
 */

PFont fontA;
final String strKali = "KALIKUT now";
int frame;

//gui
private ControlP5 cp5;
private RadioButton modeButton;
private ColorPicker cp;

//internal fx
int mode=0;

int[] colorArray;  

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
  }
  frame++;
}
