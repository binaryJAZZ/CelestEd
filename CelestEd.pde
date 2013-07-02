//****************************************************
//** CelestEd by A.R.L.                             **
//** Level Editor for "Dame Celeste: In This Dress" **
//** a game by team Adjective Animal                **
//****************************************************

//imports
import java.util.HashMap;

//camera
int camX = 0; //where is camera located? (the center square of the grid)
int camY = 0;

//window size
final static int WIN_X = 800;
final static int WIN_Y = 600;

//colors
int backgroundColor = color(65, 100, 160);
int lineColor = color(255, 255, 255);
int altColor = color(245,209,79);
int wallColor = color(0,0,0,180);
int floorColor = color(255,255,255,180);
int drawerColor = color(15,45,95);
int deleteColor = color(185,22,22);

//grid
int gridSize = 32; //the width & height of one square on the grid
int minGridSize = 8;
int maxGridSize = 128;

//tiles
TileMap floors = new TileMap("FLOORS");
TileMap walls = new TileMap("WALLS");

//loading tilesheets
String[] supportedFileTypes = {"png", "jpg", "gif"};
ArrayList<Tilesheet> tilesheets = new ArrayList<Tilesheet>();

//UI
Button hideUI;
ArrayList<Button> UIbuttons = new ArrayList<Button>();
TileDrawer drawer;
Button saveButton, openButton;

//level boundaries
int topEdge, bottomEdge, leftEdge, rightEdge;

//rooms
ArrayList<Room> roomList = new ArrayList<Room>();
Room selectedRoom;
boolean isMakingRoom = false;
int selectedCorner = -1;

void setup(){
  size(WIN_X, WIN_Y);
  
  noSmooth(); //turn off anti-aliasing
  
  background(backgroundColor);
  
  loadTilesheets(sketchPath + "/tilesheets");
  
  drawer = new TileDrawer(0,int(WIN_Y*0.8),WIN_X,int(WIN_Y*0.2), 32, tilesheets);
  
  hideUI = new Button(0,30, "Hide Options", "Show Options");
  
  UIbuttons.add(new Button(0,45,"Hide Grid","Show Grid")); //0
  UIbuttons.add(new Button(0,60,"Hide Textures","Show Textures")); //1
  UIbuttons.add(new Button(0,75,"Show Collision Map","Hide Collision Map")); //2
  UIbuttons.get(2).selected = true;
  UIbuttons.add(new Button(0,90,"Floor","Wall")); //3
  UIbuttons.add(new Button(0,105,"Show Level Bounds","Hide Level Bounds")); //4
  UIbuttons.get(4).selected = true;
  UIbuttons.add(new Button(0,120,"Close Tile Drawer","Open Tile Drawer")); //5
  UIbuttons.add(new Button(0,135,"Place Rooms", "Place Tiles")); //6
  UIbuttons.add(new Button(0,150,"Hide Rooms", "Show Rooms")); //7
  
  saveButton = new Button(0,180,"Export To File");
  openButton = new Button(0,195,"Import From File");
}

void draw(){
  //clear screen
  background(backgroundColor);
  
  //all tiles
  if (!UIbuttons.get(1).selected){
    floors.render();
    walls.render();
  }
  if (!UIbuttons.get(2).selected){
    floors.render(floorColor);
    
    //only render walls greater than index 0 (index 0 has no collision)
    for (Tile t : walls.tileList){
      if (t.tileIndex != 0){
        t.render(wallColor);
      }
    }
    //walls.render(wallColor);
  }
  
  //level boundary
  if (!UIbuttons.get(4).selected){
    drawLevelBoundary(altColor);
  }
  
  //grid lines
  if (!UIbuttons.get(0).selected){
    drawGrid(lineColor);
  }
  
  //rooms
  if (!UIbuttons.get(7).selected){
    updateRooms();
  }
  
  //cursor
  drawCursor();
  
  //mouse coordinates
  fill(lineColor);
  textAlign(LEFT,TOP);
  text("(" + getGridX() + "," + getGridY() + ")", 0, 0);
  
  //current tile
  if (!UIbuttons.get(6).selected){
    stroke(lineColor);
    fill(color(0,0,0));
    strokeWeight(4);
    rect(WIN_X - 64 - 2, 2, 64, 64);
    image(tilesheets.get(drawer.currentTilesheetIndex).tileImages[drawer.currentTileIndex], WIN_X - 64 - 2, 2, 64, 64);
  }
  
  //UI
  hideUI.render();
  if (!hideUI.selected){
    for (Button b : UIbuttons){
      b.render();
    }
  }
  saveButton.render();
  openButton.render();
  
  //drawer
  if (!UIbuttons.get(5).selected && !UIbuttons.get(6).selected){
    drawer.render(drawerColor, lineColor);
  }
}

