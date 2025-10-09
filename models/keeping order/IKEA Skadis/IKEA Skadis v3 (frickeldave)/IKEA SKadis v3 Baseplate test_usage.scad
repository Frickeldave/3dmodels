// Test file to demonstrate external usage of the IKEA Skadis Baseplate module

// Include the baseplate module
include <IKEA SKadis v3 Baseplate.scad>

// Example 1: Basic usage with default parameters
color("lightgray")
translate([-150, 0, 0])
skadis_baseplate(hole_type = "chamfered");

// Example 2: Custom size with 3x4 holes
color("lightblue")
translate([150, -150, 0])
skadis_baseplate(holes_x=3, holes_y=4);

// Example 3: Thicker plate with rounded corners
color("lightgreen")
translate([150, 0, 0])
skadis_baseplate(
    holes_x=2, 
    holes_y=3, 
    plate_thickness=8,
    corner_radius=5
);

// Example 4: Large baseplate with custom spacing
color("lightcoral")
translate([0, -150, 0])
skadis_baseplate(
    holes_x=5, 
    holes_y=3, 
    plate_thickness=6,
    border_distance=25
);

// Example 6: Large baseplate with standard holes
color("lightgoldenrodyellow")
translate([-170, -150, 0])
skadis_baseplate(holes_x = 7, holes_y = 7, hole_type = "standard", draw_holes = true);