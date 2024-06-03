import peasy.*;
PeasyCam cam;

Malla malla1, malla2, malla3;

final int STRUCTURED = 1;
final int BEND = 2;
final int SHEAR = 3;

int px;
int py;

float dt = 0.1;
PVector g = new PVector (0,0,0); //gravedad
PVector viento = new PVector (0,0,0); //viento
boolean VientoSi = false;
boolean GravedadSi = false;


void setup()
{
  smooth();
 
  System.setProperty("jogl.disable.openglcore", "true");
  size (1000, 900, P3D);
 
  cam = new PeasyCam(this, 400, 0, 0, 700);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(1000);
  
  px = 50;
  py = 30;
  
  malla1 = new Malla (STRUCTURED, px, py);
  malla2 = new Malla (BEND, px, py);
  malla3 = new Malla (SHEAR, px, py);
  
}

void draw()
{
  background(155, 155, 155);
  translate(100, 0, 0);
  
  //Draw datos
  fill (247,235,235);
  
  text("T3: SIMULACIÓN DE BANDERAS", 200, -200, 0);
  text("Tecla 'i' para iniciar la simulación", 200, -170, 0);

  //viento
  if (VientoSi)
  {
    viento.x = 0.5 - random(10, 40) * 0.1;
    viento.y = 0.1 - random(0, 0.2);
    viento.z = 0.5 + random(10, 60) * 0.1;

  }
  else
  {
    viento.x = 0; 
    viento.y = 0;
    viento.z = 0;
  }
  
  //GRAVEDAD
  if (GravedadSi)
  {
    text("Simulación activa", 200, -140, 0);
    g.y = 5; 
  }
  else
  {
    text("Simulación Incactiva", 200, -140, 0 );
    g.y = 0;
  }
  
  //STRUCTURED
  malla1.update(); 
  color c = color(255,0,0);
  malla1.display(c);
  fill(247,235,235);  
  text("STRUCTURED", 0, -50, 0); 
  line(0, 0, 0, 150);
  
  // BEND
  malla2.update();  
  pushMatrix(); 
  translate(255,0,0);  
  color c2 = color(0,255,0);
  malla2.display(c2);
  fill(247,235,235);  
  text("BEND", 0, -50, 0);  
  line(0, 0, 0, 150);
  popMatrix();
  
  
  // SHEAR
  malla3.update();
  pushMatrix();
  translate(500,0,0);
  color c3 = color(0,0,255);
  malla3.display(c3);
  fill(247,235,235);
  text("SHEAR", 0, -50, 0);
  line(0, 0, 0, 150);
  popMatrix();
  
}

void keyPressed()
{
  if (key == 'i')
  {
    if (VientoSi == false)
    {
      GravedadSi = true;
      VientoSi = true;
    }
    else if (VientoSi == true)
    {
      VientoSi = false;
      GravedadSi = false;
    }
  }
}
