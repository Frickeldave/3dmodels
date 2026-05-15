use <./IKEA Skadis v3 hook.scad>

$fn = 50;

_size = 60;
_rod_dia = 9;
_rod_endcap_dia = 8;
_height = 7;
_round = 3; // corner rounding radius
_wall  = 5; // wall thickness for hollow cutout

module rod_holder() {

    color("lightgreen")
    translate([2, _size - 56, 4.5])
    rotate([270, 90, 0])
    ikea_skadis_holder();

    difference() {
        translate([0, 0, _height / 2])
        linear_extrude(height = _height, center = true)
            offset(r = _round, $fn = 40) offset(r = -_round)
            polygon(points = [
                [0, 0],  
                [0, _size],
                [5, _size],
                [5, _size - 10],
                [(_size - 5) / 2, _size - 20],
                [_size, _size - 10],
                [_size, _size - 5],
                [_size + _rod_dia + 6, _size - 5],
                [_size + _rod_dia + 6, _size - 20],
                [10, 0],
            ]);

        // Hollow inner cutout with uniform wall thickness,
        // but keep walls around the rod slot
        translate([0, 0, _height / 2])
        linear_extrude(height = _height + 1, center = true)
            difference() {
                offset(r = _round - _wall, $fn = 40) offset(r = -(_round - _wall))
                offset(r = -_wall)
                polygon(points = [
                    [0, 0],  
                    [0, _size],
                    [5, _size],
                    [5, _size - 10],
                    [(_size - 5) / 2, _size - 20],
                    [_size, _size - 10],
                    [_size, _size - 5],
                    [_size + _rod_dia + 6, _size - 5],
                    [_size + _rod_dia + 6, _size - 20],
                    [10, 0],
                ]);
                // Exclude the rod slot footprint + wall buffer so walls stay intact
                offset(r = _wall, $fn = 20)
                hull() {
                    translate([_size + _rod_dia / 2 + 3, _size - 5])  circle(d = _rod_dia);
                    translate([_size + _rod_dia / 2 + 3, _size - 10]) circle(d = _rod_dia);
                }
            }

        color("red")
        hull() {
            translate([_size + _rod_dia / 2 + 3, _size - 5, _height / 2])
            cylinder(h = _height + 2, d = _rod_dia, center = true);
            translate([_size + _rod_dia / 2 + 3, _size - 10, _height / 2])
            cylinder(h = _height + 2, d = _rod_dia, center = true);
        }
    }
}

module rod_endcaps() {

        color("lightgreen")
        translate([0,0,0])
        cylinder(h = 2, d = _rod_endcap_dia + 4, center = false);    
    
    difference() {

        color("lightblue")
        translate([0,0,0])
        cylinder(h = 8, d = _rod_endcap_dia + 2, center = false);
        translate([0,0,2])
        cylinder(h = 11, d = _rod_endcap_dia, center = false);
    }
}

rod_endcaps();