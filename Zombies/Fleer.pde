class Fleer extends Vehicle {
    //stage dimensions
    PVector center = new PVector(width/2, height/2);

    // This component implements steering forces
    Steer steer;

    // Who to flee
    ArrayList<Vehicle> targets;
    ArrayList<Obstacle> obstacles;
    float closestDist;

    //constructor
    Fleer(  ArrayList<Vehicle> targets_,
            ArrayList<Obstacle> obstacles_,
            float x_,
            float y_,
            float r_,
            float maxSpeed_,
            float maxForce) {

        super(x_, y_, r_, maxSpeed_, maxForce);
        targets = targets_;
        obstacles = obstacles_;
        steer = new Steer(this);
    }

    // All Vehicles must implement calcSteeringForces
    void calcSteeringForces() {
        PVector force = new PVector(0, 0);
        if (target != null && closestDist < fleerTargetLimit) {
            force.add(PVector.mult(steer.flee(target), fleerTargetWt));
            // and wander a bit
            force.add(PVector.mult(steer.wander(), fleerWanderWt));
        }
        else {
            force.add(PVector.mult(steer.wander(), fleerTargetWt));
        }

        for (int i = 0; i < obstacles.size(); i++) {
            Obstacle obst = obstacles.get(i);
            force.add(PVector.mult(steer.avoidObstacle(obst, 20), fleerTargetWt));
        }

        if (offStage(border)){
            force.add(PVector.mult(steer.seek(center), fleerStageWt));
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
        if (closestTarget != null) {
            target = closestTarget.position;
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
        // Draw a triangle rotated in the direction of velocity
        float theta = velocity.heading2D() + PI/2;
        stroke(0);
        strokeWeight(1);

        pushMatrix();
            translate(position.x, position.y);
            rotate(theta);

            if (debug) {
                noFill();
                ellipse(0, 0, r*2, r*2);
            }

            fill(0);
            beginShape();
                vertex(0, -r);
                vertex(-r/2, r);
                vertex(r/2, r);
            endShape(CLOSE);

        popMatrix();
    }
}
