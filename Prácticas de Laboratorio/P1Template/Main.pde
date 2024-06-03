// Problem description: //<>// //<>//
//Se nos propone realizar la simulación de un fenómeno físico
//simple derivando sus ecuaciones, aplicando métodos de integración 
//numérica y programando dichos métodos sobre un muelle.


// Differential equations:
//      a(s(t), v(t)) = [Froz(v(t)) + Fpeso + Fe ]/m   
//
//      Froz = -k·v(t)
//      Fpeso = mg
//      Fe = -k * elongación
//
//      Eg = M * Gc * h
//      Ee = 0.5 * ke * x^2
//      Ec = 0.5 * M * v^2


// Simulation and time control:

IntegratorType _integrator = IntegratorType.NONE;   // ODE integration method
float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)


// Output control:

boolean _writeToFile = true;
PrintWriter _output;


// Variables to be solved:

PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector();   // Velocity of the particle (m/s)
PVector _a = new PVector();   // Accleration of the particle (m/(s*s))
float _energy;                // Total energy of the particle (J)


// Springs:

Spring _sp;


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

void mouseClicked() {
   // Obtener la posición del ratón
   _s.set(mouseX, mouseY); // Posición de la partícula en las coordenadas del ratón
   _v.set(0, 0); // Velocidad cero
   _a.set(0, 0); // Aceleración cero
}


void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == ' ')
      _integrator = IntegratorType.NONE;
   else if (key == '1')
      _integrator = IntegratorType.EXPLICIT_EULER;
   else if (key == '2')
      _integrator = IntegratorType.SIMPLECTIC_EULER;
   else if (key == '3')
      _integrator = IntegratorType.RK2;
   else if (key == '4')
      _integrator = IntegratorType.RK4;
   else if (key == '5')
      _integrator = IntegratorType.HEUN;
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
      writeToFile("t, E, sx, sy, vx, vy, ax, ay");
   }

   _simTime = 0.0;
   _timeStep = TS;

   _s = S0.copy();
   _v.set(0.0, 0.0, 0.0);
   _a.set(0.0, 0.0, 0.0);
   
   _sp = new Spring(C, _s, ke,l0); //Muelle
}

void restartSimulation()
{
   initSimulation();   
   _integrator = IntegratorType.NONE;
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
   calculateEnergy();
   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _energy + ", " + _s.x + ", " + _s.y + ", " + _v.x + ", " + _v.y + "," + _a.x + ", " + _a.y);
}

//Dibuja las figuras necesarias para simular los objetos que no se mueven
void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   fill(STATIC_ELEMENTS_COLOR[0], STATIC_ELEMENTS_COLOR[1], STATIC_ELEMENTS_COLOR[2]);
   
   //Particula estatica
    circle(C.x, C.y, OBJECTS_SIZE);
}

//Dibuja las figuras necesarias para simular los objetos que se mueven
void drawMovingElements()
{
   fill(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
   //Particula
   circle(_s.x, _s.y, OBJECTS_SIZE);
   
   //Muelle
   line(C.x,C.y,_s.x,_s.y);
}

void updateSimulation()
{
   switch (_integrator)
   {
      case EXPLICIT_EULER:
         updateSimulationExplicitEuler();
         break;
   
      case SIMPLECTIC_EULER:
         updateSimulationSimplecticEuler();
         break;
   
      case HEUN:
         updateSimulationHeun();
         break;
   
      case RK2:
         updateSimulationRK2();
         break;
   
      case RK4:
         updateSimulationRK4();
         break;
   
      case NONE:
      default:
   }

   _simTime += _timeStep;
}

// Calcula la energía total de la simulación
void calculateEnergy()
{
    // Calcular la energía cinética
    float Ec = 0.5 * M * _v.magSq();
     
     // Calcular la altura desde el punto C hasta la posición actual del objeto
    float h = _s.copy().y - C.y;  
     
     // Calcular la energía potencial gravitatoria
    float Eg = M * Gc * h;
    
   // Calcular la energía total sumando todas las energías
    _energy = Eg + Ec + _sp.getEnergy();
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
   text("Integrator: " + _integrator.toString(), width*0.025, height*0.075);
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.1);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.125);
   text("Energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
   text("Speed: " + _v.mag()/1000.0 + " km/s", width*0.025, height*0.175);
   text("Acceleration: " + _a.mag()/1000.0 + " km/s2", width*0.025, height*0.2);
}

//Actualiza la simulación utilizando el método de integración de Euler Explícito.
void updateSimulationExplicitEuler() {
  
    // Calcula la aceleración en la posición y velocidad actuales
    _a = calculateAcceleration(_s, _v);
    
    // Actualiza la posición utilizando el método de Euler explícito:
    // s = s + v * t
    _s.add(PVector.mult(_v, _timeStep));
    
    // Actualiza la velocidad utilizando el método de Euler explícito:
    // v = v + a * t
    _v.add(PVector.mult(_a, _timeStep));
}

//Actualiza la simulación utilizando el método de integración de Simplectic Euler
void updateSimulationSimplecticEuler() {
  
    // Calcula la aceleración en la posición y velocidad actuales
    _a = calculateAcceleration(_s, _v);
    
    // Actualiza la velocidad utilizando el método de Euler simplectico:
    // v = v + a * t
    _v.add(PVector.mult(_a, _timeStep)); 
    
    // Actualiza la posición utilizando el método de Euler simplectico:
    // s = s + v * t
    _s.add(PVector.mult(_v, _timeStep));  
}

