use <./IKEA Skadis v3 hook.scad>

$fn = 50;

_size = 60;
_rod_dia = 7.8;
_rod_endcap_dia = 8;
_rod_endcap_height = 8;
_rod_endcap_thickness = 2;
_rod_endcap_cap_dia = 20;
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



module rod_cap() {
    
    rib_count = 10;
    rib_width = 1;
    rib_depth = 2;
    rib_chamfer = 1.5; // chamfer size at inner top edge (facing the rod)

    difference() {
        color("lightblue")
        translate([0, 0, _rod_endcap_height / 2])
        cylinder(h = _rod_endcap_height, d = _rod_endcap_dia + _rod_endcap_thickness + rib_depth * 2, center = true);

        color("red")
        translate([0,0, _rod_endcap_height / 2 + _rod_endcap_thickness])
        cylinder(h = _rod_endcap_height, d = _rod_endcap_dia + rib_depth * 2, center = true);

    }

    cylinder(h = _rod_endcap_thickness, d = _rod_endcap_cap_dia, center = true);
    
    for (i = [0 : rib_count - 1]) {
        angle = i * 360 / rib_count;
        rotate([0, 0, angle])
        translate([_rod_dia / 2, -rib_width / 2, 0])
        color("green")
        difference() {
            cube([_rod_endcap_dia / 2 - _rod_dia / 2 + rib_depth, rib_width, _rod_endcap_height]);
            // chamfer: inner top edge (X=0, Z=top)
            // Dreieck-Prisma direkt als translate+rotate+cube trick:
            // Wir schneiden einen Keil heraus: X von -0.1 bis rib_chamfer, Z von (top-rib_chamfer) bis (top+0.1)
            // Die Schräge entsteht durch multmatrix (shear in XZ)
            translate([-0.1, -0.1, _rod_endcap_height - rib_chamfer])
            multmatrix([
                [1, 0, 0,                    0],
                [0, 1, 0,                    0],
                [tan(55)/rib_chamfer, 0, 1,  0],
                [0, 0, 0,                    1]
            ])
            cube([rib_chamfer + 0.1, rib_width + 0.2, rib_chamfer + 0.1]);
        }
    }
}

rod_cap();
// color("brown")
// cylinder(h = 10, d = 8, center = true);    