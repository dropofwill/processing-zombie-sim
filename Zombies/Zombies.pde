import controlP5.*;

ArrayList<Vehicle> zombies;
ArrayList<Vehicle> humans;
ControlP5 cp5;

//weights for steering forces
float fleerStageWt = 10;
float fleerTargetWt = 5;
float fleerWanderWt = 1;
float fleerTargetLimit = width/3;

float seekerStageWt = 10;
float seekerTargetWt = 5;

void setup() {
    size(1200, 900);

    cp5 = new ControlP5(this);
    cp5.setColorLabel(0x000000);

    cp5.addSlider("Human StageWt")
        .setPosition(5, 5)
        .setValue(fleerStageWt)
        .setRange(0, 10);

    cp5.addSlider("Human TargetWt")
        .setPosition(5, 15)
        .setValue(fleerTargetWt)
        .setRange(0, 10);

    cp5.addSlider("Human WanderWt")
        .setPosition(5, 25)
        .setValue(fleerWanderWt)
        .setRange(0, 10);

    cp5.addSlider("Human TargetLimit")
        .setPosition(5, 35)
        .setValue(fleerTargetLimit)
        .setRange(0, width);

    cp5.addSlider("Zombie StageWt")
        .setPosition(200, 5)
        .setValue(seekerStageWt)
        .setRange(0, 10);

    cp5.addSlider("Zombie TargetWt")
        .setPosition(200, 15)
        .setValue(seekerTargetWt)
        .setRange(0, 10);

    zombies = new ArrayList<Vehicle>();
    humans = new ArrayList<Vehicle>();

    for (int i = 0; i < 2; i++) {
        zombies.add(new Seeker(humans, width/3, height/2, 6, 4, 0.1));
    }

    for (int i = 0; i < 4; i++) {
        humans.add(new Fleer(zombies, (2*width)/3, height/2, 6, 4, 0.1));
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

void updateAttrs(float fleeSpeed, float fleeForce, float seekSpeed, float seekForce) {
    for (int i = 0; i < zombies.size(); i++) {

    }

    for (int i = 0; i < humans.size(); i++) {

    }
}
