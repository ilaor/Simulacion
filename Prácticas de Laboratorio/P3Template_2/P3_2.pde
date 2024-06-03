// Problem description: Se nos propone como segunda parte de la practica de  //<>//
// colisiones, simular un fluido con particulas que colisionan entre si
// haciendo uso de Grid y Tablas Hash.
//

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = true;
PrintWriter _output;
boolean _computeParticleCollisions = true;
boolean _computePlaneCollisions = true;
boolean _creado = true;

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

void mousePressed()
{
   //Añadir partículas al sistema mediante el ratón
  //PVector pos = new PVector(mouseX, mouseY);
   //_ps.addParticleClick(pos);
}

void initSimulation()
{
  if(_creado){
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, n, Tsim");
      
   }
  }

   _simTime = 0.0;
   _timeStep = TS;

   initPlanes();
   initParticleSystem();
}

void initPlanes()
{
   _planes = new ArrayList<PlaneSection>();
       
   _planes.add(new PlaneSection( 150, DISPLAY_SIZE_Y/2, 750, DISPLAY_SIZE_Y/2, true));
   _planes.add(new PlaneSection( 150, DISPLAY_SIZE_Y/2, 50, DISPLAY_SIZE_Y-300, false));
   _planes.add(new PlaneSection( 750, DISPLAY_SIZE_Y/2, 850, DISPLAY_SIZE_Y-300, true));
   _planes.add(new PlaneSection( 50, DISPLAY_SIZE_Y-300, 400, DISPLAY_SIZE_Y-50, false));
   _planes.add(new PlaneSection( 850, DISPLAY_SIZE_Y-300, 550, DISPLAY_SIZE_Y-50, true));   
   _planes.add(new PlaneSection( 400, DISPLAY_SIZE_Y-50, 550, DISPLAY_SIZE_Y-50, false));

}

void initParticleSystem()
{
   _ps = new ParticleSystem(new PVector());   
   
    for (int i = 0; i < filas; i++){      
      for(int j = 0; j < columnas ; j++){   
        PVector initVel = new PVector(0, 0);//Velocidad
        PVector posaux = new PVector((radius+_dpart)*j+150, (radius+_dpart)*i+500);//Posición
        _ps.addParticle(M, posaux, initVel, radius, PARTICLES_COLOR);//añadir
      }
    }
}

void restartSimulation()
{
   n_bolas = n_bolas + 1500;
   filas = n_bolas / columnas;
   _creado = false;
   //endSimulation();
   
   //_ps.restart();
   
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
   _Tdraw = millis() - time;

   time = millis();
   updateSimulation();
   _Tsim = millis() - time;

   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _ps.getNumParticles() + "," + _Tsim);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

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
      _ps.computeParticleCollisions(_timeStep);
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
   text("Number of particles: " + _ps.getNumParticles(), width*0.3, height*0.275);
}
