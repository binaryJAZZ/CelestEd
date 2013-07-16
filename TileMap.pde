//a data structure for storing a layer of tiles
//made up of an ArrayList (for easy access) 
//and a 2D Hashmap (for spatial representation)
class TileMap{
  String name; //the name of this tile map
  ArrayList<Tile> tileList = new ArrayList<Tile>();
  HashMap<Integer, HashMap> tileMap = new HashMap<Integer, HashMap>();
  
  TileMap(String name){
    this.name = name;
  }
  
  boolean addTile(Integer x, Integer y, int tilesheetIndex, int tileIndex){ //add a new tile (returns true if successful)
    //check to see if there is an open space in the map
    if (tileMap.containsKey(y)){
      HashMap<Integer, Tile> rowMap = tileMap.get(y);
      if (rowMap.containsKey(x)){
        //there is ALREADY a tile here! return false
       // println("Already a tile there");
        return false;
      }
      else{
        //ROW exists, but the TILE does not: create it!
        Tile newTile = new Tile(x, y, tilesheetIndex, tileIndex);
        tileList.add(newTile);
        rowMap.put(x, newTile);
        //success!
        return true;
      }
    }
    else{
      //NO row AND no tile: create both!
      HashMap<Integer, Tile> newRow = new HashMap<Integer, Tile>();
      tileMap.put(y, newRow);
      
      Tile newTile = new Tile(x, y, tilesheetIndex, tileIndex);
      tileList.add(newTile);
      
      newRow.put(x, newTile);
      
      //success
      return true;
    } 
    
  }
  
  boolean removeTile(Integer x, Integer y){ //remove a tile at a location (if successfully removed, returns true)
    if (tileMap.containsKey(y)){
      HashMap<Integer, Tile> rowMap = tileMap.get(y);
      if (rowMap.containsKey(x)){
        tileList.remove(rowMap.get(x));
        rowMap.remove(x);
        return true; //success!
      }
    }
    return false; //failure :(
  }
  
  Tile getTile(Integer x, Integer y){
    if (tileMap.containsKey(y)){
      HashMap<Integer, Tile> rowMap = tileMap.get(y);
      if (rowMap.containsKey(x)){
        return rowMap.get(x); //success!
      }
    }
    return null; //failure :(
  }
      
  void render(){ //draw all the tiles in this map
    Tile[] tileArray = tileList.toArray(new Tile[tileList.size()]);
    for (Tile t : tileArray){
      t.render();
    }
  }
  
  void render(int c){ //draw all the tiles in this map, with a specific color!
    for (Tile t : tileList){
      t.render(c);
    }
  }
  
  int size(){
    return tileList.size();
  }
  
  String stringExport(int startX, int startY, int endX, int endY){ //return this tile map in text form (to be outputted in a level file)
    String newLine = "\n";
    String baseIndent = "\t\t";
    
    String s = baseIndent + "/** " + newLine;
    s += baseIndent + " * " + name + " layer " + newLine;
    s += baseIndent + " * tilesheet: " + drawer.getSheetName(tileList.get(0)) + " " + newLine;
    s += baseIndent + " */ " + newLine;
    s += baseIndent + "protected static var " + name + ":Array = new Array( " + newLine;
    
    //all the stuff in the array goes here
    for (int y = startY; y < endY; y++){
      s += baseIndent + "\t";
      
      Integer keyY = new Integer(y);
      
      for (int x = startX; x < endX; x++){
        Integer keyX = new Integer(x);
        Tile t = getTile(x,y);
        String seperator = ", ";
        if (x == endX-1 && y == endY-1){
          seperator = "";
        }
        
        if (t != null){ //get the number associated with this tile
          s += t.toString() + seperator;
        }
        else{ //default option
          s += "0" + seperator;
        }
      }
      
      s += newLine;
    }
    
    s += baseIndent + "); " + newLine;
    
    return s;
  }
  
  void stringImport(String layerInfo, int tilesheetIndex){ //generate tiles from a string
    //println(layerInfo);
    //println(tilesheetIndex);
    
    tileList = new ArrayList<Tile>();
    tileMap = new HashMap<Integer, HashMap>();
    
    int x = 0;
    int y = 0;
    
    for (String curLine : layerInfo.split("\n")){
      //println(curLine);
      
      for (String tileStr : curLine.split(",")){
        //println(x + "," + y);
        
        tileStr = tileStr.replace("\t","").replace(" ","");
        //println(tileStr);
        
        try{
          //println("Add title");
          addTile(new Integer(x), new Integer(y), tilesheetIndex, Integer.parseInt(tileStr));
        }
        catch(Exception e){
          println("not a valid int conversion");
        }
        
        x++;
      }
      
      x = 0;
      y++;
    }
  }
}
