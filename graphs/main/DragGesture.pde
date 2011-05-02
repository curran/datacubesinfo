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
