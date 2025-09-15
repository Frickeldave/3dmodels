$fn = 100;

_width = 54;
_depth = 40;
_height = 20;
_thickness = 2;
_type = "r"; // c=cube, rc=rounded cube, r=rounded

_backplate_distance = 0; // additional space between bin and backplate

use <../../../../modules/scad/roundedcube.scad>
use <./IKEA Skadis v3 Plate.scad>



module bin(_w, _d, _h, _t, _r, _rh, _tp, _bpd) {

    // Set the backplate width
    _pw = _w >= 50  ? _w : 50;

    color("lightblue")
    ikea_skadis_backwall(_w, _h, _t, _rh);

    if(_tp == "c") {
        translate([0, -_d, 0])
        difference() {
            cube([_w, _d, _h]);
            color("red")
            translate([_t, _t, _t])
            cube([_w - _t * 2, _d - _t * 2, _h]);
        }
    }
    if(_tp == "rc") {
        roundedcube(size = [_w, _d, _h], center = false, radius = _r);
    }
    if(_tp == "r") {
        
        difference() {
            union() {

                color("lightgreen")
                linear_extrude(height = _h)
                polygon(
                    points=[
                        [0,0],
                        [(_pw - _w) / 2, -(_w / 2 + _bpd)],
                        [_pw - ((_pw - _w) / 2), -(_w / 2 + _bpd)],
                        [_pw, 0]
                    ]
                );
                
                translate([_pw / 2, -_w / 2 - _bpd, 0])
                cylinder(h = _h, d = _w, center = false);
            }
            color("red")
            translate([_pw / 2, -_w / 2 - _bpd, _t])
            cylinder(h = _h, d = _w - _t * 2, center = false);
        }
    }
}

bin(_width, _depth, _height, _thickness, 0, 1, _type, _backplate_distance);