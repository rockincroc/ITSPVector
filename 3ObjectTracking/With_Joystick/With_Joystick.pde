import processing.serial.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;
import cc.arduino.*;
import org.firmata.*;
import processing.video.*;

ControlDevice cont;
ControlIO control;

Arduino arduino;

Capture video;

float colThres = 900;
color trackColor;
int trackX;
int trackY;
float pit = 90;
float yaw = 90;
Check sq = new Check(320, 240, 100);

float thumb_left;
float thumb_right;
float phi_left;

void setup() {
  size(640, 480);
  printArray(Capture.list());
  video = new Capture(this, Capture.list()[0]);
  video.start();
  trackColor = color(0,0,0);
  
  control = ControlIO.getInstance(this);
  cont = control.getMatchedDevice("rev2");
  
   if (cont == null) {
    println("not today chump");
    System.exit(-1);
  }
  
  printArray(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(10, Arduino.SERVO);
  arduino.pinMode(11, Arduino.SERVO);
  arduino.pinMode(12, Arduino.SERVO);
  arduino.pinMode(13, Arduino.SERVO);
  arduino.pinMode(7, Arduino.SERVO);
  
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + (mouseY * video.width);
  trackX = mouseX;
  trackY = mouseY;
  sq = new Check(mouseX, mouseY, 100);
  trackColor = video.pixels[loc];
}

void keyPressed() {
  if (key == 'a') {
    sq.side+=5;
  } else if (key == 'z') {
    sq.side-=5; 
  }
  
  if (key == 's') {
    colThres+=5;
  } else if (key == 'x') {
    colThres-=5; 
  }
  
   if (key == 't' || key == 'T') {
    trackX = mouseX;
    trackY = mouseY;
    
    rectMode(CENTER);
    noFill();
    strokeWeight(2);
    stroke(255,0,0);
    rect(trackX, trackY, sq.side, sq.side);
    
    //print("trackX : "); println(trackX);
    //print("trackY : "); println(trackY);
  }
}

void captureEvent(Capture video) {
  video.read();
}

public void getUserInput(){
 // assign our float value 
 //access the controller.
 thumb_left = map(cont.getSlider("SER1").getValue(), -1, 1, 120, 0);
 thumb_right = map(cont.getSlider("SER2").getValue(), -1, 1, 120, 0);
 phi_left = map(cont.getSlider("ST").getValue(), -1, 1, 0, 120);
 print("left: ");
 println(thumb_left);
 print("right: ");
 println(thumb_right);
 print("phi: ");
 println(phi_left);
}

void draw(){
 getUserInput();
 //background(thumb,100,255)
 arduino.servoWrite(7, (int)phi_left);
 arduino.servoWrite(10, (int)thumb_left);
 //arduino.servoWrite(11, (int)thumb_left);
 //arduino.servoWrite(12, (int)thumb_right);
 //arduino.servoWrite(13, (int)thumb_right);
 
 
  image(video, 0, 0);
  video.loadPixels();
  loadPixels();
  
    sq.show();
    sq.avg(trackColor);
  
  float x_dist = trackX - sq.x; //println(x_dist);
  float y_dist = trackY - sq.y; //println(y_dist);
  float sum = abs(x_dist) + abs(y_dist);//println("sum: " + sum);
    
  if(sum > 70)
  {
    //if(pit<180 && pit>0) pit += map((y_dist / sum), -1 , 1 , -1, 1);
    if(yaw<188 && yaw>0) yaw += map((x_dist / sum), -1 , 1 , -1, 1);
  }
  
  //print("Pitch increment : ");println( map((y_dist / sum), -1 , 1 , -5, 5) );
  print("Yaw increment : ");println( map((x_dist / sum), -1 , 1 , -5, 5) );
    
  //print((int)pit); println(": Pitch Moving towards the location");
  print((int)yaw); println(": Yaw Moving towards the location");
  
  loadPixels();
  updatePixels();
  video.updatePixels();
  
  textAlign(RIGHT);
  fill(0);
  text("Side Length: " + sq.side, width-10, 25);
  text("Color threshold: " + colThres, width-10, 50);
  //arduino.servoWrite(12, (int)(pit));
  //arduino.servoWrite(13, (int)(181 - pit));
  arduino.servoWrite(11, (int)(yaw));
  
  //println((int)pit);
  //println((int)(181 - pit));
  //println((int)(yaw));
  
  rectMode(CENTER);
  noFill();
  strokeWeight(2);
  stroke(255,0,0);
  rect(trackX, trackY, sq.side, sq.side);
  delay(50);
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}
Attachments area
