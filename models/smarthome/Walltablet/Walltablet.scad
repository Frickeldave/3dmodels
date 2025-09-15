$fn = 50; // Auflösung für runde Formen

use <./../../modules/scad/hex_grid_v02.scad>;

_c_width = 350; // Cover width
_c_depth = 350; // Cover depth
_c_heigth = 5;  // Cover height
_i_width = 335; // Inlay width
_i_depth = 335; // Inlay depth
_i_heigth = 26; // Inlay height (thickness)
_bp_width = 350; // Baseplate width (X)
_bp_depth = 350; // Baseplate depth (Y)
_bp_height = 4; // Material thickness of baseplate
_t_width = 240.2; // Cutout width (X) for the tablet in the baseplate 
_t_depth = 160; // Cutout depth (Y) for the tablet in the baseplate
_t_thickness = 16; // Backholder for the tablet
_t_cutouttype = "sides"; // corner; sides
_t_bpc_width = 230; // baseplate tablet cutout
_t_bpc_height = 150; // baseplate tablet cutout
_t_xoffset = -25; // How muc the tablet should be moved to the right 
_m_dia = 8; // Diameter of the magnets
_m_thickness = 3; // Thickness of the magnets
_m_numholes = 20; // Number of magnets to hold the cover
_spacer_type = "enforcements"; // empty, grid, filled, enforcements

// Basic layout for the inlay
// w = outer width of the inlay
// d = outer depth of the inlay
// h = heigth of the inlay
// tcw = tablet cutout width
// tcd = tablet cutout depth
// tct = tablet cutout thickness
// txo = tablet x offset
// md = magnet diameter
// mt = magnet thickness
// mnh = magnet number of holes (at all; 20 will create 10 at the top and ten at the bottom)
module inlay_base(w, d, h, tcw, tcd, tct, txo, md, mt, mnh) {
    
    _grid_thickness = 10;
    _grid_size = (d - tcd - ((md + 10) * 2)) / 2;
    
    module screw_hole() {
        union() {
            translate([0, 0, h - 3])
            cylinder(h = 5, r1 = 2, r2 = 6);
            cylinder(h = h + 2, r = 2);
        }
        
    }

    difference() {
        
        union() {
            // magnets bottom
            cube([w, md + 10, h]);

            // spacer bottom
            difference() {
                translate([0, md + 10, 0])
                cube([w, _grid_size, h]);

                if(_spacer_type == "grid" || _spacer_type == "empty" || _spacer_type == "enforcements") {
                    color("red")
                    translate([_grid_thickness, md + 10 + _grid_thickness, -1])
                    cube([w - _grid_thickness * 2, _grid_size - _grid_thickness * 2, h + 2]);
                }
            }
            if(_spacer_type == "grid") {
                // The grid in the bottom grid frame
                translate([10, md + 20, 0])
                hexgrid([w - 40, _grid_size, h], 20, 10);
            }

            // enforcement botton
            if(_spacer_type == "enforcements") {
                translate([w / 3 - 5, md + 10, 0])
                cube([10, _grid_size, h]);

                translate([w / 3 * 2 - 5, md + 10, 0])
                cube([10, _grid_size, h]);
            }

            // tablet area
            translate([0, _grid_size + _m_dia + 10, 0])
            cube([w, tcd, h]);

            // spacer top
            difference() {
                translate([0, md + 10 + _grid_size + _t_depth, 0])
                cube([w, _grid_size, h]);

                if(_spacer_type == "grid" || _spacer_type == "empty" || _spacer_type == "enforcements") {
                    color("red")
                    translate([_grid_thickness, md + 20 + _grid_size + _t_depth, -1])
                    cube([w - _grid_thickness * 2, _grid_size - _grid_thickness * 2, h + 2]);
                }
            }

            if(_spacer_type == "grid") {
                // The grid in the top grid frame
                translate([10, md + 10 + _grid_size + _t_depth, 0])
                hexgrid([w - 40, _grid_size, h], 20, 10);
            }

            // enforcement top
            if(_spacer_type == "enforcements") {
                translate([w / 3 - 5, md + 10 + _grid_size + _t_depth, 0])
                cube([10, _grid_size, h]);

                translate([w / 3 * 2 - 5, md + 10 + _grid_size + _t_depth, 0])
                cube([10, _grid_size, h]);
            }

            // magnet top
            translate([0, md + 10 + _grid_size + _t_depth + _grid_size])
            cube([w, md + 10, h]);
        }

        // Cutout for the tablet
        translate([w / 2 - tcw / 2 + txo, d / 2 - tcd / 2, h - tct])
        cube([tcw, tcd, h + 2]);

        // Cutout backwall
        translate([w / 2 - tcw / 2 + 10 + txo, d / 2 - tcd / 2 + 10, -1])
        cube([tcw - 20, tcd - 20, h + 2]);

        // Option 1: Hoes to grab the tablet at the corners
        if(_t_cutouttype == "corner") {
            // Corner cutout bottom left
            translate([w / 2 - tcw / 2 + 10 + txo, d / 2 - tcd / 2 + 10, h - tct])
            cylinder(h = h + 2, d = 40);

            // Corner cutout bottom right
            translate([w / 2 - tcw / 2 + tcw - 10 + txo, d / 2 - tcd / 2 + 10, h - tct])
            cylinder(h = h + 2, d = 40);

            // Corner cutout top left
            translate([w / 2 - tcw / 2 + 10 + txo, d / 2 - tcd / 2 + tcd - 10, h - tct])
            cylinder(h = h + 2, d = 40);

            // Corner cutout top right
            translate([w / 2 - tcw / 2 + tcw - 10 + txo, d / 2 - tcd / 2 + tcd - 10, h - tct])
            cylinder(h = h + 2, d = 40);
        }

        // Option 1: Hoes to grab the tablet at the sides
        if(_t_cutouttype == "sides") {
            
            hull() {
                // Corner cutout bottom left
                translate([w / 2 - tcw / 2 + 10 + txo, d / 2 - tcd / 2 + 35, h - tct])
                cylinder(h = h + 2, d = 40);

                // Corner cutout top left
                translate([w / 2 - tcw / 2 + 10 + txo, d / 2 - tcd / 2 + tcd - 35, h - tct])
                cylinder(h = h + 2, d = 40);
            }

            hull() {
            // Corner cutout bottom right
            translate([w / 2 - tcw / 2 + tcw - 10 + txo, d / 2 - tcd / 2 + 35, h - tct])
            cylinder(h = h + 2, d = 40);

            // Corner cutout top right
            translate([w / 2 - tcw / 2 + tcw - 10 + txo, d / 2 - tcd / 2 + tcd - 35, h - tct])
            cylinder(h = h + 2, d = 40);
            }

        }

        // Magnet holes bottom
        for (i = [1 : mnh / 2 - 2]) {
            color("red")
            translate([((i + 0.5) * w / mnh) * 2, md / 2 + 5, h - mt])
            cylinder(h = mt + 1, d = md, center = false);
            //TODO: Add magnet tolerance based on experience for baseplate
        }

        // Magnet holes top
        for (i = [1 : mnh / 2 - 2]) {
            color("red")
            translate([((i + 0.5) * w / mnh) * 2, d - md / 2 - 5, h - mt])
            cylinder(h = mt + 1, d = md, center = false);
            //TODO: Add magnet tolerance based on experience for baseplate
        }

        // screw hole bottom left outer
        color("green")
        translate([10, 10, - 1])
        screw_hole();

        // screw hole bottom left inner
        color("green")
        translate([10, md + 10 + _grid_size + 10, - 1])
        screw_hole();

        // screw hole top left inner
        color("green")
        translate([10, md + 10 + _grid_size + tcd - 10, - 1])
        screw_hole();

        // screw hole top left outer
        color("green")
        translate([10, d - 10, - 1])
        screw_hole();

        // screw hole bottom right outer
        color("green")
        translate([w - 10, 10, - 1])
        screw_hole();

        // screw hole bottom right inner
        color("green")
        translate([w - 10, md + 10 + _grid_size + 10, - 1])
        screw_hole();

        // screw hole top right inner
        color("green")
        translate([w - 10, md + 10 + _grid_size + tcd - 10, - 1])
        screw_hole();

        // screw hole top right outer
        color("green")
        translate([w - 10, d - 10, - 1])
        screw_hole();
    }
}

