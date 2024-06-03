float dt = 0.5;
PVector center;
float radius;
float angle = 0; 
float speed = TWO_PI / 60; 

void setup(){
  size(800, 800);
  radius = 100;
  center = new PVector(width/2, height/2);
}

void draw(){
  background(150);
  
  float x = center.x + radius * cos(angle);
  float y = center.y + radius * sin(angle);


  angle += speed;
  
  fill(160, 160, 170);
  ellipse(x, y, 50, 50);

  fill(170);
  ellipse(center.x, center.y, 10,10);
}
