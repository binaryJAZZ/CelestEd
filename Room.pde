int roomCounter = 0;

class Room{
  float x, y; //position and size RELATIVE to the grid (1.0 == a full grid square; 0.1 == a tenth of a grid square)
  float width, height;
  
  float camX, camY; //position of the camera, relative to the top left corner of the room (its a percentage of the width and height)
  
  ArrayList<Room> neighborList = new ArrayList<Room>();
  
  int ID;
  
  Room(float x, float y, float width, float height){
    this(x, y, width, height, 0.5, 0.5);
  }
  
  Room(float x, float y, float width, float height, float camX, float camY){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.camX = camX;
    this.camY = camY;
  }
  
  void renderOutline(int c){
    //border
    strokeWeight(4);
    stroke(c);
    noFill();
    rect(getScreenX(), getScreenY(), getScreenWidth(), getScreenHeight());
  }
  
  void renderCorners(int c1){
    renderCorners(c1, 0, -1);
  }
  
  void renderCorners(int c1, int c2, int indexSelected){
    //handles
    noStroke();
    
    if (indexSelected == 0){
      fill(c2);
    }
    else{
      fill(c1);
    }
    ellipse(getScreenX(), getScreenY(), 20, 20);
    
    if (indexSelected == 1){
      fill(c2);
    }
    else{
      fill(c1);
    }
    ellipse(getScreenX()+getScreenWidth(), getScreenY(), 20, 20);
    
    if (indexSelected == 2){
      fill(c2);
    }
    else{
      fill(c1);
    }
    ellipse(getScreenX(), getScreenY()+getScreenHeight(), 20, 20);
    
    if (indexSelected == 3){
      fill(c2);
    }
    else{
      fill(c1);
    }
    ellipse(getScreenX()+getScreenWidth(), getScreenY()+getScreenHeight(), 20, 20);
    
    //camera
    noFill();
    strokeWeight(2);
    if (indexSelected == 4){
      stroke(c2);
    }
    else{
      stroke(c1);
    }
    ellipse(getScreenCamX(), getScreenCamY(), 40, 40);
    
    noStroke();
    if (indexSelected == 4){
      fill(c2);
    }
    else{
      fill(c1);
    }
    ellipse(getScreenCamX(), getScreenCamY(), 10, 10);
  }
  
  void renderNeighbors(int c){
    for (Room r : neighborList){
      r.renderOutline(c);
    }
  }
  
  float getScreenX(){
    return x*gridSize - (getGridX(0)*gridSize);
  }
  
  float getScreenY(){
    return y*gridSize - (getGridY(0)*gridSize);
  }
  
  float getScreenWidth(){
    return width*gridSize;
  }
  
  float getScreenHeight(){
    return height*gridSize;
  }
  
  float getScreenCamX(){
    return getScreenX() + getScreenWidth()*camX;
  }
  
  float getScreenCamY(){
    return getScreenY() + getScreenHeight()*camY;
  }
  
  boolean mouseCollision(){
    return (mouseX > getScreenX() && mouseX < getScreenX() + getScreenWidth() &&
              mouseY > getScreenY() && mouseY < getScreenY() + getScreenHeight());
  }
  
  int mouseCornerCollision(){
    if (dist(mouseX, mouseY, getScreenX(), getScreenY()) < 10){
      return 0;
    }
    else if (dist(mouseX, mouseY, getScreenX()+getScreenWidth(), getScreenY()) < 10){
      return 1;
    }
    else if (dist(mouseX, mouseY, getScreenX(), getScreenY()+getScreenHeight()) < 10){
      return 2;
    }
    else if (dist(mouseX, mouseY, getScreenX()+getScreenWidth(), getScreenY()+getScreenHeight()) < 10){
      return 3;
    }
    else if (dist(mouseX, mouseY, getScreenCamX(), getScreenCamY()) < 20){
      return 4; //actually the camera and not a corner
    }
    else{
      return -1;
    }
  }
  
  boolean roomCollision(Room otherRoom){
    return !(  (x > otherRoom.x + otherRoom.width) ||
              (x + width < otherRoom.x) ||
              (y > otherRoom.y + otherRoom.height) ||
              (y + height < otherRoom.y)    );
  }
  
  void moveCorner(int cornerIndex, float newX, float newY){
    if (cornerIndex == 0){
      width = width - (newX - x);
      x = newX;
      
      height = height - (newY - y);
      y = newY;
    }
    else if (cornerIndex == 1){
      width = newX - x;
      
      height = height - (newY - y);
      y = newY;
    }
    else if (cornerIndex == 2){
      width = width - (newX - x);
      x = newX;
      
      height = newY - y;
    }
    else if (cornerIndex == 3){
      width = newX - x;
      
      height = newY - y;
    }
    else if (cornerIndex == 4){
      camX = (newX - x) / width;
      camY = (newY - y) / height;
    }
  }
  
  void fixTopLeftCorner(){
    if (width < 0){
      x += width;
      width *= -1;
    }
    if (height < 0){
      y += height;
      height *= -1;
    }
  }
  
  void findNeighbors(ArrayList<Room> roomList){
    neighborList = new ArrayList<Room>();
    
    for (Room r : roomList){
      if (this != r && roomCollision(r)){
        neighborList.add(r);
      }
    }
  }
  
  String toString(int tileSize){
    return "var room" + ID + ":Room = new Room(new FlxPoint(" + int(x*tileSize) + "," + int(y*tileSize) + 
              "), new FlxPoint(" + int(width*tileSize) + "," + int(height*tileSize) + 
              "), new FlxPoint(" + int(x*tileSize + camX*width*tileSize) + "," + int(y*tileSize + camY*height*tileSize) + "));";
  }
  
  String neighborsToString(){
    String neighbors = "//room" + ID + "'s neighbors " + "\n";
    for (Room r : neighborList){
      neighbors += "\t\t\t";
      neighbors += "room" + ID + ".addNeighbor(room" + r.ID + "); " + "\n";
    }
    return neighbors;
  }
  
  void setID(){
    this.ID = roomCounter;
    roomCounter++;
  }
}
