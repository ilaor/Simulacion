
Mover mover;
float waterLevel;
float radio;

void setup() {
  size(800, 600);
  mover = new Mover(1000, width/2, 0);
  radio = 15;
  waterLevel = height / 2;
}

void draw() {
  background(255);
  drawStaticEnvironment();


  mover.update();
  mover.display();
}

void drawStaticEnvironment() {
  fill(0, 0, 255);
  rect(0, waterLevel, width, height - waterLevel);
}

class Mover {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float densidad;
  PVector Vgravedad;
  float gravedad;
  float volsumerg;
  PVector force;

  Mover(float m, float x, float y) {
    mass = m;
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 5);
    densidad = 0.00001;
    gravedad = 0.00981;
    Vgravedad = new PVector(0, gravedad);
    volsumerg = 0;
    force = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    PVector f = new PVector(Vgravedad.x * mass, Vgravedad.y * mass);
    force.add(f);
  }

 void update() {
    force = new PVector(0, 0); 
    applyForce(force);
    
    volsumerg = CalcVsumer();
    float fuerzaFlotabilidad = densidad * gravedad * volsumerg;
    PVector flot = new PVector(0, -fuerzaFlotabilidad); 
    force.add(flot);
    
    acceleration = PVector.div(force, mass);
    velocity.add(acceleration);
    
    // Si la elipse está completamente sumergida en el agua, cambia la dirección de la velocidad
    if (position.y - radio >= waterLevel) {
      velocity.y *= -0.5;
    }
    
    position.add(velocity);
  }

  float CalcVsumer() {
    if (position.y < height/2) {
      volsumerg = (4 * PI * pow(radio, 3)) / 3;
    } else if (position.y == height/2) {
      float h = position.y + radio - height/2;
      float a = sqrt(2 * h * radio - h * h);
      volsumerg = (3 * a * a + h * h) * PI * h / 6;
    } else
      volsumerg = 0;
    return volsumerg;
  }

  void display() {
    stroke(0);
    fill(175);
    ellipse(position.x, position.y, radio * 2, radio * 2);
  }
}
