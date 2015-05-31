
import com.github.fommil.emokit.EmotivListener;
import com.github.fommil.emokit.Packet;
import com.google.common.collect.MinMaxPriorityQueue;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;
import com.typesafe.config.Config;
import com.typesafe.config.ConfigFactory;
import lombok.extern.java.Log;

import javax.annotation.concurrent.GuardedBy;
import javax.swing.*;
import java.awt.*;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;



@Log
public class SensorData implements EmotivListener {

  Packet packet;

  private final Config config = ConfigFactory.load().getConfig("com.github.fommil.emokit.gui.sensors");


  public SensorData() {
    setPreferredSize(new Dimension(-1, 250));
  }

  @Override
  public void receivePacket(Packet p) {

    packet = p;
    
  }

  Packet getPacket() {
    return packet;
  }

  @Override
  public void connectionBroken() { }
}
