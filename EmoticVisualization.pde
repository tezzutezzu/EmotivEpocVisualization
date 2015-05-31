/*

EMOTIV data acquisition and monitoring interface

code developed by Danilo Di Cuia, Alessio Erioli, Antonio Vergari for X|Y lab 2014 - Castrignano De' Greci

Based on the Java porting of the EMOKIT library by Samuel Halliday [https://github.com/fommil/emokit-java]
who ported the open source Emokit library originally written in C developed by several brave people
 credited on the original repository: [https://github.com/openyou/emokit].

TODO:

. bad packet errors occurr from time to time, check for "catch" instructions in EmotivHid.java

*/

import com.github.fommil.emokit.*;
import oscP5.*;
import netP5.*;
import java.util.Map;
import java.util.Map.Entry;
import controlP5.*;
import processing.pdf.*;

PFont font, usrFont;
PImage logo;
PGraphics g, g1;
BrainView brainView;
EpocOSCData emotivOSC;


OscP5 oscP5;

boolean debug = true;

boolean stopDrawing = false;
boolean message = false;
boolean drawPoster = false;
boolean nameInput = true;

// color chart
color bg= color(221);
color d1 = color(0,0,132);
color m1 = color(3,85,161);
color h1 = color(2, 136,199);
color hh = color(255);
color d2 = color(74,25,91);
color m2 = color(127,0,130);
color h2 = color(244,25,153);
color dg = color(40);
color mg = color(120);
color hg = color(204);

color to = color(0, 0, 255);
color from = color(204, 204, 204);

color[] grad1 = {d1, m1, h1};
color[] grad2 = {d2, m2, h2};
color[] grad1h = {d1, m1, h1, hh};
color[] grad1g = {d1, m1, h1, bg};
color[] grad2h = {d2, m2, h2, hh};
color[] gradGr = {dg, mg, hg, hh};

ControlP5 c5;
Gui gui;

Experiment experiment;

int sensors = 14;
int timeSlices = debug?300:600; //600
int classes = 2;
int expCounter=0;

float centerX, centerY;
float diagScale = 100;

String user="";

void setup() {


	size(1280, 800, OPENGL);
	// ,  "processing.core.PGraphicsRetina2D"); // for retina displays
	// size(displayWidth, displayHeight, OPENGL);
	smooth(4);
	noStroke();
	cursor(CROSS);

	logo = loadImage("XY_logo_s.png");

	g = createGraphics(300,200,P3D);
	g1 = createGraphics(300,200,P3D);

	background(220);

    //font = loadFont("Lekton04-Thin-24.vlw");
    font = createFont("Lekton04-Thin", 14);
    usrFont = createFont("Lekton04-Thin", 48);
    textFont(font);

    // variables for centering the sensor visualization
    centerX = 810;
    centerY = height*.5;


    experiment = new Experiment(classes, sensors, timeSlices);
	//experiment.newObservation(random(1)>.5?1:0);

	float angle = (PI * 2) / experiment.nTimeSlices;
	
	SensorData sensorData = new SensorData();
	brainView = new BrainView(sensorData, experiment);

	// controlP5 = new ControlP5(this);
	c5 = new ControlP5(this);
	gui = new Gui(c5, 15,10, font); // position GUI

	/* OSC setup */
	emotivOSC = new EpocOSCData(experiment);

	if(!debug) {

		try {
			Emotiv emotiv = new Emotiv();
			emotiv.addEmotivListener(sensorData);
			emotiv.start();

  		//start oscP5, listening for incoming messages on port 7400
  		//make sure this matches the port in Mind Your OSCs
  		oscP5 = new OscP5(this, 7400);
  	} 
  	catch(IOException e) {
  		println(e);
  	}
  }

  background(bg);

}


void draw() {

	if(stopDrawing || nameInput) {
		if (nameInput){
			background(bg);
			image(logo,width-70, height-50);
		}
		gui.draw();
		if (nameInput){
			pushStyle();
			fill(bg);
			noStroke();
			rect(0,0,320,200);
			fill(d2);
			textAlign(CENTER,CENTER);

			popStyle();
		}
		return;
	}

	// if (!nameInput){

		if(drawPoster) {
			beginRecord(PDF, "output_.pdf"); 
		}

	// experiment update
	//TODO change this to be augmented on user input
	if (expCounter % experiment.nTimeSlices == 0 ) {
		brainView.clear();
		emotivOSC.clear();

		if (debug){
			experiment.newObservation(random(1)>.5?1:0);

		}else{
			// TODO at the moment it's the same for debug and not debug mode
			// but it should be changed to the sequence of our experiment purpose
			experiment.newObservation(random(1)>.5?1:0);
		}
	}

    // ______________________ drawing functions ______________________

    background(220);

    pushMatrix();
    translate(centerX-brainView.dimX*.5, centerY-brainView.dimY*.5);

    experiment.update();
    brainView.draw();
    pushStyle();
    textAlign(CENTER,CENTER);
    textFont(usrFont);
    text(user,brainView.dimX/2,brainView.dimY/2);
    popStyle();
	// emotivOSC data storage - there is no else since in normal mode data is read via oscEvent()
	if (debug) emotivOSC.storeDebugValues();
	// emotivOSC data drawing (optional)
	camera();
	translate(15, 95);
	emotivOSC.draw();
	noFill();
	stroke(0);
	strokeWeight(.5);
	//rect(0,0,290,255);
	popMatrix();

    // 2D correlation graph with features
    drawCorrelationGraph(10,height-110, 0);
    // 3D graph
    drawCorrelationGraph3D(g,experiment.observations.size()-1,10,height-470);
    pushStyle();
    fill(d2);
    textAlign(RIGHT, BOTTOM);
    textSize(14);
    text("current ob", 305,height-270);

    if (experiment.observations.size()>1) {
    	drawCorrelationGraph3D(g1,experiment.observations.size()-2,10,height-320);
    	text("ob. "+(experiment.observations.size()-2), 305,height-130);
    }
    popStyle();


    //
	// ___________ interface
	//

	pushStyle();
	stroke(d2);
	strokeWeight(.5);
	line(15, 85, 305, 85);
	line(320,10,320,height-10);
	line(15,height-440,305, height-440);
	popStyle();
// }else{background(bg);}


image(logo,width-70, height-50);
gui.draw();

if(drawPoster) {
	drawPoster = false;
	endRecord();
}

if (debug) {
	pushStyle();
	fill(d2);
	textAlign(RIGHT, BOTTOM);
	textSize(14);
	text("| debug mode |", width-85, height-25);
	popStyle();
}

expCounter++;

}

void keyPressed() {
	if (key == 's' && !nameInput) stopDrawing = !stopDrawing;
	// if (key == 'p') drawPoster = true;
	if (key == 'c' && !nameInput)	brainView.clear();
	// if (key == 'e') { // export features + raw data
	// 	exportData(experiment);
	// }
	if (key == 'i' && !nameInput) saveImg();

}

void saveImg(){
	saveFrame(dataPath(this.getClass().getName()+"_imgs/"+this.getClass().getName()+"_"+user+"_#####.png"));
}

void exportData(Experiment experiment){
	experiment.genFeatures(0);
	experiment.exportFeats(dataPath(this.getClass().getName()+"_obs/"+this.getClass().getName()+"_"+user+"_"+frameCount+"_feats.csv"));
	experiment.exportObs(dataPath(this.getClass().getName()+"_obs/"+this.getClass().getName()+"_"+user+"_"+frameCount+"_raw.csv"));

}


	// uncheck this for auto-fullscreen mode

	 boolean sketchFullScreen() {
	 	return true;
	 }
