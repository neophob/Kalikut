//create the gui

void initGui() {
  cp5 = new ControlP5(this);

  colorModeButton = cp5.addRadioButton("colorModeButton")
    .setPosition(20, 200)
      .setSize(40, 20)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setItemsPerRow(6)
                .setSpacingColumn(80)
                  .setNoneSelectedAllowed(false)
                    .addItem("Rainbow", GEN_COL_RAINBOW)
                      .addItem("Rainbow Solid", GEN_COL_RAINBOW_SOLID)
                        .addItem("Solid Chars", GEN_COL_SOLIDCHAR)
                          .addItem("Kaos", GEN_COL_KAOS)
                            .addItem("Plasma", GEN_COL_PLASMA)                                            
                              .addItem("Solid", GEN_COL_SOLID)
                                .addItem("Fire", GEN_COL_FIRE)
                                  //                                .addItem("Pulse", GEN_COL_PULSE)        
                                  //                                    .addItem("Glace", GEN_COL_GLACE)  
                                  .activate(0);

  animationButton = cp5.addRadioButton("animationButton")
    .setPosition(20, 260)
      .setSize(40, 20)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setItemsPerRow(6)
                .setSpacingColumn(80)
                  .setNoneSelectedAllowed(false)
                    .addItem("Nothing", GEN_ANIM_NOTHING)
                      .addItem("Strobo Vert 1", GEN_ANIM_STROBO1)
                        .addItem("Strobo Vert 2", GEN_ANIM_STROBO2)
                          .addItem("One Char", GEN_ANIM_ONE_CHAR)
                            .addItem("Random Char", GEN_ANIM_RANDOM_CHAR)
                              .addItem("Funny", GEN_ANIM_FUNNY)
                                //.addItem("Hotel", GEN_ANIM_HOTEL)
                                .addItem("KnightRider", GEN_ANIM_KNIGHTRIDER)
                                  .addItem("Flipper", GEN_ANIM_FLIPPER)
                                    .addItem("Fader", GEN_ANIM_FADER)
                                      .addItem("Inverter", GEN_ANIM_INVERTER)
                                        .addItem("Strobo Horiz 1", GEN_ANIM_STROBO_H)
                                          .addItem("Strobo Horiz 2", GEN_ANIM_STROBO_H2)
                                            .activate(0);

  soundButton = cp5.addRadioButton("soundButton")
    .setPosition(20, 320)
      .setSize(40, 20)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setItemsPerRow(6)
                .setSpacingColumn(80)
                  .setNoneSelectedAllowed(false)
                    .addItem("Nada", GEN_SND_NOTHING)
                      .addItem("Beat Detection", GEN_SND_BEAT)
                        .addItem("Volume", GEN_SND_VOLUME)
                          .addItem("Volume Border", GEN_SND_VOLUME2)
                            .activate(0);

  cp = cp5.addColorPicker("picker")
    .setPosition(20, 380)
      .setColorValue(color(255, 255, 255, 255))
        ;

  // add a vertical slider
  fpsSlider = cp5.addSlider("Speed")
    .setPosition(300, 380)
      .setSize(200, 20)
        .setRange(0, 1)
          .setValue(.6)
            ;


  allColorSlider = cp5.addSlider("RGB Colors")
    .setPosition(20, 460-1)
      .setSize(200, 20)
        .setRange(0, 255)
          .setValue(255)
            .setDecimalPrecision(0)
              ;

  soundSensitive= cp5.addSlider("Sound Sensitive")
    .setPosition(300, 420-1)
      .setSize(200, 20)
        .setRange(1, 5000)
          .setValue(255)
            .setDecimalPrecision(0)
              ;

  myTextarea = cp5.addTextarea("txt")
    .setPosition(580, 380)
      .setSize(200, 80)
        .setFont(createFont("arial", 12))
          .setLineHeight(14)
            .setColor(color(192))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));
  ;

  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(300, 460-1)
      .setColorForeground(color(120))
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setSize(20, 20)
              .addItem("Invert NOW", 0)
                ;

  //radiobuttons with color
  colorButton = cp5.addRadioButton("colorButton")
    .setPosition(20, 140)
      .setSize(20, 20)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setItemsPerRow(11)
                .setSpacingColumn(50)
                  .setNoneSelectedAllowed(false);

  int i=0;
  for (ColorSet cs: colorSet) {
    colorButton.addItem(cs.getSetName(), i++);
  }
  colorButton.activate(0);

  Textlabel tl = cp5.addTextlabel("sdesc", "KICK/SNARE/HAT", BOX_X+6, 6+BOX_Y+BOX_Y_SIZE);
  tl.setFont(ControlP5.standard58);
}


