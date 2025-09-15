$fn=100;

_plug_dia = 3.1;
_plug_high = 5;
_hole_dia = 4.0;
_hole_high = 6;

module aircarier() {
    
    original_width = 4000;
    target_width = 34;
    scale_factor = target_width / original_width;
    
    union() {
        difference() {
            linear_extrude(height = 6)
            scale([scale_factor, scale_factor])
            import("aircarrier.svg");

            color("red")
            translate([7, -1.6, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([13, -1.3, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([19, -1.0, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([25, -0.7, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([31, -0.3, 1])
            cylinder(h=_hole_high, d=_hole_dia);
        }

        color("green")
        translate([12, -1, -5])
        cylinder(h=_plug_high, d=_plug_dia);

        color("green")
        translate([26, -1, -5])
        cylinder(h=_plug_high, d=_plug_dia);
    }
}

module battleship() {

    original_width = 3400;
    target_width = 34;
    scale_factor = target_width / original_width;
    
    union() {
        difference() {
            linear_extrude(height = 6)
            scale([scale_factor, scale_factor])
            import("battleship.svg");

            color("red")
            translate([4, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([10.7, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([17.5, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([24, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);
        }

        color("green")
        translate([4, -1.1, -5])
        cylinder(h=_plug_high, d=_plug_dia);

        color("green")
        translate([18, -1.1, -5])
        cylinder(h=_plug_high, d=_plug_dia);
    }
}

module cruiser() {

    original_width = 3300;
    target_width = 34;
    scale_factor = target_width / original_width;
    
    union() {
        difference() {
            linear_extrude(height = 6)
            scale([scale_factor, scale_factor])
            import("cruiser.svg");

            color("red")
            translate([3, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([9.7, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([16.5, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);
        }

        color("green")
        translate([4, -1.1, -5])
        cylinder(h=_plug_high, d=_plug_dia);

        color("green")
        translate([18, -1.1, -5])
        cylinder(h=_plug_high, d=_plug_dia);
    }
}

module destroyer() {

    original_width = 3300;
    target_width = 34;
    scale_factor = target_width / original_width;
    
    union() {
        difference() {
            linear_extrude(height = 6)
            scale([scale_factor, scale_factor])
            import("destroyer.svg");

            color("red")
            translate([3, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([9, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);
        }

        color("green")
        translate([2.5, -1.1, -5])
        cylinder(h=_plug_high, d=_plug_dia);

        color("green")
        translate([9.5, -1.1, -5])
        cylinder(h=_plug_high, d=_plug_dia);
    }
}


module submarine() {

    original_width = 3300;
    target_width = 34;
    scale_factor = target_width / original_width;
    
    union() {
        difference() {
            linear_extrude(height = 6)
            scale([scale_factor, scale_factor])
            import("submarine.svg");

            color("red")
            translate([4, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([11, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);

            color("red")
            translate([18, -1.1, 1])
            cylinder(h=_hole_high, d=_hole_dia);
        }

        color("green")
        translate([4, -1.1, -5])
        cylinder(h=_plug_high, d=_plug_dia);

        color("green")
        translate([18, -1.1, -5])
        cylinder(h=_plug_high, d=_plug_dia);
    }
}




submarine();