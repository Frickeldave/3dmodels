$fn = 100;

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
        translate([-46, 5, -1])
        cube([92, 45, 32]);

        // Verstärkung wegschneiden links
        color("red")
        translate([-48, -18, -1])
        cube([5, 20, 32]);

        // Verstärkung wegschneiden rechts
        color("pink")
        translate([42.7, -18, -1])
        cube([5, 25, 32]);

}

// Haken
translate([-46, 2, 0])
cube([6, 3, 30]);




// Rechter Haken
difference() {

        color("cyan")
        translate([34.7, 5, 0])
        cylinder(h = 30, d = 16);

        color("red")
        translate([34.7, 5, -1])
        cylinder(h = 32, d = 10);


        color("pink")
        translate([26.7, 5, -1])
        linear_extrude(height=32)
        polygon(points=[
        [0, 0],
        [0, -8],
        [13.0, -8],
        [13.3, -6],
        [13, 0]
        ]);        

}

