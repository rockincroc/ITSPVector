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
