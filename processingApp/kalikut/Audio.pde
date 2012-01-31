private Minim minim;

private AudioInput in;
private BeatDetect beat;
private FFT fft;

color activeCol = color(255, 255, 255);
color inActiveCol = color(64, 64, 64);

@SuppressWarnings("unused")
private BeatListener bl;

void initAudio() {
  minim = new Minim(this);
  //in = minim.getLineIn( Minim.STEREO, 512 );
  in = minim.getLineIn( Minim.MONO, 1024 );

  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());

  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  beat.setSensitivity(250); 
  beat.detectMode(BeatDetect.FREQ_ENERGY);

  bl = new BeatListener(beat, in);

  fft = new FFT(in.bufferSize(), in.sampleRate());
  // use 128 averages.
  // the maximum number of averages we could ask for is half the spectrum size. 
  fft.linAverages(32);
}


void drawBeatStatus() {
  if (beat.isKick()) {
    fill(activeCol);
  } 
  else {
    fill(inActiveCol);
  }
  rect(0, 0, 30, 20);

  if (beat.isSnare()) {
    fill(activeCol);
  } 
  else {
    fill(inActiveCol);
  }
  rect(30, 0, 30, 20);

  if (beat.isHat()) {
    fill(activeCol);
  } 
  else {
    fill(inActiveCol);
  }
  rect(60, 0, 30, 20);
/*
  fill(inActiveCol);
  fft.forward(in.mix);
  int w = int(fft.specSize()/32);
  for (int i = 0; i < fft.specSize(); i++) {
    // draw a rectangle for each average, multiply the value by 5 so we can see it better
    rect(i, height, i, height - fft.getBand(i)*50);
  }
  */
}


class BeatListener implements AudioListener {

  /** The beat. */
  private BeatDetect beat;

  /** The source. */
  private AudioInput source;

  /**
   	 * Instantiates a new beat listener.
   	 *
   	 * @param beat the beat
   	 * @param source the source
   	 */
  BeatListener(BeatDetect beat, AudioInput source) {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  /* (non-Javadoc)
   	 * @see ddf.minim.AudioListener#samples(float[])
   	 */
  public void samples(float[] samps) {
    beat.detect(source.mix);
  }

  /* (non-Javadoc)
   	 * @see ddf.minim.AudioListener#samples(float[], float[])
   	 */
  public void samples(float[] sampsL, float[] sampsR) {
    beat.detect(source.mix);
  }
}
