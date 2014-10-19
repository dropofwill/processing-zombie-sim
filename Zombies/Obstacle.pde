class Obstacle {
    PVector position;
    float r;

    Obstacle(float x_, float y_, float r_) {
        position = new PVector(x_, y_);
        r = r_;
    }

    void display() {
        fill(100);
        ellipse(position.x, position.y, r*2, r*2);
    }
}
