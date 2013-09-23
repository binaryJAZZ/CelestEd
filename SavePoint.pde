class SavePoint{
  int x, y; //location on the grid
  
  SavePoint(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  void render(int c1, int c2){
    noStroke();
    fill(c1);
    ellipse(getScreenX(x)+gridSize*0.5, getScreenY(y)+gridSize*0.5, gridSize, gridSize);
    
    fill(c2);
    text("Save Point",getScreenX(x),getScreenY(y)-15);
  }
  
  void render(int c){
    render(c,c);
  }
  
  String toString(int tileSize, int tileShiftX, int tileShiftY, int indentDepth){
    String indentString = "";
    for (int i = 0; i < indentDepth; i++){
      indentString += "\t";
    }
    
    String str = "";
    str += indentString + "savePoints.push(new SavePoint("+(tileSize*(float(tileShiftX + x)+0.5))+", "+(tileSize*(float(tileShiftY + y)+0.5))+"));\n";
    
    return str;
  }
}
