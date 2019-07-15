#include <Servo.h>

Servo s1a;  // create servo object to control a servo
Servo s2a;
Servo s1b;
Servo s2b;

int pos = 0;    // variable to store the servo position

void setup() {
  s1a.attach(10);  // attaches the servo on pin 10 to the servo object
  s2a.attach(9);  // attaches the servo on pin 11 to the servo object
  s1b.attach(12);  // attaches the servo on pin 12 to the servo object
  s2b.attach(11);  // attaches the servo on pin 13 to the servo object
}

void loop() {
  for (pos = 0; pos <= 120; pos += 1) { // goes from 0 degrees to 180 degrees
    //in steps of 1 degree
    s1a.write(pos);
    s2a.write(pos);
    s1b.write(pos);
    s2b.write(pos);                     // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
  for (pos = 120; pos >= 0; pos -= 1) { // goes from 180 degrees to 0 degrees
    s1a.write(pos);
    s2a.write(pos);
    s1b.write(pos);
    s2b.write(pos);                     // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
}
