//represents a single sprite
class Sprite{
  String name; //identifies the sprite
  PImage img;
  float x, y; //location relative to the grid
  boolean isHideable; //can the player hide inside this sprite object?
  boolean hasHidingTimeLimit = false;
  
  Sprite(float x, float y, String name, PImage img, boolean isHideable, boolean hasHidingTimeLimit){
    this.x = x;
    this.y = y;
    
    this.name = name;
    
    this.img = img;
    
    this.isHideable = isHideable;
    
    this.hasHidingTimeLimit = hasHidingTimeLimit;
  }
  
  Sprite(String name, PImage img){
    this(0.0, 0.0, name, img, false, false);
  }
  
  Sprite(float x, float y, Sprite original){
    this(x, y, original.name, original.img, false, false);
  }
  
  Sprite(float x, float y, Sprite original, boolean isHideable, boolean hasHidingTimeLimit){
    this(x, y, original.name, original.img, isHideable, hasHidingTimeLimit);
  }
  
  //render at arbitrary location, with arbitrary size
  void render(float x, float y, float w, float h){
    image(img, x, y, w, h);
  }
  
  //render on grid, with texture
  void render(){
    float tileSize = drawer.getCurrentTileSize();
    float widthMultiplier = img.width / tileSize;
    float heightMultiplier = img.height / tileSize;
    render(getScreenXf(x), getScreenYf(y), gridSize * widthMultiplier, gridSize * heightMultiplier);
  }
  
  void renderHideability(int c){
    float tileSize = drawer.getCurrentTileSize();
    float widthMultiplier = img.width / tileSize;
    float heightMultiplier = img.height / tileSize;
    noStroke();
    fill(c);
    rect(getScreenXf(x), getScreenYf(y), gridSize * widthMultiplier, gridSize * heightMultiplier);
  }
  
  boolean collision(){
    float tileSize = drawer.getCurrentTileSize();
    float widthMultiplier = img.width / tileSize;
    float heightMultiplier = img.height / tileSize;
    if (mouseX > getScreenXf(x) && mouseY > getScreenYf(y) 
          && mouseX < getScreenXf(x) + (gridSize * widthMultiplier) && mouseY < getScreenYf(y) + (gridSize * heightMultiplier)){
            return true;
    }
    return false;
  }
  
  String toString(int tileSize, int tileShiftX, int tileShiftY, int indentDepth){
    String indentString = "";
    for (int i = 0; i < indentDepth; i++){
      indentString += "\t";
    }
    
    if (isHideable) {
      if (hasHidingTimeLimit){
        return indentString + "hideableObjects.push(new HideableObject("+(tileSize*(x+tileShiftX))+","+(tileSize*(y+tileShiftY))+",Assets."+name+",true,0.5));\n";
      }
      else{
        return indentString + "hideableObjects.push(new HideableObject("+(tileSize*(x+tileShiftX))+","+(tileSize*(y+tileShiftY))+",Assets."+name+"));\n";
      }
    }
    else {
      return indentString + "sprite = new FlxSprite("+(tileSize*(x+tileShiftX))+","+(tileSize*(y+tileShiftY))+",Assets."+name+");\n";
    }
  }
}
