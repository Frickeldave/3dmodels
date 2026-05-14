
$fn = 100;
_width = 12;
_height = 50;
_thickness = 12;

module holder_corpus(_w, _h, _t, _offset = 0) {
    
    points = [
        [0, 0],
        [_w , 0],
        [_w - 2, _t],
        [2, _t],
        [0, 0]
    ];

    rotate([270, 180, 0])
    //translate([-13, -8, 0])
    linear_extrude(height = _h + _offset) {
        offset(r = _offset)
        polygon(points);
    }
}


module holder(_w, _h, _t, _o) {

    difference() {

        holder_corpus(_w, _h, _t, _o);

        color("red")
        translate([-_w/2, 10,  -1])
        cylinder(h=_t + 2, r=1.6, center=false);

        color("red")
        translate([-_w / 2, _h - 10, -1])
        cylinder(h=_t + 2, r=1.6, center=false);


        color("green")
        translate([-_w / 2, 10, -2])
        cylinder(h=4, r1=6, r2=2, center=false);

        color("green")
        translate([-_w / 2, _h - 10, -2])
        cylinder(h=4, r1=6, r2=2, center=false);
    }


}

module attachment() {

        color("green")
        translate([0, 0, 0])
        cube([_width, 4, _thickness], center=false);

    difference() {
    
        translate([0, 0, 0])
        cube([_width, _height, _thickness], center=false);

        color("red")
        translate([1, -1, _thickness / 2 - 0.1]) 
        rotate([0, 180, 0])
        holder_corpus(_width - 2, _height + 2, _thickness / 2, 0);
    
    }
}


module hook_cyl() {

    attachment();

    _hook_height = 40;

    translate([_width / 2, _height / 2, _thickness])
    cylinder(h=_hook_height, r= 5);

    translate([_width / 2, _height / 2, _thickness])
    cylinder(h=10, r1= 10, r2 = 5);

    translate([_width / 2, _height / 2, _hook_height + _thickness])
    cylinder(h=10, r1= 5, r2 = 10);
}


module hook() {

    attachment();

    _hook_height = 40;

    points = [
        [0, 0],
        [_height - 5, 0],
        [_height, 5],
        [_height, _hook_height - 5],
        [_height - 5, _hook_height],
        [_height - 10, _hook_height],
        [_height - 10, _hook_height-5],
        [_height - 7, _hook_height-5],
        [_height - 6, _hook_height-6],
        [_height - 6, 6],
        [_height - 7, 5],
        [0, 5]
    ];

    translate([0, 0, _thickness - 3])
    rotate([90, 0, 90])
    linear_extrude(height = _width) {
        polygon(points);
    }

}

//hook();

//attachment();

holder(_width - 2, _height - 4, _thickness / 2, -0.2);

