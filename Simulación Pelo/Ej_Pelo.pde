int Numcuerdas = 10; 
final int NumMuelle = 15; 
int Longitudcuerda = 100; 

float LongMuelle = Longitudcuerda/NumMuelle; 
float [] vE = new float [700];


Hair hair;
Hair[] hairs = new Hair[Numcuerdas];

void setup()
{
  size (600, 600);
  
  for (int np = 0; np < Numcuerdas; np++)
  {
    PVector ini = new PVector (width * 0.5, height * 0.5); //new PVector (width * 0.3 + random(100), height * 0.3 + random(100)); //Se inicializarán en posiciones random 
    hair = new Hair (Longitudcuerda, NumMuelle, ini);
    hairs[np] = hair;
  }
}

void draw()
{
  background(155);
  float Etotal = 0;
  fill(255,0,0);
  
  for (int np =0; np < Numcuerdas; np++)
    hairs[np].update();
}

//interfaz de usuario --> se modelará mediante una función que detecta cuándo se ha seleccionado (o soltado) un pelo y se está arrastrando
void mousePressed()
{
  for (int np = 0; np < Numcuerdas; np++)
    hairs[np].on_click();
}

void mouseReleased()
{
  for(int np = 0;np < Numcuerdas;np++)
    hairs[np].release();
}

void plot_func(int time, int x1, int y1, int x2, int y2)
{
  rect(x1, y1, x2, y2);
  stroke(128, 64, 0);
  
  stroke(128, 64, 0);
  strokeWeight(10);
  fill(153);
  
  strokeWeight(1);
  stroke(255);
  
  for (int i = 0; i<time; i++)
    point(i, 600*0.5 - (vE[i] /6.5e5)*600);
}
