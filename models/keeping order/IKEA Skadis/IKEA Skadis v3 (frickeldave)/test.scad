// Include the baseplate module
use <IKEA SKadis v3 Baseplate.scad>

// Example 6: Large baseplate with standard holes
color("lightgoldenrodyellow")
skadis_baseplate(holes_x = 10, holes_y = 10, hole_type = "standard", draw_holes = true);

// Example 7: Piggyback configuration with standard holes
translate([0, 0, 30])
skadis_piggyback(holes_x = 7, holes_y = 8, hole_type = "standard", draw_holes = true, depth = 30);
