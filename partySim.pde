// copyright 2014: Tom Brewe
// this file belongs to the project partySim
// partyPlaner is licenced under GPL 3 (see LICENCE.txt)

/* this processing script simulates a party.
   the table represents a common meeting place, like a barTable.
   Each person likes to be in a certain distance to any of the other guests,
   which results in dynamic movements of the guests.
   
   This simulation is inspired by Rich Gold's (Richard Goldstein) Party Planner from 1982,
   which used a 20x30 grid and plotted every simulation step onto a piece of paper.
   PartySim actually uses the ideal distance values of Rich Golds Program, aswell as the guests names.
   
   For more info on the original Party Planner from 1982 see:
   [1] Richard Goldstein, The Plenitude, 2002, http://hci.stanford.edu/dschool/resources/ThePlenitude.pdf , p. 91-94
   [2] Ine Hinterwaldner, Das systemische Bild, Munich 2010, p. 214-221
*/


import java.util.Map;
ArrayList<Person> persons;
BarTable table;

void setup(){
  size(600,400, P2D);
  smooth(5);
  frameRate(60);
 
  // multiplying original values from Rich Gold's table with 20
 // relations are still the same 
 
  table = new BarTable(new PVector(random(width) - 50, random(height)-50)); 
  persons = new ArrayList<Person>();
  Person a = new Person("arthur", new PVector(random(width), random(height)));
  a.idealDistances.set("bernie", 300);
  a.idealDistances.set("dennis", 140);
  a.idealDistances.set("millie", 40);
  a.idealDistances.set("penelope", 120);
  a.idealDistances.set("susan", 180);
  a.idealDistances.set("viola", 80);
  a.idealDistances.set("wally", 240);
  a.idealDistances.set("table", 20);
  persons.add(a);
  
  Person b = new Person("bernie", new PVector(random(width), random(height)));
  b.idealDistances.set("arthur", 160);
  b.idealDistances.set("dennis", 120);
  b.idealDistances.set("millie", 80);
  b.idealDistances.set("penelope", 120);
  b.idealDistances.set("susan", 60);
  b.idealDistances.set("viola", 40);
  b.idealDistances.set("wally", 200);
  b.idealDistances.set("table", 20);
  persons.add(b);
  
  Person d = new Person("dennis", new PVector(random(width), random(height)));
  d.idealDistances.set("arthur", 220);
  d.idealDistances.set("bernie", 80);
  d.idealDistances.set("millie", 100);
  d.idealDistances.set("penelope", 240);
  d.idealDistances.set("susan", 40);
  d.idealDistances.set("viola", 180);
  d.idealDistances.set("wally", 120);
  d.idealDistances.set("table", 20);
  persons.add(d);
  
  Person m = new Person("millie", new PVector(random(width), random(height)));
  m.idealDistances.set("arthur", 220);
  m.idealDistances.set("bernie", 80);
  m.idealDistances.set("dennis", 100);
  m.idealDistances.set("penelope", 240);
  m.idealDistances.set("susan", 40);
  m.idealDistances.set("viola", 180);
  m.idealDistances.set("wally", 120);
  m.idealDistances.set("table", 100);
  persons.add(m);
  
  Person p = new Person("penelope", new PVector(random(width), random(height)));
  p.idealDistances.set("arthur", 60);
  p.idealDistances.set("bernie", 200);
  p.idealDistances.set("dennis", 100);
  p.idealDistances.set("millie", 240);
  p.idealDistances.set("susan", 220);
  p.idealDistances.set("viola", 140);
  p.idealDistances.set("wally", 300);
  p.idealDistances.set("table", 100);
  persons.add(p);
  
  Person s = new Person("susan", new PVector(random(width), random(height)));
  s.idealDistances.set("arthur", 240);
  s.idealDistances.set("bernie", 40);
  s.idealDistances.set("dennis", 80);
  s.idealDistances.set("millie", 160);
  s.idealDistances.set("penelope", 100);
  s.idealDistances.set("viola", 240);
  s.idealDistances.set("wally", 80);
  s.idealDistances.set("table", 20);
  persons.add(s);
  
  Person v = new Person("viola", new PVector(random(width), random(height)));
  v.idealDistances.set("arthur", 140);
  v.idealDistances.set("bernie", 160);
  v.idealDistances.set("dennis", 240);
  v.idealDistances.set("millie", 200);
  v.idealDistances.set("penelope", 80);
  v.idealDistances.set("susan", 260);
  v.idealDistances.set("wally", 60);
  v.idealDistances.set("table", 100);
  persons.add(v);
  
  
  Person w = new Person("wally", new PVector(random(width), random(height)));
  w.idealDistances.set("arthur", 120);
  w.idealDistances.set("bernie", 140);
  w.idealDistances.set("dennis", 160);
  w.idealDistances.set("millie", 120);
  w.idealDistances.set("penelope", 60);
  w.idealDistances.set("susan", 160);
  w.idealDistances.set("viola", 180);
  w.idealDistances.set("table", 100);
  persons.add(w);
}

void draw(){
  background(128);
  
  if(table != null) table.display();
  for(Person p : persons){
   p.update();
   p.display(); 
  }
  
}

void mouseClicked(){
  table = new BarTable(new PVector(mouseX - 50, mouseY-50)); 
}
