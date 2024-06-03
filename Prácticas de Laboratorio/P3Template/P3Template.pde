// Problem description:  //<>//
// En esta práctica s enos propone simular un billar francés,
// teniendo en cuenta las colisiones de las bolas, su velocidad,
// los límites de la mesa, etc.

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = false;
PrintWriter _output;
boolean _computeParticleCollisions = false;
boolean _computePlaneCollisions = true;
boolean _atraccion = false;
boolean _rand = false;

// System variables:

ParticleSystem _ps;
ArrayList<PlaneSection> _planes;

// Performance measures:
float _Tint = 0.0;    // Integration time (s)
float _Tdata = 0.0;   // Data-update time (s)
float _Tcol1 = 0.0;   // Collision time particle-plane (s)
float _Tcol2 = 0.0;   // Collision time particle-particle (s)
float _Tsim = 0.0;    // Total simulation time (s) Tsim = Tint + Tdata + Tcol1 + Tcol2
float _Tdraw = 0.0;   // Rendering time (s)

// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
   frameRate(DRAW_FREQ);
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

   initSimulation();
}

//Parar la simulación 
void stop()
{
   endSimulation();
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == 'c' || key == 'C')
      _computeParticleCollisions = !_computeParticleCollisions;
   else if (key == 'a' || key == 'A')
      _atraccion = !_atraccion;
   else if (key == 'p' || key == 'P')
      _computePlaneCollisions = !_computePlaneCollisions;
   else if (key == 'n' || key == 'N')
      _ps.setCollisionDataType(CollisionDataType.NONE);
   else if (key == 'g' || key == 'G')
      _ps.setCollisionDataType(CollisionDataType.GRID);
   else if (key == 'h' || key == 'H')
      _ps.setCollisionDataType(CollisionDataType.HASH);
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
}

//Función para simular el golpeo de la pelota mediante un palo de billar
void mousePressed() {
  if (mouseButton == LEFT) {
    for (int i = 0; i < _ps.getNumParticles(); i++) {
      Particle p = _ps._particles.get(i);
      
      // Calcula la distancia entre el mouse y la partícula
      float distance = dist(mouseX, mouseY, p._s.x, p._s.y);
      
      // Si la distancia es menor que el radio de la partícula, entonces el mouse está presionando esa partícula
      if (distance < p._radius) {
        // Calcula un vector desde el centro de la partícula hasta la posición del clic del mouse
        PVector direction = PVector.sub(new PVector(mouseX, mouseY), p._s);
        
        // Normaliza este vector (para obtener una dirección sin magnitud)
        direction.normalize();
        
        // Invierte la dirección
        direction.mult(-1);
        
        // Multiplica este vector por la nueva velocidad deseada para obtener el vector de velocidad final
        PVector newVel = PVector.mult(direction, 200);
        
        // Establece la velocidad de la partícula a este nuevo vector de velocidad
        p.setVel(newVel);
      }
    }
  }
  
  if (mouseButton == RIGHT) {
    for (int i = 0; i < _ps.getNumParticles(); i++) {
      Particle p = _ps._particles.get(i);
          
      PVector vsum = new PVector(1, 1); // Para mover la partícula en caso de v = 0
      PVector newVel = PVector.mult(PVector.add(p._v, vsum), random(0, 10));
      p.setVel(newVel);
    }
  }
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, n, Tsim");
   }

   _simTime = 0.0;
   _timeStep = TS;

   initPlanes();
   initParticleSystem();
}

void initPlanes()
{
   _planes = new ArrayList<PlaneSection>();
   //    
   _planes.add(new PlaneSection( 100, DISPLAY_SIZE_X/2, 800, DISPLAY_SIZE_Y/2, true));
   _planes.add(new PlaneSection( 100, DISPLAY_SIZE_X-100, 800, DISPLAY_SIZE_Y-100, false));
   _planes.add(new PlaneSection( 100, DISPLAY_SIZE_X/2, 100, DISPLAY_SIZE_Y-100, false));
   _planes.add(new PlaneSection( 800, DISPLAY_SIZE_X/2, 800, DISPLAY_SIZE_Y-100, true));   
}

//Inciar el sistema de partículas para crear las bolas
void initParticleSystem()
{
   _ps = new ParticleSystem(new PVector());   
   
    for (int i = 0; i < N_bolas; i++){
      PVector initVel = new PVector(100, 100);//Velocidad
      PVector posaux = new PVector(random(100, 800), random(DISPLAY_SIZE_X/2, DISPLAY_SIZE_X-100));//Posición
      _ps.addParticle(M, posaux, initVel, Radius, color(random(255), random(255), random(255)));
    }
}

