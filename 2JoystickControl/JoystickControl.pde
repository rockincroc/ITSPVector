import processing.serial.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;
import cc.arduino.*;
import org.firmata.*;


  ControlDevice cont;
  ControlIO control;
  Arduino arduino;
  
  //classes describing properties of variables
  static class sp
  {
    static float fbv, lrv, pfbv, ylrv, udh, pb;
  }
  
  static class b
  {
    static boolean b1, b2, b3, b4;
  }
  
  static class c
  {
    static float rad, theta, phi, pitch, yaw;
  }
  
  static class s
  {
    static float s1off = 31, s2off = 1, s3off = 0, s4off = 0, stoff = 0;
    static float serv1, serv2, s3, s4, st;
  }
  
  static class t
  { 
    static float realTime, updateTime;
  }
  
  static class maxi
  {
    static float maxTrans = 2;
    static float maxRot = 2;
  }
   
    
  static class a
  {  
    static float a1 = 26;
    static float a2 = 16.5;
  } 

  void setup() {
    size(360, 200);
    control = ControlIO.getInstance(this);
    cont = control.getMatchedDevice("GenCont");
      sp.fbv = 0;
      sp.lrv = 0;
      sp.pfbv = 0;
      sp.ylrv = 0;
      sp.udh = 0;
      sp.pb = 0;
      b.b1 = false;
      b.b2 = false;
      b.b3 = false;
      b.b4 = false;
      c.rad = 42.5;
      c.theta = HALF_PI;
      c.phi = 0;
      c.pitch = 0;
      c.yaw = 0;
      s.serv1= 90 + s.s1off;
      s.serv2 = 0 + s.s2off; 
      s.s3 = 0; s.s4 = 0; s.st = 0;
      t.realTime = 0;
      t.updateTime = 0.2;

    if (cont == null) {
      println("Controller not connected");
      System.exit(-1);
    }
  
  /*
    println(c.rad);
    println(c.theta);
    println(s.serv1);
    println(s.serv2);
    println(Arduino.list());
  */
  
    arduino = new Arduino(this, Arduino.list()[2], 57600);//Change these values according to
    arduino.pinMode(10, Arduino.SERVO); arduino.servoWrite(10, (int)s.serv1);                  //the COM it is connected in
    arduino.pinMode(11, Arduino.SERVO); arduino.servoWrite(11, (int)s.serv1);
    arduino.pinMode(12, Arduino.SERVO); arduino.servoWrite(12, (int)s.serv2);
    arduino.pinMode(13, Arduino.SERVO); arduino.servoWrite(13, (int)s.serv2);
  
   
  }


    void getUserInput() {
    
    
      
    if( !(cont.getButton("L1").pressed()) && !(cont.getButton("R1").pressed()))
    {
      sp.fbv = map(cont.getSlider("RVS").getValue(), -1, 1, maxi.maxTrans, -maxi.maxTrans);
      sp.lrv = map(cont.getSlider("RHS").getValue(), -1, 1, -maxi.maxTrans, maxi.maxTrans);
      sp.pfbv = map(cont.getSlider("LVS").getValue(), -1, 1, maxi.maxRot, -maxi.maxRot);
      sp.ylrv = map(cont.getSlider("LHS").getValue(), -1, 1, -maxi.maxRot, maxi.maxRot);
      sp.udh = 0;
      sp.pb = 0;
    }
 
    else if( !(cont.getButton("L1").pressed()) && (cont.getButton("R1").pressed()))
    {
      sp.fbv = map(cont.getSlider("RVS").getValue(), -1, 1, maxi.maxTrans, -maxi.maxTrans);
      sp.lrv = map(cont.getSlider("RHS").getValue(), -1, 1, -maxi.maxTrans, maxi.maxTrans);
      sp.pfbv = 0;
      sp.ylrv = 0;
      sp.udh = map(cont.getSlider("LVS").getValue(), -1, 1, maxi.maxTrans, -maxi.maxTrans);
      sp.pb = map(cont.getSlider("LHS").getValue(), -1, 1, -maxi.maxRot, maxi.maxRot);
    }
 
    if( (cont.getButton("L1").pressed()) && !(cont.getButton("R1").pressed()))
    {
      sp.fbv = 0;
      sp.lrv = 0;
      sp.pfbv = map(cont.getSlider("LVS").getValue(), -1, 1, maxi.maxRot, -maxi.maxRot);
      sp.ylrv = map(cont.getSlider("LHS").getValue(), -1, 1, -maxi.maxRot, maxi.maxRot);
      sp.udh = map(cont.getSlider("RVS").getValue(), -1, 1, maxi.maxTrans, -maxi.maxTrans);
      sp.pb = map(cont.getSlider("RHS").getValue(), -1, 1, -maxi.maxRot, maxi.maxRot);
    }
 
 
    b.b1 = cont.getButton("1").pressed();
    b.b2 = cont.getButton("2").pressed();
    b.b3 = cont.getButton("3").pressed();
    b.b4 = cont.getButton("4").pressed();
    
    
    
    
    sp.fbv = map(cont.getSlider("RVS").getValue(), -1, 1, maxi.maxTrans, -maxi.maxTrans);
    sp.lrv = map(cont.getSlider("RHS").getValue(), -1, 1, -maxi.maxTrans, maxi.maxTrans);
    sp.udh = map(cont.getSlider("RHS").getValue(), -1, 1, +(maxi.maxTrans*2), -(maxi.maxTrans*2));
    
    sp.pfbv = 0;
    sp.ylrv = 0;
    sp.udh = map(cont.getSlider("LVS").getValue(), -1, 1, maxi.maxTrans, -maxi.maxTrans);
    sp.pb = map(cont.getSlider("LHS").getValue(), -1, 1, -maxi.maxRot, maxi.maxRot);
      
    
  }

  void draw() {
    getUserInput();
    println(t.realTime);
    
     
    if(b.b1) {println("Please wait till the motion is complete (1)"); move1();}
    else if(b.b2) {println("Please wait till the motion is complete (2)"); move2();}
    else if(b.b3) {println("Please wait till the motion is complete (3)"); move3();}
    else if(b.b4) {println("Please wait till the motion is complete (4)"); move4();}
    else
    {
      print("Old r co-ordinate: -  "); println(c.rad);
      print("Old theta co-ordinate: - "); println(c.theta);
      print("Start if-else - draw serv1: - "); println(s.serv1);
      print("Start if-else - draw serv2: - "); println(s.serv2);
      
    
      
      print("Front-Back speed: ");  println(sp.fbv);  fbMove();updateCord();
      print("After fb if-else - draw serv1: - "); println(s.serv1);
      print("After fb if-else - draw serv2: - "); println(s.serv2);
      
      /*
      
      print("Left-Right speed: ");  println(sp.lrv);  lrMove();updateCord();
      
      print("Pitch Front-Back omega: ");  println(sp.pfbv);  pitchMove();updateCord();
      print("After pM if-else - draw serv1: - "); println(s.serv1);
      print("After pM if-else - draw serv2: - "); println(s.serv2);
      
      print("Yaw Left-Right omega: ");  println(sp.ylrv);  yawMove();updateCord();
      print("After YW if-else - draw serv1: - "); println(s.serv1);
      print("After YW if-else - draw serv2: - "); println(s.serv2);
      
      print("Phi Rotation Speed: ");  println(sp.pb);  rotMove();updateCord();
      print("After PHI if-else - draw serv1: - "); println(s.serv1);
      print("After PHI if-else - draw serv2: - "); println(s.serv2);
      
      
      */
      
      print("Up-down speed: ");  println(sp.udh);  udMove();updateCord();  
      print("After UD if-else - draw serv1: - "); println(s.serv1);
      print("After UD if-else - draw serv2: - "); println(s.serv2);
      
    }
  
    print("Old r co-ordinate: -  "); println(c.rad);
    print("Old theta co-ordinate: - "); println(c.theta);
    print("draw serv1: - "); println(s.serv1);
    print("draw serv2: - "); println(s.serv2);
  
    arduino.servoWrite(10, (int) (s.serv1*180/PI) + (int)s.s1off);
    arduino.servoWrite(11, (int) (s.serv1*180/PI) + (int)s.s1off);
    arduino.servoWrite(12, (int) (s.serv2*180/PI) + (int)s.s2off);
    arduino.servoWrite(13, (int) (s.serv2*180/PI) + (int)s.s2off);
  
  
    delay( (int) (t.updateTime*1000) );
    t.realTime += (int) (t.updateTime*1000 + 17);
  }


    void lrMove(){ 
  }

    void move1()
  {
    arduino.servoWrite(4, (int) 0 +(int) s.s4off); updateCord();
    for(; s.s3<180; s.s3++){
      arduino.servoWrite(4, (int) (s.s4*180/PI) +(int) s.s4off);
      delay(30);
      updateCord();
    }
      
  }
    void move2()
  {
    s.s4 = 0;
    arduino.servoWrite(4, (int) (s.s4*180/PI) +(int) s.s4off);

  }
    void move3()
  {
    s.s3 = 0;
    arduino.servoWrite(3, (int) (s.s3*180/PI) +(int) s.s3off);

  }
    //void move4(){
    //}



  void updateCord(){
    print("Method updated before value of r : - "); println(c.rad);
    c.rad = sqrt( a.a1*a.a1 + a.a2*a.a2 + 2*a.a1*a.a2*cos(s.serv2) );
    print("Method updated value of r : - "); println(c.rad);
  
    print("Method updated before value of theta : - "); println(c.theta);
    c.theta = s.serv1 + asin ( a.a2*sin(s.serv2)/c.rad);
    print("Method updated value of theta : - "); println(c.theta);
  }



    void rotMove()
  {
    s.st += sp.pb * t.updateTime;
    arduino.servoWrite(5, (int) (s.st*180/PI) +(int) s.stoff);

  }

    void yawMove()
  {
    s.s4 += sp.ylrv * t.updateTime;
    arduino.servoWrite(4, (int) (s.s4*180/PI) +(int) s.s4off);

  }

    void pitchMove()
  {
    s.s3 += sp.pfbv * t.updateTime;
  }




    void fbMove()
  {
    float h = c.rad*cos(c.theta); //println(h);
    float x0 = c.rad*sin(c.theta); //println(x0);
    
    float vt = (sp.fbv*t.updateTime)+x0; //println(vt);
    float temp1a = ((h*h) + (vt*vt) + (a.a1*a.a1) - (a.a2*a.a2)); 
    float temp1b = (2*a.a1*sqrt((h*h) + (vt*vt)) ); 
    float temp2 = h/vt;
    
    float temp1 = temp1a/temp1b;
    temp1 = temp1>1 ? 1 : temp1;
    s.serv1 = asin( temp1 ) - atan( temp2 );
       
    float te = (h-(a.a1*cos(s.serv1)) ) / a.a2;
    te = te>1 ? 1 : te;
    s.serv2 = acos( te ) - s.serv1;
    s.s3 = s.serv1 + s.serv2 - HALF_PI;
  }

    void udMove()
  {
    float l = c.rad*sin(c.theta);
    float y0 = c.rad*cos(c.theta);
    
    float vt = (sp.udh*t.updateTime)+y0;
    float temp = ((l*l) + (vt*vt) + a.a1*a.a1 - a.a2*a.a2) / ( 2*a.a1*sqrt((l*l) + (vt*vt)) );
    temp = temp>1 ? 1 : temp;
    float temp2 = vt/l;
    
    float te = (l-(a.a1*sin(s.serv1)) ) / a.a2;
    te = te>1 ? 1 : te;
    
    s.serv1 = asin( temp ) - atan(temp2);
    println("s.serv1 calculated in UD"+s.serv1);
    s.serv2 = asin( te ) - s.serv1;
    println("s.serv2 calculated in UD"+s.serv2);

    s.s3 = s.serv1 + s.serv2 - HALF_PI;
  }
