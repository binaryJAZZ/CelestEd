//represents a set of tiles, stored in a single image
class Tilesheet{
 String name;
 PImage sourceImage;
 int tileSize;
 PImage[] tileImages;

 Tilesheet(String name, PImage sourceImage, int tileSize){
   //basic information
   this.name = name;
   this.sourceImage = sourceImage;
   this.tileSize = tileSize;
   
   //load tilesheet into an array of images
   int rows = (sourceImage.height/tileSize);
   int cols = (sourceImage.width/tileSize);
   this.tileImages = new PImage[cols * rows];
   for (int r = 0; r < rows; r++){
     for (int c = 0; c < cols; c++){
       int i = (r*cols) + c;
       int x = c*tileSize;
       int y = r*tileSize;
       this.tileImages[i] = createImage(tileSize,tileSize,ARGB);
       this.tileImages[i].copy(sourceImage,x,y,tileSize,tileSize,0,0,tileSize,tileSize);
     }
   }
 }
}
