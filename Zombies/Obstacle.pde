class Obstacle {
    float x,
          y,
          r;

    Obstacle(float x_, float y_, float r_) {
        x = x_;
        y = y_;
        r = r_;
    }

    void display() {
        fill(100);
        ellipse(x, y, r*2, r*2);
    }
}
