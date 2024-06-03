float dt = 0.5;
PVector p, vel, r, initialP;
boolean press = false;
float lineLength = 100;

void setup() {
  size(800, 800);
  p = new PVector(width/2, height - 22);
  initialP = p.copy(); 
}

void draw() {
  background(140);
  fill(255);
  textSize(14);
  textAlign(LEFT, TOP);
  text("Apuntar con el mouse y click para disparar", 10, 10);
  
  stroke(0);
  fill(150, 150, 150);
  ellipse(p.x, p.y, 40, 40);

  if (press == true) {
    p.add(PVector.mult(vel, dt));
    if (p.y < 0 || p.x < 0 || p.x > width) {
      press = false;
    }
  } else {
    p = new PVector(width/2, height - 22);
    ellipse(p.x, p.y, 40, 40);
  }
}

void mousePressed() {
  r = new PVector(mouseX, mouseY);
  vel = PVector.sub(r, p);
  vel.normalize();
  vel.mult(70);
  press = true;
}
