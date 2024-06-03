class Malla
{
  int tipo; 
  PVector p[][]; 
  PVector f[][]; 
  
  PVector a[][]; 
  PVector v[][]; 
  
  float k; 
  float m_Damping; 
  
  int sizeX, sizeY; 
  
  float dDirecta; 
  float dOblicua; 
  
  Malla (int t, int x, int y)
  {
    tipo = t;
    sizeX = x;
    sizeY = y;
    
    p = new PVector[sizeX][sizeY]; 
    f = new PVector[sizeX][sizeY]; 
    a = new PVector[sizeX][sizeY];
    v = new PVector[sizeX][sizeY];
    
    dDirecta = 4;
    dOblicua = sqrt(2* (dDirecta*dDirecta));
    
    switch (tipo)
    {
      case 1: 
        k = 400;
        m_Damping = 2;
      break;
      
      case 2: 
        k = 150;
        m_Damping = 2;
      break;
      
      case 3: 
        k = 300;
        m_Damping = 2;
      break;
    }
    
    for (int i = 0; i < sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        p[i][j] = new PVector (i*dDirecta, j*dDirecta,0);
        a[i][j] = new PVector (0,0,0);
        v[i][j] = new PVector (0,0,0);
        f[i][j] = new PVector (0,0,0);
      }
    }
  }

  void display(color c)
  {
    fill(c);
    for(int i = 0; i < sizeX-1; i++){
      beginShape(QUAD_STRIP);
      for(int j = 0; j < sizeY; j++){
        PVector p1 = p[i][j];
        PVector p2 = p[i+1][j];
        vertex(p1.x, p1.y, p1.z);
        vertex(p2.x, p2.y, p2.z);
      }
      endShape();
    }
    
  }
  
  void update()
  {
    actualizaFuerzas();
    for (int i = 0; i < sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        a[i][j].add(f[i][j].x*dt, f[i][j].y*dt, f[i][j].z*dt);
        v[i][j].add(a[i][j].x*dt, a[i][j].y*dt, a[i][j].z*dt);
        p[i][j].add(v[i][j].x*dt, v[i][j].y*dt, v[i][j].z*dt);
        
        if((i==0 &&  j==0) || (i==0 && j== sizeY-1))
        {
          f[i][j].set(0,0,0);
          v[i][j].set(0,0,0);
          p[i][j].set(i*dDirecta, j*dDirecta, 0);
        }
        a[i][j].mult(0);
      }
    }
  }

  void actualizaFuerzas()
  {
    PVector v_Damping = new PVector (0,0,0);
    
    for (int i = 0; i<sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        f[i][j].set(0,0,0);
        PVector vertexPos = p[i][j];
        
        f[i][j].set(g.x,g.y,g.z);
        
        PVector fviento = getfviento(vertexPos, i, j);
        f[i][j] = PVector.add(f[i][j], fviento);
        
        switch(tipo)
        {
           case SHEAR:
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i-1, j, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i+1, j, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i, j-1, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i, j+1, dDirecta, k));
            
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i-1, j-1, dOblicua, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i-1, j+1, dOblicua, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i+1, j-1, dOblicua, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i+1, j+1, dOblicua, k));
          
          break;
          case STRUCTURED:
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i-1, j, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i+1, j, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i, j-1, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i, j+1, dDirecta, k));
          
          break;
          
          case BEND:
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i-1, j, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i+1, j, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i, j-1, dDirecta, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i, j+1, dDirecta, k));
            
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i-2, j, dDirecta*2, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i+2, j, dDirecta*2, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i, j-2, dDirecta*2, k));
            f[i][j] = PVector.add(f[i][j], getfuerza(vertexPos, i, j+2, dDirecta*2, k));
          
          break;
        }
        
        v_Damping.set(v[i][j].x, v[i][j].y, v[i][j].z);
        v_Damping.mult(-m_Damping);
        
        f[i][j] = PVector.add(f[i][j], v_Damping); 
      }
      
    }
  }
  
  PVector getfviento(PVector v, int i, int j)
  {
    PVector fuerza = new PVector(0,0,0);
    PVector n1 = new PVector(0,0,0);
    PVector n2 = new PVector(0,0,0);
    PVector n3 = new PVector(0,0,0);
    PVector normal4 = new PVector(0,0,0);
    PVector normal = new PVector(0,0,0);
    float proyeccion;
    
    n1 = getNormal(v, i-1, j, i, j-1);
    n2 = getNormal(v, i-1, j, i, j+1);
    n3 = getNormal(v, i, j+1, i+1, j);
    normal4 = getNormal(v, i+1, j, i, j-1);
    
    int cont = 0;
    
    if (n1.mag() >0)
      cont++;
    
    if (n2.mag() >0)
      cont++;
    
    if (n3.mag() >0)
      cont++;
    
    if (normal4.mag() >0)
      cont++;

    n1 = PVector.add(n1, n2);
    n3 = PVector.add(n3, normal4);
    normal = PVector.add(n1, n3);
    
    normal.div(cont);
    normal.normalize(); 
    
    proyeccion = normal.dot(viento); 
                                    
    fuerza.set(abs(proyeccion*viento.x), (proyeccion*viento.y), (proyeccion*viento.z));
    
    return fuerza;
    
  }
    PVector getfuerza(PVector VertexPos, int i, int j,  float m_Distance, float k){

    PVector fuerza = new PVector(0.0, 0.0, 0.0);
    PVector dist = new PVector(0.0, 0.0, 0.0);
    float fuerzaelo = 0.0;
    
    if (i >= 0 && i < sizeX && j >= 0 && j < sizeY) 
    {
      dist = PVector.sub(VertexPos, p[i][j]); 
      fuerzaelo = dist.mag() - m_Distance;  
      dist.normalize();
      fuerza = PVector.mult(dist, -k * fuerzaelo);
    }
    else{
      fuerza.set(0.0, 0.0, 0.0);
    }
    return fuerza;
  }  
  
  PVector getNormal (PVector v, int a, int b, int c, int d)
  {
    PVector n = new PVector (0,0,0);
    
    if (a >= 0 && a <= sizeX-1 && b>=0 && b<=sizeY-1 && c>=0 && c<=sizeX-1 && d>=0 && d<= sizeY-1)
    {
      PVector v1 = PVector.sub(p[a][b], v);
      PVector v2 = PVector.sub(p[c][d], v);
      n = v1.cross(v2);
    }
    
    return n;
  }


}
