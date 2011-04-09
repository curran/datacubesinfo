
//values used for Node.type
int RESOURCE = 0;
int TRIPLE = 1;

class Node{
  float x;
  float y;
  String name;
  int type; //must be either RESOURCE or TRIPLE
  boolean selected = false;
  Rectangle rect;
  Node(int type,float x,float y,String name){
    this.type = type; this.x = x; this.y = y; this.name = name;
    this.rect = new Rectangle();//set when drawing
  }
}
class Resource extends Node{
  Resource(float x,float y,String name){
    super(RESOURCE,x,y,name);
  }
}
class Triple extends Node{
  String subject;
  //String predicate; <-- is super.name
  String object;

  Triple(float x,float y,String subject,String predicate,String object){
    super(TRIPLE,x,y,predicate);
    this.subject = subject;
    this.object = object;
  }
}

