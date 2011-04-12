class Circle{
  Point point; Point velocity = new Point(); 
  int radius; Color color;
  public Circle(int x,int y, int radius,Color color){
    point = new Point(x,y); this.radius = radius; this.color = color;
  }
}
