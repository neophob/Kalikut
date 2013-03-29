//einem SOUNDGENERATOR (nix, beat detection oder volume) vermischt werden.

private static final int GEN_SND_NOTHING = 1;
private static final int GEN_SND_BEAT = 2;
private static final int GEN_SND_VOLUME = 3;
private static final int GEN_SND_VOLUME2 = 4;

private static final int MAX_SOUND = 4;

private static final int SOUND_DELAY_IN_MS = 250;

private long lastSoundFader = 0;

void generateSound() {

  if (genSnd == GEN_SND_NOTHING) {
    return;
  }

  int sndCol = 0; 

  switch(genSnd) {

  case GEN_SND_BEAT: //Beat
    if (beat.isKick() || beat.isHat() || beat.isSnare()) {
      sndCol = 255;
      lastSoundFader = System.currentTimeMillis();
    } 
    else {
      sndCol = 0;
    }
    break;

  case GEN_SND_VOLUME: //volume
    sndCol = int(in.mix.level()*soundSensitive.getValue());
    if (sndCol>255) {
      sndCol=255;
    }
    if (sndCol>10) {
      lastSoundFader = System.currentTimeMillis();
    }
    break;

  case GEN_SND_VOLUME2:
    sndCol = int(in.mix.level()*soundSensitive.getValue());
    if (sndCol>128) {
      sndCol=255;
      lastSoundFader = System.currentTimeMillis();
    } 
    else {
      sndCol=0;
    }
    break;
  }

  long delaySinceLastBang = System.currentTimeMillis() - lastSoundFader;
  if (delaySinceLastBang < SOUND_DELAY_IN_MS) { //fade 
    sndCol += SOUND_DELAY_IN_MS-delaySinceLastBang;
    if (sndCol > 255) {
      sndCol = 255;
    }
  }

  sndCol = color(sndCol, sndCol, sndCol);

  for (int i=0; i<colorArray.length; i++) {
    int blendedColor = blendColor(sndCol, 0xff000000 | colorArray[i], MULTIPLY);
    colorArray[i] = blendedColor;
  }
}

