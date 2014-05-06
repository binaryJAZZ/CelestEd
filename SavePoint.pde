class SavePoint{
  float x, y; //location relative to the grid
  
  SavePoint(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void render(int c1, int c2){
    //noStroke();
    //fill(c1);
    //ellipse(getScreenX(x)+gridSize*0.5, getScreenY(y)+gridSize*0.5, gridSize, gridSize);
    //print(savePointSprite);
    float tileSize = drawer.getCurrentTileSize();
    float widthMultiplier = savePointSprite.width / tileSize;
    float heightMultiplier = savePointSprite.height / tileSize;
    image(savePointSprite, getScreenXf(x), getScreenYf(y), widthMultiplier * gridSize, heightMultiplier * gridSize);
    
    fill(c2);
    text("Save Point",getScreenXf(x),getScreenYf(y)-15);
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
    //str += indentString + "savePoints.push(new SavePoint("+(tileSize*((tileShiftX + x)+0.5))+", "+(tileSize*((tileShiftY + y)+0.5))+"));\n";
    str += indentString + "savePoints.push(new SavePoint("+(tileSize*((tileShiftX + x)))+", "+(tileSize*((tileShiftY + y)))+"));\n";
    
    return str;
  }
  
  boolean collision(float x, float y) {
    float tileSize = drawer.getCurrentTileSize();
    float w = savePointSprite.width / tileSize;
    float h = savePointSprite.height / tileSize;
    
    return (x >= this.x && y >= this.y && x <= (this.x + w) && y <= (this.y + h));
  }
}
