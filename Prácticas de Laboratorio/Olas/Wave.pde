///////////////////////////////////////////////////////////////////////
//
// WAVE
//
///////////////////////////////////////////////////////////////////////

abstract class Wave
{
  
  protected PVector tmp;
  
  protected float A,C,W,Q,phi;
  protected PVector D;//Direction or centre
  
  public Wave(float _a,PVector _srcDir, float _L, float _C)
  {
    tmp = new PVector();
    C = _C;
    A = _a;
    D = new PVector().add(_srcDir);
    W = PI * 2 / _L;
    Q = PI * A * W; //Factor Q de las Ondas de Gerstner
    phi = C * W;
  }
  
  abstract PVector getVariation(float x, float y, float z, float time);
  abstract float getAmplitud();
  abstract void setAmplitud(float a);
  abstract float getDistance(float x, float y, float z);
}

///////////////////////////////////////////////////////////////////////
//
// DIRECTIONAL WAVE
//
//onda(x,y,t)= A * sin(W * (d * (x,y) + vp * t))
//
///////////////////////////////////////////////////////////////////////

class WaveDirectional extends Wave
{
  public WaveDirectional(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
    D.normalize();
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    tmp.x = 0;
    tmp.z = 0;
    tmp.y = A * sin((W * (D.x*x + D.z*z) ) + (time * phi));
    
    return tmp;
  }
  
  public float getAmplitud()
  {
    return A;
  }
  
  public void setAmplitud(float a)
  {
    A = a;
  }
  
  public float getDistance(float x, float y, float z){
    return (sqrt((x-D.x)*(x-D.x) + (z-D.z)*(z - D.z)));
  }
}

///////////////////////////////////////////////////////////////////////
//
// RADIAL WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveRadial extends Wave
{
  public WaveRadial(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
    
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    float s = sqrt(pow(x - D.x, 2) + pow(z - D.z, 2) );
    
    tmp.x = 0;
    tmp.z = 0;
    tmp.y = A * cos( W * s - time * phi);
    
    return tmp;
  }
  public float getAmplitud()
  {
    return A;
  }
  
  public void setAmplitud(float a)
  {
    A = a;
  }
  
  public float getDistance(float x, float y, float z){
    return (sqrt((x-D.x)*(x-D.x) + (z-D.z)*(z - D.z)));
  }
}



///////////////////////////////////////////////////////////////////////
//
// GERSTNER WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveGerstner extends Wave
{
  public WaveGerstner(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
    D.normalize();
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    tmp.x = Q * A * D.x  * cos((W * (D.x*x + D.z*z) ) + (time * phi));
    tmp.z = Q * A * D.z  * cos((W * (D.x*x + D.z*z) ) + (time * phi));
    tmp.y = -A * sin((W * (D.x*x + D.z*z) ) + (time * phi));
    
    
    return tmp;
  }
  
  public float getAmplitud()
  {
    return A;
  }
  
  public void setAmplitud(float a)
  {
    A = a;
  }
  
  public float getDistance(float x, float y, float z){
    return (sqrt((x-D.x)*(x-D.x) + (z-D.z)*(z - D.z)));
  }
  
}
