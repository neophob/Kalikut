import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

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

private static final String STR_KALIKUT = "KALIKUTn";

private static final int NR_OF_PIXELS_X = STR_KALIKUT.length();
private static final int NR_OF_PIXELS_Y = 1;
private static final int OSC_PORT = 10000;
private static final String VERSION = "KALIKUT v0.3";

private PFont fontA;
private int frame;

//gui
private ControlP5 cp5;
private RadioButton modeButton;
private ColorPicker cp;
private Slider fpsSlider, allColorSlider, soundSensitive;
private Textarea myTextarea;
private CheckBox checkbox;

//internal fx
private int mode = 0;
private boolean invertNow = false;

//buffer
private int[] colorArray;  

//Serial
private Lpd6803 lpd6803;
private boolean initialized;
private long lastSendTime;

//OSC
private OscP5 oscP5;

//output
private int[] letterWidth;
private PImage logoImg;


void setup() {
  size(800, 400);
  background(0);
  frameRate(25);
  smooth();
  
  // Load the font. Fonts must be placed within the data 
  // directory of your sketch. 
  fontA = loadFont("PTSans-Bold-120.vlw");

  // Set the font and its size (in units of pixels)
  textFont(fontA, 120);
  colorArray = new color[NR_OF_PIXELS_X*NR_OF_PIXELS_Y];

  initGui();
  frame=NR_OF_PIXELS_X*2; //init the safe way
  updateTextfield(VERSION); 
  initAudio();  
  initGenerator();
  initSerial();
  initLetter();

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, OSC_PORT);
  updateTextfield("OSC Server startet on port "+ OSC_PORT);
}


void draw() {
  background(0);
  drawGradientBackground();
  
  //generate buffer content
  generator();

  //tint buffer
  tintBuffer();

  //display some audio stuff
  drawBeatStatus();

  drawLetter();

  //send serial data if initialized and wait at least 19ms before sending again
  if (initialized && System.currentTimeMillis()-lastSendTime > 25) {    
    lastSendTime = System.currentTimeMillis();
    //println(lastSendTime+" send: "+colorArray.length);
    lpd6803.sendRgbFrame((byte)0, colorArray, ColorFormat.RGB);
  }
  frame++;
}

