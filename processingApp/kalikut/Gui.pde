//create the gui

void initGui() {
  cp5 = new ControlP5(this);

  modeButton = cp5.addRadioButton("modeButton")
    .setPosition(20, 200)
      .setSize(40, 20)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setItemsPerRow(8)
                .setSpacingColumn(80)
                  .setNoneSelectedAllowed(false)
                    .addItem("Rainbow", 0)
                      .addItem("Rainbow Solid", 1)
                        .addItem("Strobo 1", 2)
                          .addItem("Strobo 2", 3)
                            .addItem("Solid", 4)
                              .addItem("Hotel", 5)
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
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(modeButton)) {
    mode = int(theEvent.getValue());

    //init hotel mode
    if (mode==5) {
      //cp.setColorValue(color(255, 72, 0));
    }
    return;
  }

  if (theEvent.isFrom(fpsSlider)) {
    int fps = 5+int(35*fpsSlider.getValue());
    //println("framerate: "+fps);
    frameRate(fps);
  }

  if (theEvent.isFrom(allColorSlider)) {
    int x = int(allColorSlider.getValue());
    cp.setColorValue(color(x,x,x));
    //println("allrgb: "+x);
  }
}

