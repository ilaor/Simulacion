// Damped spring between two particles:
//
// Fp1 = Fe - Fd
// Fp2 = -Fe + Fd = -(Fe - Fd) = -Fp1
//
//    Fe = Ke·(l - l0)·eN
//    Fd = -Kd·eN·v
//
//    e = s2 - s1  : current elongation vector between the particles
//    l = |e|      : current length
//    eN = e/l     : current normalized elongation vector
//    v = dl/dt    : rate of change of length

public class DampedSpring
{
   Particle _p1;     // First particle attached to the spring
   Particle _p2;     // Second particle attached to the spring

   float _Ke;        // Elastic constant (N/m)
   float _Kd;        // Damping coefficient (kg/m)
    
   float _l0;        // Rest length (m)
   float _l;         // Current length (m)
   float _v;         // Current rate of change of length (m/s)

   PVector _e;       // Current elongation vector (m)
   PVector _eN;      // Current normalized elongation vector (no units)
   PVector _F;       // Force applied by the spring on particle 1 (the force on particle 2 is -_F) (N)
   float _maxForce;
   boolean _enabled; // To enable/disable the spring
   boolean _repulsion;
   //...
   //...
   //...


   DampedSpring(Particle p1, Particle p2, float ke,float kd, boolean activar, float maxForce)
   {
    _p1 = p1;
    _p2 = p2;

    _Ke = ke;
    _Kd = kd;
    
    _maxForce = maxForce;
    _repulsion = activar;
    
     _e = PVector.sub(_p2.getPosition(), _p1.getPosition());
    _eN = _e.copy();
    _eN.normalize();

    _l = _e.mag();
    _l0 = _l; 
    
    _v = 0.0;
    _enabled = true;
    _F = new PVector(0.0, 0.0, 0.0);
   }

   Particle getParticle1()
   {
      return _p1;
   }

   Particle getParticle2()
   {  
      return _p2;
   }

   void update(float simStep)
   {
      _F.set(0,0,0);
     PVector Fdamp = new PVector();
     PVector Fel = new PVector();
     float lini = _l;
     
     _e = PVector.sub(_p2.getPosition(), _p1.getPosition());
     _eN = _e.copy();
     _eN.normalize();
     _l = _e.mag();
     
      
      if(_repulsion)
      {
        Fel = PVector.mult(_eN,(_ball.getRadius() - _l)* -_Ke);
      }
      else
       Fel = PVector.mult(_eN,(_l0 - _l)* -_Ke);
      
      _v = (lini - _l)/simStep;
      
      Fdamp = PVector.mult(_eN, _Kd * _v);
      _F = PVector.sub(Fel,Fdamp);
      
      if(isEnabled())
      {
        if(_F.mag() >= _maxForce )
        {
          _enabled = false;
          _F.set(0.0,0.0,0.0);
        }
      }
   }

   void applyForces()
   {
      _p1.addExternalForce(_F);
      _p2.addExternalForce(PVector.mult(_F, -1.0));
   }

   boolean isEnabled()
   {
      return _enabled;
   }
}
