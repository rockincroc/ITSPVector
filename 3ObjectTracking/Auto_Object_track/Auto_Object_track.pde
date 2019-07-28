import processing.video.*;
import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;
import net.java.games.input.*;

Capture video;
String[] input = loadStrings("list.txt");
int i;

float colThres = 900;
color trackColor;

int trackX;
int trackY;

float pit = 90;
float yaw = 90;

Check sq = new Check(320, 240, 100);

Arduino arduino;

void setup() {
  size(640, 480);
  printArray(Capture.list());
  video = new Capture(this, Capture.list()[0]);
  video.start();
  trackColor = color(0,0,0);
  i = 0;
  // println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  //arduino.pinMode(9, Arduino.SERVO);
  //arduino.pinMode(10, Arduino.SERVO);
  //arduino.pinMode(7, Arduino.SERVO);
  //arduino.pinMode(8, Arduino.SERVO);
  //arduino.pinMode(13, Arduino.SERVO);
  arduino.pinMode(11, Arduino.SERVO);
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

void draw() {
  float [] angles = float(split(input[i], ' '));
  arduino.servoWrite(7, (int)(angles[0]));
  arduino.servoWrite(8, (int)(angles[1]));
  arduino.servoWrite(13, (int)(angles[2]));
  
  
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
  //arduino.servoWrite(9, (int)(pit));
  //arduino.servoWrite(10, (int)(181 - pit));
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

Check:
class Check{
  public int x;
  public int y;
  public int side;
  
  Check(){
    x = video.width/2;
    y = video.height/2;
    side = 100;
  }
  
  Check(int px, int py, int s){
    x = px;
    y = py;
    side = s;
  }
  
  void show(){
    rectMode(CENTER);
    noFill();
    strokeWeight(2);
    stroke(0);
    rect(x, y, side, side);
  }
  
  void avg(color c){
    int count = 1;
    float sumX = 0;
    float sumY = 0;
   
    for (int xi = ((x - side)<0? 0:(x - side)); xi < ((x + side)>video.width? video.width:(x + side)); xi++) {
      for (int yi = ((y - side)<0? 0:(y - side)); yi < ((y + side)>video.height? video.height:(y + side)); yi++) {
        int loc = xi + (yi * video.width);
        // What is current color
        color currentColor = video.pixels[loc];
        float r1 = red(currentColor);
        float g1 = green(currentColor);
        float b1 = blue(currentColor);
        float r2 = red(c);
        float g2 = green(c);
        float b2 = blue(c);
  
        float d = distSq(r1, g1, b1, r2, g2, b2); 
  
        if (d < colThres) {
          sumX += xi;
          sumY += yi;
          count++;
        } 
      }
    }
    x = (int) sumX/count;
    y = (int) sumY/count;
  }
}
