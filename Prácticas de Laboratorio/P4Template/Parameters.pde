// Spring Layout
enum SpringLayout
{
   STRUCTURAL,
   SHEAR,
   BEND,
   STRUCTURAL_AND_SHEAR,
   STRUCTURAL_AND_BEND,
   SHEAR_AND_BEND,
   STRUCTURAL_AND_SHEAR_AND_BEND
}

// Simulation values:

final boolean REAL_TIME = true;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time


// Display and output parameters:

boolean DRAW_MODE = true;                            // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color OBJ_COLOR = color(250, 240, 190);         // Object color (RGB)
final color BALL_COLOR = color(225, 127, 80);         // Ball color (RGB)
final color BACKGROUND_COLOR = color(190, 1800, 210); // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables

// Parameters of the problem:

final float TS = 0.001;     // Initial simulation time step (s)
final float G = 9.810;       // Acceleration due to gravity (m/(s·s))

final int N_H = 40;         // Number of nodes of the object in the horizontal direction
final int N_V = 40;         // Number of nodes of the object in the vertical direction

final float D_H = 20.0;     // Separation of the object's nodes in the horizontal direction (m)
final float D_V = 20.0;     // Separation of the object's nodes in the vertical direction (m)

final float Ke = 100;           // Constante elástica (N/m)
final float Kd = 5;           // Constante de amortiguamiento (kg/s)
final float M = 0.1;               // Masa de cada nodo de la estructura deformable (kg)
final float R_P = 50;           // Radio pelota (m)
final float M_P = 10;             // Masa de la pelota

final float maxF = 500;
final float maxD = 0;

final PVector V_P = new PVector(-300, random(-100, 100),random(25, 100)); //Velocidad inicial de la pelota (m/s^2)
final PVector P_P = new PVector(800,0,40); //Posicion inicial de la pelota
final PVector GV = new PVector(0.0, G);    // Vector gravedad

final boolean nG = true;
