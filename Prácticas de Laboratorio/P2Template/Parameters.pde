// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 700;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {30, 20, 50};         // Background color (RGB)
final int [] TEXT_COLOR = {255, 255, 0};              // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables 


// Parameters of the problem:

final float TS = 0.01;     // Initial simulation time step (s)
final float NT = 100.0;    // Rate at which the particles are generated (number of particles per second) (1/s)           
final float L = 2.0;       // Particles' lifespan (s) 
final float m = 0.01;
final float radius = 25;
final float diametro = radius *2;
final float Gc = -9.801;       // Acceleration due to gravity (m/(s·s))
final float kd = 0.000001;     //Constante de friccion

final float Krx = 10;          //Constante que almacena los números aleatorios en x
final float Kry = 5;           //Constante que almacena los números aleatorios en y

final float opacity_tex = 5;   //Opacidad de la textura
final float opacity_fill = 20; //Opacidad de la partícula por defecto


// Constants of the problem:

final String TEXTURE_FILE = "texture.png";
final PVector G  = new PVector(0.0, Gc);  // Vector que almacena la gravedad (m/(s·s))
final PVector C  = new PVector(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);  // Vector que almacena la la posición del sistema de partículass
