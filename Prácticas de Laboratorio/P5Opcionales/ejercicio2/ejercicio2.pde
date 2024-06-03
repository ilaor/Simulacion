import fisica.*;

final int NUM_OBJETOS = 10; // Menor número para una torre simple
final int TAM_OBJETO_X = 90;
final int TAM_OBJETO_Y = 60; // Menor altura para estabilidad

FWorld _world;
ArrayList<FBox> _objetos;

void setup() {
  size(1000, 1000);
  smooth();
  
  _objetos = new ArrayList<FBox>();

  Fisica.init(this);
  _world = new FWorld();
  _world.setEdges();

  // Creación de la torre: los objetos se colocan uno encima del otro
  for (int i = 0; i < NUM_OBJETOS; i++) {
    int posX = width / 2; // Centrar la torre
    int posY = height - (i * TAM_OBJETO_Y) - TAM_OBJETO_Y / 2; // Apilar hacia arriba

    FBox objeto = new FBox(TAM_OBJETO_X, TAM_OBJETO_Y);
    objeto.setPosition(posX, posY);
    objeto.setDensity(1.0f);
    objeto.setFriction(0.9); 
    objeto.setDamping(3); 
    objeto.setAngularDamping(0.1);
    objeto.setRestitution(0.2); 

    _world.add(objeto);
    _objetos.add(objeto);
  }
}

void draw() {
  background(225, 225, 255);

  // Simulación de los objetos del mundo físico
  _world.step();

  // Cambio de color de los objetos en función de su estado
  for (FBox objeto : _objetos) {
    if (objeto.isSleeping())
      objeto.setFillColor(color(#FF0000));
    else
      objeto.setFillColor(color(#FFFF00));
  }

  // Dibujado de los objetos del mundo físico
  _world.draw();
}
