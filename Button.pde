//an interactive button
class Button{
  int x, y;
  String[] textOptions;
  int[] colorOptions;
  int[] textColorOptions;
  int highlightColor;
  int curIndex;
  
  public Button(int x, int y, String[] textOptions, int[] colorOptions, int[] textColorOptions, int highlightColor){
    this.x = x;
    this.y = y;
    this.textOptions = textOptions;
    this.colorOptions = colorOptions;
    this.textColorOptions = textColorOptions;
    this.highlightColor = highlightColor;
    this.curIndex = 0;
  } 
  
  public Button(int x, int y, String[] textOptions){
    this(x, y, textOptions, new int[textOptions.length], new int[textOptions.length], altColor);
    
    for (int i = 0; i < colorOptions.length; i++){
      colorOptions[i] = lineColor;
      textColorOptions[i] = backgroundColor;
    }
  }
  
  public Button(int x, int y, String name, String altName, int mainColor, int selectColor, int highlightColor){
    this(x, y, new String[]{name, altName}, new int[]{mainColor, selectColor}, new int[]{selectColor, mainColor}, highlightColor);
  }
  
  public Button(int x, int y, String name, String altName){
    this(x, y, name, altName, lineColor, backgroundColor, altColor);
  }
  
  public Button(int x, int y, String name){
    this(x, y, name, name, lineColor, backgroundColor, altColor);
  }
  
  public void render(){
    int rectColor, textColor;
    String curText;
    
    if (collision()){
      rectColor = highlightColor;
      textColor = colorOptions[curIndex];
    }
    else{
      rectColor = colorOptions[curIndex];
      textColor = textColorOptions[curIndex];
    }
    
    curText = textOptions[curIndex];
    
    strokeWeight(1);
    stroke(textColor);
    
    fill(rectColor);
    rect(x,y,getWidth(),15);
    
    fill(textColor);
    textAlign(LEFT,TOP);
    text(curText,5+x,y);
  }
  
  public boolean update(){
    if (mousePressed && collision()){
      curIndex = nextIndex();
      return true;
    }
    return false;
  }
  
  public boolean collision(){
    return ( mouseX > x && mouseX < x+getWidth() && mouseY > y && mouseY < y+15 );
  }
    
  private int nextIndex(){
    int next = (curIndex + 1) % textOptions.length;
    return next;
  }
  
  public int getWidth(){
    return 10+(textOptions[curIndex].length()*7);
  }
  
  public boolean isSelected(int index){
    return curIndex == index;
  }
  
  public boolean isSelected(){
    return isSelected(1); //default "selected" = the second option
  }
  
  public int getIndex(){
    return curIndex;
  }
  
  public void setIndex(int index){
    curIndex = index;
  } 
}
