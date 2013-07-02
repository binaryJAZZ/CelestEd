//represents a single tile on the grid
class Tile{
  int tilesheetIndex, tileIndex; //what kind of tile is this?
  PImage img;
  int x, y; //location on the grid
  
  Tile(int x, int y, int tilesheetIndex, int tileIndex){
    this.tilesheetIndex = tilesheetIndex;
    this.tileIndex = tileIndex;
    
    this.x = x;
    this.y = y;
    
    this.img = tilesheets.get(tilesheetIndex).tileImages[tileIndex];
  }
  
  //render on grid, with texture
  void render(){
    image(img,getScreenX(x),getScreenY(y),gridSize,gridSize);
  }
  
  //render on grid, with color
  void render(int c){
    noStroke();
    fill(c);
    rect(getScreenX(x),getScreenY(y),gridSize,gridSize);
  }
  
  String toString(){
    return "" + tileIndex;
  }
}
