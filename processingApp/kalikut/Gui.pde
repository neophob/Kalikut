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
    .setPosition(300, 320-1)
      .setSize(200, 20)
        .setRange(0, 255)
          .setValue(255)
            .setDecimalPrecision(0)
              ;

  soundSensitive= cp5.addSlider("Sound Sensitive")
    .setPosition(300, 360-2)
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
}

