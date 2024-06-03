// Definitions:

enum IntegratorType 
{
   NONE, 
   EXPLICIT_EULER, 
   SIMPLECTIC_EULER, 
   RK2, 
   RK4,
   HEUN 
}


// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {220, 190, 210};      // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final int [] STATIC_ELEMENTS_COLOR = {0, 255, 0};     // Color of non-moving elements (RGB)
final int [] MOVING_ELEMENTS_COLOR = {255, 0, 0};     // Color of moving elements (RGB)
final float OBJECTS_SIZE = 20.0;                      // Size of the objects (m)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables 


// Parameters of the problem:

final float TS = 0.004;      // Initial simulation time step (s)
final float M = 2.0;         // Particle mass (kg)
final float Gc = 9.801;       // Acceleration due to gravity (m/(s·s))
final float D = 200.0;       // Initial distance (m)
final float kd = 10;          //Constante de friccion
final float ke = 10000;       //Constante de elasticidad
final float l0 = 50;          //longitud del muelle en reposo


// Constants of the problem:

final PVector C = new PVector(500.0, 500.0);              // Coordenadas del centro del sistema de muelle (m)
final PVector S0 = PVector.add(C, new PVector(0.0, -D));  // Posición inicial (m)
final PVector G  = new PVector(0.0, Gc);                  // Vector que almacena la gravedad (m/(s·s))

// 
// 
