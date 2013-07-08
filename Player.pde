class Player{
  int x, y; //location on the grid
  
  Player(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  void render(int c1, int c2){
    noStroke();
    fill(c1);
    rect(getScreenX(x),getScreenY(y),gridSize,gridSize);
    
    fill(c2);
    text("Player",getScreenX(x),getScreenY(y)-15);
  }
  
  void render(int c){
    render(c,c);
  }
  
  Room closestRoom(ArrayList<Room> roomList){
    Room closestRoom = null;
    
    for (Room r : roomList){
      if ( closestRoom == null || dist(x,y,r.getCamX(),r.getCamY()) < dist(x,y,closestRoom.getCamX(),closestRoom.getCamY()) ){
        closestRoom = r;
      }
    }
    
    if (closestRoom == null){
      print("oooooops");
      return new Room(0,0,0,0,0,0); //no rooms available... return a generic room
    }
    
    return closestRoom;
  }
}
