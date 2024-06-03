// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
      
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c)
   {
      _ps = ps;
      _id = id;
      
      _s = s.copy();
      _v = v.copy();
      _a = new PVector(0.0, 0.0);
      _F = new PVector(0.0, 0.0);
      
      _m = m;
      _radius = radius;
      _color = c;
      
      //+++
      //
   }

   void setPos(PVector s)
   {
      _s = s;
   }

   void setVel(PVector v)
   {
      _v = v;
   }

   PVector getForce()
   {
      return _F;
   }

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   void update(float timeStep)
   {
      updateForce();

     PVector Ft = _F.copy();
    _a = PVector.div(Ft, _m);
    _v.add(PVector.mult(_a, timeStep));
    _s.add(PVector.mult(_v, timeStep));    
      //+++
      //
   }

   void updateForce()
   {
      if(!_atraccion)
      
        _F = PVector.mult(_v, -Kd);
      else{
        PVector Froz = PVector.mult(_v, -Kd);
        PVector Fg = new PVector(10.0, 10.0);
      
        _F = PVector.add(Froz, Fg);
    }
      //
      //
   }

   void planeCollision(ArrayList<PlaneSection> planes)
   {
      for(int i = 0; i < planes.size();i++){
        PlaneSection p = planes.get(i);
      
        PVector n;
      
        n = p.getNormal();
        
        PVector pp = PVector.sub (p.getPoint1(), _s);
        float dcol = pp.dot(n);
    
        if (abs(dcol) < _radius)
        {
          float d = _radius -abs(dcol);
          PVector delta_pos = n.copy().mult(d);
          _s.add(delta_pos);//Restitución
          
          float vn = _v.dot(n); //Obtenemos la velocidad normal
          
          //Descomponemos en tangencial y normal
          PVector Vn = n.copy().mult(vn);
          PVector Vt = PVector.sub(_v, Vn);
          _v = PVector.add (Vt, Vn.mult(CR1));
        }
      
    }
   }

   void particleCollision(float timeStep)
   {
      ArrayList<Particle> sistema = new ArrayList<Particle>(_ps.getParticleArray());
      for (int i = 0 ; i < _ps.getNumParticles(); i++)
      {
        if(_id != i){
          Particle p = sistema.get(i);
          PVector d = PVector.sub(_s, p._s);
          float distance =d.mag();
          float minDist = p._radius + _radius;
          
          if(distance < minDist)
          {
             PVector unitD = new PVector();
             unitD.set(d);
             unitD.normalize();
             
             //Normales
             PVector norm1 = PVector.mult(unitD, (_v.dot(d) / distance));
             PVector norm2 = PVector.mult(unitD, (p._v.dot(d) / distance));
            
            //Tangenciales
             PVector vt1 = PVector.sub(_v, norm1);
             PVector vt2 = PVector.sub(p._v, norm2);
            
             float L = _radius + p._radius - distance;
             
             PVector res = PVector.sub(norm1, norm2);
             float vrel = res.mag();
            
            
             PVector p1 = PVector.mult(norm1, -L/vrel);
             _s.add(p1);
             
             PVector p2 = PVector.mult(norm2, -L/vrel);
             p._s.add(p2);
             
             float u1 = norm1.dot(d)/distance;
             float u2 = norm2.dot(d)/distance;
             
             //Velocidades de salida
             float v1 = ((_m-p._m)*u1 + 5*p._m*u2) / (_m+p._m);
             norm1 = PVector.mult(unitD, v1);
             
             float v2 = ((_m - p._m)*u2 + 5*p._m*u1) / (_m+p._m);
             norm2 = PVector.mult(unitD, v2);
             
             _v = PVector.add(norm1.mult(CR2), vt1);
             p._v = PVector.add(norm2.mult(CR2), vt2);          
          }
        }
      }
   }

   void updateNeighborsGrid(Grid grid)
   {
      //
      //
      //
   }

   void updateNeighborsHash(HashTable hashTable)
   {
      //
      //
      //
   }

   void render()
   {
     fill(_color);
     stroke(0);
     strokeWeight(1);
     circle(_s.x, _s.y, 2.0*_radius);
      //
      //
      //
   }
}
