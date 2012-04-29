import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import processing.serial.*;

import controlP5.*;
import oscP5.*;

import com.neophob.lpd6803.*;
import com.neophob.lpd6803.misc.*;
import processing.lib.blinken.*;

private static final String STR_KALIKUT = "KALIKUTn";

private static final int NR_OF_PIXELS_X = STR_KALIKUT.length();
private static final int NR_OF_PIXELS_Y = 4;
private static final int OSC_PORT = 10000;
private static final String VERSION = "KALIKUT v0.6";

private PFont fontA;
private int frame;
private BlinkenLibrary blink;
private PImage tmpImg;

//gui
private ControlP5 cp5;
private RadioButton colorModeButton, animationButton, soundButton, colorButton;
private ColorPicker cp;
private Slider fpsSlider, allColorSlider, soundSensitive;
private Textarea myTextarea;
private CheckBox checkbox, checkboxInvertEffect;
private int globalDelayInv = 10;
private float globalDelayF;

//internal fx, save those settings for presets
private int genAnim = GEN_ANIM_NOTHING, genColor = GEN_COL_RAINBOW, genSnd = GEN_SND_NOTHING, colSet=0;
private boolean invertNow = false;
private boolean invertEffect = false;
private int globalDelay = 10;

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

private List<ColorSet> colorSet;

void setup() {
  size(800, 500);
  background(0);
  frameRate(20);
  smooth();

  // Load the font. Fonts must be placed within the data 
  // directory of your sketch. 
  fontA = loadFont("PTSans-Bold-120.vlw");

  // Set the font and its size (in units of pixels)
  textFont(fontA, 120);
  colorArray = new color[NR_OF_PIXELS_X*NR_OF_PIXELS_Y];

  //http://kuler.adobe.com/#themes/random?time=30
  colorSet = new ArrayList<ColorSet>();
  colorSet.add( new ColorSet("RGB",         new int[] { color(255, 0, 0), color(0, 255, 0), color(0, 0, 255) } ));
  colorSet.add( new ColorSet("MiamiVice",   new int[] { color(27, 227, 255), color(255, 130, 220), color(255, 255, 255)  } ));
  colorSet.add( new ColorSet("LeBron",      new int[] { color(62, 62, 62), color(212, 182, 0), color(255, 255, 255) } ));
  colorSet.add( new ColorSet("ML581AT",     new int[] { color(105, 150, 85), color(242, 106, 54), color(255, 255, 255) } ));
  colorSet.add( new ColorSet("Neon",        new int[] { color(50, 50, 40), color(113, 113, 85), color(180, 220, 0) } ));
  colorSet.add( new ColorSet("Rasta",       new int[] { color(220, 50, 60), color(240, 203, 88), color(60, 130, 94) }));
  colorSet.add( new ColorSet("Brazil",      new int[] { color(0, 140, 83), color(46, 0, 228), color(223, 234, 0) } ));
  colorSet.add( new ColorSet("MIUSA",       new int[] { color(80, 75, 70), color(26, 60, 83), color(160, 0, 40) } ));
  colorSet.add( new ColorSet("Simpson",     new int[] { color(#d9c23e), color(#a96a95), color(#7d954b), color(#4b396b) } ));
  colorSet.add( new ColorSet("Kitty",       new int[] { color(#9f456b), color(#4f7a9a), color(#e6c84c) } ));
  colorSet.add( new ColorSet("Kitty HC",    new int[] { color(#c756a7), color(#e0dd00), color(#c9cdd0) } ));
  colorSet.add( new ColorSet("Smurf",       new int[] { color(#44bdf4), color(#e31e3a), color(#e8b118), color(#1d1628), color(#ffffff) } )); 
  colorSet.add( new ColorSet("Lantern",     new int[] { color(#0d9a0d), color(#000000), color(#ffffff) } )); 
  colorSet.add( new ColorSet("Fame 575",    new int[] { color(#540c0d), color(#fb7423), color(#f9f48e), color(#4176c4), color(#5aaf2e) } ));
  colorSet.add( new ColorSet("CGA",         new int[] { color(#d3517d), color(#15a0bf), color(#ffc062) } ));  
  colorSet.add( new ColorSet("B&W",         new int[] { color(#000000), color(#ffffff) } ));    
  colorSet.add( new ColorSet("Civil",       new int[] { color(#362F2D), color(#4C4C4C), color(#94B73E), color(#B5C0AF), color(#FAFDF2) } ));  
  colorSet.add( new ColorSet("Dribble",     new int[] { color(#3D4C53), color(#70B7BA), color(#F1433F), color(#E7E1D4), color(#FFFFFF) } ));  
  colorSet.add( new ColorSet("Castle",      new int[] { color(#4B345C), color(#946282), color(#E5A19B) } ));  
  colorSet.add( new ColorSet("Fizz",        new int[] { color(#04BFBF), color(#F7E967), color(#588F27) } ));  


  initGui();
  frame=NR_OF_PIXELS_X*2; //init the safe way
  updateTextfield(VERSION); 
  initAudio();  
  initGenerator();
  //  initSerial();
  initLetter();

  /* start oscP5, listening for incoming messages at port 12000 */
  //  oscP5 = new OscP5(this, OSC_PORT);
  //  updateTextfield("OSC Server startet on port "+ OSC_PORT);  
}


void draw() {
  background(0);

  drawGradientBackground();

  //generate buffer content
  try {
    generator();    
  } catch (Exception e) {
    println("ooops: ");
    e.printStackTrace();
  }

  drawLetter();

  //display some audio stuff
  drawBeatStatus();

  //send serial data if initialized and wait at least 45ms before sending again
  if (initialized && System.currentTimeMillis()-lastSendTime > 19) {    
    println(lastSendTime+" send: "+colorArray.length);
    lpd6803.sendRgbFrame((byte)0, colorArray, ColorFormat.RGB);
    lastSendTime = System.currentTimeMillis();
  }
  frame++;
}

//COL: florida, gelb + rosa
//CGA Colors 
//FX: Voll da, voll weg,  snake,  stobo halb unten und oben
//Wasser fx?

