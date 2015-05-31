# EMOTIV data acquisition and monitoring interface

This is an experiment in visualizing and storing data from an Emotiv Epoc neuroheadset using Processing and OSC.

The project was developed over the course of two weeks during [X | Y research lab](http://www.xylab.org/) held at [Castrignano De' Greci](http://upload.wikimedia.org/wikipedia/commons/a/a5/Castello_1_di_Castrignano_de'_Greci.jpg) in July 2014.


## Usage

Before starting, make sure the headset is connected and its sensors placed correctly. We found that it helped using a saline solution to have a better quality from the sensors.

Insert a name to identify the observation and start the visualization.

![Each blob on the right represents a sensor with its values recorded over a predefined time. On the left, from top to bottom, are the values from the OSC library, the combined values over time and the average values for each observation ](https://raw.github.com/tezzutezzu/EmoticVisualization/master/screenshot1.png)
Each blob on the right represents a sensor with its values recorded over a predefined time. On the left, from top to bottom, are the values from the OSC library, the combined values over time and the average values for each observation 



![You can click a sensor to keep it opened a nd hover it to see its name and realtime value. ](https://raw.github.com/tezzutezzu/EmoticVisualization/master/screenshot2.png)
You can click a sensor to keep it opened and hover it to see its name and realtime value.



![Blob detail ](https://raw.github.com/tezzutezzu/EmoticVisualization/master/detail.png)
The circle in the middle of the blob represents the sensor quality, the blue lines are the value recorded over a predefined interval of time and the white circle represents the current value sensed by the sensor.



## Team and credits

Eugenio Battaglia, Alessio Erioli, Leonardo Romei, Danilo Di Cuia, Giulia Marzin, Michele Pastore, Antonio Vergari.

Code by Danilo Di Cuia, Alessio Erioli, Antonio Vergari.

Based on the Java porting of the EMOKIT library by Samuel Halliday https://github.com/fommil/emokit-java
who ported the open source Emokit library originally written in C developed by several brave people
credited on the original repository: https://github.com/openyou/emokit.

Additional resources and unorganized mental snapshots from the process can be found at https://xylabopeneeg.wordpress.com






