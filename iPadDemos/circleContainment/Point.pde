class Point{
  double x; double y;
  public Point(){ x = y = 0; }
  public Point(double x, double y){
    this.x = x; this.y = y;
  }
  public Point(Point point){
    this.x = point.x; this.y = point.y;
  }
  public void zero(){ x = y = 0; }
  public void set(double x, double y){
    this.x = x; this.y = y;
  }
}
