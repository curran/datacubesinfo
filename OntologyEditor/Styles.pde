class ShapeStyle{
  boolean f; //fill on or off
  float fr; //fill red (0 to 255)
  float fg; //fill green (0 to 255)
  float fb; //fill blue (0 to 255)
  float fa; //fill alpha (0 to 255)
  boolean s; //stroke on or off
  float sr; //stroke red (0 to 255)
  float sg; //stroke green (0 to 255)
  float sb; //stroke blue (0 to 255)
  float sa; //stroke alpha (0 to 255)
  float sw; //stroke weight (in pixels)
  ShapeStyle(boolean f,float fr,float fg,float fb,float fa,
               boolean s,float sr,float sg,float sb,float sa,
               float sw){
    this.f = f; this.fr = fr; this.fg = fg; this.fb = fb; this.fa = fa;
    this.s = s; this.sr = sr; this.sg = sg; this.sb = sb; this.sa = sa; this.sw = sw;
  }
  void apply(){
    if(f)
      fill(fr,fg,fb,fa);
    else
      noFill();
    if(s){
      stroke(sr,sg,sb,sa);
      strokeWeight(sw);
    }
    else noStroke();
  }
}
class TextStyle{
  float r,g,b,a;
  float size;
  TextStyle(float r,float g,float b,float a,float size){
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
    this.size = size;
  }
  void apply(){
    fill(r,g,b,a);
    textSize(size);
  }
}

class NodeStyle{
  ShapeStyle defaultShapeStyle;
  ShapeStyle selectedShapeStyle;
  TextStyle defaultTextStyle;
  TextStyle selectedTextStyle;

  NodeStyle (ShapeStyle defaultShapeStyle, ShapeStyle selectedShapeStyle,
             TextStyle defaultTextStyle, TextStyle selectedTextStyle){
    this.defaultShapeStyle = defaultShapeStyle;
    this.selectedShapeStyle = selectedShapeStyle;
    this.defaultTextStyle = defaultTextStyle;
    this.selectedTextStyle = selectedTextStyle;
  }
}

/**
 * Defines the style for RDF Resource nodes.
 */
NodeStyle resourceNodeStyle = new NodeStyle(
  // defaultShapeStyle
  new ShapeStyle(
    true,255,255,255,255, // fill [on,r,g,b,a]
    false,150,150,150,255, 1),//stroke [on,r,g,b,a,weight]
  // selectedShapeStyle
  new ShapeStyle(
    true,255,255,255,255, // fill [on,r,g,b,a]
    true,150,150,150,255, 1),//stroke [on,r,g,b,a,weight]
  // defaultTextStyle
  new TextStyle(200,0,0,255,16), // [r,b,g,a,size]
  // selectedTextStyle
  new TextStyle(200,0,0,255,16) // [r,b,g,a,size]
);

NodeStyle tripleNodeStyle = new NodeStyle(
  // defaultShapeStyle
  new ShapeStyle(
    true,255,255,255,255, // fill [on,r,g,b,a]
    false,255,255,255,255, 1),//stroke [on,r,g,b,a,weight]
  // selectedShapeStyle
  new ShapeStyle(
    true,255,255,255,255, // fill [on,r,g,b,a]
    true,150,150,150,255, 1),//stroke [on,r,g,b,a,weight]
  // defaultTextStyle
  new TextStyle(0,200,150,255,16), // [r,b,g,a,size]
  // selectedTextStyle
  new TextStyle(0,200,150,255,16) // [r,b,g,a,size]
);

