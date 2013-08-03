int enemyCounter = 0;

class Enemy{
  int x, y; //location on the grid
  ArrayList<Waypoint> waypoints = new ArrayList<Waypoint>();
  int ID;
  
  Enemy(int x, int y){
    this.x = x;
    this.y = y;
    this.waypoints.add(new Waypoint(x,y)); //first waypoint is at its starting position
    
    this.ID = enemyCounter;
    enemyCounter++;
  }
  
  void render(int c1, int c2){
    noStroke();
    fill(c1);
    rect(getScreenX(x),getScreenY(y),gridSize,gridSize);
    
    fill(c2);
    text("Enemy",getScreenX(x),getScreenY(y)-15);
  }
  
  void render(int c){
    render(c,c);
  }
  
  void renderWaypoints(int c){
    Waypoint prevWaypoint = null;
    
    for (Waypoint w : waypoints){
      if (prevWaypoint != null){
        strokeWeight(2);
        stroke(c);
        line(getScreenX(prevWaypoint.x)+gridSize*0.5, getScreenY(prevWaypoint.y)+gridSize*0.5, getScreenX(w.x)+gridSize*0.5, getScreenY(w.y)+gridSize*0.5);
      }
      
      w.render(c);
      
      prevWaypoint = w;
    }
  }
  
  void renderWaypoints(int c1, int c2){
    Waypoint prevWaypoint = null;
    int curIndex = 0;
    
    for (Waypoint w : waypoints){
      if (prevWaypoint != null){
        strokeWeight(2);
        stroke(c1);
        line(getScreenX(prevWaypoint.x)+gridSize*0.5, getScreenY(prevWaypoint.y)+gridSize*0.5, getScreenX(w.x)+gridSize*0.5, getScreenY(w.y)+gridSize*0.5);
      }
      
      w.render(c1, c2, curIndex);
      
      prevWaypoint = w;
      curIndex++;
    }
  }
  
  void renderFOV(int c, float fovWidth){
    Waypoint prevWaypoint = null;
    int curIndex = 0;
    
    for (Waypoint w : waypoints){
      if (prevWaypoint != null){
        strokeWeight(fovWidth);
        stroke(c);
        line(getScreenX(prevWaypoint.x)+gridSize*0.5, getScreenY(prevWaypoint.y)+gridSize*0.5, getScreenX(w.x)+gridSize*0.5, getScreenY(w.y)+gridSize*0.5);
      }
      
      prevWaypoint = w;
      curIndex++;
    }
  }
  
  boolean hasWaypoint(int x, int y){
    boolean has = false;
    
    for (Waypoint w : waypoints){
      if (w.x == x && w.y == y){
        has = true;
      }
    }
    
    return has;
  }
  
  void addWaypoint(int x, int y){
    waypoints.add(new Waypoint(x,y));
  }
  
  void removeWaypoint(int x, int y){
    Waypoint waypointToRemove = null;
    
    for (Waypoint w : waypoints){
      if (w.x == x && w.y == y){
        waypointToRemove = w;
      }
    }
    
    if (waypointToRemove != null){
      waypoints.remove(waypointToRemove);
    }
  }
  
  String toString(int tileSize, int tileShiftX, int tileShiftY, int indentDepth){
    String indentString = "";
    for (int i = 0; i < indentDepth; i++){
      indentString += "\t";
    }
    
    String enemyString = indentString + "var waypointList" + ID + ": Vector.<FlxPoint> = new Vector.<FlxPoint>(); \n\n";
    
    for (Waypoint w : waypoints){
      enemyString += indentString + "waypointList" + ID + ".push(" + w.toString(tileSize, tileShiftX, tileShiftY) + "); \n";
    }
    
    enemyString += "\n";
    
    //NOTE 4
    enemyString += indentString + "enemyLight = new Light(Assets.LightImageClass, FlxG.width*3/ 4, FlxG.height/ 4, darkness, 0xFFFFFFFF); add(enemyLight); enemyLight.scale=new FlxPoint(0.75,0.75);\n\n";
    
    enemyString += indentString + "var enemy" + ID + ":Enemy = new Enemy(waypointList" + ID + ", player, enemyLight, " + (float(tileShiftX + x)*tileSize) + ", " + (float(tileShiftY + y)*tileSize) + "); \n";
    enemyString += indentString + "enemies.push(enemy" + ID + "); \n\n";
    
    return enemyString;
  }
}
