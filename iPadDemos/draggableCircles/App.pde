class Point{
  double x; double y;
  public Point(double x, double y){
    this.x = x; this.y = y;
  }
  public Point(Point point){
    this.x = point.x; this.y = point.y;
  }
}
class Color{
  int r; int g; int b;
  public Color(int r,int g,int b){
    this.r = r; this.g = g; this.b = b;
  }
}
class Circle{
  Point point; int radius; Color color;
  public Circle(int x,int y, int radius,Color color){
    point = new Point(x,y); this.radius = radius; this.color = color;
  }
}
HashMap circles = new HashMap();
HashMap circlesBeingDragged = new HashMap();
HashMap dragStartingPoints = new HashMap();
HashMap circleStartingPoints = new HashMap();
double t = 0;
void setup(){
  background(0);
}
void initCircles(){
  int n = 12;
  for(int i=0;i<n;i++){
    var r = (sin(t++)/2.0+0.5)*255;
    var g = (sin(t*1.3)/2.0+0.5)*255;
    var b = (sin(t*1.4)/2.0+0.5)*255;
    Color color = new Color(r,g,b);
    int x = random(width);
    int y = random(height);
    circles.put(i, new Circle(x,y,60,color));
  }
}
boolean firstDraw = true;
void draw(){
  if(firstDraw){
    firstDraw = false;
    initCircles();
  }
  fill(0);
  rect(0,0,width,height);
  Iterator it = circles.entrySet().iterator();
  while(it.hasNext()){
    Circle circle = it.next().getValue();

    int r = circle.color.r;
    int g = circle.color.g;
    int b = circle.color.b;
    fill(r,g,b);

    double x = circle.point.x;
    double y = circle.point.y;
    int size = circle.radius * 2;
    ellipseMode(CENTER);
    ellipse(x,y,size,size);
  }
}
Circle getCircleUnderPoint(int x, int y){
  Iterator it = circles.entrySet().iterator();
  while(it.hasNext()){
    Circle circle = it.next().getValue();
    double dx = x-circle.point.x;
    double dy = y-circle.point.y;
    double d = sqrt(dx*dx+dy*dy);
    if(d < circle.radius)
      return circle;
  }
  return null;
}
void touchStart(e){
  var touch = e.changedTouches[0];
  var touchId = touch.identifier;
  Circle circleUnderPoint = getCircleUnderPoint(touch.pageX,touch.pageY);
  if(circleUnderPoint != null){
    circlesBeingDragged.put(touchId,circleUnderPoint);
    dragStartingPoints.put(touchId,new Point(touch.pageX,touch.pageY));
    circleStartingPoints.put(touchId,new Point(circleUnderPoint.point));
  }
} 
void touchMove(e){
  for(int i=0;i<e.changedTouches.length;i++){
    var touch = e.changedTouches[i];
    int touchId = touch.identifier;
    Circle circleBeingDragged = circlesBeingDragged.get(touchId);
    if(circleBeingDragged != null){
      Point dragStart = dragStartingPoints.get(touchId);
      Point circleStart = circleStartingPoints.get(touchId);
      double dx = touch.pageX - dragStart.x;
      double dy = touch.pageY - dragStart.y;
      circleBeingDragged.point.x = circleStart.x + dx;
      circleBeingDragged.point.y = circleStart.y + dy;
    }
  }
} 
void touchEnd(e){
  for(int i=0;i<e.changedTouches.length;i++){
    var touch = e.changedTouches[i];
    int touchId = touch.identifier;
    Circle circleBeingDragged = circlesBeingDragged.get(touchId);
    if(circleBeingDragged != null){
      dragStartingPoints.remove(touchId);
      circleStartingPoints.remove(touchId);
      circlesBeingDragged.remove(touchId);
    }
  }
} 
