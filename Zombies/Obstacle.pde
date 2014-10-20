class Obstacle {
    PVector position;
    float r;
    PImage foliage;

    Obstacle(float x_, float y_, float r_) {
        position = new PVector(x_, y_);
        r = r_;
        foliage = loadImage("foliage.png");
    }

    void display() {
        fill(100);
        if (debug) ellipse(position.x, position.y, r*2, r*2);
        image(foliage, position.x - r, position.y - r);
    }
}