//Actualiza la simulación utilizando el método de integración de Runge-Kutta de 2do orden.
void updateSimulationRK2() {
  
    // Calcula la aceleración en la posición y velocidad actuales
    _a = calculateAcceleration(_s, _v);
  
    // Calcula k1 para la velocidad y la posición
    PVector k1v = PVector.mult(_a, _timeStep);
    PVector k1s = PVector.mult(_v, _timeStep);
  
    // Calcula la posición y velocidad intermedias s2 y v2
    PVector s2 = PVector.add(_s, PVector.mult(k1s, 0.5));
    PVector v2 = PVector.add(_v, PVector.mult(k1v, 0.5));
  
    // Calcula la aceleración en las posiciones y velocidades intermedias
    PVector _a2 = calculateAcceleration(s2, v2);
  
    // Calcula k2 para la velocidad y la posición
    PVector k2v = PVector.mult(_a2, _timeStep);
    PVector k2s = PVector.mult(v2, _timeStep);
  
    // Actualiza la velocidad y la posición utilizando k2
    _v.add(k2v);
    _s.add(k2s);
}

//Actualiza la simulación utilizando el método de integración de Runge-Kutta de 4to orden.
void updateSimulationRK4() {
    // Calcula la aceleración en la posición y velocidad actuales
    _a = calculateAcceleration(_s, _v);
    
    // Calcula k1 para la velocidad y la posición
    PVector k1s = PVector.mult(_v, _timeStep); // k1s = v(t) * h
    PVector k1v = PVector.mult(_a, _timeStep); // k1v = a(s(t), v(t)) * h

    // Calcula s2, v2 y k2
    PVector s2 = PVector.add(_s, PVector.mult(k1s, 0.5)); // s(t + h/2)
    PVector v2 = PVector.add(_v, PVector.mult(k1v, 0.5)); // v(t + h/2)
    PVector a2 = calculateAcceleration(s2, v2);
    PVector k2s = PVector.mult(v2, _timeStep); // k2s = (v(t + h/2)) * h
    PVector k2v = PVector.mult(a2, _timeStep); // k2v = a(s(t + h/2), v(t + h/2)) * h

    // Calcula s3, v3 y k3
    PVector s3 = PVector.add(_s, PVector.mult(k2s, 0.5)); // s(t + h/2)
    PVector v3 = PVector.add(_v, PVector.mult(k2v, 0.5)); // v(t + h/2)
    PVector a3 = calculateAcceleration(s3, v3);
    PVector k3s = PVector.mult(v3, _timeStep); // k3s = (v(t + h/2)) * h
    PVector k3v = PVector.mult(a3, _timeStep); // k3v = a(s(t + h/2), v(t + h/2)) * h

    // Calcula s4, v4 y k4
    PVector s4 = PVector.add(_s, k3s); // s(t + h)
    PVector v4 = PVector.add(_v, k3v); // v(t + h)
    PVector a4 = calculateAcceleration(s4, v4);
    PVector k4s = PVector.mult(v4, _timeStep); // k4s = (v(t + h)) * h
    PVector k4v = PVector.mult(a4, _timeStep); // k4v = a(s(t + h), v(t + h)) * h

    // Actualiza la velocidad con los valores de k1, k2, k3 y k4
    _v.add(PVector.mult(k1v, 1/6.0));
    _v.add(PVector.mult(k2v, 1/3.0));
    _v.add(PVector.mult(k3v, 1/3.0));
    _v.add(PVector.mult(k4v, 1/6.0));

    // Actualiza la posición con los valores de k1, k2, k3 y k4
    _s.add(PVector.mult(k1s, 1/6.0));
    _s.add(PVector.mult(k2s, 1/3.0));
    _s.add(PVector.mult(k3s, 1/3.0));
    _s.add(PVector.mult(k4s, 1/6.0));
}

//Actualiza la simulación utilizando el método de integración de Heun.
void updateSimulationHeun() {   

    // Calcula la aceleración en la posición y velocidad actuales
    _a = calculateAcceleration(_s, _v);
    
    // Vectores para el promedio de velocidad y aceleración
    PVector v_promedio = new PVector();
    PVector a_promedio = new PVector(); 


    // Calcula las posiciones y velocidades intermedias s2 y v2 utilizando el método de Euler
    PVector s2 = PVector.add(_s, PVector.mult(_v, _timeStep));
    PVector v2 = PVector.add(_v, PVector.mult(_a, _timeStep));

    // Calcula el promedio de velocidad y actualiza la posición
    v_promedio = PVector.mult(PVector.add(_v, v2), 0.5);
    _s.add(PVector.mult(v_promedio, _timeStep));

    // Calcula la aceleración en las posiciones y velocidades intermedias
    PVector _a2 = calculateAcceleration(s2, v2);

    // Calcula el promedio de aceleración y actualiza la velocidad
    a_promedio = PVector.mult(PVector.add(_a, _a2), 0.5);
    _v.add(PVector.mult(a_promedio, _timeStep));
}

//Calcula la aceleración basada en las fuerzas que actúan sobre la partícula.
PVector calculateAcceleration(PVector s, PVector v)
{

  PVector a = new PVector();
  PVector _F = new PVector();
  
  
  PVector Fpeso = PVector.mult(G,M);
  PVector Froz  = PVector.mult(_v,-kd);
  
  _F.x  = Fpeso.x;
  _F.y =  Fpeso.y;
  _F.add(Froz);
  
  _sp.setPos2(s);
  _sp.update();
  
  _F.add(_sp.getForce());
  
  a = _F.div(M);

   return a;
}
