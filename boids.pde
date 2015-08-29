Boid barry;
ArrayList<Boid> boids;
ArrayList<Avoid> avoids;

String tool = "boids";

void setup () {
  size(800, 600);
  boids = new ArrayList<Boid>();
  avoids = new ArrayList<Avoid>();
  for (int i = 0; i < 1; i++) {
    boids.add(new Boid(width / 2.0 + random(3), height / 2.0 + random(3)));
  }
  
  for (int x = 0; x < width; x+= 25) {
    avoids.add(new Avoid(x, 10));
        avoids.add(new Avoid(x, height - 10));
  }
}

void draw () {
  noStroke();
  colorMode(HSB);
  fill(245, 90);
  rect(0, 0, width, height);
  for (int i = 0; i <boids.size(); i++) {
    Boid current = boids.get(i);
    current.go();
    current.draw();
  }

  for (int i = 0; i <avoids.size(); i++) {
    Avoid current = avoids.get(i);
    current.go();
    current.draw();
  }

  drawDebug();
}

void keyPressed () {
  if (key == 'q') {
    tool = "boids";
  } else if (key == 'w') {
    tool = "avoids";
  }
}

void drawDebug() {
  fill(0);
  textSize(16);
  text(boids.size() + " boid" + s(boids.size()), 10, 20);

  text("placing " + tool, 10, 40);
}

String s(int count) {
  return (count != 1) ? "s" : "";
}

void mousePressed () {
  switch (tool) {
  case "boids":
    boids.add(new Boid(mouseX, mouseY));
    break;
  case "avoids":
    avoids.add(new Avoid(mouseX, mouseY));
    break;
  }
}