//The letters YONAS are splitted up into 4 horizonal regions
int[][] letterMapping = {
  //top layer
 {9,10,11,12,16,17,18,19},           //Y4
 {27,28,29,30,31,32},     //O4
 {46,47,58,59},           //N4
 {66,67,68,69},           //A4
 {93,94,95,96,97,98,99},  //S4

 {6,7,8,13,14,15},           //Y3
 {25,26,33,34},     //O3
 {44,45,48,49,56,57},           //N3
 {64,65,70,71},           //A3
 {90,91,92},  //S3

 {3,4,5},           //Y2
 {23,24,35,36},     //O2
 {42,43,50,51,54,55},           //N2
 {62,63,72,73,76,77,78,79},           //A2
 {80,86,87,88,89},  //S2

 //lower layer
 {0,1,2},           //Y1 
 {20,21,22,37,38,39},        //O1
 {40,41,52,53},           //N1
 {60,61,74,75},           //A1
 {81,82,83,84,85}  //S1
};


//map the letters
int[] getMappedLetters() {
  //output is 100 pixels
  int[] ret = new int[100];
  
  int srcOfs=0;
  int dstOfs=0;
  for (int y=0; y<NR_OF_PIXELS_Y*NR_OF_PIXELS_X; y++) {
    int col = colorArray[y];
    
    int[] segment = letterMapping[y];
    for (int i: segment) {
      ret[i] = col;
    }
  }
  
  return ret;
}

void sendE131() {
  if (this.nrOfUniverse == 1) {
    sendE131Packet(this.firstUniverseId, convertBufferTo24bit(getMappedLetters(), COL_RGB) );
  } 
  else {
    int remainingInt = colorArray.length;
    int ofs=0;
    for (int i=0; i<this.nrOfUniverse; i++) {
      int tmp=pixelsPerUniverse;
      if (remainingInt<pixelsPerUniverse) {
        tmp = remainingInt;
      }
      int[] buffer = new int[tmp];
      System.arraycopy(colorArray, ofs, buffer, 0, tmp);
      remainingInt-=tmp;
      ofs+=tmp;
      sendE131Packet(this.firstUniverseId+i, convertBufferTo24bit(getMappedLetters(), COL_RGB) );
    }
  }
}

void sendE131Packet(int universeId, byte[] buffer) {
  byte[] data = dataPacket.assembleNewE131Packet(this.sequenceID++, universeId, buffer);
  packet.setData(data);
  packet.setLength(data.length);

  //check multicast
  if (e131Ip.startsWith("239.255.")) {
    // multicast - universe number must be in lower 2 bytes
    byte[] addr = new byte[4];
    addr[0] = (byte)239;
    addr[1] = (byte)255;
    addr[2] = (byte)(universeId>>8);
    addr[3] = (byte)(universeId&255);
    InetAddress iaddr;
    try {
      iaddr = InetAddress.getByAddress(addr);
      packet.setAddress(iaddr);
    } 
    catch (UnknownHostException e) {
      println("Failed to set target address!");
      e.printStackTrace();
    }
  }
  try {
    dsocket.send(packet);
  } 
  catch (IOException e) {
    println("failed to send E1.31 data!");
    e.printStackTrace();
  }
}

String e131Ip; 

void initE131() {
  //TODO make ip configurable
  println("Init E1.31 code");

  e131Ip = config.getProperty("e131.controller.ip");
  println("Using IP: "+e131Ip);

  //pixelPerUniverse
  this.pixelsPerUniverse = parseConfigInt("e131.cfg.pixel.per.universe", 170);
  println("Pixel per Universe: "+pixelsPerUniverse);

  try {
    this.targetAdress = InetAddress.getByName(e131Ip);
    this.firstUniverseId = 1;
    calculateNrOfE131Universe();
    packet = new DatagramPacket(new byte[0], 0, targetAdress, E1_31DataPacket.E131_PORT);
    dsocket = new DatagramSocket();
  } 
  catch (Exception e) {
    println("failed to initialize E1.31 device");
    e.printStackTrace();
  }
}

void calculateNrOfE131Universe() {
  //check how many universe we need
  this.nrOfUniverse = 1;
  //TODO
  int bufferSize=NR_OF_PIXELS_X*NR_OF_PIXELS_Y;
  if (bufferSize > pixelsPerUniverse) {
    while (bufferSize > pixelsPerUniverse) {
      this.nrOfUniverse++;
      bufferSize -= pixelsPerUniverse;
    }
  }
}

