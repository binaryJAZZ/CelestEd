//an interactive button
class Button{
  int x, y;
  String t, name, altName;
  int mainColor, selectColor, highlightColor;
  boolean selected;
  
  public Button(int x, int y, String name, String altName, int mainColor, int selectColor, int highlightColor){
    this.x = x;
    this.y = y;
    this.name = name;
    this.altName = altName;
    this.t = name;
    this.mainColor = mainColor;
    this.selectColor = selectColor;
    this.highlightColor = highlightColor;
  }
  
  public Button(int x, int y, String name, String altName){
    this(x,y,name,altName,lineColor,backgroundColor,altColor);
  }
  
  public Button(int x, int y, String name){
    this(x,y,name,name,lineColor,backgroundColor,altColor);
  }
  
  public void render(){
    int rectColor, textColor;
    if (collision()){
      rectColor = highlightColor;
      textColor = mainColor;
    }
    else if (selected){
      rectColor = selectColor;
      textColor = mainColor;
    }
    else{
      rectColor = mainColor;
      textColor = selectColor;
    }
    
    strokeWeight(1);
    stroke(textColor);
    
    fill(rectColor);
    rect(x,y,10+(t.length()*7),15);
    
    fill(textColor);
    textAlign(LEFT,TOP);
    text(t,5+x,y);
  }
  
  public int getWidth(){
    return 10+(t.length()*7);
  }
  
  public boolean collision(){
    return ( mouseX > x && mouseX < x+getWidth() && mouseY > y && mouseY < y+15 );
  }
  
  public boolean update(){
    if (mousePressed && collision()){
      selected = !selected;
      
      if (t == name){
        t = altName;
      }
      else{
        t = name;
      }
    }
    return selected;
  }
}
