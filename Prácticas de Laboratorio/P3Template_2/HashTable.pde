class HashTable
{
   ArrayList<ArrayList<Particle>> _table;

   int _numCells;
   float _cellSize;
   color[] _colors;

   HashTable(float cellSize, int numCells)
   {
      _table = new ArrayList<ArrayList<Particle>>();
      _cellSize = cellSize;
      _numCells = numCells;

      _colors = new color[_numCells];

      for (int i = 0; i < _numCells; i++)
      {
         ArrayList<Particle> cell = new ArrayList<Particle>();
         _table.add(cell);
         _colors[i] = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)), 150);
      }
   }

   //Obtener la celda correspondiente dada una posición 
  int getCelda (PVector l){
    long xd = int(floor(l.x / _cellSize));
    long yd = int(floor(l.y / _cellSize));
    
    long suma = 73856093 * xd + 19349663 * yd;
    
    int cell = int(suma % _table.size());
    return cell;
  }
  
  void restart(){
    for(int i = 0; i < _table.size(); i++){
      _table.get(i).clear();
    }
  }
  
  void insertar(Particle p){
    int cell = getCelda(p._s);
    p._color = _colors[cell];
    _table.get(cell).add(p);
  }
   //   
}
