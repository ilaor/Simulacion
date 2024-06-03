import java.util.TreeMap;

public class DeformableObject
{
   int _numNodesH;   // Number of nodes in horizontal direction
   int _numNodesV;   // Number of nodes in vertical direction

   float _sepH;      // Separation of the object's nodes in the X direction (m)
   float _sepV;      // Separation of the object's nodes in the Y direction (m)

   SpringLayout _springLayout;   // Physical layout of the springs that define the surface of each layer
   color _color;                 // Color (RGB)

   Particle[][] _nodes,_nodes1;                             // Particles defining the object
   ArrayList<DampedSpring> _springs;                // Springs joining the particles
   boolean _isUnbreakable;

   TreeMap<String, DampedSpring> _springsCollision;

   DeformableObject(int numNodesH, int numNodesV, float sepH, float sepV, float Ke, float Kd, float mass, boolean nG, float maxForce, SpringLayout springLayout, color c, int lado)
   {
     _numNodesH = numNodesH;
     _numNodesV = numNodesV;
     
     _sepH = sepH;
     _sepV = sepV;
     
    
     _springLayout = springLayout;

     
     _color = c;
     
     _nodes = new Particle[_numNodesH][_numNodesV];
     _nodes1 = new Particle[_numNodesH][_numNodesV];
     _springs = new ArrayList();
     
     createNodos(mass,lado, nG);
     createSurfaceSprings(Ke,Kd,lado,maxForce);
     
     _springsCollision = new TreeMap<String, DampedSpring>();
   }

   int getNumNodes()
   {
      return _numNodesH*_numNodesV;
   }

   int getNumSprings()
   {
      return _springs.size();
   }
   
