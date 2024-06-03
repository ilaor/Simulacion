// Deformable object simulation //<>//
import peasy.*;

// Display control:

PeasyCam _camera;   // Mouse-driven 3D camera

// Simulation and time control:

float _timeStep;              // Simulation time-step (s)
int _lastTimeDraw = 0;        // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;         // Simulated time (s)
float _elapsedTime = 0.0;     // Elapsed (real) time (s)

// Output control:

boolean _writeToFile = true;
PrintWriter _output;

// System variables:

Ball _ball;                           // Sphere
DeformableObject _derch, _izq,_fondo,_larguero;              // Deformable object
SpringLayout _springLayout;           // Current spring layout
PVector _ballVel = new PVector();     // Ball velocity



// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
}

void setup() {
   frameRate(DRAW_FREQ);
   _lastTimeDraw = millis();

   float aspect = float(DISPLAY_SIZE_X) / float(DISPLAY_SIZE_Y);
   perspective((FOV * PI) / 180, aspect, NEAR, FAR);

   // Crea la cámara PeasyCam
   _camera = new PeasyCam(this, 0, 0, 0, 1250); // Coloca la cámara en el origen (0, 0, 0) y establece la distancia inicial a 1250 unidades
  _camera.setDistance(1500);
   // Orienta la cámara para que mire desde el eje x
   _camera.rotateY(HALF_PI); // Rota la cámara 90 grados alrededor del eje y para mirar hacia el eje x positivo
   _camera.rotateZ(HALF_PI + PI);
   _camera.rotateX(PI/8);
   

   // Inicializa la simulación
   initSimulation(SpringLayout.STRUCTURAL_AND_SHEAR_AND_BEND);
}



void stop()
{
   endSimulation();
}

void keyPressed()
{
   if (key == '1')
      restartSimulation(SpringLayout.STRUCTURAL);

   if (key == '2')
      restartSimulation(SpringLayout.SHEAR);

   if (key == '3')
      restartSimulation(SpringLayout.BEND);

   if (key == '4')
      restartSimulation(SpringLayout.STRUCTURAL_AND_SHEAR);

   if (key == '5')
      restartSimulation(SpringLayout.STRUCTURAL_AND_BEND);

   if (key == '6')
      restartSimulation(SpringLayout.SHEAR_AND_BEND);

   if (key == '7')
      restartSimulation(SpringLayout.STRUCTURAL_AND_SHEAR_AND_BEND);

   if (key == 'r')
      resetBall();

   if (key == 'b')
      restartBall();

   if (keyCode == UP)
      _ballVel.x *= 1.05;

   if (keyCode == DOWN)
      _ballVel.x /= 1.05;

   if (key == 'D' || key == 'd')
      DRAW_MODE = !DRAW_MODE;

   if (key == 'I' || key == 'i')
      initSimulation(_springLayout);
}

void initSimulation(SpringLayout springLayout)
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, n, Tsim");
   }

   _simTime = 0.0;
   _timeStep = TS*TIME_ACCEL;
   _elapsedTime = 0.0;
   _springLayout = springLayout;
   _ballVel = V_P;
   
    _derch = new DeformableObject(N_H-20,N_V-20, D_H, D_V ,Ke,Kd,M,nG,maxF,_springLayout,color(0,0,0),1);
    _izq = new DeformableObject(N_H-20,N_V-20, D_H, D_V ,Ke,Kd,M,nG,maxF,_springLayout,color(0,0,0),2);
    _fondo = new DeformableObject(N_H,N_V-20, D_H, D_V,Ke,Kd,M,nG,maxF,_springLayout,color(0,0,0),3); //fondo
    _larguero = new DeformableObject(N_H-20,N_V  , D_H, D_V ,Ke,Kd,M,nG,maxF,_springLayout,color(0,0,0),4); //larguero
    _ball = new Ball(P_P, V_P, M_P, R_P, color(255));
    
}

