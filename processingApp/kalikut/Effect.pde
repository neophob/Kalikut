private static final int MAX_EFFECT=9;


void initGenerator() {
  setupAnimation();
  setupColor();
}

//generate buffer
void generator() {

  generateColor();
  generateAnimation();
  generateSound();

}

/*

      case 9: //Test
        if (y>0) {   
          long l = colorArray[x]&0xffffff;
          if (l>0) {
            colorArray[i] = color(0, 0, 0);
          } 
          else {
            colorArray[i] = color(255, 255, 255);
          }
          break;
        }
        if ((frame-i>>2)%2==1) {
          colorArray[i] = color(0, 0, 0);
        } 
        else {
          colorArray[i] = color(255, 255, 255);
        }
        break;


*/

