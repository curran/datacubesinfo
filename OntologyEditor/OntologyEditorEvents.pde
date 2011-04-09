void mousePressed(){
  if(userIsSelectingTripleSubject)
    for(int i=0;i<nodes.length;i++)
      if(nodes[i].rect.containsPoint(mouseX,mouseY)
         && nodes[i].type == RESOURCE){
        newTriplePromptForName(nodes[i]);
        return;
      }
  if(userIsSelectingTripleObject)
    for(int i=0;i<nodes.length;i++)
      if(nodes[i].rect.containsPoint(mouseX,mouseY)
         && nodes[i].type == RESOURCE){
        newTripleCreate(nodes[i]);
        return;
      }

  Node mousePressedOnNode;
  for(int i=0;i<nodes.length;i++){
    var n = nodes[i];
    if(n.rect.containsPoint(mouseX,mouseY)){
      mousePressedOnNode = n;
      break;
    }
  }
  if(mousePressedOnNode){
    if(!mousePressedOnNode.selected){
      for(int i=0;i<nodes.length;i++){
        var n = nodes[i];
        n.selected = false;
      }
      mousePressedOnNode.selected = true;
    }
    nodesBeingDragged = true;
  }
  else{
    selectionRect.set(mouseX,mouseY,mouseX+1,mouseY+1)
    selectionBeingMade = true;
    for(int i=0;i<nodes.length;i++)
      nodes[i].selected = false;
  }
  redraw();
}
void mouseDragged(){
  if(selectionBeingMade){
    selectionRect.setX2andY2(mouseX,mouseY)
    tempSelectionRect.setToRectangle(selectionRect);
    tempSelectionRect.ensurePositiveArea();
    for(int i=0;i<nodes.length;i++){
      var n = nodes[i];
      n.selected = tempSelectionRect.intersects(n.rect);
    }
  }
  else if(nodesBeingDragged)
  {
    float dx = mouseX - pmouseX, dy = mouseY - pmouseY;
    for(int i=0;i<nodes.length;i++){
      Node n = nodes[i];
      if(n.selected){
        n.x += dx;
        n.y += dy;
      }
    }
  }
  redraw();
}
void mouseReleased(){
  selectionBeingMade = false;
  nodesBeingDragged = false;
  redraw();
}
void mouseClicked(){
  for(int i=0;i<nodes.length;i++){
    var n = nodes[i];
    n.selected = n.rect.containsPoint(mouseX,mouseY)
  }
}
void mouseMoved(){
  if(userIsSelectingTripleSubject)
    redraw();
}
void keyPressed() {
  if (key == 78 || key == 40)
    deleteSelectedNodes();
}

