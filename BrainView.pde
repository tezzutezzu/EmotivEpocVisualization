public class  BrainView {

  private HashMap<String, SensorView> sensorMap = new HashMap<String, SensorView>();

  private JSONArray json;
  public float dimX, dimY, xMin, yMin, xMax, yMax;
  SensorData model;
  Experiment experiment;



  // offsets are taken by experimental sampling on raw channels
  float[] offsets = {
    8697.0, 8394.0, 8214.0, 9216.0, 9135.0, 8384.0, 8839.0, 7337.0, 
    8145.0, 8212.0, 7995.0, 8320.0, 8341.0, 8643.0
  };


  public BrainView(SensorData model, Experiment experiment) {
    this.model = model;
    this.experiment = experiment;

    xMin = Float.MAX_VALUE;
    yMin = xMin;
    xMax = -Float.MAX_VALUE;
    yMax = xMax;
    /* Load json containing points coordinates */

    json = loadJSONArray("punti.json");

    for (int i = 0; i < json.size(); i++) {
      JSONObject sensor = json.getJSONObject(i);
      String name = sensor.getString("name").toUpperCase();
      JSONArray pnts = json.getJSONObject(i).getJSONArray("paths"); 
      JSONObject p = pnts.getJSONObject(0); 
      float x = p.getFloat("x");
      float y = p.getFloat("y");
      if (x < xMin) xMin = x;
      if (x > xMax ) xMax =x;
      if (y < yMin) yMin = y;
      if (y > yMax ) yMax =y;
      SensorView sensorView = new SensorView(experiment, i, round(x), round(y));
      sensorMap.put(name, sensorView);
      sensorView.name = name;
      sensorView.qualityRecords = new float[experiment.nTimeSlices];
    }

    dimX = xMax-xMin;
    dimY = yMax-yMin;

  }



  public void clear() {
    for (Entry<String, SensorView> entry : sensorMap.entrySet()) {
      String sensorName = entry.getKey().toString();
      SensorView sensorView = sensorMap.get(sensorName);
      sensorView.qualityRecords = new float[experiment.nTimeSlices];

    }
  }



  public void draw() {


    if(!debug) {
      Packet packet = model.getPacket();
      if (packet != null) {
        storeValues(packet);
      }
    } else {
      storeDebugValues();
    }

    drawSensors();
  }



  void storeValues(Packet packet) {

    Map<Packet.Sensor, Integer> sensors = packet.getSensors();

    for (Entry<Packet.Sensor, Integer> entry : sensors.entrySet()) {
    // for (Entry<String, SensorView> entry : sensorMap.entrySet()) {
      String sensorName = entry.getKey().toString();
      SensorView sensorView = sensorMap.get(sensorName);
      Packet.Sensor sensor = entry.getKey();

      try {
        sensorView.quality =  packet.getQuality(entry.getKey());
      } 
      catch(Exception e) {
        sensorView.quality = 0;
        println("quality not set e: "+e);
      }
      try {
        int index =  sensorView.index;
        experiment.addValue( index, map( (entry.getValue() - offsets[index]) / offsets[index], -1,1 ,0,1 ));
      } 

      catch(Exception e) {
        println("strength not set e: "+e);
      }
    }
  }


  void storeDebugValues() {
    int i =0;
    for (Entry<String, SensorView> entry : sensorMap.entrySet()) {
      String sensorName = entry.getKey().toString();
      SensorView sensorView =  entry.getValue();
      sensorView.quality =  1;
      experiment.addValue(i, noise(expCounter/100.0+1, i));
      i++;
    }
  }

  void drawSensors() {


    textAlign(CENTER, CENTER);

    pushMatrix();
    translate(-xMin, -yMin); // compensate for SVG drawing non-alignemnt

    // int i =0;
    for (Entry<String, SensorView> entry : sensorMap.entrySet()) {
      SensorView sensorView = entry.getValue();
      sensorView.draw();

    }

    // battery and Gyroscope data
    float gX, gY, bL;
    Packet packet = null;

    if (!debug){
     packet = model.getPacket();
    }
    
    if (packet != null) {

      gX = packet.getGyroX();
      gY = packet.getGyroY();
      bL = packet.getBatteryLevel();

    }else{

      gX = 0;
      gY = 0;
      bL = 0;

    }
    popMatrix();

    pushMatrix();
    camera(); // resets matrix transformations

    fill(d2);
    textAlign(LEFT, TOP);
    textSize(14);
    text("GyroX: " + gX, 15, 60);
    text("GyroY: " + gY, 110, 60);
    //textAlign(RIGHT, BOTTOM);
    text("Battery: " + int(bL)+" %", 200, 60);
    noFill();
    popMatrix();
    
    // textAlign(LEFT, CENTER);
    
  }



}
