$fn = 100; // Auflösung für glatte Kreise

outer_diameter = 53; // Außendurchmesser in mm
wall_thickness = 2; // Wandstärke in mm
inner_diameter = outer_diameter - 2 * wall_thickness; // Innendurchmesser
leg_length = 20; // Minimale Schenkellänge, abhängig vom Außendurchmesser

// module pipe_segment() {
//     difference() {
//         // Äußeres Rohr
//         cylinder(d = outer_diameter, h = leg_length, center = false);
//         // Innerer Hohlraum
//         translate([0, 0, -0.1]) // Leichtes Überlappen für sauberes Rendern
//             cylinder(d = inner_diameter, h = leg_length + 0.2, center = false);
//     }
// }

// module elbow() {
//     // Erster Schenkel
//     pipe_segment();
    
//     // Zweiter Schenkel, 45° gedreht
//     translate([0, 0, leg_length])
//         rotate([0, -45, 0])
//             pipe_segment();
    
//     // Verbindungsstück (Kugel für glatte Übergänge)
//     // translate([0, 0, leg_length])
//     //     difference() {
//     //         sphere(d = outer_diameter);
//     //         sphere(d = inner_diameter);
//     //         // Schneide überschüssige Teile ab
//     //         translate([0, 0, -outer_diameter/2])
//     //             cube([outer_diameter, outer_diameter, outer_diameter], center = true);
//     //         rotate([0, -45, 0])
//     //             translate([0, 0, -outer_diameter/2])
//     //                 cube([outer_diameter, outer_diameter, outer_diameter], center = true);
//     //     }
// }

// module elbow() {
//     difference() {
//         union() {
//             // Linker schenkel
//             color("blue")
//             cylinder(d = outer_diameter, h = leg_length, center = false);
//             // Rechter schenkel
//             color("green")
//             translate([0, 0, leg_length])
//             rotate([0, -45, 0])
//             cylinder(d = outer_diameter, h = leg_length, center = false);
//             // Verbindung
//             color("pink")
//             translate([0, 0, leg_length])
//             sphere(d = outer_diameter);
//         }

//         // Linken Schenkel aushöhlen
//         color("lightblue")
//         translate([0, 0, -11])
//         cylinder(d = outer_diameter - wall_thickness * 2, h = leg_length + 12, center = false);

//         // Rechten Schenkel aushöhlen
//         color("lightgreen")
//         translate([1, -0, leg_length - 1])
//         rotate([0, -45, 0])
//         cylinder(d = outer_diameter - wall_thickness * 2, h = leg_length + 20, center = false);

//         //Verbindung aushöhlen
//         color("lightpink")
//         translate([0, 0, leg_length])
//         sphere(d = outer_diameter - wall_thickness * 2);
//     }
// }

module elbow() {
    translate([0, 0, 85])    
    rotate([0, 180, 0])
    left();
    translate([0, 0, 85])
    rotate([0, -45, 0])
    right();

    color("pink")
    translate([0, 0, 85])
    sphere(d = outer_diameter);

}

module right() {
    difference() {
        union() {
            color("blue")
            translate([0, 0, 0])
            cylinder(d = 50, h = 34);

            color("blue")
            translate([0, 0, 34])
            cylinder(d1 = 50, d2 = 47, h = 4);
        }

        color("lightblue")
        translate([0, 0, -1])
        cylinder(d = 46, h = 40);
    }
}

module left() {
    union() {
        difference() {
            color("green")
            cylinder(h=33, d1 = 53, d2 = 57);

            color("lightgreen")
            translate([0, 0, -1])
            cylinder(h=35, d1 = 49, d2 = 53);
        }

        translate([0, 0, 33])
        difference() {
            color("green")
            cylinder(h=42, d = 57);

            translate([0, 0, -1])
            color("lightgreen")
            cylinder(h=44, d = 53);
        }
    }
}

elbow();