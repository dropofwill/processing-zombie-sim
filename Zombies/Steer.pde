//Implements a steering component for this vehicle
//providing frequently used steering functions
//each of which returns a vector steering force

class Steer {
    Vehicle vehicle;
    float wanderTheta;

    Steer (Vehicle vehicle_) {
        vehicle = vehicle_;
    }

    // steering force towards a target
    PVector seek(PVector target) {
        PVector desired = PVector.sub(target, vehicle.position);
        desired.normalize();
        desired.mult(vehicle.maxSpeed);
        PVector steer = PVector.sub(desired, vehicle.velocity);
        return steer;
    }

    PVector flee(PVector target) {
        PVector desired = PVector.sub(vehicle.position, target);
        println(vehicle.position, target);
        desired.normalize();
        desired.setMag(vehicle.maxSpeed);
        PVector steer = PVector.sub(desired, vehicle.velocity);
        return steer;
    }

    PVector wander() {
        float wanderR = 25;
        float wanderD = 80;
        float change = 0.3;
        wanderTheta += random(-change, change);

        PVector circlePos = vehicle.velocity.get();
        circlePos.normalize();
        circlePos.mult(wanderD);
        circlePos.add(vehicle.position);

        float h = vehicle.velocity.heading2D();
        float offX = wanderR * cos(wanderTheta + h);
        float offY = wanderR * sin(wanderTheta + h);
        PVector circleOffset = new PVector(offX, offY);
        PVector target = PVector.add(circlePos, circleOffset);

        return seek(target);
    }

    PVector avoidObstacle (Obstacle obst, float safeDistance) {
        PVector steer = new PVector(0, 0);

        //Create vecToCenter - a vector from the character to the center of the obstacle

        // Find the distance to the obstacle

        //return a zero vector if the obstacle is too far to concern us

        //return a zero vector if the obstacle is behind us

        //Use the dot product of the vector to obstacle center and
        //the unit vector to the right of the vehicle to find the
        //distance between the centers of the vehicle and the obstacle
        //compare this to the some of the radii and
        //return a zero vector if we can pass safely


        //If we get this far we are on a collision course and must steer
        //Use the sign of the dot product between the vector to center and
        //the vector to the right to determine whether to steer left or right

        //for each case calculate desired velocity using the right vector and maxspeed


        //compute the force required to change current velocity to desired velocity

        //consider multiplying this by safeDistance/dist to increase the relative
        //weight of the steering force when obstacles are closer.

        return steer;
    }
}