final int BOX_X = 700;
final int BOX_Y = 0;
final int BOX_X_SIZE = 30;
final int BOX_Y_SIZE = 20;

void drawBeatStatus() {
  if (beat.isKick()) {
    fill(activeCol);
  } 
  else {
    fill(inActiveCol);
  }
  rect(BOX_X, BOX_Y, BOX_X_SIZE, BOX_Y_SIZE);

  if (beat.isSnare()) {
    fill(activeCol);
  } 
  else {
    fill(inActiveCol);
  }
  rect(BOX_X+BOX_X_SIZE, BOX_Y, BOX_X_SIZE, BOX_Y_SIZE);

  if (beat.isHat()) {
    fill(activeCol);
  } 
  else {
    fill(inActiveCol);
  }
  rect(BOX_X+BOX_X_SIZE*2, BOX_Y, BOX_X_SIZE, BOX_Y_SIZE);
/*
  final int SINE_X = BOX_X+BOX_X_SIZE*4;
  stroke(255);  
  // draw the waveforms
  for (int i = 0; i < in.bufferSize()-1; i++) {
    line(SINE_X+i, 10+BOX_Y + in.mix.get(i)*30, SINE_X+i+1, 10+BOX_Y + in.mix.get(i+1)*30);
  }

  stroke(0);*/
}



void updateTextfield(String text) {
  String s = myTextarea.getText();
  s += text+"\n";
  myTextarea.setText(s);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(colorModeButton)) {
    genColor = int(theEvent.getValue());
    return;
  }

  if (theEvent.isFrom(animationButton)) {
    genAnim = int(theEvent.getValue());
    return;
  }

  if (theEvent.isFrom(soundButton)) {
    genSnd = int(theEvent.getValue());
    return;
  }

  if (theEvent.isFrom(colorButton)) {
    colSet = int(theEvent.getValue());
    return;
  }

  if (theEvent.isFrom(fpsSlider)) {
    globalDelay = 2+int(18*fpsSlider.getValue());
    globalDelayInv = 21-globalDelay;
    globalDelayF = fpsSlider.getValue();
    //    println("INV: "+globalDelay);
  }

  if (theEvent.isFrom(allColorSlider)) {
    int x = int(allColorSlider.getValue());
    cp.setColorValue(color(x, x, x));
    //println("allrgb: "+x);
  }

  if (theEvent.isFrom(checkbox)) {
    if (checkbox.getArrayValue()[0] > 0) {
      invertNow = true;
    } 
    else {
      invertNow = false;
    }
  }
}

int slideBackground = color(48, 48, 48);

//draw some rectangles
void drawBackgroundSlide(int ypos, int ysize) {

  int ofs=this.width*ypos;
  for (int y=0; y<ysize; y++) {
    for (int x=10; x<this.width-10; x++) {
      this.pixels[ofs+x] = slideBackground;
    }
    ofs += this.width;
  }
}

//draw background
void drawGradientBackground() {
  this.loadPixels();	
  int ofs=this.width*(this.height-255);

  for (int y=0; y<255; y++) {
    int pink = color(y/2, y/2, y/2);
    for (int x=0; x<this.width; x++) {
      this.pixels[ofs+x] = pink;
    }
    ofs += this.width;
  }

  drawBackgroundSlide(135, 51);
  drawBackgroundSlide(195, 51);
  drawBackgroundSlide(255, 51);
  drawBackgroundSlide(315, 51);

  this.updatePixels();
}

