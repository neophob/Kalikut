//einem SOUNDGENERATOR (nix, beat detection oder volume) vermischt werden.

private static final int GEN_SND_NOTHING = 1;
private static final int GEN_SND_BEAT = 2;
private static final int GEN_SND_VOLUME = 3;

private static final int MAX_SOUND = 3;

void generateSound() {

  if (genSnd == GEN_SND_NOTHING) {
    return;
  }

  int sndCol = 0; 

  switch(genSnd) {

  case GEN_SND_BEAT: //Beat
    if (beat.isKick() || beat.isHat() || beat.isSnare()) {
      sndCol = color(255, 255, 255);
    } 
    else {
      sndCol = color(0, 0, 0);
    }
    break;

  case GEN_SND_VOLUME: //volume
    int c = int(in.mix.level()*soundSensitive.getValue());
    if (c>255) c=255;
    sndCol = color(c, c, c);
    break;
  }

  for (int i=0; i<colorArray.length; i++) {
    int blendedColor = blendColor(sndCol, 0xff000000 | colorArray[i], MULTIPLY);
    colorArray[i] = blendedColor;
  }

}
