// the model
var ontologyName = "default";
var nodes = [];
var nodesByName = {};

void addNode(Node n){
  nodes.push(n);
  nodesByName[n.name] = n;
}
void clearNodes(){
  nodes = [];
  nodesByName = {};
}
void deleteSelectedNodes(){
  var oldNodes = nodes;
  clearNodes();
  for(int i=0;i<oldNodes.length;i++)
    if(!oldNodes[i].selected)
      addNode(oldNodes[i]);
  redraw();
}

