$fn = 100;

_height = 80;
_width = 70;
_thickness = 4;
_holder_top_dia = 10;
_holder_top_height = 10;
_center_stick_dia = 4;
_center_stick_height = 8;

translate([_width / 2, 0, _height / 2]) 
cube([_width, _thickness, _height], center = true);

// top holder left side
translate([0, 0, _height - _holder_top_height]) 
cylinder(h=_holder_top_height, d=_holder_top_dia);

// topholder right side
translate([_width , 0, _height - _holder_top_height]) 
cylinder(h=_holder_top_height, d=_holder_top_dia);

// top holder connector
translate([_width / 2, 0, _height - _holder_top_height / 2]) 
cube([_width, _holder_top_dia, _holder_top_height], center = true);

// Center stick
translate([_width / 2, 0, - _center_stick_height]) 
cylinder(h = _center_stick_height, d = _center_stick_dia);