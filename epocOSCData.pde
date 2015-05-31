class EpocOSCData{


  public String[] epocAddr_2 = {
    "/COG/NEUTRAL", "/COG/PUSH", "/COG/PULL", "/COG/LIFT", "/COG/DROP", "/COG/LEFT", 
    "/COG/RIGHT", "/COG/ROTATE_LEFT", "/COG/ROTATE_RIGHT", "/COG/ROTATE_CLOCKWISE", "/COG/ROTATE_COUNTER_CLOCKWISE", 
    "/COG/ROTATE_FORWARD", "/COG/ROTATE_REVERSE", "/COG/DISAPPEAR", "/AFF/Engaged/Bored", "/AFF/Excitement", 
    "/AFF/Excitement Long Term", "/AFF/Meditation", "/AFF/Frustration", "/EXP/WINK_LEFT", "/EXP/WINK_RIGHT", 
    "/EXP/BLINK", "/EXP/LEFT_LID", "/EXP/RIGHT_LID", "/EXP/HORIEYE", "/EXP/VERTEYE", "/EXP/SMILE", "/EXP/CLENCH", 
    "/EXP/LAUGH", "/EXP/SMIRK_LEFT", "/EXP/SMIRK_RIGHT", "/EXP/FURROW", "/EXP/EYEBROW"
  };

  public String[] epocAddr_1 = {"/AFF/Engaged/Bored", "/AFF/Excitement",  "/AFF/Meditation", "/AFF/Frustration", 
 "/AFF/Excitement Long Term"};

   public String[] epocAddr = {"/AFF/Engaged/Bored", "/AFF/Excitement",  "/AFF/Meditation", "/AFF/Frustration"};

private int maxData; // max recorded datasets
public int currVal = 0;
private int counter = 0;

public float[][] data;
public float rad = 130, rad1=50;

private PVector[][] eCurves;
private float thres = 0.01;

private Experiment experiment;

EpocOSCData(Experiment experiment){
  this.experiment = experiment;
  this.maxData = experiment.nTimeSlices;
  //                EPOC address     data in time
  //                      |             |
  data = new float[epocAddr.length][maxData];
  eCurves = new PVector[epocAddr.length][maxData];

}

void storeValues(OscMessage theOscMessage){
  // boolean addVal = false;
  for (int i=0; i< epocAddr.length; i++) {
    if (theOscMessage.checkAddrPattern(epocAddr[i])==true /*&& theOscMessage.get(0).floatValue()>thres*/) {
      // data[i][this.currVal]=theOscMessage.get(0).floatValue();
      
      data[i][experiment.timeCounter % maxData]=theOscMessage.get(0).floatValue();
      // addVal=true;
    }
  }
  // if (addVal) this.currVal = ++this.currVal % maxData;

}

void storeDebugValues() {

  for (int i=0; i< epocAddr.length; i++) {
    data[i][experiment.timeCounter % maxData]=noise(expCounter/100.0+1, i);
  }
  // this.currVal = ++this.currVal % maxData;
}

void clear(){
  data = new float[epocAddr.length][maxData];

}

void draw(){
  int step = 65;
	drawDiagram(step);
	drawData(step);
}

void drawDiagram(int textStep){
  float diagWidth=290;
  float diagHeight=40;
  float step = diagWidth / (float) maxData;
  int dataStep = 4;
  pushMatrix();
  translate(0,-25);
  for (int i=0; i< epocAddr.length; i++){
    translate(0,textStep);
    beginShape(QUADS);
    for (int j=0; j<maxData-dataStep; j+=dataStep){
      
      float val = - data[i][j] * diagHeight;
      //float val2= - data[i][j+1] * diagHeight;
      stroke(lerpGradient(grad2, map(j, 0, maxData, 0,1)));
      strokeWeight(2);
      line(j*step,0,j*step, val);

      // vertex(j*step,val);
      // vertex(j*step, 0);
      // fill(lerpGradient(grad2, map(j+1, 0, maxData, 0,1)));
      // vertex((j+1)*step,0);
      // vertex((j+1)*step, val2);

    }
    endShape();
  }
  popMatrix();

}

void drawData(int graphStep){
  pushMatrix();
	pushStyle();
	//stroke(0);
  translate(0,50);
	strokeWeight(.5);
  fill(d2);
  float angle = TWO_PI/maxData; // calculates step angle
  float currAng = currVal * angle; // calculates current angle for current data acquisition
  textAlign(LEFT, TOP);
  textSize(14);
  
  for (int i=0; i< epocAddr.length; i++){

    pushMatrix();
    translate(0, i*graphStep); // go into data drawing position

    text(epocAddr[i]+" | "+data[i][experiment.timeCounter % maxData],0,0);

    popMatrix();



  }

  popMatrix();
  
  popStyle();

  ////////////////


    // angle = (PI * 2) / experiment.nTimeSlices;
    
    // pushMatrix();
    // translate(this.x, this.y);

    // noFill();
    // strokeWeight(1);
    // strokeCap(SQUARE);
    // float curr = experiment.timeCounter % experiment.nTimeSlices;
    // float rotAng = curr * angle;
    // pushMatrix();
    // rotate(rotAng);
    /*float value=0;

    
    for (int i = 0; i < experiment.nTimeSlices; ++i) {

      value = experiment.currentObservation[index][i] * 100;

      float currentAngle = -i * angle;
      currentAngle -= PI /2;
      if (high){
        stroke(lerpGradient(grad1h, map(i, 0, curr, 1,0)));
      }else{
        stroke(lerpGradient(gradGr, map(i, 0, curr, 1,0)));
      }

      if(value >= 100) {
        stroke(0xffffffff);
        value = 100;
      }
      line(0,0, cos(currentAngle) * value, sin(currentAngle) * value);      
    }
    popMatrix();*/


  }

  void drawDiagram_circ(){

  // draws setup elements (graph base: radial lines and labels)
  for (int i=0; i< epocAddr.length; i++){

    // step angle for each data
    float currAng = i * TWO_PI/(float)epocAddr.length;

    strokeWeight(0.5);
    stroke(120, 80);
    line(10*cos(currAng), 10*sin(currAng), 0, rad*cos(currAng), rad*sin(currAng), 0);

    // text color according to value
    // fill(120-120*tval);
    fill(lerpGradient(gradGr, data[i][experiment.timeCounter % maxData]));
    
    // text
    pushMatrix();
    rotate(currAng);
    text(epocAddr[i]+"_"+data[i][experiment.timeCounter % maxData], rad*1.2, 0);
    popMatrix();

  }
  println();

}

void initCurves(){
  for(int i=0; i<eCurves.length; i++){
   for (int j=0; j< eCurves[i].length; j++){
    eCurves[i][j] = new PVector();
  }
}

}

}