void resetBall()
{
   _ball.setPosition(P_P);
   initSimulation(_springLayout);
}

void restartBall()
{
  _ballVel = new PVector(-300, random(-100, 100),random(25, 100)); //Nueva velocidad aleatoria
   _ball.setPosition(P_P);
   _ball.setVelocity(_ballVel);
}

void restartSimulation(SpringLayout springLayout)
{
   _simTime = 0.0;
   _timeStep = TS*TIME_ACCEL;
   _elapsedTime = 0.0;
   _springLayout = springLayout;

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
   int now = millis();
   _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
   _elapsedTime += _deltaTimeDraw;
   _lastTimeDraw = now;

   //println("\nDraw step = " + _deltaTimeDraw + " s - " + 1.0/_deltaTimeDraw + " Hz");

   background(BACKGROUND_COLOR);
   drawStaticEnvironment();
   drawDynamicEnvironment();

   if (REAL_TIME)
   {
      float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
      float expectedIterations = expectedSimulatedTime/_timeStep;
      int iterations = 0;

      for (; iterations < floor(expectedIterations); iterations++)
         updateSimulation();

      if ((expectedIterations - iterations) > random(0.0, 1.0))
      {
         updateSimulation();
         iterations++;
      }

     //println("Expected Simulated Time: " + expectedSimulatedTime);
      //println("Expected Iterations: " + expectedIterations);
      //println("Iterations: " + iterations);
   } 
   else
      updateSimulation();

   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + "," + _fondo.getNumNodes()+", " + _izq.getNumNodes()+ ", " + _derch.getNumNodes()+", " + _larguero.getNumNodes() + ", " + _deltaTimeDraw);

}

void drawStaticEnvironment()
{
   
  /*
  Ejes de coordenadas
    
  noStroke();
   fill(255, 0, 0);
   box(1000.0, 1.0, 1.0);

   fill(0, 255, 0);
   box(1.0, 1000.0, 1.0);

   fill(0, 0, 255);
   box(1.0, 1.0, 1000.0);

   fill(255, 255, 255);
   sphere(1.0);*/
   
   pushMatrix();
   
   translate((-width/4)-150, 0); // Centrar el rectángulo
   
  // Dibujar el césped (rectángulo verde)
  fill(0, 128, 0); // Verde oscuro
  
  rect(0, height, width*2, -height*2);
  

  popMatrix();
   
  pushMatrix(); 
  translate(0, width); // Centrar el rectángulo
   // Dibujar la línea blanca
   strokeWeight(4);
   stroke(255); // Blanco
   line(0, 0, 0, -height*2); // Línea vertical en el eje Y
   popMatrix();
   
   fill(255);
   circle(800,0,40);
}

void drawDynamicEnvironment()
{
  _ball.render(); 
  _derch.render();
   _izq.render();
   _fondo.render();
   _larguero.render();
   
}

void updateSimulation()
{
     _ball.update(_timeStep);
     _derch.avoidCollision(_ball, 100,Kd,maxF);
     _izq.avoidCollision(_ball, 100,Kd,maxF);
     _fondo.avoidCollision(_ball, 100,Kd,maxF);
     _larguero.avoidCollision(_ball, 100,Kd,maxF);

     _derch.update(_timeStep);
     _izq.update(_timeStep);
     _fondo.update(_timeStep);
     _larguero.update(_timeStep);

   _simTime += _timeStep;
}

void writeToFile(String data)
{
   _output.println(data);
}

void displayInfo()
{
   pushMatrix();
   {
      camera();
      fill(0);
      textSize(20);

      text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.05);
      text("Elapsed time = " + _elapsedTime + " s", width*0.025, height*0.075);
      text("Simulated time = " + _simTime + " s ", width*0.025, height*0.1);
      text("Spring layout = " + _springLayout, width*0.025, height*0.125);
      text("Ball start velocity = " + _ballVel + " m/s", width*0.025, height*0.15);
   }
   popMatrix();
}
