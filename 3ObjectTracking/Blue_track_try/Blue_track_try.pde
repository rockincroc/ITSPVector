PImage img;

void setup() {
  size(1280, 720);
  img = loadImage("test1.jpg");
}

void draw() {
  loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 
  int HTotal = 0, WTotal = 0, num = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int loc = x + y*width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      if(b>50 && r<50 && g>85 && g<200)
      {
        b = 255;
        r = 0;
        g = 0;
        HTotal += y;
        WTotal += x;
        num++;
      }
      else
      {
        r = 255;
        g = 0;
        b = 0;
      }
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b);          
    }
  }
  
  int yCent = (int) HTotal/num;
  int xCent = (int) WTotal/num;
  int side = 10;
  
  for (int y = yCent - side; y < yCent + side; y++) {
    for (int x = xCent - side; x < xCent + side; x++) {
      int loc = x + y*width;
      pixels[loc] =  color(0,255,0);          
    }
  }
  
  updatePixels();
}
