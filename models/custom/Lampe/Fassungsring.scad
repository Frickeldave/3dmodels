$fn = 500;

difference() {
translate([0, 0, 8])
difference() {
    union() {
        cylinder(h=16, d1=55, d2=41, center=true);
    }
    translate([0, 0, -0])
    cylinder(h=18, d=39, center=true);




}

color("red")
translate([0, 0, -2])
rotate([0,-5,0])
cube([70, 70,10], center=true);

}



// color("pink")
// translate([0, 0, 6])
// cube([70, 70,.1], center=true);