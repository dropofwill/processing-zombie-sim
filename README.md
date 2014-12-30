processing-zombie-sim
=====================

Use Craig Reynolds steering algorithms to simulate a zombie outbreak
====================

There are debug vectors and collison boxes that you can toggle with a Control5 switch.

I implemented pursue and evade with a target that was 2 times the target vehicles maxSpeed in the direction of it's forward vector.

The weights were difficult to balance. Without the stage weight it works really well, but I think I found a good balance even with that.
