// Garden sign with stake and single or double line text
$fn = 100;
// Parameters
width = 100;        // Sign width in mm
height = 40;        // Sign height in mm
thickness = 2;      // Sign thickness in mm
corner_radius = 4;  // Corner radius in mm
plug_length = 80;   // Stake length in mm
plug_width = 20;    // Stake width in mm
text_size = ###GardensignFontsize###;     // Font size in mm
text_line1 = ###GardensignLine1###;       // First text line
text_line2 = ###GardensignLine2###;       // Second text line (empty for single line)
is_multiline = ###GardensignIsMultiLine###; // true/false for multiline text

// Module for rounded rectangle
module rounded_rect(width, height, radius, thickness) {
    hull() {
        // Four circles for rounded corners
        translate([radius, radius, 0])
            cylinder(h=thickness, r=radius, $fn=50);
        translate([width-radius, radius, 0])
            cylinder(h=thickness, r=radius, $fn=50);
        translate([radius, height-radius, 0])
            cylinder(h=thickness, r=radius, $fn=50);
        translate([width-radius, height-radius, 0])
            cylinder(h=thickness, r=radius, $fn=50);
    }
}

// Main module for the sign
module garden_sign() {
    // Sign surface
    rounded_rect(width, height, corner_radius, thickness);
    
    // Text
    if (is_multiline) {
        // Double line text
        // First line (above center)
        translate([width/2, height/2 + text_size/2 + 2, thickness])
        linear_extrude(height=1) // 1 mm extrusion for 3D text
        text(text_line1, size=text_size, font="Arial:style=Bold", halign="center", valign="center");
        
        // Second line (below center)
        translate([width/2, height/2 - text_size/2 - 2, thickness])
        linear_extrude(height=1) // 1 mm extrusion for 3D text
        text(text_line2, size=text_size, font="Arial:style=Bold", halign="center", valign="center");
    } else {
        // Single line text (centered)
        translate([width/2, height/2, thickness])
        linear_extrude(height=1) // 1 mm extrusion for 3D text
        text(text_line1, size=text_size, font="Arial:style=Bold", halign="center", valign="center");
    }

    // Border
    color("blue")
    translate([0, 0, thickness])
    difference() {
        rounded_rect(width, height, corner_radius, 2);
        translate([2, 2, -1])
        rounded_rect(width - 4, height - 4, corner_radius, 4);
    }

    // Stake
    union() {
        translate([width/2 - plug_width/2, 0, 0])
        hull() {
            // Rectangular part of stake
            cube([plug_width, 1, thickness]);
            // Pointed tip of stake
            translate([plug_width/2, -plug_length-1, 0])
                cylinder(h=thickness, r=1, $fn=50);
        }

        color("pink")
        translate([width/2 - 1, -plug_length + 10, 2])
        cube([2, plug_length - 10, thickness]);

        color("red")
        translate([width/2 - 1, -plug_length + 10, thickness])
        rotate([0, 90, 0])
        cylinder(h=2, d=4);

    }
}

// Render sign
garden_sign();