// General module for cubes with rounded corners
module chamfered_cube(w, d, h) {
    minkowski() {
        translate([2, 2, 0])
        cube([w - 4, d - 4, h - 2], center = false);
        cylinder(h = 2, r1 = 2, r2 = 0, center = false);
    }
}

// Baseplate with rounded corners and cutout for the tablet
module baseplate(w, d, h, tcw, tcd, md, mt, mnh, iw, id, ih) {
    difference() {
        
        // The baseplate
        chamfered_cube(w, d, h);

        // The rest of the cutout for the tablet
        color("red")
        translate([w / 2 - tcw / 2 + _t_xoffset, d / 2 - tcd / 2, - 1])
        cube([tcw, tcd, h + 2]);

        // The chamfer cutout for the tablet
        color("cyan")
        translate([
            tcw + w/2 - tcw/2 + _t_xoffset + 2,  // back to chamfer-Radius in X
            d/2 - tcd/2          - 2,      // back to chamfer-Radius in Y
            h * 2
        ]) 
        rotate([0, 180, 0])
        chamfered_cube(tcw + 4, tcd + 4, h + 2);


        // Magnet holes bottom
        for (i = [1 : mnh / 2 - 2]) {
            color("red")
            translate([((i + 0.5) * iw / mnh) * 2 + ((w - iw) / 2), ((d - id) / 2) + md / 2 + 5, -1])
            cylinder(h = mt + 1, d = md + 0.2, center = false);
        }

        // Magnet holes top
        for (i = [1 : mnh / 2 - 2]) {
            color("red")
            translate([((i + 0.5) * iw / mnh) * 2 + ((w - iw) / 2), d - ((d - id) / 2) - md / 2 - 5, -1])
            cylinder(h = mt + 1, d = md + 0.2, center = false);
        }
    }
}

// Inlay with some specific customizings
module inlay() {
    difference() {
        inlay_base(_i_width, _i_depth, _i_heigth,  _t_width, _t_depth, _t_thickness, _t_xoffset, _m_dia, _m_thickness, _m_numholes);

        color("blue")
        translate([_i_width / 2 - _t_width / 2 + _t_width + _t_xoffset, _i_depth / 2 - _t_depth / 2 + _t_depth - 60 - 30, _i_heigth - _t_thickness + 1])
        cube([60, 60, _t_thickness]);

        color("pink")
        translate([_i_width / 2 - _t_width / 2 + _t_width + _t_xoffset + 45, _i_depth / 2 - _t_depth / 2 + _t_depth - 60 - 30, -1])
        cube([15, 60, _i_heigth + 2]);

    }
}

//translate([-((_c_width - _i_width) /2), -((_c_depth - _i_depth) / 2),30])
//baseplate(_c_width, _c_depth, _c_heigth, _t_bpc_width, _t_bpc_height, _m_dia, _m_thickness, _m_numholes, _i_width, _i_depth, _i_heigth);

inlay();