class Boid {
  // main fields
  PVector pos;
  PVector move;
  float maxSpeed = 2.1;
  float shade;
  ArrayList<Boid> friends;

  // timers
  int thinkTimer = 0;

  // class stuff
  float friendRadius = 60;
  float crowdRadius = friendRadius / 2.0;
  float avoidRadius = 120;

  Boid (float xx, float yy) {
    move = new PVector(0, 0);
    pos = new PVector(0, 0);
    pos.x = xx;
    pos.y = yy;
    thinkTimer = int(random(10));
    shade = random(255);
    friends = new ArrayList<Boid>();
  }

  void go () {
    increment();
    wrap();

    if (thinkTimer ==0 ) {
      // update our friend array (lots of square roots)
      getFriends();
    }
    flock();
    pos.add(move);
  }

  void flock () {
    PVector allign = getAverageDir();
    PVector avoidDir = getAvoidDir(); 
    PVector avoidObjects = getAvoidAvoids();
    PVector noise = new PVector(random(2) - 1, random(2) -1);

    allign.mult(1.5);
    avoidDir.mult(1);
    avoidObjects.mult(2);
    noise.mult(0.05);

    stroke(0, 255, 160);

    move.add(allign);
    move.add(avoidDir);
    move.add(avoidObjects);
    move.add(noise);

    move.limit(maxSpeed);
  }

  void getFriends () {
    ArrayList<Boid> nearby = new ArrayList<Boid>();
    for (int i =0; i < boids.size(); i++) {
      Boid test = boids.get(i);
      if (abs(test.pos.x - this.pos.x) < friendRadius &&
        abs(test.pos.y - this.pos.y) < friendRadius) {
        nearby.add(test);
      }
    }
    friends = nearby;
  }

  PVector getAverageDir () {
    PVector sum = new PVector(0, 0);
    int count = 0;

    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < friendRadius)) {
        PVector copy = other.move.copy();
        copy.normalize();
        copy.div(d); 
        sum.add(copy);
        count++;
      }
      if (count > 0) {
        //sum.div((float)count);
      }
    }
    return sum;
  }

  PVector getAvoidDir() {
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < crowdRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    if (count > 0) {
      //steer.div((float) count);
    }
    return steer;
  }
  
  PVector getAvoidAvoids() {
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Avoid other : avoids) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < avoidRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    if (count > 0) {
      //steer.div((float) count);
    }
    return steer;
  }

  void draw () {
    for ( int i = 0; i < friends.size(); i++) {
      Boid f = friends.get(i);
      stroke(90);
      //line(this.pos.x, this.pos.y, f.pos.x, f.pos.y);
    }
    noStroke();
    fill(shade, 40, 170);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(move.heading());
    beginShape();
    vertex(10, 0);
    vertex(-5, 5);
    vertex(-5, -5);
    endShape(CLOSE);
    popMatrix();
   
  }

  // update all those timers!
  void increment () {
    thinkTimer = (thinkTimer + 1) % 5;
  }

  void wrap () {
    pos.x = (pos.x + width) % width;
    pos.y = (pos.y + height) % height;
  }
}