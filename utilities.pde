// creates a gradient with more than 2 colors

color lerpGradient(color[] colors, float amt) {
  color c = color(0);
  float stepSize = 100.0/(colors.length-1);
  float loc = (amt*100.0);
  for (int i=0; i< colors.length-1; i++) {
    if (loc < stepSize*(i+1)) {
      float am = (loc % stepSize)/stepSize;
      c = lerpColor(colors[i], colors[i+1], am);
      break;
    }
  }
  return c;
}


// calculates the distance squared (faster than distance since it doesn't perform square root operations)

float distanceSq(float x1, float y1, float x2, float y2){

  return(pow(x2-x1,2)+pow(y2-y1,2));

}

// checks if mouse is within a threshold from a target - based on distanceSq (see below)
// so remember to calibrate the thres for the square of the distance (ex. within 10 pix > thres = 100)

boolean mouseOver(PVector loc, float thres){

  return distanceSq(loc.x,loc.y,mouseX, mouseY) < thres;

}