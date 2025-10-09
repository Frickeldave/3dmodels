$fn = 100;


difference() {
    cylinder(h=52, d = 107);
    
    translate([0, 0, 4])
    cylinder(h=44, d = 102);

    translate([0, 0, 2])
    cylinder(h=3, d = 92);
    

    color("red")
    translate([107/2, 0, 26])
    cube([109, 109, 54], center=true);    

}

