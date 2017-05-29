class Food {
  PVector pos;
  
  Food(float xx, float yy) {
    pos = new PVector(xx,yy);
  }
  
  void go () {
  }
  
  void draw () {
    fill(0, 255, 200);
    rect(pos.x, pos.y, 10, 10);
  }
}