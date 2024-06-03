float dt = 0.1;
float P, F, dEc, Ec = 0, v = 0, m = 1, k = 0.1;
float xCar = 0, t = 0, lastX = 0, lastY = height;
boolean powerOn = false;
int segment = 0; 

void setup() {
  size (800, 800);
}

void draw() {
  background(150);


  fill(255);
  textSize(14);
  textAlign(LEFT, TOP);
  text("P para parar o arrancar el vehículo", 10, 10);
  

  fill(0,255,255);
  rect(xCar, height/2, 50, 25);

  if (powerOn) {
    updateVelocity();
  }
}

void updateVelocity() {
  P = 1000; 
  

  F = -k * v * v;
  P += F * v;
  
  dEc = P * dt;

  Ec += dEc;
 
  v = sqrt(2 * Ec / m);
  
  xCar += v * dt;
  
  if (xCar > width + 25) {
    xCar = -25; 
    t = 0;
    lastY = height; 
    lastX = 0; 
    segment = (segment + 1) % 3;


    switch(segment) {
      case 0:
        k = 0.1;
        break;
      case 1:
        k = 0.2;
        break;
      case 2:
        break;
    }
  }
}

void keyPressed() {

  if (key == 'p' || key == 'P') {
    powerOn = !powerOn; 
  }
}
