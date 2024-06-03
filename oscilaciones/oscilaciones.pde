float x1 = 0;
float x2 = 0;
float v = 0.1; 
boolean funcion1 = true;

void setup() {
  size(800, 800);
}

void draw() {
  background(150);
  
  float y1 = sin(x1) * exp(-0.002 * x1);
  float y2 = 0.5 * sin(3 * x2) + 0.5 * sin(3.5 * x2);

  if (funcion1) {
    text("Letra C para cambiar el modo", width/4, 20);
    text("0.5 * sin(3 * x2) + 0.5 * sin(3.5 * x2)", width/4, 40);

    fill(250, 250, 250);
    ellipse(width/4 + x2, height/2 - y2 * 50, 30, 30);
  }

  else {
    
    textAlign(CENTER, CENTER);
    text("Letra C para cambiar el modo", width/4, 20);
    text("sin(x1) * exp(-0.002 * x1)", width/4, 40);
 
    fill(250, 250, 250);
    ellipse(width/4 + x1, height/2 - y1 * 50, 30, 30);
    
  }

  x1 += v;
  x2 += v;
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    funcion1 = !funcion1;
    x1 = 0;
    x2 = 0;
  }
}
