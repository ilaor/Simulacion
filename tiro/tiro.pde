
final float M  = 50.0;  
final float Gc = 9.8;  
final PVector G  = new PVector(0.0, -Gc);   
float K  = 0.2;    
final PVector S0 = new PVector(10.0, 10.0);  

PVector _v  = new PVector();   
PVector _a  = new PVector();   
PVector _s  = new PVector();  

PVector v_a = new PVector();

PVector _v0 = new PVector();

PVector s_a = new PVector();   


float SIM_STEP = .02;   
float _simTime;



PVector calculateAcceleration(PVector s, PVector v)
{
  PVector Froz  = PVector.mult(v,-K);
  PVector Fpeso = PVector.mult(G,M);
  PVector SumF  = new PVector(Froz.x, Froz.y);
  SumF.add(Fpeso);
  
  PVector a = SumF.div(M);

  return a;
}

void settings()
{
    size(800, 800);
}

void setup()
{
  frameRate(60);
  _v0.set(38.0, 80);
  _s = S0.copy();
  _a.set(0.0, 0.0);
  _v.set(_v0.x, _v0.y);
  
  _simTime = 0;
}

void draw()
{
  background(155);
 
  drawScene();
  updateSimulation();
  
  if (_s.y < 0){
    println(_s);
    exit();
  }
}

void drawScene()
{
  int radio = 20;
  
  translate(0,height);
  strokeWeight(3);
  noFill();
  circle(_s.x, -_s.y, radio);
  
  // Aproximacion mediante integrador numerico
  strokeWeight(1);
  fill(170,170,170);
  circle(s_a.x, -s_a.y, radio); 
}

void updateSimulation()
{
  updateSimulationExplicitEuler();

  
  _simTime += SIM_STEP;
  s_a.y = S0.y + (M/K)*((M*Gc/K) + _v0.y)*(1-exp((-K/M)*_simTime)) - (M*Gc*_simTime)/K;
  s_a.x = S0.x + (M*_v0.x/K)*(1-exp((-K/M)*_simTime));
  
}

void updateSimulationExplicitEuler()
{

  PVector acel =  calculateAcceleration(_s, _v);
  
  _s.add(PVector.mult(_v, SIM_STEP));
  _v.add(PVector.mult(acel, SIM_STEP)); 
  
}




void keyPressed()
{
  if (key == 'r' || key == 'R')
  {
    setup();
  }
 
}
