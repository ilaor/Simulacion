// Problem description: //<>//
//    En esta práctica se nos propone simular el humo de una hoguera, jugando con 
//    las partículas, su generación, su desaparición, dándole texturas y modificando 
//    la podición a la vez que se elevan para simular el efecto del viento


// Differential equations:
//      a = [Froz(v(t)) + Fpeso + Fe ]/m
//
//      Froz = -k·v(t)
//      Fpeso = mg
//      Fviento = obtenida a partir de los calculos de la posición del mouse
//      Ftotal = fRoz + Fpeso + Fviento
//
//      Ep = m * g * h
//      Ec = (m * v^2) * 0.5


// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = false;
boolean _useTexture = false;
PrintWriter _output;

// Variables to be monitored:

float _energy;                // Total energy of the system (J)
int _numParticles;            // Total number of particles
PVector v = new PVector();

ParticleSystem _ps;

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
  else if (key == 't' || key == 'T')
    _useTexture = !_useTexture;
  else if (key == '+')
    _timeStep *= 1.1;
  else if (key == '-')
    _timeStep /= 1.1;
}

void initSimulation()
{
  if (_writeToFile)
  {
    _output = createWriter(FILE_NAME);
    writeToFile("t, E, n");
  }
  
  //Creamos un sistema de partículas en medio de la parte inferior de la ventana
  _ps = new ParticleSystem(new PVector(C.x/2, C.y-radius));
  _simTime = 0.0;
  _timeStep = TS;
}

void restartSimulation()
{
  endSimulation();
  initSimulation();
  _ps.restart();
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
  drawStaticEnvironment();
  drawMovingElements();

  updateSimulation();
  displayInfo();

  if (_writeToFile)
    writeToFile(_simTime + ", " + _energy + ", " + _numParticles);
}

void drawStaticEnvironment()
{
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  background(0);
}

void drawMovingElements()
{
  _ps.render(_useTexture);
}

//Añadimos partículas al sistema de partículas
void updateSimulation()
{
  for (int i = 0; i<NT*_timeStep; i++)
    _ps.addParticle(m, new PVector(), v, radius, color(255, 255, 0), L);
    
  // Actualizar la simulación
  _ps.update(_timeStep);
  
  // Incrementar el tiempo simulado
  _simTime += _timeStep;

  // Calcular la energía total del sistema
  _energy = _ps.getTotalEnergy();

  // Calcular el número total de partículas
  _numParticles = _ps.getNumParticles();

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
  text("Draw: " + frameRate + "fps", width*0.025, height*0.05);
  text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.075);
  text("Simulated time = " + _simTime + " s", width*0.025, height*0.1);
  text("Number of particles: " + _numParticles, width*0.025, height*0.125);
  text("Total energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
}
