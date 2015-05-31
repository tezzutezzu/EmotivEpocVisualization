void drawCorrelationGraph(float xP, float yP, int featMode) {


	experiment.genFeatures(featMode);

	float graphHeight = 80;
	float graphWidth = 300;
	

	if(experiment.genData.size() >0 ) {
		
		float col =  graphWidth / (experiment.genData.get(0).length-1);

		pushMatrix();
		translate(xP,yP);


		for (int i = 0; i < experiment.genData.size() -1; ++i) {

			float [] gData = experiment.genData.get(i);
			int obsClass = experiment.obsClasses.get(i); // gets observation class

			float prevX=0;
			float prevY =0;

			//for each column
			for (int k = 0; k < gData.length; ++k) {

				float average;

				average = gData[k];

				float x =  (k * col);
				float y = average * graphHeight;
				stroke(hh);
				line(x, 0, x, graphHeight);
				if(k > 0)  {
				// 	stroke(lerpColor(from, to, map(i, 0, experiment.observations.size()-1,  0,1) ) ); 
				// 	line(prevX, prevY,x,y);
				// }
				if (obsClass == 0){
					stroke(lerpGradient(grad1h, map(i, 0, experiment.observations.size()-1,  1,0)));
				}else{
					stroke(lerpGradient(grad2h, map(i, 0, experiment.observations.size()-1,  1,0)));
				}
				strokeWeight(map(i, 0, experiment.observations.size()-1,  0.2,2)); // stroke gets thinner as the data gets old
				line(prevX, prevY,x,y);
			}

				// ellipse(x,y,10,10);
				prevX = x;
				prevY = y;

			}

		}

		popMatrix();

	}
}

void drawCorrelationGraph3D(PGraphics g, int nObs, float xP, float yP) {


	float graphHeight = 100;
	float graphWidth = 200;
	float graphDepth = 600;
	float col =  graphWidth /  experiment.nSensors;
	float row =  graphDepth /  experiment.nTimeSlices;
	float zoom = .8;
	int obInd;

	int obsClass = experiment.obsClasses.get(nObs); // gets observation class

	if(experiment.observations.size() >0 ) {
		pushStyle();

		g.beginDraw();
		g.camera(graphWidth*zoom, graphDepth*zoom, graphHeight*3, 0, 0,0,0,0,-1);
		g.rotateZ(frameCount*0.002);
		g.pushMatrix();
		g.translate(-graphWidth*.5, -graphDepth*.5, -graphHeight*.5);
		g.clear(); // use this instead of backgrounnd for transparent overlay
		// if (obsClass == 0){
		// 	g.fill(d1);
		// }else{
		// 	g.fill(d2);
		// }
		g.fill(hh);
		g.noStroke();
		//g.lightSpecular(230, 200, 230);
		g.ambientLight(5,5,5); // 102
		g.lightSpecular(80, 80, 80);
		// g.directionalLight(2, 136, 199, -1, -1, -1);
		// g.directionalLight(244,25,153, 1, -1, -1);
		g.directionalLight(110, 110, 110, -1, -1, -1);
		g.directionalLight(80,80,80, 1, -1, -1);
		// g.shininess(1.0);

		if (mousePressed && mouseButton==LEFT){
           // mouse pressure action (to be implemented)
       }

       nObs = constrain(nObs, 0, experiment.observations.size()-1);

       float [][] observation = experiment.observations.get(nObs);

       float x,y,z,x1,y1,z1, z2, z3;
       for (int i = 0; i < experiment.nSensors-1; i++) {
       	x = i*col;
       	x1= (i+1)*col;

       	g.beginShape(QUADS);

       	for (int j=0; j< experiment.nTimeSlices-1; j++){
       		y = j*row;
       		y1 = (j+1)*row;
       		z = observation[i][j]*graphHeight;
       		z1 = observation[i+1][j]*graphHeight;
       		z3 = observation[i+1][j+1]*graphHeight;
       		z2 = observation[i][j+1]*graphHeight;

       		g.vertex(x,y,z);
       		g.vertex(x1,y,z1);
       		g.vertex(x1,y1,z3);
       		g.vertex(x,y1,z2);

       	}

       	g.endShape();

       }

       // g.noFill();
       // g.stroke(hg);
       // g.strokeWeight(.5);
       g.noLights();
	   // g.line(graphWidth/2, graphDepth/2,0,graphWidth/2, graphDepth/2,500);
	   // g.translate(graphWidth*.5, graphDepth*.5, graphHeight*.5);
	   //g.box(graphWidth,graphDepth, graphHeight);
	   g.popMatrix();
	   g.endDraw();
	   popStyle();


	};

	// else{ // put a waiting figure here
	// 	g.beginDraw();
	// 	g.clear();
	// 	g.fill(hh);
	// 	g.stroke(d2);
	// 	g.translate(200, 200);
	// 	g.rotateZ(frameCount*.01);
	// 	g.box(50);
	// 	g.endDraw(); 
	// }
	
	image(g,xP,yP);
	
}

// deprecated

void drawCorrelationGraph_old(float xP, float yP) {


	float graphHeight = 80;
	float graphWidth = 300;
	float col =  graphWidth / (experiment.nSensors-1);


	if(experiment.observations.size() >0 ) {

		pushMatrix();
		translate(xP,yP);


		for (int i = 0; i < experiment.observations.size() -1; ++i) {

			float [][] observation = experiment.observations.get(i);

			float prevX=0;
			float prevY =0;

			//for each column
			for (int k = 0; k < observation.length; ++k) {

				float total = 0;
				float average;
				for (int z = 0; z < observation[k].length; ++z) {
					//              sensor  time
					//                   |  |
					total += observation[k][z];
				}

				average = total / observation[k].length;

				float x =  (k * col) ;
				float y = average * graphHeight;
				stroke(from);
				line(x, 0, x, graphHeight);
				if(k > 0)  {
					stroke(lerpColor(from, to, map(i, 0, experiment.observations.size()-1,  0,1) ) ); 
					line(prevX, prevY,x,y);
				}
				// ellipse(x,y,10,10);
				prevX = x;
				prevY = y;

			}

		}

		popMatrix();

	}
}

