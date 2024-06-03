class Grid
{
   float _cellSize;
   int _numCells;
   int _nRows; 
    int _nCols; 
   color [] _colors;
   
   ArrayList<ArrayList<Particle>> _cells;
   
   

   Grid(float cellSize)
   {
      _cellSize = cellSize;
      _nRows = int(height/_cellSize);
      _nCols = int(width/_cellSize);
      _numCells = _nRows*_nCols;
      
      _cells = new ArrayList<ArrayList<Particle>>();
      
      _colors = new color[_numCells];

      for (int i = 0; i < _numCells; i++)
      {
            ArrayList<Particle> cell = new ArrayList<Particle>();
            _cells.add(cell);
            _colors[i] = color(int(random(0,256)), int(random(0,256)), int(random(0,256)), 150);
      }
   }

   int getCelda(PVector l){
    int cell = 0;
    int fila = int (l.y / _cellSize);
    cell = fila + int(l.x / _cellSize) * _nCols;
    
    if(cell < 0 || cell >= _numCells)
      return 0;
    else
      return cell;
  }
  
  void restart(){
    for(int i = 0; i < _numCells; i++){
       _cells.get(i).clear();
    }
  }
  
  void insertar(Particle p){
    int cell = getCelda(p._s);
    p._color = _colors[cell];
    _cells.get(cell).add(p);
  }
  
}
