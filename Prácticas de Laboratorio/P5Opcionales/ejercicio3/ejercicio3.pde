import fisica.*;

FWorld mundo;
FCircle cuerpo1, cuerpo2;
FRevoluteJoint articulacion;

void setup() {
  size(800, 600);
  Fisica.init(this);
  mundo = new FWorld();
  mundo.setGravity(0, 0); 

  cuerpo1 = new FCircle(40);
  cuerpo1.setPosition(200, height/2);
  cuerpo1.setNoStroke();
  cuerpo1.setFill(120, 100, 220); 
  cuerpo1.setDensity(1);
  cuerpo1.setFriction(0);  
  cuerpo1.setAngularDamping(0);  
  mundo.add(cuerpo1);

  cuerpo2 = new FCircle(40);
  cuerpo2.setPosition(600, height/2);
  cuerpo2.setNoStroke();
  cuerpo2.setFill(255, 150, 0);  
  cuerpo2.setDensity(1);
  cuerpo2.setFriction(0);  
  cuerpo2.setAngularDamping(0);  
  mundo.add(cuerpo2);
  articulacion = new FRevoluteJoint(cuerpo1, cuerpo2);
  articulacion.setAnchor(width/2, height/2);  
  articulacion.setEnableLimit(true); 
  articulacion.setLowerAngle(0); 
  articulacion.setUpperAngle(0); 
  mundo.add(articulacion);
}

void draw() {
  background(240);  
  mundo.step();
  mundo.draw();
  cuerpo1.addTorque(-50); 
}

void mousePressed() {
  mundo.remove(articulacion); 

  cuerpo2.setPosition(mouseX, mouseY);
  
  articulacion = new FRevoluteJoint(cuerpo1, cuerpo2);
  articulacion.setAnchor((cuerpo1.getX() + cuerpo2.getX()) / 2, (cuerpo1.getY() + cuerpo2.getY()) / 2);
  articulacion.setEnableLimit(true);
  articulacion.setLowerAngle(0);
  articulacion.setUpperAngle(0);
  mundo.add(articulacion);
}
