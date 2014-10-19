ArrayList<Vehicle> zombies;
ArrayList<Vehicle> humans;

void setup() {
    size(1200, 900);

    zombies = new ArrayList<Vehicle>();
    humans = new ArrayList<Vehicle>();

    for (int i = 0; i < 2; i++) {
        zombies.add(new Seeker(humans, width/2, height/2, 6, 4, 0.1));
    }

    for (int i = 0; i < 4; i++) {
        humans.add(new Fleer(zombies, width/2, height/2, 6, 4, 0.1));
    }
}

void draw() {
    background(255);
    /*PVector mouse = new PVector(mouseX, mouseY);*/
    // Draw an ellipse at the mouse location
    /*fill(200);*/
    /*stroke(0);*/
    /*strokeWeight(2);*/
    /*ellipse(mouse.x, mouse.y, 48, 48);*/

    // Call the appropriate steering behaviors for our agents
    for (int i = 0; i < zombies.size(); i++) {
        Vehicle seekV = zombies.get(i);
        seekV.getTarget();
        /*seekV.setTarget(seekV.position);*/
        seekV.update();
        seekV.display();
    }

    for (int i = 0; i < humans.size(); i++) {
        Vehicle fleeV = humans.get(i);
        fleeV.getTarget();
        /*fleeV.setTarget(fleeV.position);*/
        fleeV.update();
        fleeV.display();
    }
}
