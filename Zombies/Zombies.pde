import controlP5.*;
import java.util.Iterator;

ArrayList<Vehicle> zombies;
ArrayList<Vehicle> humans;
ArrayList<Obstacle> trees;

ControlP5 cp5;

float border = 200;
boolean debug = true;
float zombieRadius = 12;
float humanRadius = 12;

//weights for steering forces
float fleerStageWt = 8;
float fleerTargetWt = 5;
float fleerAvoidWt = 5;
float fleerWanderWt = 0.5;
float fleerTargetLimit = 200;
float fleerSpeed = 3.5;
float fleerForce = 0.15;

float seekerStageWt = 5;
float seekerTargetWt = 10;
float seekerAvoidWt = 8;
float seekerSpeed = 2;
float seekerForce = 0.1;

void setup() {
    size(1200, 900);

    cp5Setup();

    zombies = new ArrayList<Vehicle>();
    humans = new ArrayList<Vehicle>();
    trees = new ArrayList<Obstacle>();

    for (int i = 0; i < 2; i++) {
        zombies.add(new Seeker( humans,
                                trees,
                                random(border, width-border),
                                random(border, height-border),
                                zombieRadius,
                                seekerSpeed,
                                seekerForce));
    }

    for (int i = 0; i < 10; i++) {
        humans.add(new Fleer( zombies,
                              trees,
                              random(border, width-border),
                              random(border, height-border),
                              humanRadius,
                              fleerSpeed,
                              fleerForce));
    }

    for (int i = 0; i < 8; i++) {
        trees.add(new Obstacle(random(border, width-border),
                               random(border, height-border),
                               30));
    }
}

void draw() {
    background(255);

    if (debug) {
        noFill();
        rect(border, border, width - 2* border, height - 2* border);
    }

    // Add controlP5 changes
    updateAttrs(fleerSpeed, fleerForce, seekerSpeed, seekerForce);

    // Call the appropriate steering behaviors for our agents
    for (int i = 0; i < zombies.size(); i++) {
        Vehicle seekV = zombies.get(i);
        seekV.getTarget();
        seekV.update();
        seekV.display();
    }

    for (int i = 0; i < humans.size(); i++) {
        Vehicle fleeV = humans.get(i);
        fleeV.getTarget();
        fleeV.update();
        fleeV.display();
    }

    for (int i = 0; i < zombies.size(); i++) {
        Vehicle aZombie = zombies.get(i);
        Iterator<Vehicle> iter = humans.iterator();

        while (iter.hasNext()) {
            Vehicle aHuman = iter.next();
            float dist = PVector.dist(aHuman.position, aZombie.position);

            if (dist < (humanRadius + zombieRadius)) {
                println("Collision, you're a zombie");
                zombies.add(new Seeker( humans,
                                        trees,
                                        aHuman.position.x,
                                        aHuman.position.y,
                                        zombieRadius,
                                        seekerSpeed,
                                        seekerForce));
                iter.remove();
                aZombie.closestTarget = null;
                aZombie.target = null;
            }
        }
    }
}

void reset() {
    for (int i = 0; i < humans.size(); i++) {
        Vehicle human = humans.get(i);
        human.position.x = random(border, width-border);
        human.position.y = random(border, height-border);
    }

    for (int i = 0; i < zombies.size(); i++) {
        Vehicle zombie = zombies.get(i);
        zombie.position.x = random(border, width-border);
        zombie.position.y = random(border, height-border);
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

    for(int i = 0; i < trees.size(); i++) {
        trees.get(i).display();
    }
}

void drawVector(PVector start, PVector vec, float scale) {
    stroke(0);
    line(start.x, start.y, start.x + vec.x*scale, start.y + vec.y*scale);
}

void drawVector(PVector start, PVector vec) {
    stroke(0);
    line(start.x, start.y, start.x + vec.x, start.y + vec.y);
}

void drawVector(float x, float y, PVector vec) {
    stroke(0);
    line(x, y, x + vec.x, y + vec.y);
}

void drawVector(PVector start, PVector vec, int col) {
    stroke(col);
    line(start.x, start.x, start.x + vec.x, start.x + vec.y);
}

void drawVector(float x, float y, PVector vec, int col) {
    stroke(col);
    line(x, y, x + vec.x, y + vec.y);
}

void cp5Setup() {
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
    cp5.addSlider("fleerAvoidWt")
        .setPosition(5, 35)
        .setValue(fleerAvoidWt)
        .setRange(0, 10);
    cp5.addSlider("fleerTargetLimit")
        .setPosition(5, 45)
        .setValue(fleerTargetLimit)
        .setRange(0, width);

    cp5.addSlider("seekerStageWt")
        .setPosition(200, 5)
        .setValue(seekerStageWt)
        .setRange(0, 10);
    cp5.addSlider("seekerAvoidWt")
        .setPosition(200, 15)
        .setValue(seekerAvoidWt)
        .setRange(0, 10);
    cp5.addSlider("seekerTargetWt")
        .setPosition(200, 25)
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
}
