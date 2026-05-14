use <./IKEA Skadis v3 Plate.scad>

_width = 60;
_depth = 50;
_height = 80;
_thickness = 2;
_type = "rc"; // c=cube, rc=rounded cube, r=rounded 

module bin(_w, __h, _t, _rh, _tp, _bpd) {

ikea_skadis_backwall(_w, _h, _t, _rh);

}



bin(_width, _depth, _height, _thickness, 5, 1, _type, _backplate_distance);