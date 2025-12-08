$fn =100;

_dia_bottom = 10;
_dia_top =20;
_height =33; 
_plate_thickness = 2;
_plate_width = 35;
_plate_depth = 35;
_screw_hole_dia = 5;
_screw_hole_offset = 6;

module Feets(_h, _db, _dt, _pw, _pd, _pt, _shd, _sho){
    difference() {
        
        union(){
            translate([0, 0,((_h - _db / 2) / 2) + _db / 2])
            cylinder(h=_h - _db / 2, d1=_db, d2=_dt, center=true);

            translate([0, 0, _db / 2])
            sphere(d=_db, center=true);

            translate([0, 0, _h + (_pt / 2)])
            cube([_pw, _pd, _pt], center=true);
        }

        // 4 screwholes in plate
        color("Red")
        translate([(_pw / 2) - _sho, (_pd / 2) - _sho, _h + (_pt / 2)])
        cylinder(h = _pt + 2, d = _shd, center=true);

        color("Pink")
        translate([(_pw / 2) - _sho, (_pd / 2) - _sho, _h])
        cylinder(h = 2, d1 = _shd * 2, d2 = _shd, center=true);

        color("Red")
        translate([-((_pw / 2) - _sho), (_pd / 2) - _sho, _h + (_pt / 2)])
        cylinder(h = _pt + 2, d = _shd, center=true);

        color("Pink")
        translate([-((_pw / 2) - _sho), (_pd / 2) - _sho, _h])
        cylinder(h = 2, d1 = _shd * 2, d2 = _shd, center=true);

        color("Red")
        translate([(_pw / 2) - _sho, -((_pd / 2) - _sho), _h + (_pt / 2)])
        cylinder(h = _pt + 2, d = _shd, center=true);

        color("Pink")
        translate([(_pw / 2) - _sho, -((_pd / 2) - _sho), _h])
        cylinder(h = 2, d1 = _shd * 2, d2 = _shd, center=true);

        color("Red")
        translate([-((_pw / 2) - _sho), -((_pd / 2) - _sho), _h + (_pt / 2)])
        cylinder(h = _pt + 2, d = _shd, center=true);

        color("Pink")
        translate([-((_pw / 2) - _sho), -((_pd / 2) - _sho), _h])
        cylinder(h = 2, d1 = _shd * 2, d2 = _shd, center=true);
    }
}

Feets(_height, _dia_bottom, _dia_top, _plate_width, _plate_depth, _plate_thickness, _screw_hole_dia, _screw_hole_offset);

// Mit Aussparung
// difference(){
//     // Main Feets
//     Feets(_height, _dia_bottom, _dia_top, _plate_width, _plate_depth, _plate_thickness, _screw_hole_dia, _screw_hole_offset);

//     color("red")
//     translate([-_plate_width / 4 + 1, -_plate_depth / 4 + 1, _height + (_plate_thickness / 2) + 2])
//     cube([_plate_width / 2 + 10 + 1, _plate_depth / 2 + 10 + 1, 5], center=true);

// }

