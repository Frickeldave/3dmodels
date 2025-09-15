// IKEA Skadis Baseplate
// Parametric model for creating custom sized baseplates
// By frickeldave

// Parameters - adjust these to change the baseplate size
holes_x = 7;        // Number of holes in X direction
holes_y = 6;        // Number of holes in Y direction
plate_thickness = 10; // Thickness of the baseplate in mm

// Constants based on IKEA Skadis specifications
hole_spacing_x = 40;    // Distance between hole centers in X (mm)
hole_spacing_y = 20;    // Distance between hole centers in Y (mm)
row_offset = 20;        // Offset for every second row in X direction (mm)
hole_width = 5;         // Width of the slot holes (mm)
hole_height = 15;       // Height of the slot holes (mm)
hole_radius = 2.5;      // Radius of the rounded ends of holes (mm)
border_distance = 20;   // Distance from hole center to plate edge (mm)
corner_radius = 5;      // Radius for plate corners (mm)
edge_radius = 4;        // Radius for rounded edges (mm) -> Must be less than half of the thickness

// Calculate plate dimensions
num_columns = ceil(holes_x);
plate_width = holes_x % 2 == 0 ? (holes_x / 2 - 1) * hole_spacing_x + row_offset + 2 * border_distance : floor(holes_x / 2) * hole_spacing_x + 2 * border_distance;
plate_height = (holes_y - 1) * hole_spacing_y + 2 * border_distance;

module skadis_baseplate() {
    difference() {
        // Main plate with rounded corners
        minkowski() {
            linear_extrude(height = plate_thickness - edge_radius * 2) {
                rounded_square([plate_width - edge_radius * 2, plate_height - edge_radius * 2], corner_radius);
            }
            sphere(r = edge_radius);
        }
        
        // Create holes array with offset pattern
        for (x = [0:num_columns-1]) {
            echo ("row ", x);
            for (y = [0:holes_y-1]) {
                // Calculate X offset for every second row
                x_offset = (y % 2 == 1) ? row_offset : 0;
                
                // Only create a hole if it's within the desired hole count
                if (x * 2 + (y % 2) < holes_x) {
                    translate([
                        border_distance + x * hole_spacing_x + x_offset - plate_width/2,
                        border_distance + y * hole_spacing_y - plate_height/2,
                        -edge_radius + 0.1
                    ])
                    skadis_hole();
                }
            }
        }
    }
}

// Module for creating a single Skadis hole
module skadis_hole() {
    linear_extrude(height = plate_thickness + 0.2) {
        hull() {
            // Bottom circle
            translate([0, -(hole_height - 2*hole_radius)/2])
                circle(r = hole_radius);
            // Top circle  
            translate([0, (hole_height - 2*hole_radius)/2])
                circle(r = hole_radius);
        }
    }
}

// Helper module for rounded square
module rounded_square(size, radius) {
    hull() {
        translate([radius - size[0]/2, radius - size[1]/2])
            circle(r = radius);
        translate([size[0]/2 - radius, radius - size[1]/2])
            circle(r = radius);
        translate([size[0]/2 - radius, size[1]/2 - radius])
            circle(r = radius);
        translate([radius - size[0]/2, size[1]/2 - radius])
            circle(r = radius);
    }
}

// Create the baseplate
skadis_baseplate();

// Display information
echo(str("Baseplate dimensions: ", plate_width, "mm x ", plate_height, "mm x ", plate_thickness, "mm"));
echo(str("Number of holes: ", holes_x, " x ", holes_y, " = ", holes_x * holes_y, " total"));
