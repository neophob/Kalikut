# Kalikut Stage Design

Stage Design project for a band, illuminate eight 80cm high letters with 110 led modules.

For more information check out the **Blog Entry**: http://neophob.com/2012/11/kalikut-now-stage-design/

## Arduino
Tested with Version 1.0.1. As I need a low latency serial connection I used a Teensy board.

You need to install the lpd6803 library and time1 library in your Arduino lib directory.

## Processing
Tested with Version 1.5.1.

Hint, the default librxtxSerial.jnilib will crash on osx, don't know why.

I replaced the version (/Applications/Processing.app/Contents/Resources/Java/modes/java/libraries/serial/library/macosx/) with a custom build. You can find the custom version in the `dependencies` directory.

You need the oscP5 and controlP5 library in your local Processing lib directory. Check the `dependencies` directory.
## Old Readme

### Trace errors:
* Replace power supply (impulsstrom issues)
* Use twistet pair cable?
* Use Teensy instead an Arduino
* Play with CPU Power for the LPD6803 (strip.setCPUmax(XX)) strip and SPI speed

