

//global settings
int fontSize = 16;
int rectHorizontalMargin = 8;
PFont arial;

//variables for selection and dragging
Rectangle selectionRect = new Rectangle(0,0,0,0);
Rectangle tempSelectionRect = new Rectangle(0,0,0,0);
boolean selectionBeingMade = false;
boolean nodesBeingDragged = false;

//reused temporary variables
NodeStyle nodeStyle;
Rectangle nodeRect = new Rectangle();

//variables for triple creation flow
boolean userIsSelectingTripleSubject = false;
Node           selectedTripleSubject;
String         selectedTriplePredicate;
boolean userIsSelectingTripleObject = false;

void setup()
{
  size(1920,1080);
  noLoop();

  smooth();

  arial = loadFont( "arial.svg" );
  textFont( arial, fontSize );
/*
  Resource a = new Resource(50,100,"A");
  Resource b = new Resource(150,100,"B");
  Triple c = new Triple( 100,100, "A","hasParent","B");
  addNode(a);
  addNode(b);
  addNode(c);*/
}



void draw()
{
  background(255);

  //compute the updated node rectangles
  for(int i=0;i<nodes.length;i++){
    var n = nodes[i];
    float x = n.x, y = n.y;
    float tw = rectHorizontalMargin+arial.width(n.name)*fontSize;
    float th = fontSize*1.3;
    n.rect.set(x-rectHorizontalMargin/2-tw/2, y-th/2,
               x+rectHorizontalMargin/2+tw/2, y+th/2);
  }

  //draw the triple edges
  for(int i=0;i<nodes.length;i++){
    var n = nodes[i];
    if(n.type == TRIPLE){
      Node s = nodesByName[n.subject];
      Node o = nodesByName[n.object];
      line(s.x,s.y,n.x,n.y);

      float theta = atan2(n.y-o.y,o.x-n.x)-PI/2;
      float a = o.rect.h/2;
      float b = o.rect.w/2;
      float r = a*b/sqrt(pow(b*cos(theta),2)+pow(a*sin(theta),2));
      float px = sin(theta)*r+o.x;
      float py = cos(theta)*r+o.y;

      line(n.x,n.y,px,py);

      //draw the arrowhead
      fill(0,0,0);
      translate(px,py);
      rotate(-theta);
      quad(-5,15,0,0,5,15,0,10);
      rotate(theta);
      translate(-px,-py);
    }
  }


  //draw the resource and triple nodes
  for(int i=0;i<nodes.length;i++){
    var n = nodes[i];
    float x = n.x, y = n.y;
    float w = n.rect.w;
    float h = n.rect.h;

    //set the style
    if(n.type == RESOURCE) nodeStyle = resourceNodeStyle;
    else if(n.type == TRIPLE) nodeStyle = tripleNodeStyle;

    //draw the ellipse
    if(n.selected) nodeStyle.selectedShapeStyle.apply();
    else nodeStyle.defaultShapeStyle.apply();
    n.rect.drawAsEllipse();

    //draw the text
    if(n.selected) nodeStyle.selectedTextStyle.apply();
    else nodeStyle.defaultTextStyle.apply();
    text(n.name, x-w/2+rectHorizontalMargin, y-h/2);
  }
  if(selectionBeingMade){
    noFill();
    stroke(100);
    selectionRect.draw();
  }
  if(userIsSelectingTripleSubject){
    fill(0,0,0);
    text("Subject?",mouseX,mouseY+20);
  }
  else if(userIsSelectingTripleObject){
    fill(0,0,0);
    text("Object?",mouseX,mouseY+20);
  }
}

void newResource(String name){
  addNode(new Resource(pmouseX,pmouseY,name));
  redraw();
}
void newTriple(){
  userIsSelectingTripleSubject = true;
  redraw();
}
void newTriplePromptForName(Resource subject){
  userIsSelectingTripleSubject = false;
  selectedTripleSubject = subject;
  selectedTriplePredicate = window.prompt("Predicate?", "");
  userIsSelectingTripleObject = true;
  redraw();
}
void newTripleCreate(Resource object){
  alert("in newTripleCreate");
  userIsSelectingTripleObject = false;
  Resource subject = selectedTripleSubject;

  float x = (subject.x+object.x)/2;
  float y = (subject.y+object.y)/2;

  addNode(new Triple(x,y,subject.name,selectedTriplePredicate,object.name));
  redraw();
}
void editSelected(){
  for(int i=0;i<nodes.length;i++){
    var n = nodes[i];
    if(n.rect.containsPoint(mouseX,mouseY))
      n.name = window.prompt("New Name?",n.name);
  }
  redraw();
}
void save(){
  $.post("../ontology/save",{name:ontologyName,json:JSON.stringify(nodes)},
    function(data){
      if(data == "success")
        alert("Save successful!")
      else
        alert(data);
    }
  );
}
void load(String ontologyNameToLoad){
  ontologyName = ontologyNameToLoad
  $.get("../ontology/load",{name:ontologyName},
    function(data){
      var newNodes = JSON.parse(data,function(key,value){
        if(key == "rect"){
          Rectangle rect = new Rectangle();
          rect.setToRectangle(key);
          return rect;
        }
        return value;
      });
      clearNodes();
      for(int i=0;i<newNodes.length;i++)
        addNode(newNodes[i]);
      redraw();
    }
  );
}

