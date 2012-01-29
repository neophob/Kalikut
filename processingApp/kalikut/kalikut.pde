import processing.serial.*;

import controlP5.*;
import oscP5.*;

import com.neophob.lpd6803.*;
import com.neophob.lpd6803.misc.*;

/**
 * Words. 
 * 
 * The text() function is used for writing words to the screen. 
 */
private static final int NR_OF_PIXELS = 8;

private final String strKali = "KALIKUTn";

private PFont fontA;
private int frame;

//gui
private ControlP5 cp5;
private RadioButton modeButton;
private ColorPicker cp;
private Slider fpsSlider, allColorSlider;

//internal fx
private int mode=0;

//buffer
private int[] colorArray;  

//Serial
private Lpd6803 lpd6803;
private boolean initialized;

//OSC
private OscP5 oscP5;

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

  try {
    lpd6803 = new Lpd6803(this, NR_OF_PIXELS);          
    this.initialized = lpd6803.ping();
    println("ping result: "+ this.initialized);
  } 
  catch (NoSerialPortFoundException e) {
    println("failed to initialize serial port!");
  }

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);



  frameRate(25);
}


void draw() {
  background(0);

  //generate buffer content
  generator();

  //tint buffer
  tintBuffer();

  //show simulation
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
  //write rest of text
  text("ow", 70+sw, 130);

  //send serial data
  if (initialized) {
    lpd6803.sendRgbFrame((byte)0, colorArray, ColorFormat.RGB);
  }

  frame++;
}