void keyPressed(){
  if (key == 'w') camY--;
  if (key == 's') camY++;
  if (key == 'a') camX--;
  if (key == 'd') camX++;
  
  if (key == '-' && gridSize > minGridSize) gridSize /= 2;
  if (key == '=' && gridSize < maxGridSize) gridSize *= 2;
}

void mousePressed(){
  boolean buttonPress = userInterface();
  
  if (!buttonPress){
    if (UIbuttons.get(6).selected){
      if (!UIbuttons.get(7).selected){
        //select a room
        for (Room r : roomList){
          if (selectedRoom == null){
            selectedCorner = r.mouseCornerCollision();
            if (selectedCorner != -1){
              selectedRoom = r;
            }
          }
        }
        //OR make a new room
        if (selectedRoom == null){
          selectedRoom = new Room(getGridX(0) + (mouseX/float(gridSize)), getGridY(0) + (mouseY/float(gridSize)), 0, 0);
          isMakingRoom = true;
          selectedCorner = 3;
        }
      }
    }
    else{
      //make a tile
      makeTile();
    }
  }
}

void mouseReleased(){
  if (isMakingRoom){
    selectedRoom.setID();
    roomList.add(selectedRoom);
    isMakingRoom = false;
  }
  if (selectedRoom != null){
    selectedRoom.fixTopLeftCorner();
    if (abs(selectedRoom.getScreenWidth()) < 20 && abs(selectedRoom.getScreenHeight()) < 20){
      roomList.remove(selectedRoom);
    }
    
    //print(selectedRoom.toString(16));
  }
  selectedRoom = null;
}

boolean userInterface(){
  boolean buttonPress = false;
  
  buttonPress = (!UIbuttons.get(5).selected) && (!UIbuttons.get(6).selected) && drawer.collision();
  
  if (hideUI.collision()){
    hideUI.update();
    buttonPress = true;
  }
  
  if (!hideUI.selected){
    for (Button b : UIbuttons){
      if (b.collision()){
        b.update();
        buttonPress = true;
      }
    }
  }
  
  if (saveButton.collision()){
    selectOutput("Where do you want to save the map?", "saveMap");
    buttonPress = true;
  }
  
  if (openButton.collision()){
    selectInput("Pick a map file to open", "loadMap");
    buttonPress = true;
  }
  
  return buttonPress;
}

void makeTile(){
  //update level boundaries
  boolean noTilesYet = (walls.size() == 0 && floors.size() == 0);
  if (noTilesYet || getGridX() < leftEdge){
    leftEdge = getGridX();
  }
  if (noTilesYet || getGridX() > rightEdge){
    rightEdge = getGridX();
  }
  if (noTilesYet || getGridY() < topEdge){
    topEdge = getGridY();
  }
  if (noTilesYet || getGridY() > bottomEdge){
    bottomEdge = getGridY();
  }
  
  //choose the correct layer of tiles
  //depending on what is selected in the menu
  TileMap tileMap;
  if (UIbuttons.get(3).selected){
    tileMap = walls;
  }
  else{
    tileMap = floors;
  }
  
  //attempt to add a new tile to the selected layer
  Integer gridX = new Integer(getGridX());
  Integer gridY = new Integer(getGridY());
  boolean tileAddSuccessful = tileMap.addTile(gridX, gridY, drawer.currentTilesheetIndex, drawer.currentTileIndex);
                  
  //if you can't add a tile, that means there is already one at that position on that layer
  //delete the offending tile    
  if (!tileAddSuccessful){        
    tileMap.removeTile(gridX, gridY);
    
    if (getGridX() == leftEdge || getGridX() == rightEdge || 
        getGridY() == topEdge || getGridY() == bottomEdge){
      recalculateLevelBounds();
    }
  }
}

void drawGrid(int c){
  stroke(c);
  strokeWeight(1);
  
  int gridWidth = WIN_X / gridSize;
  int gridHeight = WIN_Y / gridSize;
  
  int centerX = WIN_X / 2;
  int centerY = WIN_Y / 2;
  
  for (int i = 0; i < gridWidth/2 + 1; i++){
    int xRight = (centerX + gridSize/2) + (i * gridSize);
    line(xRight, 0, xRight, WIN_Y);
    int xLeft = (centerX - gridSize/2) - (i * gridSize);
    line(xLeft, 0, xLeft, WIN_Y);
  }
  
  for (int i = 0; i < gridHeight/2 + 1; i++){
    int yDown = (centerY + gridSize/2) + (i * gridSize);
    line(0, yDown, WIN_X, yDown);
    int yUp = (centerY - gridSize/2) - (i * gridSize);
    line(0, yUp, WIN_X, yUp);
  }
}

