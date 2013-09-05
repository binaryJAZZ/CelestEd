//a UI for selecting Tiles
class TileDrawer{
  //basics
  int x,y,w,h;
  int tileSize;
  int currentTilesheetIndex;
  int currentTileIndex;
  ArrayList<Tilesheet> tilesheets;
  Tilesheet currentSheet;
  
  //buttons
  Button prev, next, prevSheet, nextSheet;
  
  //other
  int tilesPerPage;
  int currentPage, totalPages;
  
  TileDrawer(int x, int y, int w, int h, int tileSize, ArrayList<Tilesheet> tilesheets){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.tileSize = tileSize;
    this.tilesheets = tilesheets;
    this.currentTilesheetIndex = 0;
    this.currentSheet = tilesheets.get(currentTilesheetIndex);
    
    //init buttons
    prevSheet = new Button(x,y+15,"< Prev Sheet");
    nextSheet = new Button(x,y+30,"Next Sheet >");
    prev = new Button(x,y+60,"< Prev Page");
    next = new Button(x,y+75,"Next Page >");
    
    this.currentPage = 0;
    this.currentTileIndex = 0;
    this.tilesPerPage = int((w - nextSheet.getWidth() - 15) / (tileSize*1.5));
    this.totalPages = this.currentSheet.tileImages.length / tilesPerPage;
    if (this.currentSheet.tileImages.length % tilesPerPage != 0) this.totalPages++;
  }
  
  void render(int color1, int color2){
    //background
    noStroke();
    fill(color1);
    rect(x,y,w,h);
    
    //text
    fill(color2);
    textAlign(LEFT,TOP);
    text("Tilesheet: " + currentSheet.name, x, y);
    textAlign(RIGHT,TOP);
    text("Page: " + (currentPage+1) + "/" + totalPages, x+w, y);
    
    //buttons
    prevSheet.render();
    nextSheet.render();
    prev.render();
    next.render();
    
    //tiles
    for (int i = 0; i < tilesPerPage; i++){
      if (currentTileIndex == (currentPage*tilesPerPage + i)){
        strokeWeight(6);
        stroke(color2);
        rect(x + nextSheet.getWidth() + 15 + tileSize*1.5*i, y + h*0.5 - tileSize*0.5, tileSize, tileSize);
      }
      
      if (currentPage*tilesPerPage + i < currentSheet.tileImages.length){
        PImage tileImage = currentSheet.tileImages[currentPage*tilesPerPage + i];
        image(tileImage, x + nextSheet.getWidth() + 15 + tileSize*1.5*i, y + h*0.5 - tileSize*0.5, tileSize, tileSize);
      }  
    }
  }
  
  boolean collision(){
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      //tiles
      for (int i = 0; i < tilesPerPage; i++){
        int tileIndex = currentPage*tilesPerPage + i;
        if (tileIndex < currentSheet.tileImages.length){
          int tileX = int(x + nextSheet.getWidth() + 15 + tileSize*1.5*i);
          int tileY = int(y + h*0.5 - tileSize*0.5);
          if (mouseX > tileX && mouseX < tileX + tileSize && mouseY > tileY && mouseY < tileY + tileSize){
            currentTileIndex = tileIndex;
          }
        }
      }
      
      //buttons
      if (prevSheet.collision()){
        currentTilesheetIndex--;
        if (currentTilesheetIndex < 0){
          currentTilesheetIndex = tilesheets.size()-1;
        }

        currentSheet = tilesheets.get(currentTilesheetIndex);
        currentPage = 0;
        currentTileIndex = 0;
        totalPages = currentSheet.tileImages.length / tilesPerPage;
        if (currentSheet.tileImages.length % tilesPerPage != 0) totalPages++;
      }
      if (nextSheet.collision()){
        currentTilesheetIndex = (currentTilesheetIndex+1)%(tilesheets.size());
        
        currentSheet = tilesheets.get(currentTilesheetIndex);
        currentPage = 0;
        currentTileIndex = 0;
        totalPages = currentSheet.tileImages.length / tilesPerPage;
        if (currentSheet.tileImages.length % tilesPerPage != 0) totalPages++;
      }
      
      if (prev.collision()){
        currentPage--;
        if (currentPage < 0){
          currentPage = totalPages-1;
        }
      }
      if (next.collision()){
        currentPage = (currentPage+1)%totalPages;
      }
      
      return true;
    }
    return false;
  }
  
  String getSheetName(Tile t){
    return tilesheets.get(t.tilesheetIndex).name;
  }
  
  int getCurrentTileSize(){
    return currentSheet.tileSize;
  }
}
