Mover mover;
ParticleSystem particleSystem;
float waterLevel;
float radio;
boolean hasCollided = false; // Variable para controlar si ya ha ocurrido la colisión con el agua

void setup() {
  size(800, 600);
  mover = new Mover(1000, width/2, 0);
  particleSystem = new ParticleSystem();
  radio = 15;
  waterLevel = height / 2;
}

void draw() {
  background(255);
  drawStaticEnvironment();

  mover.update();
  
  // Dibuja la esfera principal solo si no ha ocurrido la colisión
  if (!hasCollided) {
    mover.display();
  }
  
  // Si la bola está en contacto con el agua y aún no ha ocurrido la colisión, activa el sistema de partículas
  if (mover.position.y >= waterLevel && !hasCollided) {
    particleSystem.explode(mover.position.x, waterLevel); // Ajustamos la altura de la explosión para que sea en el nivel del agua
    hasCollided = true; // Marcar que ya ha ocurrido la colisión
  }
  
  particleSystem.update();
  particleSystem.display();
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
    gravedad = 0.009;
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
    
    // Si la elipse está en contacto con el agua, cambia la dirección de la velocidad
    if (position.y >= waterLevel) {
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

class ParticleSystem {
  ArrayList<Particle> particles;

  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void explode(float x, float y) {
    for (int i = 0; i < 100; i++) {
      Particle p = new Particle(x, y);
      particles.add(p);
    }
  }

  void update() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity.mult(random(2, 5));
    acceleration = new PVector(0, 0.05);
    lifespan = 255.0;
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  void display() {
    stroke(0, lifespan);
    fill(175, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
