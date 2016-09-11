var Vector = Victor; // just an alias. I prefer "Vector" over "Victor"
var randomColor = () => 'rgb(' + Math.round(Math.random() * 255) + ',' + Math.round(Math.random() * 255) + ',' + Math.round(Math.random() * 255) + ')';

var canvas = document.getElementById('canvas');
var ctx = canvas.getContext("2d");
var tables = [];
var persons = [];
var objects = [];
var maxWalkSpeed = 0.275;

var Table = function (name, position = [Math.random() * canvas.width, Math.random() * canvas.height]) {
	this.position = Vector.fromArray(position);
	this.name = name ? name : 'table';
	this.draw = function() {
		ctx.save();
		ctx.translate(this.position.x, this.position.y);
		ctx.fillStyle = "green";
		ctx.fillRect(0, 0, 75, 20);
		ctx.restore();
	}
}

// new Person(String, Map, Vector)
var Person = function (name, idealDistances, position = new Vector(0, 0).randomize(new Vector(40, 40), new Vector(canvas.width - 40, canvas.height - 40))) {
	this.name = name;
	this.position = position;
	this.velocity = new Vector(0, 0);
	this.acceleration = new Vector(0, 0);
	this.idealDistances = idealDistances;
	this.diameter = 15;
	this.bodyColor = randomColor();
	this.hatColor = randomColor();
	
	this.step = function () {
		this.acceleration.x = this.acceleration.y = 0;
		for (let object of objects) {
			
			/* calculating the force. it will be towards an object (person, table), if the actual distance is higher than the ideal, it will be from a person away if the actual distance is closer than the ideal one */
			
			
			let isPerson = object instanceof Person;
			if(isPerson && object === this) {
				continue;
			}
			
			let dir = object.position.clone().subtract(this.position);
			// Distance is max 400 and min 2 (guest) or 5 (table)
			let dist = Math.min(Math.max(dir.length(), isPerson ? 5 : 2), 400);
			let idealDist = this.idealDistances.get(object.name);
			let delta = 1 + dist - idealDist;

			let force = dir.normalize().multiplyScalar(delta).normalize().divideScalar(isPerson ? 2300 : 1350);

			
			// Guest/Table collision handling
			if (isPerson && dist < this.diameter * 1.9) {
				// Strengthen force moving away from eachother.
				// This works, because ideal distance is always smaller than diameter + 10.
				force.multiplyScalar(8);
			} else if (!isPerson && dist < 25) {
				force.multiplyScalar(4);
			}
			
			
			this.acceleration.add(force);
		}
		
		this.avoidWalls();
		
		/*
		Limit walking speed. Algor. adapted from: https://github.com/processing/p5.js/blob/6e1a672c04c6149bc92767e96b258786cbe5c710/src/math/p5.Vector.js#L536-L543
		*/
		this.velocity.add(this.acceleration);
		let lSq = this.velocity.lengthSq();
		if(lSq > Math.pow(maxWalkSpeed, 2)) {
			this.velocity.divideScalar(Math.sqrt(lSq)); //normalize it
			this.velocity.multiplyScalar(maxWalkSpeed);
		}
		this.heading = this.velocity.angle();
		this.position.add(this.velocity);
	}
	
	this.avoidWalls = function () {
		let antiWallAcceleration = new Vector(0, 0);
		
    //check left and right walls
    if (this.position.x > canvas.width - this.diameter) {
			antiWallAcceleration.x -= 0.004;
    }
    else if (this.position.x < this.diameter) {
      antiWallAcceleration.x += 0.004;
    }

    // check top and bottom walls
    if (this.position.y > canvas.height - this.diameter) {
			antiWallAcceleration.y -= 0.004;
    }
    else if (this.position.y < this.diameter) {
			antiWallAcceleration.y += 0.004;
    }
		
		if(antiWallAcceleration.y + antiWallAcceleration.x !== 0) {
			this.velocity.divideScalar(1.3 + (Math.random() / 10));
			this.acceleration.add(antiWallAcceleration);
				// this.acceleration.invert();
		}
		
  }

	this.draw = function() {
		
		ctx.save();
		ctx.translate(this.position.x, this.position.y);
		// draw body
		ctx.rotate(this.heading);
		ctx.beginPath();
		ctx.arc(0, 0, this.diameter, 0, 2 * Math.PI);
		ctx.fillStyle = this.bodyColor;
		ctx.fill();
		// draw hat/head
		ctx.beginPath();
		ctx.fillStyle = this.hatColor;
		ctx.arc(this.diameter * 0.65, 0, this.diameter * 0.65, 0, 2 * Math.PI);
		ctx.fill();
		ctx.restore();
	}
	
}


function step() {
	for (let p of persons) {
		p.step();
	}
	draw();
	window.requestAnimationFrame(step);
}

function draw() {
	// Drawing step (called at the end of each simulation step)
	ctx.fillStyle = 'rgb(204, 204, 204)';
	ctx.clearRect(0, 0, canvas.width, canvas.height);
	for (let object of objects) {
		object.draw();
	}
}

function init() {
	
	fetch('partyguests.json')
	.then(response => response.json())
	.then(idealDistances => {
		for (let name in idealDistances) {
			let person = new Person(name, new Map(idealDistances[name]));
			persons.push(person);
		}
	}).then(() => {
		tables.push(new Table());
		objects = [...tables, ...persons];
		console.log(objects);
		step();

	})

	
}


init();
