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
}
class Color{
  int r; int g; int b;
  public Color(int r,int g,int b){
    this.r = r; this.g = g; this.b = b;
  }
}
class Circle{
  Point point; Point velocity = new Point(); 
  int radius; Color color;
  public Circle(int x,int y, int radius,Color color){
    point = new Point(x,y); this.radius = radius; this.color = color;
  }
}
class DragGesture{
  Circle circle; //the circle being dragged
  Point circleStart; //the initial location of the circle
  Point dragStart; //the initial location of the touch
  public DragGesture(Circle circle, Point circleStart, Point dragStart){
    this.circle = circle;
    this.circleStart = circleStart;
    this.dragStart = dragStart;
  }
}
ArrayList circles = new ArrayList();/*<Circle>*/
HashMap pendingDragGestures = new HashMap();/*<int touchId,DragGesture>*/
double t = 0;//"time", used for generating distinct colors
void setup(){
  background(0);
}
void initCircles(){
  int n = 12;//put 12 circles randomly around the display
  for(int i=0;i<n;i++){
    var r = (sin(t++)/2.0+0.5)*255;
    var g = (sin(t*1.3)/2.0+0.5)*255;
    var b = (sin(t*1.4)/2.0+0.5)*255;
    Color color = new Color(r,g,b);
    int x = random(width);
    int y = random(height);
    circles.add(new Circle(x,y,60,color));
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
  for(int i = 0;i<circles.size();i++){
    Circle circle = circles.get(i);

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
  incrementLayout();
}
void incrementLayout(){
  int n = circles.size();
  //Step 1 of 2: Apply forces to all pairs
  for(int i = 0; i < n; i++){
    for(int j = i + 1; j < n; j++){
      Circle a = circles.get(i);
      Circle b = circles.get(j);
      double dx = b.point.x - a.point.x;
      double dy = b.point.y - a.point.y;
      double d = sqrt(dx*dx + dy*dy);
      double unitX = dx/d;
      double unitY = dy/d;
      double force = (d-200)*0.01;
      a.velocity.x += unitX * force;
      a.velocity.y += unitY * force;
      b.velocity.x -= unitX * force;
      b.velocity.y -= unitY * force;
    }
  }
  //Step 2 of 2: Increment and dampen velocities
  double dampeningFactor = 0.9;
  for(int i = 0; i < n; i++){
    Circle circle = circles.get(i);
    if(!circleIsBeingDragged(circle)){
      circle.point.x += (circle.velocity.x *= dampeningFactor);
      circle.point.y += (circle.velocity.y *= dampeningFactor);
    }
  }
}
boolean circleIsBeingDragged(Circle circle){
  Iterator it = pendingDragGestures.entrySet().iterator();
  while(it.hasNext())
    if(it.next().getValue().circle == circle)
      return true;
  return false;
}
Circle getCircleUnderPoint(int x, int y){
  for(int i = circles.size()-1;i>=0;i--){
    Circle circle = circles.get(i);
    double dx = x-circle.point.x;
    double dy = y-circle.point.y;
    double d = sqrt(dx*dx+dy*dy);
    if(d < circle.radius)
      return circle;
  }
  return null;
}
void touchStart(e){
  for(int i=0;i<e.changedTouches.length;i++){
    var touch = e.changedTouches[i];
    var touchId = touch.identifier;
    Circle circleUnderPoint = getCircleUnderPoint(touch.pageX,touch.pageY);
    if(circleUnderPoint != null){
      Point circleStart = new Point(circleUnderPoint.point);
      Point dragStart = new Point(touch.pageX,touch.pageY);
      DragGesture drag = new DragGesture(circleUnderPoint,circleStart,dragStart);
      pendingDragGestures.put(touchId,drag);
    }
  }
} 
void touchMove(e){
  for(int i=0;i<e.changedTouches.length;i++){
    var touch = e.changedTouches[i];
    int touchId = touch.identifier;
    DragGesture drag = pendingDragGestures.get(touchId);
    if(drag != null){
      double dx = touch.pageX - drag.dragStart.x;
      double dy = touch.pageY - drag.dragStart.y;
      drag.circle.point.x = drag.circleStart.x + dx;
      drag.circle.point.y = drag.circleStart.y + dy;
      drag.circle.velocity.zero();
    }
  }
} 
void touchEnd(e){
  for(int i=0;i<e.changedTouches.length;i++){
    var touch = e.changedTouches[i];
    int touchId = touch.identifier;
    DragGesture drag = pendingDragGestures.get(touchId);
    if(drag != null)
      pendingDragGestures.remove(touchId);
  }
} 
