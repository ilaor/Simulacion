// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle (-)

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)
   float _energy;       // Energy (J)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   float _lifeSpan;     // Total time the particle should live (s)
   float _timeToLive;   // Remaining time before the particle dies (s)
   
   float randomx = randomGaussian()*Krx;  //Saca número aleatorio para la dispersión del humo en x
   float randomy = randomGaussian()*Kry;  //Saca número aleatorio para la dispersión del humo en y
   PVector randomv = new PVector ( randomx, randomy);  //Vector con números aleatorios para la dispersión del humo

   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c, float lifeSpan)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;

      _a = new PVector(0.0, 0.0);
      _F = new PVector(0.0, 0.0);
      _energy = 0.0;

      _radius = radius;
      _color = c;
      _lifeSpan = lifeSpan;
      _timeToLive = _lifeSpan;
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

   float getEnergy()
   {
      return _energy;
   }

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   float getTimeToLive()
   {
      return _timeToLive;
   }

   boolean isDead()
   {
      return (_timeToLive <= 0.0);
   }

   void update(float timeStep)
   {
      

      updateSimplecticEuler(timeStep);
      
      _timeToLive -= timeStep;
      
      updateEnergy();
   }

   void updateSimplecticEuler(float timeStep)
   {
      updateForce();
      
      //Calculo de aceleración
     _a = _F.div(m);
    
    // Actualiza la velocidad utilizando el método de Euler simplectico:
    // v = v + a * t
    _v.add(PVector.mult(_a, timeStep)); 
    
    // Actualiza la posición utilizando el método de Euler simplectico:
    // s = s + v * t
    _s.add(PVector.mult(_v, timeStep));
    
    //Interferimos en el bucle de la simulación modificando la posicion de las partículas cuando se elevan 
    //para crear cierto realismo y efecto de viento sobre el humo
    _s.add(PVector.mult(randomv,timeStep));
   }

   void updateForce() {
      // Fuerza peso (gravitatoria)
      PVector Fpeso = PVector.mult(G, _m);
  
      // Fuerza de fricción con el aire
      // Suponemos que la magnitud de la fuerza de fricción es proporcional al cuadrado de la velocidad
      float velocidadCuadrado = _v.magSq();
      PVector Froz = _v.copy(); // Crear una copia de _v para no modificar su valor original
      Froz.mult(-kd * velocidadCuadrado); // Multiplicar por el factor de fricción
      
      _F = PVector.add(Fpeso, Froz); // Sumamos las fuerzas de peso y fricción
      
      //Fuerza del viento respecto a la posición del mouse
      float dx = map(mouseX, 0, width, -0.3, 0.3);
      PVector wind = new PVector(dx, 0);

      // Fuerza total
      _F.add(wind);
  }


   void updateEnergy()
   {
      // Calcular la energía cinética
      float Ec = 0.5 * m * _v.magSq();
       
       // Calcular la altura desde el punto C hasta la posición actual del objeto
      float h = _s.copy().y - C.y;  
       
       // Calcular la energía potencial gravitatoria
      float Eg = m * Gc * h;
      
     // Calcular la energía total sumando todas las energías
      _energy = Eg + Ec;
   }

   void render(boolean useTexture)
{
    if (useTexture)
    {
        imageMode(CENTER);
        tint(255, _timeToLive*opacity_tex);
        image(_ps._tex, _s.x + randomx, _s.y + randomy);
    } 
    else
    {
      
        fill(255,_timeToLive*opacity_fill);
        noStroke();
        ellipse(_s.x,_s.y + randomy,diametro,diametro);
    }
}
}
