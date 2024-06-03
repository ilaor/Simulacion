float dt = 0.1;
PVector a, b, c, _p, _v, v2, ace, vel2ace;
boolean seg1 = true, seg2 = false;
float speedIncrease = 5; // Ajusta este valor para cambiar el incremento de velocidad

void setup() {
  size (800, 800);
  
  a = new PVector(width/2 - 0.2*width, height/2);
  b = new PVector(width/2 + 0.2*width, height/2 - 0.2*height);
  c = new PVector(width/2 + 0.4*width, height/2);
  _p = new PVector(width/2 - 0.2*width, height/2);
  
  _v = PVector.sub(b,a);
  _v.normalize();
  _v.mult(15);
  
  ace = PVector.sub(a,b);
  ace.normalize();
  ace.mult(15);

  v2 = PVector.sub(a,b);
  v2.normalize();
  v2.mult(15);            
}

void draw() {
  float d1 = PVector.dist(_p, b);
  float d2 = PVector.dist(_p, c);
  
  background(150);

  strokeWeight(5);
  stroke(150,150,150);
  fill(255);
  ellipse(a.x, a.y, 15 , 15);
  ellipse(c.x, c.y, 15 , 15);

  fill(0,255,255);
  ellipse(_p.x, _p.y, 40 , 40);

  fill(255);
  ellipse(b.x, b.y, 15 , 15);
  
  stroke(10);
  line(a.x,a.y,b.x,b.y);
  line(b.x,b.y,c.x,c.y);

  if (seg1){
    _p.add(PVector.mult(_v,dt));
    if (d1<15){
      seg1 = false;
      seg2 = true;
      _v = PVector.sub(c,b);
      _v.normalize();
      _v.mult(50 + speedIncrease); }
  }
  else if(seg2){
    _p.add(PVector.mult(_v,dt));
    if (d2<15){
      seg2 = false;
      seg1 = true;
      _p = new PVector(width/2 - 0.2*width, height/2);
      _v = PVector.sub(b,a);
      _v.normalize();
      _v.mult(15);
    }
  }
}
