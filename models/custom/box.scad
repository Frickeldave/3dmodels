use <./../../modules/scad/roundedcube.scad>

_box_width = 160;
_box_depth = 160;
_box_height = 50;
_thickness = 3;
_box_radius = 5; 

module box_base(_w, _d, _h, _t, _r) {
    difference() {
        roundedcube(size = [_w, _d, _h], center = false, radius = _r, "z");
        translate([_t, _t, _t])
        roundedcube(size = [_w - _t * 2, _d - _t * 2, _h], center = false, radius = _r, "z");
    }
}

module lid_base(_w, _d, _h, _t, _r) {
    difference() {
        roundedcube(size = [_w + _t * 2, _d + _t * 2, _t * 2], center = false, radius = _r, "z");
        translate([_t + 0.1, _t + 0.1, _t])
        roundedcube(size = [_w + 0.2, _d + 0.2, _h], center = false, radius = _r, "z");
    }
}


module fusable_nuts_holder(_h) {
    difference() {
        cylinder(h = _h, r = 5);
        translate([0, 0, -1])
        cylinder(h = _h + 2, r = 2.5);
    }
}

module box(_w, _d, _h, _t, _r) {
    difference() {

        union() {
            box_base(_w, _d, _h, _t, _r);

            color("pink") {
                // Fusable nuts holder in den 4 Ecken
                translate([7, 7, 0]) fusable_nuts_holder(_h); // ul
                translate([_w - 7, 7, 0]) fusable_nuts_holder(_h); // ur
                translate([_w - 7, _d - 7, 0]) fusable_nuts_holder(_h); // or
                translate([7, _box_depth - 7, 0]) fusable_nuts_holder(_box_height); // ol

                // Fusable nuts holder mittig an den 4 Seiten
                translate([_w / 2, 7, 0]) fusable_nuts_holder(_h); // u
                translate([_w - 7, _d / 2, 0]) fusable_nuts_holder(_h); // r
                translate([_w / 2, _d - 7, 0]) fusable_nuts_holder(_h); // o
                translate([7, _d / 2, 0]) fusable_nuts_holder(_h); // l
            }
        }

        // Loch für Kabeldurchführung unten rechts 1 (Netzteil 1)
        translate([_w - _t - 1, 27, _h / 2])
        rotate([90, 0, 90])
        cylinder(h = _t + 2, d = 16);

        // Loch für Kabeldurchführung unten rechts 2 (Netzteil 1)
        translate([_w - _t - 1, _d / 2 - 19, _h / 2])
        rotate([90, 0, 90])
        cylinder(h = _t + 2, d = 16);

        // Loch für Kabeldurchführung unten rechts 3 (leer)
        translate([_w - _t - 1, _d / 2 + 19, _h / 2])
        rotate([90, 0, 90])
        cylinder(h = _t + 2, d = 16);

        // Loch für Kabeldurchführung unten rechts 4 (leer)
        translate([_w - _t - 1, _d - 27, _h / 2])
        rotate([90, 0, 90])
        cylinder(h = _t + 2, d = 16);

        // Loch für Kabeldurchführung oben links (Steckdose)
        translate([27, _d + 1, _h / 2])
        rotate([90, 0, 0])
        cylinder(h = _t + 2, d = 16);

        // Loch für Kabeldurchführung oben links (leer)
        translate([_w / 2 - 19, _d + 1, _h / 2])
        rotate([90, 0, 0])
        cylinder(h = _t + 2, d = 16);

        // Loch für Kabeldurchführung oben links (leer)
        translate([_w / 2 + 19, _d + 1, _h / 2])
        rotate([90, 0, 0])
        cylinder(h = _t + 2, d = 16);

        // Loch für Kabeldurchführung oben links (leer)
        translate([_w - 27, _d + 1, _h / 2])
        rotate([90, 0, 0])
        cylinder(h = _t + 2, d = 16);

        // Loch für Kabeldurchführung unten (Zuleitung)
        translate([50, _d / 2, -1])
        rotate([0, 0, 0])
        cylinder(h = _t + 2, d = 20);
    }
}

module lid(_w, _d, _h, _t, _r) {

    difference() {
        lid_base(_w, _d, _h, _t, _r);

        // Srew holes in corners
        color("Red")
        translate([_thickness + 7, _thickness + 7, -10]) cylinder(h = _t + 20, r = 2.5); // ul
        translate([_w - 7 + _thickness, _thickness + 7, -10]) cylinder(h = _t + 20, r = 2.5); // ur
        translate([_w - 7 + _thickness, _d - 7 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // or
        translate([7 + _thickness, _box_depth - 7 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // ol

        // Screw holes at the sides
        translate([_w / 2 + _thickness, 7 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // u
        translate([_w - 7 + _thickness, _d / 2 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // r
        translate([_w / 2 + _thickness, _d - 7 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // o
        translate([7 + _thickness, _d / 2 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // l

    }
}


// translate([_box_width +_thickness, - _thickness, 60])
// rotate([0, 180, 0])
lid(_box_width, _box_depth, _box_height, _thickness, _box_radius);
//box(_box_width, _box_depth, _box_height, _thickness, _box_radius);


