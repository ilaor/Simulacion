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
   
   ArrayList Neighbors;
      
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c)
   {
      Neighbors = new ArrayList<Particle>();
     
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
      PVector Froz = PVector.mult(_v, -Kd);
      PVector Fg = PVector.mult(Gc, _m);
      
      _F = PVector.add(Froz, Fg);
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
    ArrayList<Particle> sistema = new ArrayList<Particle>();

    int totalPart = 0;
    
    //Según la estructura de datos utilizada, el total de colisiones que se comprobarán será diferente
    switch(_ps._collisionDataType){
      case NONE:
        totalPart = _ps.getNumParticles();
        sistema = _ps.getParticleArray();
      break;
      
      case GRID:
        updateNeighborsGrid(_ps._grid);
        totalPart = Neighbors.size();
        sistema = Neighbors;
      break;
        
      case HASH:
        updateNeighborsHash(_ps._hashTable);
        totalPart = Neighbors.size();
        sistema = Neighbors;
      break;
    
    }
    
    
    for (int i = 0 ; i < totalPart; i++)
    {
      if(_id != i){
        Particle p = sistema.get(i);

        PVector vcol = PVector.sub(p._s, _s);
        float distance = vcol.mag();

         
       
        if(distance < minDist)
        {
          
          float angle = atan2(vcol.y, vcol.x);

        
          float targetX = this._s.x + cos(angle) * minDist;
          float targetY = this._s.y + sin(angle) * minDist;
          
          float Fmuellex = (targetX - p._s.x) * 0.99 + Ke*_v.x; //Distancia * constante elástica = fuerza del muelle
          float Fmuelley = (targetY - p._s.y) * 0.99 + Ke*_v.y;
         
          //Nuevas velocidades de salida para ambas partículas: en estas actuará una fuerza del muelle determinada por sus posiciones
          this._v.x -= Fmuellex;
          this._v.y -= Fmuelley;
          p._v.x += Fmuellex;
          p._v.y += Fmuelley;
          
          p._v.mult(0.99);
         _v.mult(0.99);

        }
      }
    }
   }

   void updateNeighborsGrid(Grid grid)
   {
      PVector a, b, c, d;
    int celdaA, celdaB, celdaC, celdaD;
    Neighbors.clear();
    
    //Cálculo de los vecinos de partícula this
    a = new PVector(_s.x - _radius, _s.y);
    b = new PVector(_s.x + _radius, _s.y);
    c = new PVector(_s.x, _s.y + _radius);
    d = new PVector(_s.x, _s.y - _radius);
    
    //Obtención de celda de cada vecino
    celdaA = grid.getCelda(a);
    celdaB = grid.getCelda(b);
    celdaC = grid.getCelda(c);
    celdaD = grid.getCelda(d);
    
    if(celdaA >= 0 && celdaB >= 0 && celdaC >= 0 && celdaD >= 0) //Comprobación para no exceder el rango del vector
    {
       for(int i = 0; i < grid._cells.get(celdaA).size(); i++){
        Particle p = grid._cells.get(celdaA).get(i);
        Neighbors.add(p);
      }
      if(celdaB != celdaA){
        for(int i = 0; i < grid._cells.get(celdaB).size(); i++){
          Particle p = grid._cells.get(celdaB).get(i);
          Neighbors.add(p);
        }
      }
      if(celdaC != celdaA && celdaC != celdaB){
        for(int i = 0; i < grid._cells.get(celdaC).size(); i++){
          Particle p = grid._cells.get(celdaC).get(i);
          Neighbors.add(p);
        }
      }
      if(celdaD != celdaA && celdaD != celdaB && celdaD != celdaC){
        for(int i = 0; i < grid._cells.get(celdaD).size(); i++){
          Particle p = grid._cells.get(celdaD).get(i);
          Neighbors.add(p);
        }
      }
    }
   }

   void updateNeighborsHash(HashTable hashTable)
   {
      PVector a, b, c, d;
      int celdaA, celdaB, celdaC, celdaD;
      Neighbors.clear();
      
      //Cálculo de los vecinos de la partícula
      a = new PVector(_s.x - _radius, _s.y);
      b = new PVector(_s.x + _radius, _s.y);
      c = new PVector(_s.x, _s.y + _radius);
      d = new PVector(_s.x, _s.y - _radius);
      
      //Obtención de celda de cada vecino
      celdaA = hashTable.getCelda(a);
      celdaB = hashTable.getCelda(b);
      celdaC = hashTable.getCelda(c);
      celdaD = hashTable.getCelda(d);
      
      if(celdaA >= 0 && celdaB >= 0 && celdaC >= 0 && celdaD >= 0) //Comprobación para no exceder el rango del vector
      {
        for(int i = 0; i < hashTable._table.get(celdaA).size(); i++){
          Particle p = hashTable._table.get(celdaA).get(i);
          Neighbors.add(p);
        }
        if(celdaB != celdaA){
          for(int i = 0; i < hashTable._table.get(celdaB).size(); i++){
            Particle p = hashTable._table.get(celdaB).get(i);
            Neighbors.add(p);
          }
        }
        if(celdaC != celdaA && celdaC != celdaB){
          for(int i = 0; i < hashTable._table.get(celdaC).size(); i++){
            Particle p =hashTable._table.get(celdaC).get(i);
            Neighbors.add(p);
          }
        }
        if(celdaD != celdaA && celdaD != celdaB && celdaD != celdaC){
          for(int i = 0; i < hashTable._table.get(celdaD).size(); i++){
            Particle p = hashTable._table.get(celdaD).get(i);
            Neighbors.add(p);
          }
        }
      }  
      //
   }

   void render()
   {
     fill(_color);
     stroke(0);
     strokeWeight(1);
     circle(_s.x, _s.y, 2.0*_radius);
   }
}
