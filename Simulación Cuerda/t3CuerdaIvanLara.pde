int Numcuerdas = 1;
final int NumMuelle = 15;
int Longitudcuerda = 100;

float LongMuelle = Longitudcuerda/NumMuelle;
float [] vE = new float [700];

Hair hair;
Hair[] hairs = new Hair[Numcuerdas];

void setup() {
  size(600, 600);
  
  for (int np = 0; np < Numcuerdas; np++) {
    PVector ini = new PVector (width * 0.5, height * 0.5);
    hair = new Hair(Longitudcuerda, NumMuelle, ini);
    hairs[np] = hair;
  }
}

void draw() {
  background(155);
  float Etotal = 0;
  fill(255,0,0);
  
  for (int np = 0; np < Numcuerdas; np++)
    hairs[np].update();
  
  fill(128, 64, 0); // Marrón
  textAlign(LEFT, TOP);
  textSize(20);
  text("Simulación cuerda", 20, 20);

  textSize(14);
  text("Pulsa 'r' para reiniciar la simulación", 20, 50);
}

void mousePressed() {
  for (int np = 0; np < Numcuerdas; np++)
    hairs[np].on_click();
}

void mouseReleased() {
  for(int np = 0; np < Numcuerdas; np++)
    hairs[np].release();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    restartSimulation();
  }
}

void restartSimulation() {
  for (int np = 0; np < Numcuerdas; np++) {
    PVector ini = new PVector(width * 0.5, height * 0.5);
    hairs[np] = new Hair(Longitudcuerda, NumMuelle, ini);
  }
}

void plot_func(int time, int x1, int y1, int x2, int y2) {
  rect(x1, y1, x2, y2);
  stroke(128, 64, 0);
  
  stroke(128, 64, 0);
  strokeWeight(10);
  fill(153);
  
  strokeWeight(1);
  stroke(255);
  
  for (int i = 0; i < time; i++)
    point(i, 600 * 0.5 - (vE[i] / 6.5e5) * 600);
}
