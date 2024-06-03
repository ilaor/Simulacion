// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;

   Grid _grid;
   HashTable _hashTable;
   CollisionDataType _collisionDataType;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;

      _grid = new Grid(SC_GRID);
      _hashTable = new HashTable(SC_HASH, NC_HASH);
      _collisionDataType = CollisionDataType.HASH;
   }

   void addParticle(float mass, PVector initPos, PVector initVel, float radius, color c)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, radius, c));
      _nextId++;
   }
   
   void addParticleClick(PVector pos){
    int newParts = 200; //Número total de partículas (Debe ser múltiplo de 20)
    int columnas = 20; 
    int filas = newParts/columnas;

    //Distribución de las nuevas partículas para que quepan en el recipiente
    for (int i = 0; i < filas; i++){      
      for(int j = 0; j < columnas ; j++){   
        PVector initVel = new PVector(0, 0);//Velocidad
        PVector posaux = new PVector((radius+_dpart)*j+pos.x, (radius+_dpart)*i+pos.y);//Posición
        addParticle( M, posaux, initVel, radius, PARTICLES_COLOR);//añadir
      }
    }
  } 
  
   void restart()
   {
      _particles.clear();
   }

   void setCollisionDataType(CollisionDataType collisionDataType)
   {
      _collisionDataType = collisionDataType;
   }

   int getNumParticles()
   {
      return _particles.size();
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void updateCollisionData()
   {
      switch(_collisionDataType){
      case NONE:
        
      break;
      
      case GRID:
        updateGrid();
        
      break;
        
      case HASH:
        updateHashTable();
      break;
    
    } 
   }

   void updateGrid()
   {
      _grid.restart();
      for(Particle _part: _particles){
        _grid.insertar(_part);
      }
   }

   void updateHashTable()
   {
     _hashTable.restart();
      for(Particle _part: _particles){
        _hashTable.insertar(_part);
      }
   }

   void computePlanesCollisions(ArrayList<PlaneSection> planes)
   {
     int n = _particles.size();
     for (int i = 0; i < n; i++)  //Para cada partícula
      {
        Particle p = _particles.get(i);
        p.planeCollision(planes);
      }
      //
      // 
   }

   void computeParticleCollisions(float timeStep)
   {
     int n = _particles.size();
     for (int i = 0; i < n; i++)  //Para cada partícula
      {
        Particle p = _particles.get(i);
        p.particleCollision(timeStep);
      }
      //+++
      // 
   }

   void update(float timeStep)
   {
      int n = _particles.size();
      for (int i = n - 1; i >= 0; i--)
      {
         Particle p = _particles.get(i);
         p.update(timeStep);
      }
   }

   void render()
   {
      int n = _particles.size();
      //int n = n_bolas;
      for (int i = n - 1; i >= 0; i--) {
        Particle p = _particles.get(i);   
        color c;
        int celda;
        
        //Dependiendo de la estructura utilizada, los colores de las partículas serán diferentes
        switch(_collisionDataType){
          case NONE:
          c = color(0, 136, 255, 155);
          break;
          
          case GRID:
          celda = _grid.getCelda(p._s);
          //c = _grid._colors[celda];
          break;
          
          case HASH:
          celda = _hashTable.getCelda(p._s);
          c = _hashTable._colors[celda];
          break;
      }
         p.render();
      }
   }
}
