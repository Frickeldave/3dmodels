wall = 2;
bottom = 18;
inner = 25;
height = 30;
r = 15;

module klein() {
    outer = inner + 2 * wall;
    e = 0.01;

    difference() {
        // Außenform: eine Ecke (bei Ursprung) gerundet
        union() {
            translate([0, r, 0]) cube([outer, outer - r, height]);
            translate([r, 0, 0]) cube([outer - r, r, height]);
            // Viertelzylinder auf x=0..r, y=0..r begrenzt → keine Beulen an den geraden Wänden
            intersection() {
                translate([r, r, 0]) cylinder(r=r, h=height, $fn=64);
                cube([r + e, r + e, height]);
            }
        }
        // Innenraum: gleiche Ecke gerundet mit r-wall → konstante Wandstärke
        union() {
            translate([wall, r, bottom]) cube([inner, outer - wall - r, height - bottom + e]);
            translate([r, wall, bottom]) cube([outer - wall - r, r - wall, height - bottom + e]);
            // Viertelzylinder auf x=0..r, y=0..r begrenzt
            intersection() {
                translate([r, r, bottom]) cylinder(r=r - wall, h=height - bottom + e, $fn=64);
                translate([0, 0, bottom]) cube([r + e, r + e, height - bottom + e]);
            }
        }
    }
}

module gross() {
    difference() {
        cylinder(h=height, d=48 + 2 * wall, $fn=64);
        color("red")
        translate([0, 0, bottom])
        cylinder(h=height, d=48, $fn=64);
        
    }
}

gross();