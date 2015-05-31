class SensorView {

	int x;
	int y;
	int index;
	boolean high;
	public float quality;
	public String name;



	private float[] qualityRecords;

	Experiment experiment;

	SensorView(Experiment experiment, int index, int x, int y) {
		this.x = x;
		this.y = y;
		this.index = index;
		this.experiment = experiment;
	}


	void draw() {
		
		float angle = (PI * 2) / experiment.nTimeSlices;
		
		pushMatrix();
		translate(this.x, this.y);

		float strength = experiment.currentObservation[index][experiment.timeCounter % experiment.nTimeSlices] * (diagScale*2);
		noStroke();
        fill(255,50);
        //ellipse(0, 0, strength, strength); // ellipse of current strength
		
		if(quality > 24) quality = 24;
		qualityRecords[index] = map(quality, 0, 24, 0,1);

		noFill();
		strokeWeight(1);
		strokeCap(SQUARE);
        float curr = experiment.timeCounter % experiment.nTimeSlices;
		float rotAng = curr * angle;
		pushMatrix();
		rotate(rotAng);
		float value=0;

		
		for (int i = 0; i < experiment.nTimeSlices; ++i) {



			value = experiment.currentObservation[index][i];

			float currentAngle = -i * angle;
			currentAngle -= PI /2;
			// vertex(cos(currentAngle) * records[newIndex], sin(currentAngle) * records[newIndex]);			
			//stroke(lerpColor(hh, d1, map(i, 0, experiment.nTimeSlices, 0,1)));
			if (high){
			stroke(lerpGradient(grad1h, map(i, 0, /*experiment.nTimeSlices*/ curr, 1,0)));
		}else{
			stroke(lerpGradient(gradGr, map(i, 0, /*experiment.nTimeSlices*/ curr, 1,0)));
		}

			if(value >= 1) {
				// stroke(hh);
				value = 1;
			}
			line(0,0, cos(currentAngle) * value * diagScale, sin(currentAngle) * value * diagScale);

		}
		popMatrix();


		// index = counter % records.length;

		// for (int i = 0; i < qualityRecords.length; ++i) {
		// 	int newIndex = (index + i) % qualityRecords.length;
		// 	int prevIndex = (newIndex-1) % qualityRecords.length;
		// 	float currentAngle = i * angle;
		// 	currentAngle -= PI /2;
		// 	int col;
		// 	if(qualityRecords[newIndex] == 0.0) {
		// 		col = (0);
		// 	} else {
		// col = ( lerpColor(0xffec000b, 0xff23ff08, qualityRecords[newIndex] ) ) ;
		// 	}
		// 	stroke( col );
		// 	line(0,0, cos(currentAngle) *10, sin(currentAngle) *10);			
		// }

		// quality indicator
		color col;
		if(qualityRecords[index] == 0.0) {
			col = color(70,0,70);
		} else {
			col = lerpColor(color(70,0,70), color(255,0,255), qualityRecords[index]);
		}
		fill(col);
		noStroke();
		pushMatrix();
		translate(0,0,1);
		ellipse(0,0,10,10);
		popMatrix();

		stroke(255,0,255);
		strokeWeight(1.5);
		strokeCap(SQUARE);

		line(0,0, cos(-PI/2) * experiment.currentObservation[index][0], sin(-PI/2) * experiment.currentObservation[index][0]);			

		noStroke();
		// println("quality: "+quality);
        if (mouseHighlight(1000)){
			if (mousePressed && mouseButton==LEFT) high = true;
			if (mousePressed && mouseButton==RIGHT) high = false;
		}


		// test if mouse position is in Sensor diagram range or if the sensor is highlighted
		// if so, draws the highlights features

		if (mouseHighlight(500) || high){

			pushMatrix();
			
			translate(0, 0, 5);
			pushStyle();
			
			// noFill();
			// stroke(255,180);
			strokeWeight(0.5);
			float sign=((x-brainView.dimX/2)/abs(x-brainView.dimX/2));
			stroke(h1);
			line(sign*30,0,sign*120,0);
			if (sign > 0) {textAlign(LEFT, BOTTOM);}
			else
				{textAlign(RIGHT, BOTTOM);}
			textSize(14);
			fill(h1);
			text(name, sign*130,-3); 
			stroke(h1);
			line(sign*130,0, sign*180,0);
			fill(d1);
			text(nf(strength,0,2), sign*130, 22);
			translate(0, 0, -10);
			fill(hh);
			noStroke();
			//ellipse(0,0,200,200);
			ellipse(0,0,strength*1.5,strength*1.5);
			popStyle();
			popMatrix();
		}

		// line(0,0,mouseX-x+brainView.xMin+(brainView.dimX-width)*.5,mouseY-y+brainView.yMin+(brainView.dimY-height)*.5);

		popMatrix();


	}

	boolean mouseHighlight(float thres){

		return distanceSq(0,0,mouseX-x+brainView.xMin+(brainView.dimX*.5-centerX),
			mouseY-y+brainView.yMin+(brainView.dimY*.5-centerY)) < thres;

	}


}