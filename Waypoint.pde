class Waypoint{
  int x, y; //location on the grid
  
  Waypoint(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  void render(int c){
    noStroke();
    fill(c);
    ellipse(getScreenX(x)+gridSize*0.5, getScreenY(y)+gridSize*0.5, gridSize*0.5, gridSize*0.5);
  }
  
  void render(int c1, int c2, int index){
    render(c1);
    
    noStroke();
    fill(c2);
    text(index, getScreenX(x), getScreenY(y));
  }
  
  String toString(int tileSize, int tileShiftX, int tileShiftY){
    return "new FlxPoint("+(tileSize*(float(tileShiftX + x)+0.5))+","+(tileSize*(float(tileShiftY + y)+0.5))+")";
  }
}
