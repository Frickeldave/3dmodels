$fn = 100;

module ring(_h, _r, _ir) {

    difference() {
        cylinder(h = _h, r = _r, center=false);
        translate([0, 0, -1])
        cylinder(h=_h + 2, r=_ir, center=false);
    }

}

ring(2, 25 / 2, 21 / 2);
ring(2, 17 / 2, 13 / 2);
ring(2, 9 / 2, 4 / 2);

color("pink")
translate([0, 0, 2])
cylinder(4, r=25 / 2, center=false);

color("lightblue")
translate([0, 0, 6])
cylinder(3.5, r=10 / 2, center=false);

color("lightgreen")
translate([0, 0, 9.5])
cylinder(1.5, r1 = 10 / 2, r2 = 14 / 2, center=false);

color("lightgreen")
translate([0, 0, 11])
cylinder(1.5, r = 14 / 2, center=false);

color("lightyellow")
translate([0, 0, 12.5])
cylinder(7, r1 = 14 / 2, r2 = 4 / 2, center=false);