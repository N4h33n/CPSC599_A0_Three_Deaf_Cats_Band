/**
  * This sketch demonstrates how to use the BeatDetect object in FREQ_ENERGY mode.<br />
  * You can use <code>isKick</code>, <code>isSnare</code>, </code>isHat</code>, <code>isRange</code>, 
  * and <code>isOnset(int)</code> to track whatever kind of beats you are looking to track, they will report 
  * true or false based on the state of the analysis. To "tick" the analysis you must call <code>detect</code> 
  * with successive buffers of audio. You can do this inside of <code>draw</code>, but you are likely to miss some 
  * audio buffers if you do this. The sketch implements an <code>AudioListener</code> called <code>BeatListener</code> 
  * so that it can call <code>detect</code> on every buffer of audio processed by the system without repeating a buffer 
  * or missing one.
  * <p>
  * This sketch plays an entire song so it may be a little slow to load.
  */

import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Arduino arduino;


int ledPin1 =  11;    // LED connected to digital pin 11
int ledPin2 =  10;    // LED connected to digital pin 10
int ledPin3 =  9;     // LED connected to digital pin 9

int buttonPin = 4;    // button connected to digital pin 4

float kickSize, snareSize, hatSize, kickDiv, snareDiv, hatDiv;
PImage kickImage, snareImage, hatImage;

void setup() {
  fullScreen(P3D);
  
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  
  song = minim.loadFile("ilikethat.mp3", 2048);
  kickImage = loadImage("kickHat.jpeg");
  snareImage = loadImage("snare.jpeg");
  hatImage = loadImage("kickHat.jpeg");
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  beat.setSensitivity(100);  
  kickSize = snareSize = hatSize = 40;
  kickDiv = snareDiv = hatDiv = 8;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 40));
  textAlign(CENTER);
  
  arduino.pinMode(ledPin1, Arduino.OUTPUT);    
  arduino.pinMode(ledPin2, Arduino.OUTPUT);  
  arduino.pinMode(ledPin3, Arduino.OUTPUT);  
  arduino.pinMode(buttonPin, Arduino.INPUT);
}

int i = 0;
void draw() {
  background(0);
  fill(255);
    if (arduino.digitalRead(buttonPin) == 1){
    while (arduino.digitalRead(buttonPin) == 1){
      delay(10);
    } i++;
  } if (i%2 == 1){
    song.play();
  if(beat.isKick()) {
      arduino.digitalWrite(ledPin1, 1);   // set the LED on
      kickSize = 50;
      kickDiv = 6;
  }
  if(beat.isSnare()) {
      arduino.digitalWrite(ledPin2, 1);   // set the LED on
      snareSize = 50;
      snareDiv = 6;
  }
  if(beat.isHat()) {
      arduino.digitalWrite(ledPin3, 1);   // set the LED on
      hatSize = 50;
      hatDiv = 6;
  }
  } else {
    song.pause();
  }
  arduino.digitalWrite(ledPin1, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin2, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin3, Arduino.LOW);    // set the LED off
  fill(255, 0, 0);
  textSize(kickSize);
  text("KICK", width/4, 3*height/4);
  image(kickImage, width/2 - (kickImage.height/kickDiv)/2, height/2 - 50, kickImage.width/kickDiv, kickImage.height/kickDiv);
  fill(0, 255, 0);
  textSize(snareSize);
  text("SNARE", width/2, 3*height/4);
  image(snareImage, width/2 - (snareImage.height/snareDiv)/2, height/2 - 50, snareImage.width/snareDiv, snareImage.height/snareDiv);
  fill(255, 0, 0);
  textSize(hatSize);
  text("HAT", 3*width/4, 3*height/4);
  image(hatImage, width/2 - (hatImage.height/hatDiv)/2, height/2 - 50, hatImage.width/hatDiv, hatImage.height/hatDiv);
  kickSize = constrain(kickSize * 0.95, 40, 50);
  kickDiv = constrain(kickSize * 0.95, 6, 8);
  snareSize = constrain(snareSize * 0.95, 40, 50);
  snareDiv = constrain(kickSize * 0.95, 6, 8);
  hatSize = constrain(hatSize * 0.95, 40, 50);
  hatDiv = constrain(kickSize * 0.95, 6, 8);
}

void stop() {
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}
