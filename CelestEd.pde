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
int dragScreenX = 0; //what grid square is the user grabbing in order to move the screen?
int dragScreenY = 0;
boolean isDraggingScreen = false;

//window size
final static int WIN_X = 800;
final static int WIN_Y = 600;

//colors
int backgroundColor = color(65, 100, 160); //blue
int lineColor = color(255, 255, 255); //white
int altColor = color(245,209,79); //gold
int wallColor = color(0,0,0,150); //transparent black
int floorColor = color(255,255,255,150); //transparent white
int drawerColor = color(15,45,95); //dark blue
int deleteColor = color(185,22,22); //dark red
int altColor2 = color(0,0,0); //black

//grid
int gridSize = 32; //the width & height of one square on the grid
int minGridSize = 8;
int maxGridSize = 128;

//tiles
TileMap floors = new TileMap("FLOORS");
TileMap foreground = new TileMap("FOREGROUND");
TileMap walls = new TileMap("WALLS");
TileMap[] tileMapList = {floors, foreground, walls};

//loading tilesheets
String[] supportedFileTypes = {"png", "jpg", "gif"};
ArrayList<Tilesheet> tilesheets = new ArrayList<Tilesheet>();

//level boundaries
int topEdge, bottomEdge, leftEdge, rightEdge;

//rooms
ArrayList<Room> roomList = new ArrayList<Room>();
Room selectedRoom;
boolean isMakingRoom = false;
int selectedCorner = -1;

//UI
Button hideOptions;
ArrayList<Button> optionsButtons = new ArrayList<Button>();
TileDrawer drawer;
Button saveButton, openButton;
Button toolSelector, layerSelector, enemyModeSelector;
Button hideCollisionMap, hideLevelBounds, hideGrid, hideTextures, hideRooms, hideTileDrawer, hidePlayer, hideEnemies, hideWaypoints;

//player and enemies
Player playerStart = new Player(0,0);
ArrayList<Enemy> enemyList = new ArrayList<Enemy>();
Enemy selectedEnemy = null;

void setup(){
  size(WIN_X, WIN_Y);
  
  noSmooth(); //turn off anti-aliasing
  
  background(backgroundColor);
  
  loadTilesheets(sketchPath + "/tilesheets");
  
  drawer = new TileDrawer(0,int(WIN_Y*0.8),WIN_X,int(WIN_Y*0.2), 32, tilesheets);
  
  initButtons();
}

