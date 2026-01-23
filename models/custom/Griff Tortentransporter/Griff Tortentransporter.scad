$fn = 100;

difference() {
    union() {
        rotate([0,90,0])
        cylinder(h=79, d=11);

        color("blue")
        translate([0, 0, -5.5])
        cube([79, 26, 2.5]);

        translate([-5, 0, 0])
        rotate([0, 90, 0])
        cylinder(h=79 + 5 + 5, d=3.5);

        color("green")
        translate([0, 13.6, -5.6 + 2.5])
        cube([79, 2, 5.6]);

        color("pink")
        translate([7, 13.6 - 1.3, 0.5])
        cube([10, 1.3, 2]);

        color("pink")
        translate([79 - 7 -10, 13.6 - 1.3, 0.5])
        cube([10, 1.3, 2]);
    }

    color("red")
    translate([(79-72.5) / 2, 0, -6 + 3])
    cube([72.5, 11, 12]);
}
