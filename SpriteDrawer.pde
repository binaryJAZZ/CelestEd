//a UI for selecting Sprites
class SpriteDrawer{
  //basics
  int x,y,w,h;
  int spriteSize;
  ArrayList<Sprite> sprites;
  
  //buttons
  Button prev, next;
  
  //navigation and selection
  int currentSpriteIndex;
  int spritesPerPage;
  int currentPage, totalPages;
  
  SpriteDrawer(int x, int y, int w, int h, int spriteSize, ArrayList<Sprite> sprites){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.spriteSize = spriteSize;
    this.sprites = sprites;
    
    //init buttons
    prev = new Button(x,y+60,"< Prev Page");
    next = new Button(x,y+75,"Next Page >");
    
    //init navigation
    this.currentPage = 0;
    this.currentSpriteIndex = 0;
    this.spritesPerPage = int((w - next.getWidth() - 15) / (spriteSize*1.5));
    this.totalPages = this.sprites.size() / spritesPerPage;
    if (this.sprites.size() % spritesPerPage != 0) this.totalPages++;
  }
  
  void render(int color1, int color2){
    //background
    noStroke();
    fill(color1);
    rect(x,y,w,h);
    
    //text
    fill(color2);
    textAlign(RIGHT,TOP);
    text("Page: " + (currentPage+1) + "/" + totalPages, x+w, y);
    
    //buttons
    prev.render();
    next.render();
    
    //sprites
    for (int i = 0; i < spritesPerPage; i++){
      if (currentSpriteIndex == (currentPage*spritesPerPage + i)){
        strokeWeight(6);
        stroke(color2);
        rect(x + next.getWidth() + 15 + spriteSize*1.5*i, y + h*0.5 - spriteSize*0.5, spriteSize, spriteSize);
      }
      
      if (currentPage*spritesPerPage + i < sprites.size()){
        sprites.get(currentPage*spritesPerPage + i).render(x + next.getWidth() + 15 + spriteSize*1.5*i, y + h*0.5 - spriteSize*0.5, spriteSize, spriteSize);
      }  
    }
  }
  
  boolean collision(){
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      //sprites
      for (int i = 0; i < spritesPerPage; i++){
        int spriteIndex = currentPage*spritesPerPage + i;
        if (spriteIndex < sprites.size()){
          int spriteX = int(x + next.getWidth() + 15 + spriteSize*1.5*i);
          int spriteY = int(y + h*0.5 - spriteSize*0.5);
          if (mouseX > spriteX && mouseX < spriteX + spriteSize && mouseY > spriteY && mouseY < spriteY + spriteSize){
            currentSpriteIndex = spriteIndex;
          }
        }
      }
      
      //buttons
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
  
  Sprite getSelectedSprite(){
    return sprites.get(currentSpriteIndex);
  }
}