void drawLevelBoundary(int c){
  boolean noTilesYet = (walls.size() == 0 && floors.size() == 0);
  if (!noTilesYet){
    noStroke();
    fill(c);
  
    //top
    rect(getScreenX(leftEdge-1), getScreenY(topEdge-1), gridSize*(rightEdge-leftEdge+3), gridSize);
    //bottom
    rect(getScreenX(leftEdge-1), getScreenY(bottomEdge+1), gridSize*(rightEdge-leftEdge+3), gridSize);
    //left
    rect(getScreenX(leftEdge-1), getScreenY(topEdge-1), gridSize, gridSize*(bottomEdge-topEdge+3));
    //right
    rect(getScreenX(rightEdge+1), getScreenY(topEdge-1), gridSize, gridSize*(bottomEdge-topEdge+3));
  }
}

//get mouse position relative to the grid
int getGridX(){
  return getGridX(mouseX);
}

int getGridX(int x){
  int relativeX = x - (WIN_X/2);
  int sign = 0;
  if (relativeX != 0) sign = relativeX/abs(relativeX);
  return camX + ((relativeX + (gridSize/2 * sign)) / gridSize);
}

int getGridY(){
  return getGridY(mouseY);
}

int getGridY(int y){
  int relativeY = y - (WIN_Y/2);
  int sign = 0;
  if (relativeY != 0) sign = relativeY/abs(relativeY);
  return camY + ((relativeY + (gridSize/2 * sign)) / gridSize);
}
 
//get the pixel position of the top left corner of a part of the grid  
int getScreenX(int gridX){
  return (-1*camX*gridSize) + (gridX*gridSize) + (WIN_X/2 - gridSize/2);
}

int getScreenY(int gridY){
  return (-1*camY*gridSize) + (gridY*gridSize) + (WIN_Y/2 - gridSize/2);
}

void loadTilesheets(String tilesheetDirectoryPath){
  File tilesheetDirectory = new File(tilesheetDirectoryPath);
  
  for (String folderName : tilesheetDirectory.list()){
    String[] folderInfo = folderName.split("_");
    
    if (folderInfo[0].equals("tilesheets")){
      int tileSize = Integer.parseInt(folderInfo[1]);
      String folderPath = tilesheetDirectoryPath + "/" + folderName;
      File folder = new File(folderPath);
      
      for (String fileName : folder.list()){
        String[] fileInfo = fileName.split("\\.");
        if (fileInfo.length > 1){
          String fileType = fileInfo[1];
          
          if (Arrays.asList(supportedFileTypes).contains(fileType.toLowerCase())){
            tilesheets.add( new Tilesheet(fileInfo[0], loadImage(folderPath + "/" + fileName), tileSize) );
          }
        }
      }
    }
  }
}

void saveMap(File fileOut){
  try{
    PrintWriter output = createWriter(fileOut.getName()); //open file
    
    //write level data
    output.print("//tile map arrays");
    output.print("\n");
    output.print(floors.stringExport(leftEdge, topEdge, rightEdge+1, bottomEdge+1));
    output.print("\n");
    output.print(walls.stringExport(leftEdge, topEdge, rightEdge+1, bottomEdge+1));
    
    output.print("\n");
    output.print("//room data");
    output.print("\n");
    for (Room r : roomList){
      output.print(r.toString(16));
      output.print("\n");
    }
    output.print("\n");
    for (Room r : roomList){
      output.print(r.neighborsToString());
      output.print("\n");
    }
    
    output.flush(); //write remaing data
    output.close(); //finish the file
  }
  catch(Exception e){
    println("cannot save this map... that sucks");
  }
}

