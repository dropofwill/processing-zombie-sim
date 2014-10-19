import controlP5.*;
import java.util.Iterator;

ArrayList<Vehicle> zombies;
ArrayList<Vehicle> humans;
ControlP5 cp5;
float border = 200;
boolean debug = true;
float zombieRadius = 12;
float humanRadius = 12;

//weights for steering forces
float fleerStageWt = 10;
float fleerTargetWt = 5;
float fleerWanderWt = 1;
float fleerTargetLimit = width/3;
float fleerSpeed = 4;
float fleerForce = 0.1;

float seekerStageWt = 10;
float seekerTargetWt = 5;
float seekerSpeed = 4;
float seekerForce = 0.1;

void setup() {
    size(1200, 900);

    cp5 = new ControlP5(this);
    cp5.setColorLabel(0x000000);

    cp5.addSlider("fleerStageWt")
        .setPosition(5, 5)
        .setValue(fleerStageWt)
        .setRange(0, 10);
    cp5.addSlider("fleerTargetWt")
        .setPosition(5, 15)
        .setValue(fleerTargetWt)
        .setRange(0, 10);
    cp5.addSlider("fleerWanderWt")
        .setPosition(5, 25)
        .setValue(fleerWanderWt)
        .setRange(0, 10);
    cp5.addSlider("fleerTargetLimit")
        .setPosition(5, 35)
        .setValue(fleerTargetLimit)
        .setRange(0, width);

    cp5.addSlider("seekerStageWt")
        .setPosition(200, 5)
        .setValue(seekerStageWt)
        .setRange(0, 10);
    cp5.addSlider("seekerTargetWt")
        .setPosition(200, 15)
        .setValue(seekerTargetWt)
        .setRange(0, 10);

    cp5.addSlider("fleerMaxSpeed")
        .setPosition(400, 5)
        .setValue(fleerSpeed)
        .setRange(0, 10);
    cp5.addSlider("fleerMaxForce")
        .setPosition(400, 15)
        .setValue(fleerForce)
        .setRange(0, 1);

    cp5.addSlider("seekerMaxSpeed")
        .setPosition(600, 5)
        .setValue(seekerSpeed)
        .setRange(0, 10);
    cp5.addSlider("seekerMaxForce")
        .setPosition(600, 15)
        .setValue(seekerForce)
        .setRange(0, 1);

    cp5.addToggle("debug")
        .setPosition(600, 35)
        .setValue(debug)
        .setSize(25, 10)
        .setMode(ControlP5.SWITCH);

    zombies = new ArrayList<Vehicle>();
    humans = new ArrayList<Vehicle>();

    for (int i = 0; i < 2; i++) {
        zombies.add(new Seeker( humans,
                                random(0, width),
                                random(0, height),
                                zombieRadius,
                                seekerSpeed,
                                seekerForce));
    }

    for (int i = 0; i < 4; i++) {
        humans.add(new Fleer( zombies,
                              width/2,
                              height/2,
                              humanRadius,
                              fleerSpeed,
                              fleerForce));
    }
}

void draw() {
    background(255);

    if (debug) {
        noFill();
        rect(border, border, width - 2* border, height - 2* border);
    }

    // ControlP5 changes
    updateAttrs(fleerSpeed, fleerForce, seekerSpeed, seekerForce);

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

    for (int i = 0; i < zombies.size(); i++) {
        Vehicle aZombie = zombies.get(i);
        for (int j = 0; j < humans.size(); j++) {
            Vehicle aHuman = humans.get(j);
            float dist = PVector.dist(aHuman.position, aZombie.position);

            if (dist < (humanRadius + zombieRadius)) {
                println("Collision, you're a zombie");
            }
        }
    }
}

void reset() {
    for (int i = 0; i < humans.size(); i++) {
        Vehicle human = humans.get(i);
        /*human.position.x = width/2;*/
        /*human.position.y = height/2;*/
        human.position.x = random(0, width);
        human.position.y = random(0, height);
    }

    for (int i = 0; i < zombies.size(); i++) {
        Vehicle zombie = zombies.get(i);
        zombie.position.x = random(0, width);
        zombie.position.y = random(0, height);
    }
}

void updateAttrs(float fleeSpeed, float fleeForce, float seekSpeed, float seekForce) {
    for (int i = 0; i < humans.size(); i++) {
        Vehicle human = humans.get(i);
        human.maxSpeed = fleeSpeed;
        human.maxForce = fleeForce;
    }

    for (int i = 0; i < zombies.size(); i++) {
        Vehicle zombie = zombies.get(i);
        zombie.maxSpeed = seekSpeed;
        zombie.maxForce = seekForce;
    }
}
