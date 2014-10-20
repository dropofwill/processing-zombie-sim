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

    PVector pursue(Vehicle targetVehicle, float scale) {
        targetVehicle.fwd.normalize();
        PVector aheadTarget = PVector.mult(targetVehicle.fwd, scale);
        PVector target = PVector.add(aheadTarget, targetVehicle.position);

        //if (debug) drawVector(targetVehicle.position, aheadTarget);
        return seek(target);
    }

    PVector flee(PVector target) {
        PVector desired = PVector.sub(vehicle.position, target);
        desired.normalize();
        desired.setMag(vehicle.maxSpeed);
        PVector steer = PVector.sub(desired, vehicle.velocity);
        return steer;
    }

    PVector evade(Vehicle targetVehicle, float scale) {
        targetVehicle.fwd.normalize();
        PVector aheadTarget = PVector.mult(targetVehicle.fwd, scale);
        PVector target = PVector.add(aheadTarget, targetVehicle.position);

        //if (debug) drawVector(targetVehicle.position, aheadTarget);
        return flee(target);
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

        PVector desiredVelocity;
        float dotFwd,
              dotRight,
              dist;

        //Create vecToCenter - a vector from the character to the center of the obstacle
        PVector vecToCenter = PVector.sub(obst.position, vehicle.position);
        //PVector vecToCenter = PVector.sub(vehicle.position, obst.position);

        // Find the distance to the obstacle
        dist = vecToCenter.mag();
        dotFwd = vehicle.fwd.dot(vecToCenter);
        dotRight = PVector.dot(vehicle.right, vecToCenter);

        //return a zero vector if the obstacle is behind us
        if (dotFwd < 0) {
            //println("behind");
        }
        //return a zero vector if the obstacle is too far to concern us
        else if (dist > safeDistance) {
            //println("too far");
        }
        //Use the dot product of the vector to obstacle center and
        //the unit vector to the right of the vehicle to find the
        //distance between the centers of the vehicle and the obstacle
        //compare this to the sum of the radii and
        //return a zero vector if we can pass safely
        else if (Math.abs(dotRight) > (vehicle.r + (obst.r * 2))) {
            //println("too wide");
        }

        //If we get this far we are on a collision course and must steer
        //Use the sign of the dot product between the vector to center and
        //the vector to the right to determine whether to steer left or right
        //for each case calculate desired velocity using the right vector and maxspeed
        else {
            if (dotRight > 0) {
                desiredVelocity = PVector.mult(vehicle.right, -vehicle.maxSpeed);
            }
            else {
                desiredVelocity = PVector.mult(vehicle.right, vehicle.maxSpeed);
            }

            //compute the force required to change current velocity to desired velocity
            steer = PVector.sub(desiredVelocity, vehicle.velocity);
            //consider multiplying this by safeDistance/dist to increase the relative
            //weight of the steering force when obstacles are closer.
            steer.mult(safeDistance / dist);
        }
        // if (debug) drawVector(vehicle.position, vecToCenter);
        return steer;
    }
}
