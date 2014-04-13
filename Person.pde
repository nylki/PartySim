// copyright 2014: Tom Brewe
// this file belongs to the project partySim
// partySim is licenced under GPL 3 (see LICENCE.txt)

class Person {
  PVector location;
  PVector velocity;
  PVector acceleration;
  IntDict idealDistances;
  String name;
  color c;
  float heading;

  Person(String _name, PVector _location) {
    this.location = _location;
    // check if initial position is very close to the table, then set it somewhere else
    // this should run too often. so its alright we'll just try a new random location
    // in other circumstances (bigger tables), we'd want to set the position differently to avoid
    // very long loops
    while(PVector.dist(table.getClosestTablePosition(location), location) < 50){
      location = new PVector(random(width), random(height));
    }
      
    
    
    this.name = _name;
    c = color(random(255), random(255), random(255));
    idealDistances = new IntDict();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    heading = 0;
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y);
    fill(0, 128);
    text(name, 0, 15);
    rotate(heading);
    fill(c);
    ellipse(0, 0, 15, 15);
    fill(200, 100, 100);
    ellipse(5, 0, 10, 10);

    popMatrix();
  }

  void checkWalls() {
    //check left and right walls
    if (location.x > width - 20) {
      velocity.div(random(1, 1.1));
      acceleration.add(-0.004, 0, 0);
    }
    else if (location.x < 20) {
      velocity.div(random(1, 1.1));
      acceleration.add(0.004, 0, 0);
    }

    // check top and bottom walls
    if (location.y > height - 20) {
      velocity.div(random(1, 1.1));
      acceleration.add(0, -0.004, 0);
    }
    else if (location.y < 20) {
      velocity.div(random(1, 1.1));
      acceleration.add(0, 0.004, 0);
    }
  }

  public void checkTable() {
    if (table == null) return;

    float idealDistance = idealDistances.get("table");
    PVector tablePosition = table.getClosestTablePosition(this.location);
    PVector direction = PVector.sub(tablePosition, this.location);

    //float distance = direction.mag();
    float distance = PVector.dist(tablePosition, this.location);
    direction.normalize();

    // calculating the force. it will be towards a person, if the actual distance is higher than the ideal
    // it will be from a person away if the actual distance is closer than the ideal one
    distance = constrain(distance, 2, 400);
    float delta = (distance - idealDistance) + 1; // +1 to avoid multiplikation by 0
    PVector force = PVector.mult(direction, delta);



    force.normalize();
    // table has more influence on position than other people
    force.div(2000);


    acceleration.add(force);
    // if too close to table accelerate away
    if (distance < 10) {
      velocity.div(random(1, 1.3));
      acceleration.add(PVector.mult(direction, -0.005));
    }
  }

  void update() {
    acceleration.mult(0);

    //for every other person add forces to either push or pull them
    for (Person p : persons) {
      if (p == this) continue;

      float idealDistance = idealDistances.get(p.name);
      PVector direction = PVector.sub(p.location, this.location);

      //float distance = direction.mag();
      float distance = PVector.dist(p.location, this.location);
      direction.normalize();

      // calculating the force. it will be towards a person, if the actual distance is higher than the ideal
      // it will be from a person away if the actual distance is closer than the ideal one
      distance = constrain(distance, 5, 400);
      float delta = (distance - idealDistance) + 1; // +1 to avoid multiplikation by 0
      PVector force = PVector.mult(direction, delta);
      force.normalize();
      force.div(2500);
      acceleration.add(force);
    }
    checkTable();
    checkWalls();
    velocity.add(acceleration);
    // limit walking speed
    velocity.limit(0.35);

    location.add(velocity);
    heading = velocity.heading();
  }
}
