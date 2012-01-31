private Minim minim;

final color activeCol = color(255, 255, 255);
final color inActiveCol = color(64, 64, 64);

private AudioInput in;
private BeatDetect beat;

@SuppressWarnings("unused")
private BeatListener bl;

void initAudio() {
  minim = new Minim(this);
  in = minim.getLineIn( Minim.STEREO, 512 );
  //in = minim.getLineIn( Minim.MONO, 1024 );

  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());

  // set the sensitivity to 250 milliseconds
  // After a beat has been detected, the algorithm will wait for 250 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  beat.setSensitivity(250); 
  beat.detectMode(BeatDetect.FREQ_ENERGY);

  bl = new BeatListener(beat, in);
}

final int BOX_X = 50;
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
  rect(BOX_X+BOX_X_SIZE*2, BOX_Y, BOX_X_SIZE,BOX_Y_SIZE);
  
  stroke(255);  
  // draw the waveforms
  for(int i = 0; i < in.bufferSize()-1; i++) {
    line(237+i, BOX_Y + in.mix.get(i)*30, 237+i+1, BOX_Y + in.mix.get(i+1)*30);
  }
  
  stroke(0); 
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

