int numCircles = 20;
double minRadius = 5;
double maxRadius = 100;
double fudgeFactor = 0;
double dampeningFactor = 0.9;
double pullTowardCenterForce = 0.001;
double dragPullForce = 0.2;
double dragExtraDampening = 0.7;

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
  Point previousPoint; //the previous frame's location of the touch
  public DragGesture(Circle circle, Point circleStart, Point dragStart){
    this.circle = circle;
    this.circleStart = circleStart;
    this.dragStart = dragStart;
    this.previousPoint = new Point(dragStart);
  }
}
ArrayList circles = new ArrayList();/*<Circle>*/
HashMap pendingDragGestures = new HashMap();/*<int touchId,DragGesture>*/
void setup(){
  background(0);
}
void initCircles(){
  for(int i=0;i<numCircles;i++){
    int r = random(255); int g = random(255); int b = random(255);
    Color color = new Color(r,g,b);
    double x = random(width); double y = random(height);
    double radius = random(minRadius,maxRadius);
    circles.add(new Circle(x,y,radius,color));
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
  //draw the circles
  for(int i = 0;i<circles.size();i++){
    Circle circle = circles.get(i);
    Color color = circle.color;
    Point point = circle.point;
    int size = circle.radius * 2;
    fill(color.r,color.g,color.b);
    ellipseMode(CENTER);
    ellipse(point.x,point.y,size,size);
  }
  incrementLayout();
}
void incrementLayout(){
  int n = circles.size();
  applyForces();
  incrementVelocities();
  dragCircles();
  bounceOffWalls();
  pullTowardCenter();
}
void applyForces(){
  int n = circles.size();
  for(int i = 0; i < n; i++){
    for(int j = i + 1; j < n; j++){
      Circle a = circles.get(i);
      Circle b = circles.get(j);
      double dx = b.point.x - a.point.x;
      double dy = b.point.y - a.point.y;
      double d2 = dx*dx + dy*dy;
      double cutoffD = (a.radius + b.radius)+10;
      if(d2 < cutoffD * cutoffD){
        double d = sqrt(d2);
        double unitX = dx/d;
        double unitY = dy/d;
        double optimalD = a.radius + b.radius + n * fudgeFactor;
        double x = d/optimalD;
        //using sigmoid is the key to stopping incessant jitter!
        double force = -1/(1+pow(2,((d - optimalD)*2)));
  
        a.velocity.x += unitX * force;
        a.velocity.y += unitY * force;
        b.velocity.x -= unitX * force;
        b.velocity.y -= unitY * force;
      }
    }
  }
}
void incrementVelocities(){
  int n = circles.size();
  for(int i = 0; i < n; i++){
    Circle circle = circles.get(i);
    circle.point.x += (circle.velocity.x *= dampeningFactor);
    circle.point.y += (circle.velocity.y *= dampeningFactor);
  }
}
void bounceOffWalls(){
  for(int i = 0; i < circles.size(); i++){
    Circle circle = circles.get(i);
    if(circle.point.x - circle.radius < 0){
      circle.point.x = circle.radius;
      circle.velocity.x = abs(circle.velocity.x);
    }
    else if(circle.point.x + circle.radius > width){
      circle.point.x = width - circle.radius;
      circle.velocity.x = -abs(circle.velocity.x);
    }
    if(circle.point.y - circle.radius < 0){
      circle.point.y = circle.radius;
      circle.velocity.y = abs(circle.velocity.y);
    } 
    else if(circle.point.y + circle.radius > height){
      circle.point.y = height - circle.radius;
      circle.velocity.y = -abs(circle.velocity.y);
    }
  }
}
void dragCircles(){
  Iterator it = pendingDragGestures.entrySet().iterator();
  while(it.hasNext()){
    DragGesture drag = it.next().getValue();
    double dx = drag.previousPoint.x - drag.dragStart.x;
    double dy = drag.previousPoint.y - drag.dragStart.y;
    double nextCircleX = drag.circleStart.x + dx;
    double nextCircleY = drag.circleStart.y + dy;
    drag.circle.velocity.x += (nextCircleX - drag.circle.point.x)*dragPullForce;
    drag.circle.velocity.y += (nextCircleY - drag.circle.point.y)*dragPullForce;
    drag.circle.velocity.x *= dragExtraDampening;
    drag.circle.velocity.y *= dragExtraDampening;
  }
}
void pullTowardCenter(){
  int n = circles.size();
  double centerX = width/2;
  double centerY = height/2;
  for(int i = 0; i < n; i++){
    Circle circle = circles.get(i);
    double dx = centerX - circle.point.x;
    double dy = centerY - circle.point.y;
    double d = sqrt(dx*dx + dy*dy);
    d = d > 1 ? 1 : d;
    double unitX = dx/d;
    double unitY = dy/d;
    circle.velocity.x += d * unitX * pullTowardCenterForce;
    circle.velocity.y += d * unitY * pullTowardCenterForce;
  }
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
    if(drag != null)
      drag.previousPoint.set(touch.pageX, touch.pageY);
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
