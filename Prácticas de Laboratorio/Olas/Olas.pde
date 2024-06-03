import peasy.*;

final int _MAP_SIZE = 150;
final float _MAP_CELL_SIZE = 10f;

boolean _viewmode = false;
boolean _clear = false;
boolean gota = false;

long lastWaveFrame = 0; // Tiempo en que se generó la última onda

PeasyCam camera;
HeightMap map, map2;
PImage img, fondo;
Raindrop drop; //gotas de lluvia

public void settings() {
    System.setProperty("jogl.disable.openglcore", "true");
    //size(900,600, P3D);
    fullScreen(P3D);
}

void setup() {
    img = loadImage("water_surface.jpg");
    fondo = loadImage("fondo.jpg");
    fondo.resize(width, height);
    camera = new PeasyCam(this, 100);
    camera.setMinimumDistance(50);
    camera.setMaximumDistance(2500);
    camera.setDistance(400);
    map = new HeightMap(_MAP_SIZE, _MAP_CELL_SIZE);
    drop = new Raindrop(); // Inicializar el ArrayList de gotas de lluvia
    println(img.width + " : " + img.height);
}

void draw() {
  
  
    background(fondo);
    lights();
    map.update();
    updateRain();
    if (_viewmode)
        map.presentWired();
    else
        map.present();
    //presentAxis();
    drawInteractiveInfo();
    if (_clear) {
        map.waves.clear();
        map.waveArray = new Wave[0];
        _clear = false;
    }

    //map.addWave(new WaveGerstner(amplitude,new PVector(dx,0,dz),wavelength,speed));//amplitude,direction,wavelength,speed
    
    // Ajustamos la cantidad de gotas de lluvia que se generan
    /*if (frameCount % 80 == 0) { // Generar una nueva gota de lluvia cada 60 fotogramas
        drop = new Raindrop(); // Generar una nueva gota de lluvia
       gota = true;
    }*/
}

void drawInteractiveInfo()
{
  float textSize = 100;
  float offsetX = -500;
  float offsetZ = -1000;
  float offsetY = -1000;
  
  int i = 0;
  noStroke();
  textSize(textSize);
  fill(0xff000000);
  text("q : sinusoidal wave", offsetX, offsetY + textSize*(++i),offsetZ);
  text("w : radial wave", offsetX, offsetY + textSize*(++i),offsetZ);
  text("e : gerstner wave", offsetX, offsetY + textSize*(++i),offsetZ);
  text("r : change viewmode", offsetX, offsetY + textSize*(++i),offsetZ);
  text("t : reset", offsetX, offsetY + textSize*(++i),offsetZ);
}

void keyPressed()
{
  float amplitude = random(2f)+8f;
  float dx = random(2f)-1;
  float dz = random(2f)-1;
  float wavelength = amplitude * (30 + random(2f));
  float speed = wavelength / (1+random(3f));
  
  if(key == 'q')
  {
    map.addWave(new WaveDirectional(amplitude,new PVector(dx,0,dz),wavelength,speed));//amplitude,direction,wavelength,speed
  }
  if(key == 'w')
  {
    map.addWave(new WaveRadial(amplitude,new PVector(dx*(_MAP_SIZE*_MAP_CELL_SIZE/2f),0,dz*(_MAP_SIZE*_MAP_CELL_SIZE/2f)),wavelength,speed));//amplitude,direction,wavelength,speed
  }
  if(key == 'e')
  {
    map.addWave(new WaveGerstner(amplitude,new PVector(dx,0,dz),wavelength,speed));//amplitude,direction,wavelength,speed
  }
  if(key == 'r')
  {
    _viewmode = !_viewmode;
  }
  if(key == 't')
  {
    _clear = true;
  }
  
  if(key == '1')
  {
    map.waves.get(0).W -=.001;  
  }
  
  if(key == '2')
  {
    map.waves.get(0).W +=.001;  
  }
  
  if(key == '3')
  {
    map.waves.get(0).phi -=.1;  
  }
  
  if(key == '4')
  {
    map.waves.get(0).phi +=.1;  
  }
  
  if(key == '5')
  {
    map.waves.get(0).A -=1;  
  }
  
  if(key == '6')
  {
    map.waves.get(0).A +=1;  
  }
  
  /*if(key == 'l') {
       drop = new Raindrop(); // Generar una nueva gota de lluvia
       gota = true;
  }*/
}
void presentAxis() {
     float axisSize = _MAP_SIZE*2f;
  stroke(0xffff0000);
  line(0,0,0,axisSize,0,0);
  stroke(0xff00ff00);
  line(0,0,0,0,-axisSize,0);
  stroke(0xff0000ff);
  line(0,0,0,0,0,axisSize);
}

void updateRain() {

        drop.update();
        drop.display();
        //checkCollision(drop);
}

void CrearOnda(Raindrop drop) {
    float amplitude = 10; // Amplitud fija
    float wavelength = amplitude * 30; // Longitud de onda fija
    float speed = wavelength / 2; // Velocidad fija
   
    // Reducir gradualmente la amplitud de la onda existente (si existe)
    if (!map.waves.isEmpty()) {
        WaveRadial wave = (WaveRadial) map.waves.get(0); // Obtener la primera onda (suponiendo que solo haya una)
        if (wave.A > 0) {
            wave.A -= 0.25; // Reducir la amplitud en 1
        } else {
            // Si la amplitud ha alcanzado cero, establecer la bandera _clear en true
            _clear = true;
        }
    }
    
    // Si la amplitud de la onda existente ha alcanzado cero y ha pasado cierto número de frames desde la última onda
    if (gota && frameCount - lastWaveFrame > 80) { // Suponiendo que quieras esperar 60 frames antes de generar otra onda en otra posición
        
        // Obtener las coordenadas x y z de la posición de la gota
        float x = drop.position.x; // Coordenada x
        float z = drop.position.z; // Coordenada z
        
          // Crear una onda radial en la posición de la colisión de la gota con el agua
          map.addWave(new WaveRadial(amplitude, new PVector(x, 0, z), wavelength, speed));
        
        // Establecer la bandera _clear como false para indicar que se ha generado una nueva onda
        _clear = false;
        
        // Actualizar el frame en que se generó la última onda
        lastWaveFrame = frameCount;
        gota = false;
    }
}
