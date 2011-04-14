class Circle{
  Point point; Point velocity = new Point(); 
  int radius; Color color;
  String labelText = "Test";
  public Circle(int x,int y, int radius,Color color){
    point = new Point(x,y); this.radius = radius; this.color = color;
  }
  public Circle(int x,int y, int radius,Color color, String labelText){
    point = new Point(x,y); this.radius = radius; this.color = color;
    this.labelText = labelText;
  }
}
