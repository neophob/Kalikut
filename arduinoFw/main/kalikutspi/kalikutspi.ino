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
#include <TimerOne.h>

#include <SPI.h>
#include "Neophob_LPD6803.h"

//should be ignored on the teensy
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
#define SERIAL_WAIT_DELAY 5


//how many letters
#define TOTAL_LETTERS 8

//the sum of all led modules
#define TOTAL_MODULES 108


//ONE COLOR PER LETTER
const byte modulesPerLetter[TOTAL_LETTERS] = {
  //  5, 2, 1, 1, 5, 2, 2, 2}; //test with one strand
  16, 15, 10, 10, 16, 15, 11, 15}; //actual



//-----------------------------
//TWO COLOR PER LETTER

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
const uint16_t pixelOffsetForTwoColorsPerLetter[16][15] = {
  { 0, 1, 2,13,14,15},                //K
  {16,17,18,26,27,28,29,30},          //A
  {35,36,37,38,39,40},                //L
  {46,47,48,49,50},                   //I
  {51,52,53,64,65,66},                //K
  {71,72,73,74,75,76,77},             //U
  {90,91,92},                         //T
  {93,94,95,96,97,98,99,100,101,102,103,104,105,106,107}, //NOW
  
  { 3, 4, 5, 6, 7, 8, 9,10,11,12},  //K
  {19,20,21,22,23,24,25},           //A
  {31,32,33,34},                    //L
  {41,42,43,44,45},                 //I
  {54,55,56,57,58,59,60,61,62,63},  //K
  {67,68,69,70,78,79,80,81},        //U
  {82,83,84,85,86,87,88,89},        //T
  {}            //NOW};
};

//how many modules per segment
const byte segmentSizeForTwoColorsPerLetter[16] = {
  6,  
  8,  
  6,  
  5,  
  6,  
  7,  
  3,  
  15,
  
  10, //K
  7,  //A
  4,  //L
  5,  //I
  10, //K
  8,  //U
  8,  //T
  0
};


//test with one strand
/*const uint16_t pixelOffsetForSplittetLetter[16][5] = {
 { 0 }, { 1 }, 
 { 2 }, { 3 }, 
 { 4 }, { 5 }, 
 { 6 }, { 7 },
 { 10 }, { 11 },
 { 12 }, { 13 },
 { 14 }, { 15 },
 { 17,18,19 }, { } 
 };
 
 const byte segmentSize[16] = {
 1, 1, 
 1, 1, 
 1, 1, 
 1, 1, 
 1, 1, 
 1, 1, 
 1, 1, 
 3, 0, 
 };
*/


//array that will hold the serial input string
byte serInStr[4*TOTAL_LETTERS+SERIAL_HEADER_SIZE]; //*2 is only needed for v2 				 

// Choose which 2 pins you will use for output. Can be any valid output pins.
// Teensy 2.0 ++: 22/23
// Arduino 2/3

//initialize pixels
Neophob_LPD6803 strip = Neophob_LPD6803(TOTAL_MODULES);

//I set it to 64 for arduino duemillanove
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

//  strip.setCPUmax(49);  // start with 50% CPU usage. up this if the strand flickers or is slow  //
//  strip.begin(SPI_CLOCK_DIV64);        // Start up the LED counterm 0.25MHz - 4uS

  //works even better!
  strip.setCPUmax(25);  
  strip.begin(SPI_CLOCK_DIV128);        // Start up the LED counterm 0.125MHz - 8uS

//  strip.begin(SPI_CLOCK_DIV128);        // Start up the LED counterm 0.125MHz - 8uS
//  strip.begin(SPI_CLOCK_DIV64);        // Start up the LED counterm 0.25MHz - 4uS
//  strip.begin(SPI_CLOCK_DIV32);        // Start up the LED counterm 0.5MHz - 2uS
//  strip.begin(SPI_CLOCK_DIV16);        // Start up the LED counterm 1.0MHz - 1uS
  strip.show();
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
  byte* cmd = serInStr+5;

  switch (type) {
  case CMD_SENDFRAME:
    //the size of buffer must match the number of all letters
    if (sendlen == TOTAL_LETTERS*2) { //v1
      updatePixelsv1(cmd);
      g_errorCounter = 0;
    } 
    else
      if (sendlen == TOTAL_LETTERS*4) { //v2
        updatePixelsv2(cmd);
        g_errorCounter = 0;
      } 
      else {
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
// update one color per letter
// --------------------------------------------
void updatePixelsv1(byte* buffer) {
  uint16_t color;
  byte src=0;
  byte dst=0;

  //v1: one color per letter
  for (byte i=0; i < TOTAL_LETTERS; i++) {
    color = buffer[src]<<8 | buffer[src+1];
    for (byte n=0; n < modulesPerLetter[i]; n++) {
      //two bytes per pixel
      strip.setPixelColor(dst++, color);
    }        
    src+=2;
  }

  strip.show(); 
}

// --------------------------------------------
// update two colors per letter
// --------------------------------------------
void updatePixelsv2(byte* buffer) {
  uint16_t color;
  byte src=0;
  byte dst=0;

  //v2: two segments per letter
  for (byte i=0; i < TOTAL_LETTERS*2; i++) {
    color = buffer[src]<<8 | buffer[src+1];
    for (byte n=0; n < segmentSizeForTwoColorsPerLetter[i]; n++) {
      //two bytes per pixel
      strip.setPixelColor(pixelOffsetForTwoColorsPerLetter[i][n], color);
    }        
    src+=2;
  }

  strip.show(); 
}



