public class Experiment
{
	private HashMap<Integer, Integer> obsClasses = new HashMap<Integer, Integer>();
	private int nClasses = 2;

	// observations is structured like this:
	// the single observation
    // 				    |				
    //					|  sensors
    //  				|  |  
    //  				|  |  recorded data in time   
    //  				|  |  |   
    // observations.get(i)[j][k];
    private ArrayList<float [][]> observations = new ArrayList<float [][]>();

    private int observationCounter = 0;
    private int timeCounter=0;

    // generated data (features)
    private ArrayList<float[]> genData = new ArrayList<float[]>();
    
    public int nSensors;
    public int nTimeSlices;

    public float[][] currentObservation;

    public Experiment(int nClasses, int nSensors, int nTimeSlices)
    {
    	this.nClasses = nClasses;
    	this.nSensors = nSensors;
    	this.nTimeSlices = nTimeSlices;
    }


    public int nObservations()
    {
    	return observations.size();
    }


    public void update() {
    	timeCounter++;
    }

    public void newObservation(int label) {
    	timeCounter = 0;
    	addObservation(new float[nSensors][nTimeSlices], label);
    	observationCounter++;
    	currentObservation = observations.get(observations.size()-1);
    }

	/*
	Add observations to our ArrayList

	@sensor2timeslice	matrix of sensors values and timeslices
	@label				class of the observation
	*/
	public void addObservation(float [][] sensor2timeslice, int label) {
		observations.add(sensor2timeslice);

		/* add class label to the hashmap */
		int obsID = observations.size() - 1;
		obsClasses.put(obsID, label);
	}

	/*
		Change the value of a sensor on a given time for an observation
		*/
		public void addValue(int obsID, int sensorID, int timeID, float value)
		{
			if(timeID < nTimeSlices) {
				observations.get(obsID)[sensorID][timeID] = value;
			} else {
				//TODO implement what to do when the timeslice is full
				//println("timeslice is full");
			}

		}


	/*
		Change the value of a sensor on a given time for the last observation
		*/
		public void addValue(int sensorID, int timeID, float value)
		{
			/* get the last observation */
			addValue(observations.size() - 1, sensorID, timeID, value);
		}

			/*
		Change the value of a sensor on a given time for the current moment at the last observation
		*/
		public void addValue(int sensorID, float value)
		{
			/* get the last observation */
			addValue(observations.size() - 1, sensorID, timeCounter, value);
		}





	/*
		Change the value of all the sensors for a given time for the last observation
		*/
		public void addValue(int timeID, float[] values)
		{
			for(int j = 0; j < nSensors; ++j)
			{
				addValue(j, timeID, values[j]);
			}
		}


		public String toString()
		{
			String repr = "";
			for(int i = 0; i < observations.size(); ++i)
			{
				repr += "obs: " + i + " class " + obsClasses.get(i) + "\n";
				for(int j = 0; j < nSensors; ++j)
				{
					for(int k = 0; k < nTimeSlices; ++k) 
					{
						repr += observations.get(i)[j][k] + " ";
					} 
					repr += "\n";
				}
				repr += "\n";
			}
			return repr;
		}

		public String toString2()
		{
			String repr = "";
			for(int i = 0; i < observations.size(); ++i)
			{
				repr += "obs: " + i + " class " + obsClasses.get(i) + "\n";
				for(int k = 0; k < nTimeSlices; ++k)
				{
					for(int j = 0; j < nSensors; ++j) 
					{
						repr += observations.get(i)[j][k] + " ";
					} 
					repr += "\n";
				}
				repr += "\n";
			}
			return repr;
		}


		

		public void genFeatures(int method){

			switch (method){

				case 0:

				if (observations.size() > 1){
					// clears generated data array
					genData.clear();

					for (float[][] ob : observations) { // scans observations

						float[] gD = new float[ob.length];

						for (int i=0; i<ob.length;i++) {
							    // average ob[i] data:
							    float tot = 0;
							    for (int j=0; j< ob[i].length; j++){
							    	tot += ob[i][j];

							    }
							    gD[i] = tot/(float)ob[i].length;
								// end average method
							}

							genData.add(gD);
						}
					}
					break;

					case 1:

				// clears generated data array
				genData.clear();

					for (float[][] ob : observations) { // scans observations


						int nFeat = 3; // define n. of features (can be any number)

						float[] gD = new float[nFeat];

						for (int i=0; i<nFeat;i++) {
								/*
								
								your custom *AWESOME* feature calculation method

								*/
							}

							genData.add(gD);
						}

						break;

					}

				}

			// exports raw observations data
			public void exportObs(String fileName) {
  			String eol = System.getProperty("line.separator"); // line separator character
  			String flux = toString2();

			 // creates output & writes observations
			 PrintWriter output;   //Declare the PrintWriter
			 output = createWriter(fileName);   //Create a new PrintWriter object
			 output.println(flux); // Writes the observations
			 output.flush();  //Write the remaining observations to the file
			 output.close();  //Finishes the files

			 println("file Saved");

			}

			// exports features data
			public void exportFeats(String fileName) {
  			String eol = System.getProperty("line.separator"); // line separator character
  			String flux="";
  			int count = 0;
  			float avg;

  			for (float[] gD : genData) {
  				for (int i=0; i<gD.length; i++){

		      		flux +=(str(gD[i]));  // observations
		      		if (i< gD.length-1) flux+=",";  // writes end of observations except for last observations
		      	}

		    	if (count<genData.size()-1) flux+=eol; // writes end of line except for last line
		    	count++;
		    }

			 // creates output & writes observations
			 PrintWriter output;   //Declare the PrintWriter
			 output = createWriter(fileName);   //Create a new PrintWriter object
			 output.println(flux); // Writes the observations
			 output.flush();  //Write the remaining observations to the file
			 output.close();  //Finishes the files

			 println("file Saved");
			}


		}