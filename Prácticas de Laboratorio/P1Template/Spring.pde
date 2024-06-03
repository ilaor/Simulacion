// Class for a simple spring with no damping
public class Spring
{
   PVector _pos1;   // First end of the spring (m)
   PVector _pos2;   // Second end of the spring (m)
   float _Ke;       // Elastic constant (N/m)
   float _l0;       // Rest length (m)

   float _energy;   // Energy (J)
   PVector _F;      // Force applied by the spring towards pos1 (the force towards pos2 is -_F) (N)s

   Spring(PVector pos1, PVector pos2, float Ke, float l0)
   {
      _pos1 = pos1;
      _pos2 = pos2;
      _Ke = Ke;
      _l0 = l0;

      _energy = 0.0;
      _F = new PVector(0.0, 0.0);
      setKe(Ke);
      setRestLength(l0);
   }

   void setPos1(PVector pos1)
   {
      _pos1 = pos1;
   }

   void setPos2(PVector pos2)
   {
      _pos2 = pos2;
   }

   void setKe(float Ke)
   {
      _Ke = Ke;
   }

   void setRestLength(float l0)
   {
      _l0 = l0;
   }

   void update()
   {
      /* Este método debe actualizar todas las variables de la clase 
         que cambien según avanza la simulación, siguiendo las ecuaciones 
         de un muelle sin amortiguamiento.
       */     
        
     // Inicializa las componentes x e y de la fuerza total (_F) como cero.
     _F.x = 0;
     _F.y = 0;
     
     // Calcula la elongación del muelle restando la longitud de equilibrio (l0) a la distancia entre la posición actual (_pos2) y el punto de referencia C.
     Float elongacion = PVector.dist(_pos2, C) - l0; 
     
     // Calcula la dirección normalizada del vector que apunta desde C hasta _pos2.     
     PVector direccion = PVector.sub(_pos2, C).normalize(); 
     
     // Calcula la magnitud de la fuerza elástica (Fe) utilizando la ley de Hooke.
     float magnitud = -ke * elongacion;
     PVector Fe = direccion.mult(magnitud);
     
     // Agrega la fuerza elástica al vector total de fuerzas (_F).
     _F.add(Fe);
           
     // Calcular la distancia de estiramiento (x)
     float x = _s.copy().sub(C).mag() - l0;
  
     // Calcular la energía de estiramiento
     _energy = 0.5 * ke * (x * x);
       
      updateEnergy();
   }

   void updateEnergy()
   {
      calculateEnergy();
   }

   float getEnergy()
   {
      return _energy;
   }

   PVector getForce()
   {
      return _F;
   }
}
