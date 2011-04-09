int x = 0;
double t = 0;
PFont fontA;
void setup() {  
  size(400, 200);  
  fontA = loadFont("Times New Roman");  
  textFont(fontA, 32);  
} 
void draw(){
  int luminance = 255/2+(255/2)*sin(t/2);
  background(luminance);  
  stroke(255-luminance);  
  fill(255-luminance);  
  int x = sin(t)*50+width/2;
  int y = cos(t)*50+height/2;
  textAlign(CENTER,CENTER);
  text("Hello World!", x, y);
  x += sin(t*1.5)*80;
  y += cos(t*1.5)*20 - 5;
  int luminance = 255/2+(255/2)*sin(t*2);
  stroke(luminance);  
  fill(255-luminance);  
  ellipse(x,y,10,10);
  t += 0.01;  
}