void draw(){
  //clear screen
  background(backgroundColor);
  
  //all tiles
  if (!hideTextures.isSelected()){
    floors.render();
    foreground.render();
    walls.render();
  }
  if (!hideCollisionMap.isSelected()){
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
  if (!hideLevelBounds.isSelected()){
    drawLevelBoundary(altColor);
  }
  
  //grid lines
  if (!hideGrid.isSelected()){
    drawGrid(lineColor);
  }
  
  //player
  if (!hidePlayer.isSelected()){
    if (toolSelector.isSelected(2)){
      playerStart.render(lineColor);
    }
    else {
      playerStart.render(floorColor);
    }
  }
  
  //enemies
  if (!hideEnemies.isSelected()){
    for (Enemy e : enemyList){
      if (toolSelector.isSelected(3)){ 
        if (e == selectedEnemy){
          e.render(altColor);
          if (!hideWaypoints.isSelected()){
            e.renderWaypoints(altColor,lineColor);
          }
        }
        else{
          e.render(altColor2);
          if (!hideWaypoints.isSelected()){
            e.renderWaypoints(altColor2);
          }
        }
      }
      else{
        e.render(wallColor);
        if (!hideWaypoints.isSelected()){
          e.renderWaypoints(wallColor);
        }
      }
    }
  }
  
  //rooms
  if (!hideRooms.isSelected()){
    updateRooms();
  }
  
  //cursor
  drawCursor();
  
  //mouse coordinates
  fill(lineColor);
  textAlign(LEFT,TOP);
  text("(" + getGridX() + "," + getGridY() + ")", 0, 0);
  
  //current tile
  if (toolSelector.isSelected(0)){
    stroke(lineColor);
    fill(color(0,0,0));
    strokeWeight(4);
    rect(WIN_X - 64 - 2, 2, 64, 64);
    image(tilesheets.get(drawer.currentTilesheetIndex).tileImages[drawer.currentTileIndex], WIN_X - 64 - 2, 2, 64, 64);
  }
  
  //UI
  saveButton.render();
  openButton.render();
  
  toolSelector.render();
  if (toolSelector.isSelected(0)){
    layerSelector.render();
  }
  else if (toolSelector.isSelected(3)){
    enemyModeSelector.render();
  }
  
  hideOptions.render();
  if (!hideOptions.isSelected()){
    for (Button b : optionsButtons){
      b.render();
    }
  }
  
  //drawer
  if (!hideTileDrawer.isSelected()){
    drawer.render(drawerColor, lineColor);
  }
  
  //drag screen around
  if (isDraggingScreen && mousePressed){
    camX += dragScreenX - getGridX();
    camY += dragScreenY - getGridY();
  }
}

void keyPressed(){
  if (key == 'w') camY--;
  if (key == 's') camY++;
  if (key == 'a') camX--;
  if (key == 'd') camX++;
  
  if (key == '-' && gridSize > minGridSize) gridSize /= 2;
  if (key == '=' && gridSize < maxGridSize) gridSize *= 2;
  
  if (key == ' ') isDraggingScreen = true;
}

void keyReleased(){
  if (key == ' ') isDraggingScreen = false;
}

void mousePressed(){
  boolean buttonPress = userInterface();
  
  if (!buttonPress){
    if (isDraggingScreen){
      dragScreenX = getGridX();
      dragScreenY = getGridY();
    }
    else if (toolSelector.isSelected(0)){
      //make a tile
      editTiles();
    }
    else if (toolSelector.isSelected(1)){
      if (!hideRooms.isSelected()){
        editRooms();
      }
    }
    else if (toolSelector.isSelected(2)){
      //change player location
      playerStart.x = getGridX();
      playerStart.y = getGridY();
    }
    else if (toolSelector.isSelected(3)){
      editEnemies();
    }
  }
}

void editRooms(){
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

void editEnemies(){
  if (enemyModeSelector.isSelected(0)){
    //add, select, remove enemies
    Enemy existingEnemy = null;
    for (Enemy e : enemyList){
      if (e.x == getGridX() && e.y == getGridY()){
        existingEnemy = e;
      }
    }
    
    if (existingEnemy == null){
      selectedEnemy = new Enemy(getGridX(), getGridY());
      enemyList.add(selectedEnemy);
    }
    else if (existingEnemy == selectedEnemy){
      enemyList.remove(existingEnemy);
      selectedEnemy = null;
    }
    else{
      selectedEnemy = existingEnemy;
    }
  }
  else if (enemyModeSelector.isSelected(1)){
    //add and remove waypoints
    if (selectedEnemy != null){
      if (!(getGridX() == selectedEnemy.x && getGridY() == selectedEnemy.y)){ //you can't get rid of the initial waypoint
        if (selectedEnemy.hasWaypoint(getGridX(), getGridY())){
          selectedEnemy.removeWaypoint(getGridX(), getGridY());
        }
        else{
          selectedEnemy.addWaypoint(getGridX(), getGridY());
        }
      }
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
  
  buttonPress = !hideTileDrawer.isSelected() && drawer.collision();
  
  if (hideOptions.collision()){
    hideOptions.update();
    buttonPress = true;
  }
  
  if (!hideOptions.isSelected()){
    for (Button b : optionsButtons){
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
  
  if (toolSelector.collision()){
    toolSelector.update();
    buttonPress = true;
    
    if (toolSelector.isSelected(0)){
      hideTileDrawer.setIndex(0);
      hideRooms.setIndex(1);
      hidePlayer.setIndex(1);
      hideEnemies.setIndex(1);
      hideWaypoints.setIndex(1);
    }
    else if (toolSelector.isSelected(1)){
      hideTileDrawer.setIndex(1);
      hideRooms.setIndex(0);
      hidePlayer.setIndex(1);
      hideEnemies.setIndex(1);
      hideWaypoints.setIndex(1);
    }
    else if (toolSelector.isSelected(2)){
      hideTileDrawer.setIndex(1);
      hideRooms.setIndex(1);
      hidePlayer.setIndex(0);
      hideEnemies.setIndex(0);
      hideWaypoints.setIndex(1);
    }
    else if (toolSelector.isSelected(3)){
      hideTileDrawer.setIndex(1);
      hideRooms.setIndex(1);
      hidePlayer.setIndex(0);
      hideEnemies.setIndex(0);
      hideWaypoints.setIndex(0);
    }
  }
  
  if (toolSelector.isSelected(0) && layerSelector.collision()){
    layerSelector.update();
    buttonPress = true;
  }
  
  if (toolSelector.isSelected(3) && enemyModeSelector.collision()){
    enemyModeSelector.update();
    buttonPress = true;
  }
  
  return buttonPress;
}

void editTiles(){
  //update level boundaries
  boolean noTilesYet = (walls.size() == 0 && floors.size() == 0 && foreground.size() == 0);
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
  TileMap tileMap = tileMapList[layerSelector.getIndex()];
  
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
    
    //WRITE LEVEL DATA
    String className = fileOut.getName().replace(".as","");
    int tileSize = tilesheets.get(floors.tileList.get(0).tilesheetIndex).tileSize;
    int levelWidth = rightEdge-leftEdge+1;
    int levelHeight = bottomEdge-topEdge+1;
    //the distance from the top left corner to the (0,0) point
    int tileShiftX = -1 * leftEdge;
    int tileShiftY = -1 * topEdge;
    
    //the header of the flash source file
    output.print("/**\n * Initialization code: new "+className+"(new FlxPoint("+(levelWidth*tileSize*2)+", "+(levelHeight*tileSize*2)+"),new FlxPoint("+tileSize+", "+tileSize+"));\n * tilesize: "+tileSize+"\n */\n");
    //^the '*2' in the map size is just for safety
    output.print("package\n{\n\timport org.flixel.*;\n\tpublic class "+className+" extends TopDownLevel\n\t{\n");
    
    //the arrays for the tile maps
    output.print(floors.stringExport(leftEdge, topEdge, rightEdge+1, bottomEdge+1));
    output.print("\n");
    output.print(walls.stringExport(leftEdge, topEdge, rightEdge+1, bottomEdge+1));
    output.print("\n");
    output.print(foreground.stringExport(leftEdge, topEdge, rightEdge+1, bottomEdge+1));
    output.print("\n");
    
    //initialize variables
    output.print("\t\tprotected var decalGroup:FlxGroup;\n");
    output.print("\t\tprotected var objectGroup:FlxGroup;\n\n");
    
    output.print("\t\tprivate var darkness:FlxSprite;\n");
    output.print("\t\tprivate var playerLight:Light;\n\n");
    
    output.print("\t\tprivate var enemyController:EnemyController;\n\n");
    
    //the constructor
    output.print("\t\tpublic function "+className+"(levelSize:FlxPoint, blockSize:FlxPoint):void {\n");
    output.print("\t\t\tsuper(levelSize, blockSize, new FlxPoint("+((tileShiftX+float(playerStart.x)+0.5)*tileSize)+","+((tileShiftY+float(playerStart.y)+0.5)*tileSize)+"));\n");
    output.print("\t\t}\n\n");
    
    //function for creating the map based on the arrays
    output.print("\t\toverride protected function createMap():void {\n\t\t\tvar tiles:FlxTilemap;\n\n");
    
    output.print("\t\t\ttiles = new FlxTilemap();\n\t\t\ttiles.loadMap(\n");
    output.print("\t\t\t\tFlxTilemap.arrayToCSV(FLOORS, "+levelWidth+"),\n");
    output.print("\t\t\t\tAssets.FLOORS_TILE, tileSize.x, tileSize.y, 0, 0, 0, uint.MAX_VALUE\n\t\t\t);\n");
    output.print("\t\t\tfloorGroup.add(tiles);\n\n");
    
    output.print("\t\t\ttiles = new FlxTilemap();\n\t\t\ttiles.loadMap(\n");
    output.print("\t\t\t\tFlxTilemap.arrayToCSV(WALLS, "+levelWidth+"),\n");
    output.print("\t\t\t\tAssets.WALLS_TILE, tileSize.x, tileSize.y\n\t\t\t);\n");
    output.print("\t\t\twallGroup.add(tiles);\n\n");
    
    output.print("\t\t\tdarkness = new FlxSprite(0,0);\n\t\t\tdarkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);\n");
    output.print("\t\t\tdarkness.scrollFactor.x = darkness.scrollFactor.y = 0;\n\t\t\tdarkness.blend = \"multiply\";\n");
    output.print("\t\t\tplayerLight = new Light(Assets.LightImageClass, FlxG.width / 2, FlxG.height / 2, darkness);\n");
    
    //room data
    output.print("\n");
    output.print("\t\t\t//room data");
    output.print("\n");
    for (Room r : roomList){
      output.print("\t\t\t");
      output.print(r.toString(tileSize, tileShiftX, tileShiftY));
      output.print("\n");
    }
    output.print("\n");
    for (Room r : roomList){
      output.print("\t\t\t");
      output.print(r.neighborsToString());
      output.print("\n");
    }

    output.print("\t\t\tcurrRoom = room"+playerStart.closestRoom(roomList).ID+"; //replace with room of your choice\n");
    output.print("\t\t\tfocusOnCurrRoom();\n\n");
    
    output.print("\t\t\tcreateObjects();\n\t\t}\n\n");
    
    //function for creating objects
    output.print("\t\tprotected function createObjects():void {\n\t\t\tvar sprite:FlxSprite;\n\t\t\tdecalGroup = new FlxGroup();\n\t\t\tobjectGroup = new FlxGroup();\n\t\t}\n\n");
    
    //function for initializing the player
    output.print("\t\toverride protected function createPlayer():void {\n\t\t\tplayer = new Player(playerStart.x, playerStart.y);\n\t\t}\n\n");
    
    //function for creating the GUI
    output.print("\t\toverride protected function createGUI():void {\n\t\t}\n\n");
    
    //function for adding all the object groups - order determines how things are draw
    output.print("\t\toverride protected function addGroups(): void {\n");
    output.print("\t\t\tadd(floorGroup);\n");
    output.print("\t\t\tadd(wallGroup);\n");
    output.print("\t\t\tadd(decalGroup);\n");
    output.print("\t\t\tadd(objectGroup);\n");
    output.print("\t\t\tadd(player);\n");
    output.print("\t\t\tadd(player.mySprite);\n");
    
    //enemies get inserted here for some reason
    output.print("\n");
    output.print("\t\t\tvar enemies:Vector.<Enemy> = new Vector.<Enemy>();\n");
    output.print("\t\t\tvar light5:Light = new Light(Assets.LightImageClass, FlxG.width*3/ 4, FlxG.height/ 4, darkness, 0xFFFFFFFF);\n");
    output.print("\t\t\tadd(light5);\n\n");
    
    for (Enemy e : enemyList){
      output.print(e.toString(tileSize, tileShiftX, tileShiftY, 3));
    }
    output.print("\t\t\tenemyController = new EnemyController(enemies);\n");
    output.print("\t\t\tadd(enemyController);\n\n");
    
    output.print("\t\t\tadd(playerLight);\n");
    output.print("\t\t\tadd(darkness);\n");
    output.print("\t\t\tadd(guiGroup);\n");
    output.print("\t\t}\n\n");
    
    //drawing function
    output.print("\t\toverride public function draw():void {\n\t\t\tdarkness.fill(0xff000000);\n\t\t\tsuper.draw();\n\t\t}\n\n");
    
    //transfer level function
    output.print("\t\toverride public function transferLevel(): TopDownLevel{\n\t\t\treturn null;\n\t\t}\n\n");
    
    //update function
    output.print("\t\toverride public function update():void {\n\t\t\tsuper.update();\n\t\t}\n\n");
    
    //normal gameplay function
    output.print("\t\toverride public function normalGameplay():void {\n\t\t\tsuper.normalGameplay();\n");
    output.print("\t\t\tplayerLight.x = (player.x+player.width/2);\n\t\t\tplayerLight.y = (player.y-player.height/2);\n");
    output.print("\t\t\tFlxG.collide(objectGroup, player);\n\n");
    output.print("\t\t\tvar enemyMessage:int = enemyController.commandEnemies();\n");
    output.print("\t\t}\n");
    
    //end of flash source file
    output.print("\t}\n}");
    
    output.flush(); //write remaing data
    output.close(); //finish the file
  }
  catch(Exception e){
    println("cannot save this map... that sucks");
  }
}

void loadMap(File fileIn){
  try{
    int tileSize = 16; //default is 16
    String layerName = "";
    String tilesheetName = "";
    String arrayStr = "";
    boolean readingMapArray = false;
    ArrayList<Room> newRoomList = new ArrayList<Room>();
    ArrayList<Enemy> newEnemyList = new ArrayList<Enemy>();
    ArrayList<Waypoint> waypointList = new ArrayList<Waypoint>();
    
    //String mapFileStr = "";
    for (String curLine : loadStrings(fileIn.getAbsolutePath())){
      //println(curLine);
      String[] curWords = curLine.replace("\t","").split(" "); //split on whitespace
      
      //println(curWords.length);
      //println(curWords[0]);
      
      if (curWords.length > 3 && curWords[2].equals("tilesize:")){
        tileSize = Integer.parseInt(curWords[3]);
        //println(tileSize);
      }
      
      if (curWords.length > 3 && curWords[0].equals("super(levelSize,")){
        //player starting position
        String[] playerStartStr = splitTokens(curWords[3], "()")[1].split(",");
        playerStart.x = int(Float.parseFloat(playerStartStr[0])/tileSize);
        playerStart.y = int(Float.parseFloat(playerStartStr[1])/tileSize);
      }
      
      if (curWords.length > 1 && curWords[0].split("List")[0].equals("waypoint")){
        //found a waypoint!
        String[] waypointStr = splitTokens(curWords[1], "()")[1].split(",");
        waypointList.add(new Waypoint(int(Float.parseFloat(waypointStr[0])/tileSize), int(Float.parseFloat(waypointStr[1])/tileSize)));
      }
      
      
      if (curWords.length > 0 && curWords[0].split("\\(")[0].equals("enemies.push")){
        //found an enemy!
        Enemy newEnemy = new Enemy(waypointList.get(0).x, waypointList.get(0).y);
        
        for (int i = 1; i < waypointList.size(); i++){
          newEnemy.addWaypoint(waypointList.get(i).x, waypointList.get(i).y);
        }
        
        //add enemy to list
        newEnemyList.add(newEnemy);
        
        //clear the waypoint list
        waypointList = new ArrayList<Waypoint>();
      }
      
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
            else if (layerName.equals("FOREGROUND")){
              //println("importing walls " + tilesheetName);
              foreground.stringImport(arrayStr, i);
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
    enemyList = newEnemyList;
    selectedEnemy = null;
  }
  catch(Exception e){
    println("can't load the map... dang");
  }
  
  for (Room r : roomList){
    r.findNeighbors(roomList);
  }
  recalculateLevelBounds();
  
  //hax
  mousePressed = false;
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
  if (toolSelector.isSelected(0)){
    //tile cursor
    strokeWeight(4);
    stroke(lineColor);
    if (layerSelector.isSelected(2)){
      fill(wallColor);
    }
    else{
      fill(floorColor);
    }
    rect(getScreenX(getGridX()), getScreenY(getGridY()), gridSize, gridSize);
  }
  else if (toolSelector.isSelected(1)){
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

void initButtons(){
  saveButton = new Button(0,30,"Export To File");
  openButton = new Button(0,45,"Import From File");
  
  
  toolSelector = new Button(0,75,new String[]{"Switch tool (TILES)","Switch tool (ROOMS)","Switch tool (PLAYER)","Switch tool (ENEMY)"});
  layerSelector = new Button(0,90,new String[]{"Switch layer (FLOOR)","Switch layer (FOREGROUND)","Switch layer (WALL)"});
  enemyModeSelector = new Button(0,90,"Switch mode (ENEMY)","Switch mode (WAYPOINT)");
  
  hideOptions = new Button(0,120, "Hide Options", "Show Options");
  hideOptions.setIndex(1);
  
  hideCollisionMap = new Button(0,135,"Hide Collision Map","Show Collision Map");
  optionsButtons.add(hideCollisionMap);
  hideCollisionMap.setIndex(1);
  
  hideLevelBounds = new Button(0,150,"Hide Level Bounds","Show Level Bounds");
  optionsButtons.add(hideLevelBounds);
  hideLevelBounds.setIndex(1);
  
  hideGrid = new Button(0,165,"Hide Grid","Show Grid");
  optionsButtons.add(hideGrid);
  
  hideTextures = new Button(0,180,"Hide Textures","Show Textures");
  optionsButtons.add(hideTextures);
  
  hideRooms = new Button(0,195,"Hide Rooms", "Show Rooms");
  optionsButtons.add(hideRooms);
  hideRooms.setIndex(1);
  
  hideTileDrawer = new Button(0,210,"Hide Tile Drawer","Show Tile Drawer");
  optionsButtons.add(hideTileDrawer);
  
  hidePlayer = new Button(0,225,"Hide Player Start","Show Player Start");
  optionsButtons.add(hidePlayer);
  hidePlayer.setIndex(1);
  
  hideEnemies = new Button(0,240,"Hide Enemies","Show Enemies");
  optionsButtons.add(hideEnemies);
  hideEnemies.setIndex(1);
  
  hideWaypoints = new Button(0,255,"Hide Enemy Waypoints","Show Enemy Waypoints");
  optionsButtons.add(hideWaypoints);
  hideWaypoints.setIndex(1);
}
