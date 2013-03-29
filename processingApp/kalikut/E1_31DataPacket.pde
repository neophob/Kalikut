import java.nio.ByteBuffer;
import java.util.UUID;

public class E1_31DataPacket {

    private final UUID PIXELCONTROLLER_UUID = new UUID(0x31337babel, 0x0caffebeefl);
    
    public static final int E131_PORT = 5568;

    private static final int E131_PACKET_LEN = 638;
    private static final int E131_SEQUENZE_OFS = 111;
    private static final int E131_UNIVERSE_ID_HI = 113;
    private static final int E131_UNIVERSE_ID_LOW = 114;
    private static final int E131_DMX_PAYLOAD_OFS = 126;
    private static final int E131_DMX_PAYLOAD_SIZE = 512;
    
    private byte[] data = new byte[E131_PACKET_LEN];
    
    /**
     * create E1.31 data packet
     */
    public E1_31DataPacket() {        
        //ROOT LAYER
        data[0]=0x00;   // Preamble Size (high)
        data[1]=0x10;   // Preamble Size (low)
        data[2]=0x00;   // Post-amble Size (high)
        data[3]=0x00;   // Post-amble Size (low)
        data[4]=0x41;   // ACN Packet Identifier, Identifies this packet as E1.17 (12 bytes)
        data[5]=0x53;
        data[6]=0x43;
        data[7]=0x2d;
        data[8]=0x45;
        data[9]=0x31;
        data[10]=0x2e;
        data[11]=0x31;
        data[12]=0x37;
        data[13]=0x00;
        data[14]=0x00;
        data[15]=0x00;
        data[16]=0x72;  // Protocol flags and length, Low 12 bits = PDU length, High 4 bits = 0x7 (high)
        data[17]=0x6e;  // Protocol flags and length (low), 0x26e = 638 - 16
        data[18]=0x00;  // Vector, Identifies RLP Data as 1.31 Protocol PDU, (4 bytes)
        data[19]=0x00;
        data[20]=0x00;
        data[21]=0x04;

        // CID Sender’s CID Sender’s unique ID
        // The CID shall be a UUID (Universally Unique Identifier) [UUID] 
        // that is a 128-bit number that is unique across space and time compliant with RFC 4122        
        ByteBuffer pixelControllerUUID = ByteBuffer.wrap(new byte[16]);
        pixelControllerUUID.putLong(PIXELCONTROLLER_UUID.getMostSignificantBits());
        pixelControllerUUID.putLong(PIXELCONTROLLER_UUID.getLeastSignificantBits());
        System.arraycopy(pixelControllerUUID.array(), 0, data, 22, 16);
        
        //E1.31 FRAMING LAYER
        data[38]=0x72;  // Framing Protocol flags and length (high)
        data[39]=0x58;  // 0x258 = 638 - 38
        data[40]=0x00;  // Framing Vector (indicates that the E1.31 framing layer is wrapping a DMP PDU)
        data[41]=0x00;
        data[42]=0x00;
        data[43]=0x02;
        data[44]='p';   // User Assigned Name of Source (64 bytes), *should* be utf8 enoded
        data[45]='i';
        data[46]='x';
        data[47]='e';
        data[48]='l';
        data[49]='c';
        data[50]='o';
        data[51]='n';
        data[52]='t';
        data[53]='r';
        data[54]='o';
        data[55]='l';
        data[56]='l';
        data[57]='e';
        data[58]='r';
        data[59]=' ';
        data[60]='1';
        data[61]=0x00;

        data[108]=100;                          // Priority, Data priority if multiple sources 0-200
        data[109]=0x00;                         // Reserved, Transmitter Shall Send 0 (high)
        data[110]=0x00;                         // Reserved, Transmitter Shall Send 0 (low)
        data[111]=0x00;                         // Sequence Number, To detect duplicate or out of order packets. 
        data[112]=0x00;                         // Options Flags, Bit 7 = Preview_Data, Bit 6 = Stream_Terminated
//        data[113]=(byte)(universeNr >> 8);      // Universe Number (high)
//        data[114]=(byte)(universeNr & 255);     // Universe Number (low)

        //DMP LAYER
        data[115]=0x72;                         // Protocol flags and length, Low 12 bits = PDU length, High 4 bits = 0x7 (high)
        data[116]=0x0b;                         // Protocol flags and length (low) 0x20b = 638 - 115
        data[117]=0x02;                         // DMP Vector (Identifies DMP Set Property Message PDU)
        data[118]=(byte)0xa1;                   // DMP Address Type & Data Type
        data[119]=0x00;                         // First Property Address (high), Indicates DMX START Code is at DMP address 0
        data[120]=0x00;                         // First Property Address (low)
        data[121]=0x00;                         // Address Increment (high)
        data[122]=0x01;                         // Address Increment (low)
        data[123]=0x02;                         // Property value count (high)
        data[124]=0x01;                         // Property value count (low)
        data[125]=0x00;                         // DMX512-A START Code
//512 DMX DATA
        
    }
    
    /**
     * create a new data package to send to an e1.31 device
     * @param id
     * @param imageData
     * @return
     */
    public byte[] assembleNewE131Packet(int sequenzeId, int universeNr, byte[] imageData) {
    	if (imageData==null) {
    		return null;
    	}
    	
    	byte[] payload = data.clone();
    	payload[E131_SEQUENZE_OFS] = (byte)(sequenzeId%255);
    	payload[E131_UNIVERSE_ID_HI]=(byte)(universeNr >> 8);      // Universe Number (high)
    	payload[E131_UNIVERSE_ID_LOW]=(byte)(universeNr & 255);     // Universe Number (low)

    	int dataSize = E131_DMX_PAYLOAD_SIZE;
    	if (imageData.length < E131_DMX_PAYLOAD_SIZE) {
    		dataSize = imageData.length;
    	}
    	System.arraycopy(imageData, 0, payload, E131_DMX_PAYLOAD_OFS, dataSize);
    	return payload;
    }

}