void restartSimulation()
{
   endSimulation();
   
   _ps.restart();
   
   initSimulation();
}

void endSimulation()
{
   if (_writeToFile)
   {
      _output.flush();
      _output.close();
   }
}

void draw()
{
   float time = millis();
   drawStaticEnvironment();
   drawMovingElements();
   drawBilliardStick();
   _Tdraw = millis() - time;

   time = millis();
   updateSimulation();
   _Tsim = millis() - time;

   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _ps.getNumParticles() + "," + _Tsim);
}

//Función que dibuja un palo de billar para golpear las pelotas
void drawBilliardStick() {
  // Calcula las coordenadas del centro de la mesa de billar para orientar el palo siempre al centro
  PVector p1 = _planes.get(0).getPoint1();
  PVector p2 = _planes.get(0).getPoint2();
  PVector p3 = _planes.get(1).getPoint1();
  PVector p4 = _planes.get(1).getPoint2();
  
  float centerX = (p1.x + p2.x + p3.x + p4.x) / 4;
  float centerY = (p1.y + p2.y + p3.y + p4.y) / 4;
  
  // Calcula un vector desde la posición del ratón hasta el centro de la mesa de billar
  PVector direction = PVector.sub(new PVector(centerX, centerY), new PVector(mouseX, mouseY));
  
  // Normaliza este vector (para obtener una dirección sin magnitud)
  direction.normalize();
  
  // Multiplica este vector por la longitud deseada de la línea
  float lineLength = 175; // Cambia esto por la longitud deseada
  direction.mult(lineLength);
  
  // Calcula el punto de inicio de la línea
  PVector lineStart = PVector.add(new PVector(mouseX, mouseY), direction);
  
  // Dibuja una línea desde este punto hasta la posición del ratón
  stroke(223, 185, 146); // Color blanco
  strokeWeight(4); // Grosor de la línea
  line(lineStart.x, lineStart.y, mouseX, mouseY);
}

//Función que dibuja la mesa de billar
void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   
   fill(5, 163, 6);
   rect(100, DISPLAY_SIZE_X-100, 800 - 100, (DISPLAY_SIZE_X/2) - (DISPLAY_SIZE_X-100));

   for (int i = 0; i < _planes.size(); i++)
      _planes.get(i).render();
}

void drawMovingElements()
{
   _ps.render();
}

void updateSimulation()
{
   float time = millis();
   if (_computePlaneCollisions)
      _ps.computePlanesCollisions(_planes);
   _Tcol1 = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.updateCollisionData();
      //_ps.computeParticleCollisions(_timeStep);
   _Tdata = millis() - time;

   time = millis();
   if (!_computeParticleCollisions)
      _ps.computeParticleCollisions(_timeStep);
   _Tcol2 = millis() - time;

   time = millis();
   _ps.update(_timeStep);
   _simTime += _timeStep;
   _Tint = millis() - time;
}

void writeToFile(String data)
{
   _output.println(data);
}

void displayInfo()
{
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   textSize(20);
   text("Time integrating equations: " + _Tint + " ms", width*0.3, height*0.025);
   text("Time updating collision data: " + _Tdata + " ms", width*0.3, height*0.050);
   text("Time computing collisions (planes): " + _Tcol1 + " ms", width*0.3, height*0.075);
   text("Time computing collisions (particles): " + _Tcol2 + " ms", width*0.3, height*0.100);
   text("Total simulation time: " + _Tsim + " ms", width*0.3, height*0.125);
   text("Time drawing: " + _Tdraw + " ms", width*0.3, height*0.150);
   text("Total step time: " + (_Tsim + _Tdraw) + " ms", width*0.3, height*0.175);
   text("Fps: " + frameRate + "fps", width*0.3, height*0.200);
   text("Simulation time step = " + _timeStep + " s", width*0.3, height*0.225);
   text("Simulated time = " + _simTime + " s", width*0.3, height*0.250);
   text("Click en A: para atraer las bolar a la esquina inferior izquierda", width*0.3, height*0.300);
   text("Click en C: para activar/desactivar colisiones", width*0.3, height*0.325);
   text("Click en P: para activar/desactivar límites de la mesa de billar", width*0.3, height*0.350);
   text("Click izq para golpear la bola", width*0.3, height*0.375);
   text("Click drch: para darle velocidad (random) a las pelotas de la mesa", width*0.3, height*0.400);
   text("Click en R: reiniciar", width*0.3, height*0.450);

}
