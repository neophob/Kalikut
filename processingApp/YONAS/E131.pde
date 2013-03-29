void sendE131() {
  if (this.nrOfUniverse == 1) {
    sendE131Packet(this.firstUniverseId, convertBufferTo24bit(colorArray, COL_RGB) );
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
      sendE131Packet(this.firstUniverseId+i, convertBufferTo24bit(colorArray, COL_RGB) );
    }
  }
}

void sendE131Packet(int universeId, byte[] buffer) {
  byte[] data = dataPacket.assembleNewE131Packet(this.sequenceID++, universeId, buffer);
  packet.setData(data);
  packet.setLength(data.length);

  //TODO
  /*  if (this.sendMulticast) {
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
   LOG.log(Level.WARNING, "Failed to set target address!", e);
   }
   }*/
  try {
    dsocket.send(packet);
  } 
  catch (IOException e) {
    println("failed to send E1.31 data!");
    e.printStackTrace();
  }
}


void initE131() {
  //TODO make ip configurable
  println("Init E1.31 code");
  try {
    this.targetAdress = InetAddress.getByName("192.168.111.55");
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
  this.pixelsPerUniverse = 170;
  //TODO
  int bufferSize=NR_OF_PIXELS_X*NR_OF_PIXELS_Y;
  if (bufferSize > pixelsPerUniverse) {
    while (bufferSize > pixelsPerUniverse) {
      this.nrOfUniverse++;
      bufferSize -= pixelsPerUniverse;
    }
  }
}

