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
  // base is made of 4 rectangles that cap off the bottoms of the pyramids, connecting the inner and the outer
  
  UGeometry[] rectangles = {UPrimitive.rect(baseProportion, wallThickness),
                            UPrimitive.rect(baseProportion, wallThickness),
                            UPrimitive.rect(wallThickness, baseProportion),
                            UPrimitive.rect(wallThickness, baseProportion)};
                            
  // UPrimitive's rectangles only take a width and a height, so to position them in space we need to translate                   
  UVec3 positions[] = {new UVec3(0, -baseProportion + wallThickness, 0),
                       new UVec3(0, baseProportion - wallThickness, 0),
                       new UVec3(baseProportion - wallThickness, 0, 0),
                       new UVec3(-baseProportion + wallThickness, 0, 0)};
                       
  for (int i = 0; i < rectangles.length; i++) {
    rectangles[i].translate(positions[i]);
    model.add(rectangles[i]); 
  }
}

int gridOffset(int d) {
  return (baseProportion - wallThickness * 2) * 2 * d;
}

void build() {
  model = new UGeometry();
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) {
      float peakAngle = random(25, 65); // steepness of the pyramd
      model.translate(gridOffset(x), gridOffset(y), 0);
      drawPyramid(baseProportion, peakAngle); // outer pyramid
      drawPyramid(baseProportion - (wallThickness * 2), peakAngle); // inner
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

