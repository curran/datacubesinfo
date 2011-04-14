int numCircles = 15;
double minRadius = 5;
double maxRadius = 70;
double fudgeFactor = 0;
double dampeningFactor = 0.95;
double pullTowardCenterForce = 0.001;
double dragPullForce = 0.2;
double dragExtraDampening = 0.7;

Circle outerCircle;
ArrayList circles = new ArrayList();/*<Circle>*/
HashMap pendingDragGestures = new HashMap();/*<int touchId,DragGesture>*/
PFont labelFont;
void setup(){
  background(0);
  frameRate(30);
  labelFont = loadFont("Times New Roman");
  textFont(labelFont, 32); 
}
void addCircle(String label,double size){
    int max = 200;
    int r = random(max); int g = random(max); int b = random(max);
    Color color = new Color(r,g,b);
    double x = random(width); double y = random(height);
    double area = size / 100000;
    double radius = sqrt(area);
    circles.add(new Circle(x,y,radius,color,label));
}
void initCircles(){
  double centerX = width/2; double centerY = height/2;
  double outerRadius = min(width/2,height/2);
  Color outerColor = new Color(100,100,100);
  outerCircle = new Circle(centerX, centerY, outerRadius, outerColor);
  outerCircle.dRadius = 0;//this field is the rate of change of the radius
}
boolean firstDraw = true;
void draw(){
  if(firstDraw){
    firstDraw = false;
    initCircles();
  }
  fill(0);
  rect(0,0,width,height);

  //draw the outer circle
  drawCircle(outerCircle);

  //draw the inner circles
  for(int i = 0;i<circles.size();i++){
    Circle circle = circles.get(i);
    drawCircle(circle);
    drawCircleLabel(circle);
  }

  incrementLayout();
}
void drawCircle(Circle circle){
  Color color = circle.color;
  Point point = circle.point;
  int size = circle.radius * 2;
  fill(color.r,color.g,color.b);
  ellipseMode(CENTER);
  ellipse(point.x,point.y,size,size);
}
void drawCircleLabel(Circle circle){
  Color color = circle.color;
  Point point = circle.point;
  fill(255);
  textSize(32);
  double labelWidth = textWidth(circle.labelText);
  textAlign(CENTER,CENTER);
  textSize(62*circle.radius/labelWidth);
  text(circle.labelText, point.x, point.y);
}
void incrementLayout(){
  int n = circles.size();
  applyForces();
  incrementVelocities();
  dragCircles();
  bounceOffWalls();
  //pullTowardCenter();
  incrementOuterCircleForces();
  //repelFromLabelLine();
}
void incrementOuterCircleForces(){
  outerCircle.dRadius -= 2;
  outerCircle.radius += (outerCircle.dRadius *= 0.8);
  //Repel circles from outer circle 
  int n = circles.size();
  for(int i = 0; i < n; i++)
  {
    Circle circle = circles.get(i);
    double dx = circle.point.x - outerCircle.point.x;
    double dy = circle.point.y - outerCircle.point.y;
    double d = sqrt(dx*dx + dy*dy) + circle.radius;
    double unitX = dx/d;
    double unitY = dy/d;
    double force = -1/(1+pow(2,(outerCircle.radius - d)*2));
    circle.velocity.x += unitX * force;
    circle.velocity.y += unitY * force;
    outerCircle.dRadius -= force;
  }
}
void applyForces(){
  //Repel adjacent circles using the sigmoid function
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
//void repelFromLabelLine(){
//  for(int i = circles.size()-1;i>=0;i--){
//    Circle circle = circles.get(i);
//    double dy = circle.point.y - circle.radius - labelLineY;
//    double force = 1/(1+pow(2,(dy*2)));
//    circle.velocity.y += force;
//  }
//}
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
