import unlekker.modelbuilder.*;

UGeometry model;

int baseSquareSize;
int thickness;
int gridSize;

void setup() {
  size(800,800,P3D);
  
  baseSquareSize = 100;
  thickness = 7;
  gridSize = 4;
  
  build();
}

void draw() {
  background(255);
  noFill();
  
  // rotate the canvas when the mouse moves
  rotateX(map(mouseY, 0, height, -PI/2, PI/2));
  rotateY(map(mouseX, 0, width, -PI/2, PI/2));
  
  // start in the middle
  translate(width/2, height/2, 0);
  
  model.draw(this);
}

void drawPyramid(int t, float a) {  
  // the pyramid has 4 sides, each drawn as a separate triangle made of 3 vertices
  // the parameter "t" determines the size (height?) of the pyramid
  
  float h = zPoint(t, a); // (t)*tan(radians(a));
  
  model.beginShape(TRIANGLES);
  
  println("t: "+t);
  println("baseSquareSize: "+baseSquareSize);
  
  UVec3[] s1 = {new UVec3(-t,-t,-baseSquareSize), new UVec3( t,-t,-baseSquareSize), new UVec3(0, 0, h)};
  UVec3[] s2 = {new UVec3(t,-t,-baseSquareSize), new UVec3(t, t,-baseSquareSize), new UVec3(0, 0, h)};
  UVec3[] s3 = {new UVec3(t, t,-baseSquareSize), new UVec3(-t, t,-baseSquareSize), new UVec3(0, 0, h)};
  UVec3[] s4 = {new UVec3(-t, t,-baseSquareSize), new UVec3(-t,-t,-baseSquareSize), new UVec3(0, 0, h)};
  
  model.addFace(s1);
  model.addFace(s2);
  model.addFace(s3);
  model.addFace(s4);
  model.endShape();
}

void drawBase(int t) { 
  UGeometry r1, r2, r3, r4;
  UVec3 pos1 = new UVec3(0, -baseSquareSize+thickness, -baseSquareSize);
  r1 = UPrimitive.rect(baseSquareSize, thickness);
  r1.translate(pos1);
  
  UVec3 pos2 = new UVec3(0, baseSquareSize-thickness, -baseSquareSize);
  r2 = UPrimitive.rect(baseSquareSize, thickness);
  r2.translate(pos2);
  
  UVec3 pos3 = new UVec3(baseSquareSize-thickness, 0, -baseSquareSize);
  r3 = UPrimitive.rect(thickness, baseSquareSize);
  r3.translate(pos3);
  
  UVec3 pos4 = new UVec3(-baseSquareSize+thickness, 0, -baseSquareSize);
  r4 = UPrimitive.rect(thickness, baseSquareSize);
  r4.translate(pos4);

  model.add(r1);
  model.add(r2);
  model.add(r3);
  model.add(r4);
}

public void keyPressed() {
  if(key=='s') {
    model.writeSTL(this, "Pyramids.stl");
    println("STL written");
  }
}

int gridOffset(int d) {
  return (baseSquareSize-thickness*2)*2*d;
}

float zPoint(int baseWidth, float angle) {
  println("angle in degrees: "+angle);
  println("angle in radians: "+radians(angle));
  println("tan of the radians: "+tan(radians(angle)));
  println("baseWidth: "+baseWidth);
  return (baseWidth)*tan(radians(angle));
}


void build() {
  model = new UGeometry();
  for (int x=0; x<gridSize; x++) {
    for (int y=0; y<gridSize; y++) {
      float randAngle = (pow(random(65), 2))/65;
      // steepness of the pyramd, using exponents to create more extreme variation, capped at 65 so it doesn't get too steep

      model.translate(gridOffset(x), gridOffset(y), 0);
      drawPyramid(baseSquareSize, randAngle);
      drawPyramid(baseSquareSize - (thickness*2), randAngle); //FIX the angle
      drawBase(baseSquareSize);
      model.translate(gridOffset(-x), gridOffset(-y), 0); // reset it back to the center
    }
  }
}