  void createNodos(float m, int lado, boolean ng) {
    PVector _v = new PVector(0.0, 0.0, 0.0); // Velocidad inicial
    PVector _s = new PVector(0.0, 0.0, 0.0);
    boolean clamp;

    for (int i = 0; i < _numNodesH; i++) {
      for (int j = 0; j < _numNodesV; j++) {
        // Determina si el nodo está en el borde de la malla
        if (i == 0 || j == 0 || i == _numNodesH - 1 || j == _numNodesV - 1) {
          clamp = true;
        } else {
          clamp = false;
        }

        // Calcula las coordenadas del nodo según el lado

        if (lado == 1) {
          _s = new PVector(i * _sepH-((D_H)*(N_H-20)-20), -400, j * _sepV);  //derecha
          _nodes[i][j] = new Particle(_s, _v, m, ng, clamp);  
      } else if (lado == 2) {
          _s = new PVector(i * _sepH-((D_H)*(N_H-20)-20), ((D_H)*(N_H)-420), j * _sepV);  //izq
          _nodes[i][j] = new Particle(_s, _v, m, ng, clamp);  
      } else if (lado == 3) {
          _s = new PVector(-((D_H)*(N_H-20)-20), (i * _sepH)-400, j * _sepV);  //fondo
          _nodes[i][j] = new Particle(_s, _v, m, ng, clamp);
        } else if (lado == 4) {
          _s = new PVector(i * _sepH -((D_H)*(N_H-20)-20), (j * _sepH)-400, +((D_H)*(N_H-20)-20));  //larguero
          _nodes[i][j] = new Particle(_s, _v, m, ng, clamp);
      }

      }
    }
  }

  
  void createSurfaceSprings(float Ke, float Kd, int lado, float maxForce)
  {

     switch(_springLayout)
     {
       case STRUCTURAL:
         for(int i = 0; i < _numNodesH - 1; i++)
         {
           for(int j = 0; j < _numNodesV - 1; j++)
           {
             if(i < _numNodesH-1)
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd, false, maxForce));
             
             if(j < _numNodesV-1)
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd, false, maxForce));
           }
         }
       break;
       case SHEAR:
       
         for(int i = 0; i < _numNodesH-1; i++)
         {
           for(int j = 0; j < _numNodesV-1; j++)
           {
             _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce));
             _springs.add(new DampedSpring(_nodes[i][j+1], _nodes[i+1][j], Ke, Kd, false, maxForce));
           }
         }
       break;
       case BEND:
         for(int i = 0; i < _numNodesH-1; i++)
         {
           for(int j = 0; j < _numNodesV-1; j++)
           {
             //BEND
             if(i < _numNodesH-2)
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+2][j], Ke, Kd, false, maxForce));
                 
             if(j < _numNodesV-2)
                _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+2], Ke, Kd, false, maxForce));
           }
         }
         break;
         case STRUCTURAL_AND_SHEAR:
           for (int i = 0; i < _numNodesH-1; i++)
           {
             for(int j = 0; j < _numNodesV-1; j++) 
             {
               //STRUCTURAL
               if(i < _numNodesH-1)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd, false, maxForce));
             
               if(j < _numNodesV-1)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd, false, maxForce));
               
               //SHEAR
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce));
               _springs.add(new DampedSpring(_nodes[i][j+1], _nodes[i+1][j], Ke, Kd, false, maxForce));
               
             }
           }
         break;
         case STRUCTURAL_AND_BEND:
           for(int i = 0; i < _numNodesH-1; i++)
           {
             for(int j = 0; j < _numNodesV-1; j++)
             {
               //STRUCTURAL
               if(i < _numNodesH-1)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd, false, maxForce));
             
               if(j < _numNodesV-1)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd, false, maxForce));
                 
               //BEND
               if(i < _numNodesH-2)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+2][j], Ke, Kd, false, maxForce));
                   
               if(j < _numNodesV-2)
                  _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+2], Ke, Kd, false, maxForce));
                
             }
           }
         break;
         case SHEAR_AND_BEND:
           for(int i = 0; i < _numNodesH-1; i++)
           {
             for(int j = 0; j < _numNodesV-1; j++)
             {
               //SHEAR
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce));
               _springs.add(new DampedSpring(_nodes[i][j+1], _nodes[i+1][j], Ke, Kd, false, maxForce));
               
               //BEND
               if(i < _numNodesH-2)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+2][j], Ke, Kd, false, maxForce));
                   
               if(j < _numNodesV-2)
                  _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+2], Ke, Kd, false, maxForce));
               
             }
           }
         case STRUCTURAL_AND_SHEAR_AND_BEND:
           for(int i = 0; i < _numNodesH-1; i++)
           {
             for(int j = 0; j < _numNodesV-1; j++)
             {
               //STRUCTURAL
               if(i < _numNodesH-1)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd, false, maxForce));
             
               if(j < _numNodesV-1)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd, false, maxForce));
               
               //SHEAR
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce));
               _springs.add(new DampedSpring(_nodes[i][j+1], _nodes[i+1][j], Ke, Kd, false, maxForce));
               
               //BEND
               if(i < _numNodesH-2)
                 _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+2][j], Ke, Kd, false, maxForce));
                   
               if(j < _numNodesV-2)
                  _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+2], Ke, Kd, false, maxForce));
             }
           }
     }   
     
  }

   void update(float simStep)
   {
      int i, j;

    for (i = 0; i < _numNodesH; i++)
      for (j = 0; j < _numNodesV; j++)
        if (_nodes[i][j] != null)
          _nodes[i][j].update(simStep);

    for (DampedSpring s : _springs) 
    {
      s.update(simStep);
      s.applyForces();
    }
    
    for (DampedSpring s : _springsCollision.values()) 
    {
      s.update(simStep);
      s.applyForces();
    }
   }
   void avoidCollision(Ball b, float Ke, float Kd, float maxForce)
  {
    /* Este método debe evitar la colisión entre la esfera y la malla deformable. Para ello
       se deben crear muelles de colisión cuando se detecte una colisión. Estos muelles
       se almacenarán en el diccionario '_springsCollision'. Para evitar que se creen muelles 
       duplicados, el diccionario permite comprobar si un muelle ya existe previamente y 
       así usarlo en lugar de crear uno nuevo.
     */
     
     DampedSpring muelle;
     Particle part;
     PVector distancia = new PVector();
     
     for(int i = 0; i < _numNodesH -1; i++)
     {
       
       for(int j = 0; j < _numNodesV -1; j++)
       {
         
         part = _nodes[i][j];
         distancia = PVector.sub(part.getPosition(),b.getPosition());
         
         if(distancia.mag() <= b.getRadius())
         {
           
           muelle = new DampedSpring(b, part, Ke, Kd,true, maxForce);
           
           String id = Integer.toString(part.getId());
           
           if(!_springsCollision.containsKey(id))
             _springsCollision.put(id, muelle);
             
         }
         
         else
         {
           
           String id = Integer.toString(part.getId());
           if(_springsCollision.containsKey(id))
           
             _springsCollision.remove(id);
             
         }
         
       }
       
     }
     
  }
   

   void render()
   {
      if (DRAW_MODE)
         renderWithSegments();
      else
         renderWithQuads();
   }

   void renderWithQuads()
   {
     int i, j;
     
     fill(255);
     stroke(_color);

     for (j = 0; j < _numNodesV - 1; j++)
     {
       beginShape(QUAD_STRIP);
       for (i = 0; i < _numNodesH; i++)
       {
         if ((_nodes[i][j] != null) && (_nodes[i][j+1] != null))
         {
           PVector pos1 = _nodes[i][j].getPosition();
           PVector pos2 = _nodes[i][j+1].getPosition();

           vertex(pos1.x, pos1.y, pos1.z);
           vertex(pos2.x, pos2.y, pos2.z);
         }
       }
       endShape();
     }
  }

  void renderWithSegments()
  {
    stroke(_color);

    for (DampedSpring s : _springs) 
    {
      if (s.isEnabled())
      {
        PVector pos1 = s.getParticle1().getPosition();
        PVector pos2 = s.getParticle2().getPosition();

        line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
      }
    }
  }
}
