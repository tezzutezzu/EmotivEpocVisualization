void oscEvent(OscMessage theOscMessage) {
  if (message){
    //print(theOscMessage.addrPattern());
    println(theOscMessage.toString());
    // for(float i:epocVar) println(i);
    //theOscMessage.printData();
    message = false;
  }
  // for (int i=0; i< epoc.epocAddr.length; i++) {
  //   if (theOscMessage.checkAddrPattern(epoc.epocAddr[i])==true) {
  //     epoc.data[epoc.currVal][i]=theOscMessage.get(0).floatValue();
  //   }
  // }
  if (frameCount%1 == 0) emotivOSC.storeValues(theOscMessage);
}
