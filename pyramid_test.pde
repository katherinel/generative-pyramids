import unlekker.modelbuilder.*;

UGeometry model;

int baseProportion;
int wallThickness;
int gridSize;

void setup() {
  size(800,800,P3D);
  
  baseProportion = 100;
  wallThickness = 7;
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

void drawPyramid(int pyrSize, float peakAngle) {  
  // the pyramid has 4 sides, each drawn as a separate triangle made of 3 vertices
  // the parameter "t" determines the size (height?) of the pyramid
  
  float peak = pyrSize * tan(radians(peakAngle)); // where in space it should go based on the angle
  UVec3 peakPt = new UVec3(0, 0, peak); // top of the pyramid
  
  // four corners
  UVec3 ptA = new UVec3(-pyrSize, -pyrSize, 0);
  UVec3 ptB = new UVec3(pyrSize, -pyrSize, 0);
  UVec3 ptC = new UVec3(pyrSize, pyrSize, 0);
  UVec3 ptD = new UVec3(-pyrSize, pyrSize, 0);
  
  UVec3[][] faces = {{ptA, ptB, peakPt},
                     {ptB, ptC, peakPt},
                     {ptC, ptD, peakPt},
                     {ptD, ptA, peakPt}};
  
  model.beginShape(TRIANGLES);
  for (int i = 0; i < faces.length; i++) {
    model.addFace(faces[i]);
  }
  model.endShape();  
}

void drawBase() {
  UGeometry rect1, rect2, rect3, rect4; // base is made of 4 rectangles that cap off the bottoms of the pyramids
  
  UVec3 pos1 = new UVec3(0, -baseProportion+wallThickness, 0);
  rect1 = UPrimitive.rect(baseProportion, wallThickness);
  rect1.translate(pos1);
  
  UVec3 pos2 = new UVec3(0, baseProportion-wallThickness, 0);
  rect2 = UPrimitive.rect(baseProportion, wallThickness);
  rect2.translate(pos2);
  
  UVec3 pos3 = new UVec3(baseProportion-wallThickness, 0, 0);
  rect3 = UPrimitive.rect(wallThickness, baseProportion);
  rect3.translate(pos3);
  
  UVec3 pos4 = new UVec3(-baseProportion+wallThickness, 0, 0);
  rect4 = UPrimitive.rect(wallThickness, baseProportion);
  rect4.translate(pos4);
  
  model.add(rect1);
  model.add(rect2);
  model.add(rect3);
  model.add(rect4);
}

int gridOffset(int d) {
  return (baseProportion-wallThickness*2)*2*d;
}

void build() {
  model = new UGeometry();
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) {
      float randAngle = (pow(random(40, 65), 2))/65;
      // steepness of the pyramd, using exponents to create more extreme height variation

      model.translate(gridOffset(x), gridOffset(y), 0);
      drawPyramid(baseProportion, randAngle);
      drawPyramid(baseProportion - (wallThickness*2), randAngle); //FIX the angle
      drawBase();
      model.translate(gridOffset(-x), gridOffset(-y), 0); // reset it back to the center
    }
  }
}

public void keyPressed() {
  if(key=='s') {
    model.writeSTL(this, "Pyramids.stl");
    println("STL written");
  }
}

