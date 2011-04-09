class Color{
  int r; int g; int b;
  public Color(int r,int g,int b){
    this.r = r; this.g = g; this.b = b;
  }
}
class Circle{
  int x; int y; int radius; Color color;
  public Circle(int x,int y, int radius,Color color){
    this.x = x; this.y = y; this.radius = radius; this.color = color;
  }
}
HashMap circles = new HashMap();
double t = 0;
void setup(){
  background(0);
}
void draw(){
  fill(0,5);
  rect(0,0,width,height);
  Iterator it = circles.entrySet().iterator();
  while(it.hasNext()){
    Circle circle = it.next().getValue();
    int size = circle.radius * 2;
    int r = circle.color.r;
    int g = circle.color.g;
    int b = circle.color.b;
    fill(r,g,b);
    ellipseMode(CENTER);
    ellipse(circle.x,circle.y,size,size);
  }
}
void touchStart(e){
  for(int i=0;i<e.changedTouches.length;i++){
    var touch = e.changedTouches[i];
    int touchId = touch.identifier;
    int touchX = touch.pageX; int touchY = touch.pageY;
    var r = (sin(t++)/2.0+0.5)*255;
    var g = (sin(t*1.3)/2.0+0.5)*255;
    var b = (sin(t*1.4)/2.0+0.5)*255;
    Color color = new Color(r,g,b);
    circles.put(touchId, new Circle(touchX,touchY,60,color));
  }
} 
void touchMove(e){
  for(int i=0;i<e.changedTouches.length;i++){
    var touch = e.changedTouches[i];
    int touchId = touch.identifier;
    Circle circle = circles.get(touchId);
    circle.x = touch.pageX; circle.y = touch.pageY;
  }
} 
void touchEnd(e){
  for(int i=0;i<e.changedTouches.length;i++){
    var touch = e.changedTouches[i];
    int touchId = touch.identifier;
    circles.remove(touchId);
  }
} 
