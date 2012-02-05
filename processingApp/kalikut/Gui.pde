//create the gui

void initGui() {
  cp5 = new ControlP5(this);

  modeButton = cp5.addRadioButton("modeButton")
    .setPosition(20, 200)
      .setSize(40, 20)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setItemsPerRow(6)
                .setSpacingColumn(80)
                  .setNoneSelectedAllowed(false)
                    .addItem("Rainbow", 0)
                      .addItem("Rainbow Solid", 1)
                        .addItem("Strobo 1", 2)
                          .addItem("Strobo 2", 3)
                            .addItem("Solid", 4)
                              .addItem("Hotel", 5)
                                .addItem("Beat", 6)
                                  .addItem("Volume", 7)
                                    .addItem("Test", 8)
                                      .activate(0);

  cp = cp5.addColorPicker("picker")
    .setPosition(20, 280)
      .setColorValue(color(255, 255, 255, 255))
        ;

  // add a vertical slider
  fpsSlider = cp5.addSlider("Speed")
    .setPosition(300, 280)
      .setSize(200, 20)
        .setRange(0, 1)
          .setValue(.6)
            ;


  allColorSlider = cp5.addSlider("RGB Colors")
    .setPosition(20, 360-1)
      .setSize(200, 20)
        .setRange(0, 255)
          .setValue(255)
            .setDecimalPrecision(0)
              ;

  soundSensitive= cp5.addSlider("Sound Sensitive")
    .setPosition(300, 320-1)
      .setSize(200, 20)
        .setRange(1, 5000)
          .setValue(255)
            .setDecimalPrecision(0)
              ;

  myTextarea = cp5.addTextarea("txt")
    .setPosition(580, 280)
      .setSize(200, 80)
        .setFont(createFont("arial", 12))
          .setLineHeight(14)
            .setColor(color(192))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));
  ;

  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(300, 360-1)
      .setColorForeground(color(120))
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setSize(20, 20)
              .addItem("Invert NOW", 0)
                ;

  Textlabel tl = cp5.addTextlabel("sdesc", "KICK/SNARE/HAT", BOX_X, 175);
  tl.setFont(ControlP5.standard58);
}


final int BOX_X = 37;
final int BOX_Y = 150;
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

  final int SINE_X = BOX_X+BOX_X_SIZE*4;
  stroke(255);  
  // draw the waveforms
  for (int i = 0; i < in.bufferSize()-1; i++) {
    line(SINE_X+i, 10+BOX_Y + in.mix.get(i)*30, SINE_X+i+1, 10+BOX_Y + in.mix.get(i+1)*30);
  }

  stroke(0);
}



void updateTextfield(String text) {
  String s = myTextarea.getText();
  s += text+"\n";
  myTextarea.setText(s);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(modeButton)) {
    mode = int(theEvent.getValue());
    return;
  }

  if (theEvent.isFrom(fpsSlider)) {
    int fps = 5+int(55*fpsSlider.getValue());
    //println("framerate: "+fps);
    frameRate(fps);
  }

  if (theEvent.isFrom(allColorSlider)) {
    int x = int(allColorSlider.getValue());
    cp.setColorValue(color(x, x, x));
    //println("allrgb: "+x);
  }
  
  if (theEvent.isFrom(checkbox)) {
    if (checkbox.getArrayValue()[0] > 0) {
      invertNow = true;
    } else {
      invertNow = false;
    }
  }
  
}


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
  this.updatePixels();
}