void loadMap(File fileIn){
  try{
    int tileSize = 16;
    
    String layerName = "";
    String tilesheetName = "";
    String arrayStr = "";
    boolean readingMapArray = false;
    ArrayList<Room> newRoomList = new ArrayList<Room>();
    
    //String mapFileStr = "";
    for (String curLine : loadStrings(fileIn.getAbsolutePath())){
      //println(curLine);
      String[] curWords = curLine.split(" "); //split on whitespace
      
      //println(curWords.length);
      //println(curWords[0]);
      
      if (curWords.length > 9 && curWords[4].equals("Room(new")){
        String[] leftCornerStr = splitTokens(curWords[5], "()")[1].split(",");
        String[] sizeStr = splitTokens(curWords[7], "()")[1].split(",");
        String[] cameraStr = splitTokens(curWords[9], "()")[1].split(",");
        
        float x = Float.parseFloat(leftCornerStr[0])/tileSize;
        float y = Float.parseFloat(leftCornerStr[1])/tileSize;
        float width = Float.parseFloat(sizeStr[0])/tileSize;
        float height = Float.parseFloat(sizeStr[1])/tileSize;
        float camX = ((Float.parseFloat(cameraStr[0])/tileSize) - x) / width;
        float camY = ((Float.parseFloat(cameraStr[1])/tileSize) - y) / height;
        
        Room newRoom = new Room(x, y, width, height, camX, camY);                        
        newRoom.setID();
        newRoomList.add(newRoom);
        
        //println(newRoom.x + "," + newRoom.y);
        
        /*
        println("room found!");
        println(leftCornerStr[1]);
        println(sizeStr[1]);
        println(cameraStr[1]);
        */
      }
      
      if (curWords.length > 3 && curWords[3].equals("layer")){
        layerName = curWords[2];
        //println(layerName);
      }
      
      if (curWords.length > 2 && curWords[2].equals("tilesheet:")){
        tilesheetName = curWords[3];
        //println(tilesheetName);
      }
      
      if (curWords.length > 0 && curWords[0].equals(");")){
        readingMapArray = false;
        
        //load tiles into the map
        int i = 0;
        for (Tilesheet sheet : drawer.tilesheets){
          if (sheet.name.equals(tilesheetName)){
            if (layerName.equals("FLOORS")){
              //println("importing floors " + tilesheetName);
              floors.stringImport(arrayStr, i);
            }
            else if (layerName.equals("WALLS")){
              //println("importing walls " + tilesheetName);
              walls.stringImport(arrayStr, i);
            }
          }
          i++;
        }
        
        //reset everything
        layerName = "";
        tilesheetName = "";
        arrayStr = "";
      }
      
      if (readingMapArray){
        //println("reading");
        arrayStr += curLine + "\n"; //keep the new line so we know where each row ends
      }
      
      if (curWords.length > 3 && curWords[3].equals(layerName+":Array")){
        readingMapArray = true;
      }
    }
    
    roomList = newRoomList;
  }
  catch(Exception e){
    println("can't load the map... dang");
  }
  
  recalculateLevelBounds();
}

void recalculateLevelBounds(){
  boolean isFirstTile = true;
  
  for (Tile t : floors.tileList){
    if (isFirstTile || t.y < topEdge){
      topEdge = t.y;
    }
    if (isFirstTile || t.y > bottomEdge){
      bottomEdge = t.y;
    }
    if (isFirstTile || t.x < leftEdge){
      leftEdge = t.x;
    }
    if (isFirstTile || t.x > rightEdge){
      rightEdge = t.x;
    }
    
    isFirstTile = false;
  }
  for (Tile t : walls.tileList){
    if (isFirstTile || t.y < topEdge){
      topEdge = t.y;
    }
    if (isFirstTile || t.y > bottomEdge){
      bottomEdge = t.y;
    }
    if (isFirstTile || t.x < leftEdge){
      leftEdge = t.x;
    }
    if (isFirstTile || t.x > rightEdge){
      rightEdge = t.x;
    }
    
    isFirstTile = false;
  }
}

void drawCursor(){
  if (!UIbuttons.get(6).selected){
    //tile cursor
    strokeWeight(4);
    stroke(lineColor);
    if (UIbuttons.get(3).selected){
      fill(wallColor);
    }
    else{
      fill(floorColor);
    }
    rect(getScreenX(getGridX()), getScreenY(getGridY()), gridSize, gridSize);
  }
  else{
    //room cursor
    strokeWeight(2);
    stroke(lineColor);
    noFill();
    ellipse(mouseX, mouseY, 20, 20);
  }
}

void updateRooms(){
  for (Room r : roomList){
    r.renderOutline(wallColor);
  }
  for (Room r : roomList){
    if (r.mouseCollision()){
      r.findNeighbors(roomList);
      r.renderNeighbors(lineColor);
    }
  }
  for (Room r : roomList){
    if (r.mouseCollision()){
      r.renderOutline(altColor);
      r.renderCorners(altColor);
    }
  }
  if (selectedRoom != null){
    selectedRoom.findNeighbors(roomList);
    selectedRoom.renderNeighbors(lineColor);
    
    if (abs(selectedRoom.getScreenWidth()) < 20 && abs(selectedRoom.getScreenHeight()) < 20){
      selectedRoom.renderOutline(deleteColor);
      selectedRoom.renderCorners(deleteColor, lineColor, selectedCorner);
    }
    else{
      selectedRoom.renderOutline(altColor);
      selectedRoom.renderCorners(altColor, lineColor, selectedCorner);
    }
  }
  if (isMakingRoom){
    selectedRoom = new Room(selectedRoom.x, selectedRoom.y, 
                            getGridX(0) + (mouseX/float(gridSize)) - selectedRoom.x, 
                            getGridY(0) + (mouseY/float(gridSize)) - selectedRoom.y);
  }
  else if (selectedRoom != null){
    selectedRoom.moveCorner(selectedCorner, getGridX(0) + (mouseX/float(gridSize)), getGridY(0) + (mouseY/float(gridSize)));
  }
}
