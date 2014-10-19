abstract class Vehicle {
    ArrayList<PVector> history = new ArrayList<PVector>();

    //vectors for moving vehicle
    PVector position;
    PVector velocity;
    PVector acceleration;

    //orientation vectors provide local point of view for vehicle
    PVector fwd;
    PVector right;

    float mass = 1.0;  //arbitrary value will alter acceleration
    float r;           //radius - not correct for this display
    float maxForce;    // Maximum steering force
    float maxSpeed;    // Maximum speed

    Vehicle(float x_, float y_, float r_, float maxSpeed_, float maxForce_) {
        acceleration = new PVector(0, 0);
        velocity = new PVector(0, 0);
        position = new PVector(x_, y_);
        r = r_;
        maxSpeed = maxSpeed_;
        maxForce = maxForce_;
    }

    abstract void calcSteeringForces();
    abstract void display();
    abstract void getTarget();

    // Method to update position
    void update() {
        calcSteeringForces();
        velocity.add(acceleration);
        velocity.limit(maxSpeed);
        position.add(velocity);
        acceleration.mult(0);
    }

    void applyForce(PVector force) {
        acceleration.add(PVector.div(force, mass));
    }
}
