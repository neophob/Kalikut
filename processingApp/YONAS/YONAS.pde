import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import controlP5.*;
import oscP5.*;

import processing.lib.blinken.*;

private static final String STR_YONAS = "YONAS";
private static final int XOFS_TEXT = 220;

private static final int NR_OF_PIXELS_X = STR_YONAS.length();
private static final int NR_OF_PIXELS_Y = 4;
private static final int OSC_PORT = 10000;
private static final String VERSION = "Yonas v0.62";

private PFont fontA;
private int frame;
private BlinkenLibrary blink;
private PImage tmpImg;

//e1.31
private InetAddress targetAdress;
private E1_31DataPacket dataPacket = new E1_31DataPacket();
private DatagramPacket packet;
private DatagramSocket dsocket;
private int sequenceID;
private int pixelsPerUniverse;
private int nrOfUniverse;
private int firstUniverseId;


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
  loadConfigFile();
  
  // Load the font. Fonts must be placed within the data 
  // directory of your sketch. 
  fontA = loadFont("PTSans-Bold-120.vlw");

  // Set the font and its size (in units of pixels)
  textFont(fontA, 120);
  colorArray = new color[NR_OF_PIXELS_X*NR_OF_PIXELS_Y];

  //http://kuler.adobe.com/#themes/random?time=30
  colorSet = new ArrayList<ColorSet>();
  initColorset();

  initGui();
  frame=NR_OF_PIXELS_X*2; //init the safe way
  updateTextfield(VERSION); 
  initAudio();  
  setupAnimation();
  setupColor();
  initE131();
  initLetter();

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, OSC_PORT);
  updateTextfield("OSC Server startet on port "+ OSC_PORT);
  
  updateTextfield("E1.31 controller at "+e131Ip);
}


void draw() {
  background(0);

  drawGradientBackground();

  //generate buffer content
  try {
    generateColor();  
    //tint buffer
    tintBuffer();
    generateAnimation();
    generateSound();
  } 
  catch (Exception e) {
    println("ooops: ");
    e.printStackTrace();
  }

  drawLetter();

  //display some audio stuff
  drawBeatStatus();

  sendE131();
  //send serial data if initialized and wait at least 45ms before sending again
  /*  if (initialized && System.currentTimeMillis()-lastSendTime > 19) {    
   println(lastSendTime+" send: "+colorArray.length);
   lpd6803.sendRgbFrame((byte)0, colorArray, ColorFormat.RGB);
   lastSendTime = System.currentTimeMillis();
   }*/
  frame++;
}


