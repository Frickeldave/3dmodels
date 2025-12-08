
$fn = 20;

_width = 80;
_depth = 50;
_height = 80;
_thickness = 2;
_type = "rc"; // c=cube, rc=rounded cube, r=rounded 

_backplate_distance = 0; // additional space between bin and backplate


use <IKEA Skadis v3 Bin.scad>

bin(_width, _depth, _height, _thickness, 5, 1, _type, _backplate_distance);