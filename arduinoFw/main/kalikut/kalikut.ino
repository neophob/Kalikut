/*
 * PixelInvaders serial-led-gateway, Copyright (C) 2011 michael vogt <michu@neophob.com>
 * Tested on Teensy and Arduino
 * 
 * This file is part of PixelController.
 *
 * PixelController is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * PixelController is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 * 	
 */

//the lpd6803 library needs the timer1 library
#include "LPD6803.h"

//to draw a frame we need arround 20ms to send an image. the serial baudrate is
//NOT the bottleneck. 
//#define BAUD_RATE 230400//
#define BAUD_RATE 115200

//--- protocol data start
#define CMD_START_BYTE 0x01
#define CMD_SENDFRAME 0x03
#define CMD_PING  0x04

#define START_OF_DATA 0x10 
#define END_OF_DATA 0x20

//frame size for specific color resolution
//32pixels * 2 byte per color (15bit - one bit wasted)
//#define COLOR_5BIT_FRAME_SIZE 64
#define SERIAL_HEADER_SIZE 5
//--- protocol data end

//8ms is the minimum! else we dont get any data!
#define SERIAL_DELAY_LOOP 6
#define SERIAL_WAIT_DELAY 3

//how many letters
#define TOTAL_LETTERS 8

//the sum of all modulesPerLetter must be equal to TOTAL_MODULES
#define TOTAL_MODULES 20
//#define TOTAL_MODULES 103

//-----------------------------
//v 1.0 starts here
const byte modulesPerLetter[TOTAL_LETTERS] = {
  5, 2, 1, 1, 5, 2, 2, 2}; //test with one strand
// 16, 15, 10, 10, 16, 15, 11, 10}; //actual

//v 1.0 ends here
//-----------------------------


/*
//-----------------------------
//v 2.0 starts here
//spliter, lower: 3 lines
//K   lower: 00,01,02,13,14,15       // upper: 03,04,05,06,07,08,09,10,11,12   total: 16 / 16
//A   lower: 16,17,18,26,27,28,29,30 // upper: 19,20,21,22,23,24,25            total: 15 / 31
//L   lower: 35,36,37,38,39,40       // upper: 31,32,33,34                     total: 10 / 41
//I   lower: 46,47,48,49,50          // upper: 41,42,43,44,45                  total: 10 / 51
//K   lower: 51,52,53,64,65,66       // upper: 54,55,56,57,58,59,60,61,62,63   total: 16 / 67
//U   lower: 71,72,73,74,75,76,77    // upper: 67,68,69,70,78,79,80,81         total: 15 / 82
//T   lower: 90,91,92                // upper: 82,83,84,85,86,87,88,89         total: 11 / 93
//now lower: 93,94,95,96,97,98,99,100,101,102                                  total: 10

//each letter is splitted up in two segments, a lower and a higher
//"now" uses only lower segment
const byte pixelOffsetForSplittetLetter[16][10] = {
  { 0, 1, 2,13,14,15},                { 3, 4, 5, 6, 7, 8, 9,10,11,12},  //K
  {16,17,18,26,27,28,29,30},          {19,20,21,22,23,24,25},           //A
  {35,36,37,38,39,40},                {31,32,33,34},                    //L
  {46,47,48,49,50},                   {41,42,43,44,45},                 //I
  {51,52,53,64,65,66},                {54,55,56,57,58,59,60,61,62,63},  //K
  {71,72,73,74,75,76,77},             {67,68,69,70,78,79,80,81},        //U
  {90,91,92},                         {82,83,84,85,86,87,88,89},        //T
  {93,94,95,96,97,98,99,100,101,102}, {}                                //NOW
};

//how many modules per segment
const byte segmentSize[16] = {
  6, 10, //K
  8, 7,  //A
  6, 4,  //L
  5, 5,  //I
  6, 10, //K
  7, 8,  //U
  3, 8,  //T
  10,0
};
/**/
//v 2.0 ends here
//-----------------------------

//array that will hold the serial input string
byte serInStr[TOTAL_LETTERS+SERIAL_HEADER_SIZE]; 	 				 

// Choose which 2 pins you will use for output.
// Can be any valid output pins.
int dataPin = 2;       // 'green' wire
int clockPin =3;      // 'blue' wire

//initialize pixels
LPD6803 strip = LPD6803(TOTAL_MODULES, dataPin, clockPin);

#define SERIALBUFFERSIZE 4
byte serialResonse[SERIALBUFFERSIZE];

byte g_errorCounter;

int j=0,k=0;
byte serialDataRecv;


// --------------------------------------------
//      setup
// --------------------------------------------
void setup() {
  memset(serialResonse, 0, SERIALBUFFERSIZE);

  //im your slave and wait for your commands, master!
  Serial.begin(BAUD_RATE); //Setup high speed Serial
  Serial.flush();

  strip.setCPUmax(80);  // start with 50% CPU usage. up this if the strand flickers or is slow  
  strip.begin();        // Start up the LED counter

  showInitImage();      // display some colors

  serialDataRecv = 0;   //no serial data received yet  
}

// --------------------------------------------
//      main loop
// --------------------------------------------
void loop() {
  g_errorCounter=0;

  // see if we got a proper command string yet
  if (readCommand(serInStr) == 0) {
    //nope, nothing arrived yet...
    if (g_errorCounter!=0 && g_errorCounter!=102) {
      sendAck();
    }

    if (serialDataRecv==0) { //if no serial data arrived yet, show the rainbow...
      rainbow();    	
    }
    return;
  }

  //how many bytes we're sending
  byte sendlen = serInStr[2];
  //what kind of command we send
  byte type = serInStr[3];
  //get the image data
  byte* cmd    = serInStr+5;

  switch (type) {
  case CMD_SENDFRAME:
    //the size of buffer must match the number of all letters
    if (sendlen == TOTAL_LETTERS*2) {
      updatePixels(0, cmd); 
    } else {
      g_errorCounter=100;
    }
    break;

  case CMD_PING:
    //just send the ack!
    serialDataRecv = 1;        
    break;

  default:
    //invalid command
    g_errorCounter=130; 
    break;
  }

  //send ack to library - command processed
  sendAck();
}

// --------------------------------------------
//    update 32 bytes of the led matrix
//    ofs: which panel, 0 (ofs=0), 1 (ofs=32), 2 (ofs=64)...
// --------------------------------------------
void updatePixels(byte ofs, byte* buffer) {
  uint16_t dst=0;
  uint16_t color;
  byte src=0;

  //v1: one color per letter
  for (byte i=0; i < TOTAL_LETTERS; i++) {
    color = buffer[src]<<8 | buffer[src+1];
    for (byte n=0; n < modulesPerLetter[i]; n++) {
      //two bytes per pixel
      strip.setPixelColor(dst++, color);
    }        
    src+=2;
  }

  //v2: two segments per letter
/*  for (byte i=0; i < TOTAL_LETTERS; i++) {
    color = buffer[src]<<8 | buffer[src+1];
    for (byte n=0; n < segmentSize[i]; n++) {
      //two bytes per pixel
      strip.setPixelColor(pixelOffsetForSplittetLetter[i][n], color);
    }        
    src+=2;
  }
*/

  strip.doSwapBuffersAsap(0); 
}


