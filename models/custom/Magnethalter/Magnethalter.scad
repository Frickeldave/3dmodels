$fn = 30;

difference() {

union() {
    cube([40, 10, 15]);
    cube([40, 20, 4]);
}
color("red")
translate([8, 15, -1])
cylinder(h=6, d=4, center=false);

color("pink")
translate([8, 15, 1])
cylinder(h=4, d1=4, d2=8, center=false);



color("red")
translate([32, 15, -1])
cylinder(h=6, d=4, center=false);

}

