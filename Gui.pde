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
}



void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(modeButton)) {
    mode = int(theEvent.getValue());
    return;
  }
  
  if (theEvent.isFrom(cp)) {
    println("colr");
  }
}

