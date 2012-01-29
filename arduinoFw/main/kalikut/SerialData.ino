// --------------------------------------------
//     send status back to library
// --------------------------------------------
static void sendAck() {
  serialResonse[0] = 'A';
  serialResonse[1] = 'K';
  serialResonse[2] = Serial.available();
  serialResonse[3] = g_errorCounter;
  Serial.write(serialResonse, SERIALBUFFERSIZE);

  //comment out next line on arduino!
  //Serial.send_now();
}


/* 
 --------------------------------------------
 read serial command
 --------------------------------------------
 read a string from the serial and store it in an array
 you must supply the str array variable
 returns number of bytes read, or zero if fail
 
 example ping command:
 		cmdfull[0] = START_OF_CMD (marker);
 		cmdfull[1] = addr;
 		cmdfull[2] = 0x01; 
 		cmdfull[3] = CMD_PING;
 		cmdfull[4] = START_OF_DATA (marker);
 		cmdfull[5] = 0x02;
 		cmdfull[6] = END_OF_DATA (marker);
 */

byte readCommand(byte *str) {
  byte b,i,sendlen;

  //wait until we get a CMD_START_BYTE or queue is empty
  i=0;
  while (Serial.available()>0 && i==0) {
    b = Serial.read();
    if (b == CMD_START_BYTE) {
      i=1;
    }
  }

  if (i==0) {
    //failed to get data ignore it
    g_errorCounter = 102;
    return 0;    
  }

  //read header  
  i=1;
  b=SERIAL_DELAY_LOOP;
  while (i<SERIAL_HEADER_SIZE) {
    if (Serial.available()) {
      str[i++] = Serial.read();
    } 
    else {
      delay(SERIAL_WAIT_DELAY); 
      if (b-- == 0) {
        g_errorCounter = 103;
        return 0;        //no data available!
      }      
    }
  }

  // --- START HEADER CHECK    
  //check if data is correct, 0x10 = START_OF_DATA
  if (str[4] != START_OF_DATA) {
    g_errorCounter = 104;
    return 0;
  }

  //check sendlen, its possible that sendlen is 0!
  sendlen = str[2];  
  // --- END HEADER CHECK

  //read data  
  i=0;
  b=SERIAL_DELAY_LOOP;
  while (i<sendlen+1) {
    if (Serial.available()) {
      str[SERIAL_HEADER_SIZE+i++] = Serial.read();
    } else {
      delay(SERIAL_WAIT_DELAY); 
      if (b-- == 0) {
        g_errorCounter = 105;
        return 0;        //no data available!
      }      
    }
  }

  //check if data footer is correct, 0x20 = END_OF_DATA
  if (str[SERIAL_HEADER_SIZE+sendlen] != END_OF_DATA) {
    g_errorCounter = 106;
    return 0;
  }

  //return data size (without meta data)
  return sendlen;
}




