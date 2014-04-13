// copyright 2014: Tom Brewe
// this file belongs to the project partySim
// partyPlaner is licenced under GPL 3 (see LICENCE.txt)

class BarTable {
  PShape tableShape;
  PVector location;
  


  BarTable(PVector location_) {
    // generate vertices
    location = location_;
    tableShape = createShape();
    tableShape.beginShape();
    float x = location.x;
    float y = location.y;
    for (int i=-1; i <= 10; i++) {
      x += 10;
      tableShape.vertex(x, y);
    }

    for (int i=0; i <= 2; i++) {
      y += 10;
      tableShape.vertex(x, y);
    }

    for (int i=0; i <= 10; i++) {
      x -= 10;
      tableShape.vertex(x, y);
    }

    for (int i=0; i <= 2; i++) {
      y -= 10;
      tableShape.vertex(x, y);
    }
    tableShape.endShape();
  }

  public PVector getClosestTablePosition(PVector person) {
    float maxDist = width;
    PVector closestPosition = tableShape.getVertex(0);
    for (int i = 0; i < tableShape.getVertexCount(); i++) {
      float curDist = PVector.dist(person, tableShape.getVertex(i));
      if(curDist < maxDist){
        maxDist = curDist;
        closestPosition = tableShape.getVertex(i);
      }
    }
    return closestPosition;
  }


  
  public void display(){

   fill(255);
   shape(tableShape);

  }
    
}
