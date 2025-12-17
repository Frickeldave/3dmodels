$fn = 100;


module left_hook() {

        color("lightblue")
        linear_extrude(30)
        polygon(points=[
        [0,0],
        [0,9],
        [-4,10],
        [-5,10],
        [-5,12],
        [3,12],
        [3,0]
        ]);
}

module right_hook() {

    // Rechter Haken
    difference() {

        color("cyan")
        cylinder(h = 30, d = 16);

        color("red")
        translate([0, 0, -1])
        cylinder(h = 32, d = 10);

        // Halbieren
        color("green")
        translate([0, -10, -1])
        cube([20, 20, 32]);

    };

    color("pink")
    translate([0,5, 0])
    cube([13, 3, 30]);

    color("grey")
    translate([0, 8, 10])
    cube([13, 2, 10]);
}

module gutter_main() {
        
    difference() {

        union() {
            // Main body
            cylinder(h = 30, d=86);

            // Verstärkung
            color("cyan")
            translate([0, 0, 10])
            cylinder(h = 10, d=90);
        }

        // Aussparung für Dachrinne
        translate([0, 0, -1])
        cylinder(h = 32, d=80);

        // Halbieren
        color("cyan")
        translate([-46, 0, -1])
        cube([92, 45, 32]);

        // Verstärkung wegschneiden links
        color("red")
        translate([-48, -18, -1])
        cube([5, 20, 32]);

        // Verstärkung wegschneiden rechts
        // color("pink")
        // translate([43, -18, -1])
        // cube([5, 25, 32]);

    }
}


module gutter_holder() {

    gutter_main();
    translate([-43, 0, 0])
    left_hook();

    translate([35, 13, 0])
    rotate([0, 0, 270])
    right_hook();

    difference() {

        union() {
            translate([43, 12, 0])
            color("lightblue")
            linear_extrude(30)
            polygon(points=[
            [0,-12],
            [0,0],
            [-1.5, 2],
            [-2,3],
            [-2,4],
            [-3,5],
            [-4,6],
            [-5,7],
            [-6,8],
            [-7,9],
            [50,9],
            [50,7],
            [6,0],
            [6,0]
            ]);

            // Keil
            translate([35, 21, 0])
            color("lightgreen")
            linear_extrude(30)
            polygon(points=[
            [0, 0],
            [58, 0],
            [58, 10],
            [0, 0]
            ]);
        }

        translate([60, 30, 7])
        rotate([90, 0, 0])    
        cylinder( h=30, d=3);

        translate([60, 30, 23])
        rotate([90, 0, 0])    
        cylinder( h=30, d=3);

        translate([80, 30, 15])
        rotate([90, 0, 0])    
        cylinder( h=30, d=3);


    }
}

translate([0,-21,0])
gutter_holder();

