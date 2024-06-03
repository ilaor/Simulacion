// Definitions:

enum CollisionDataType
{
   NONE,
   GRID,
   HASH
}

// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 900;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 900;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {200, 190, 210};      // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables


// Parameters of the problem:

final float TS = 0.05;     // Initial simulation time step (s)
final float M = 0.1;       // Particles' mass (kg)
final float Kd = 0.07;   // Constante de rozamiento
final float SIM_STEP = 0.01;   // Simulation time-step (s)
//
//

// Constants of the problem:

final color PARTICLES_COLOR = color(120, 160, 220);
final int N_bolas = 50;              //Número de bolas  
final int Radius = 12;              //Radio
final int SC_GRID = 50;             // Cell size (grid) (m)
final int SC_HASH = 50;             // Cell size (hash) (m)
final int NC_HASH = 1000;           // Number of cells (hash)
final float CR1 = -0.6; //Constante de pérdida de energía bola-plano
final float CR2 = 0.5; //Constante de pérdida de energía bola-bola
