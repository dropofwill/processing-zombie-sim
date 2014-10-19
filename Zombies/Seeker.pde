class Seeker extends Vehicle {
    // seek target
    PVector target = null;

    //stage dimensions
    PVector center = new PVector(width/2, height/2);
    float border = 200;

    //weights for steering forces
    float stageWt = 10;
    float targetWt = 5;

    // This component implements steering forces
    Steer steer;

    // Who to flee
    ArrayList<Vehicle> targets;
    Vehicle closestTarget;
    float closestDist;

    //constructor
    Seeker( ArrayList<Vehicle> targets_,
            float x_,
            float y_,
            float r_,
            float maxSpeed_,
            float maxForce) {

        super(x_, y_, r_, maxSpeed_, maxForce);
        targets = targets_;
        steer = new Steer(this);
    }

    // All Vehicles must implement calcSteeringForces
    void calcSteeringForces() {
        PVector force = new PVector(0, 0);
        if (target != null) {
            force.add(PVector.mult(steer.seek(target), targetWt));
        }

        if (offStage(border)){
            force.add(PVector.mult(steer.seek(center), stageWt));
        }
        //could add other steering forces here
        force.limit(maxForce);
        applyForce(force);
    }

    void getTarget() {
        closestDist = Float.MAX_VALUE;

        for (int i = 0; i < targets.size(); i++) {
            Vehicle curTarget = targets.get(i);
            float dist = PVector.dist(this.position, curTarget.position);

            if (dist < closestDist) {
                closestDist = dist;
                closestTarget = curTarget;
            }
        }
    }

    // test for outside stage border
    boolean offStage(float dist){
        boolean off = false;
        if (position.x < dist) off = true;
        else if (position.x > width - dist) off = true;
        else if (position.y < dist) off = true;
        else if (position.y > height - dist) off = true;
        return off;
    }

    //All Vehicles must implement display
    void display() {
        stroke(0);
        strokeWeight(1);
        noFill();
        rect(border, border, width - 2* border, height - 2* border);
        // Draw a triangle rotated in the direction of velocity
        float theta = velocity.heading2D() + PI/2;
        fill(127);
        stroke(0);
        strokeWeight(1);
        pushMatrix();
        translate(position.x, position.y);
        rotate(theta);
        beginShape();
        vertex(0, -r*2);
        vertex(-r, r*2);
        vertex(r, r*2);
        endShape(CLOSE);
        popMatrix();
    }
}
