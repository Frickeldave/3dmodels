// IKEA Skadis Baseplate
// Parametric model for creating custom sized baseplates
// By frickeldave

// IKEA Skadis specifications (usually don't need to be changed)
hole_spacing_x = 40;        // Distance between hole centers in X (mm)
hole_spacing_y = 20;        // Distance between hole centers in Y (mm)
row_offset = 20;            // Offset for every second row in X direction (mm)
hole_width = 5;             // Width of the slot holes (mm)
hole_height = 15;           // Height of the slot holes (mm)
plate_thickness = 5;        // Thickness of the baseplate in mm

// Main function to create IKEA Skadis baseplate
// Call this function from external files with your desired parameters
module skadis_baseplate(
    // Primary parameters
    holes_x = 2,                // Number of holes in X direction
    holes_y = 2,                // Number of holes in Y direction
    plate_thickness = 5,        // Thickness of the baseplate in mm
    
    // Optional parameters
    border_distance = 20,       // Distance from hole center to plate edge (mm)
    corner_radius = 0,          // Radius for plate corners (mm)
    edge_radius_plate = 2,      // Radius for rounded edges (mm) -> Must be less than half of the thickness
    edge_radius_holes = 2,      // Radius for rounded edges (mm) -> Must be less than half of the thickness
    draw_holes = true,          // Set to false to disable hole cutting (for debugging)
    hole_type = "standard",     // Type of holes: "standard" or "chamfered"
    fn = 16                    // Resolution for curves
) {
    // Set local resolution
    $fn = fn;
    
    // Calculate plate dimensions
    num_columns = ceil(holes_x);
    plate_width = holes_x % 2 == 0 ? (holes_x / 2 - 1) * hole_spacing_x + row_offset + 2 * border_distance : floor(holes_x / 2) * hole_spacing_x + 2 * border_distance;
    plate_height = (holes_y - 1) * hole_spacing_y + 2 * border_distance;
    
    difference() {
        if(corner_radius == 0) {
            // Main plate without rounded corners
            translate([-plate_width/2, -plate_height/2, 0])
            cube([plate_width, plate_height, plate_thickness]);
        } else {
            // Main plate with rounded corners
            translate([0, 0, edge_radius_plate])
            minkowski() {
                linear_extrude(height = plate_thickness - edge_radius_plate * 2) {
                    rounded_square([plate_width - edge_radius_plate * 2, plate_height - edge_radius_plate * 2], corner_radius);
                }
                sphere(r = edge_radius_plate);
            }
        }
        
        if(draw_holes == true) {

            // Create holes array with offset pattern
            color("red")
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
                            -0.1
                        ])
                        if(hole_type == "standard")
                            skadis_hole(hole_width / 2, plate_thickness + 0.2, hole_height);
                        else if(hole_type == "chamfered")
                            skadis_hole_chamfered(hole_width / 2, plate_thickness + 0.2, hole_height, edge_radius_holes, edge_radius_holes);
                    }
                }
            }
        }
    }
}

module skadis_piggyback(
    // Primary parameters
    holes_x = 2,                // Number of holes in X direction
    holes_y = 2,                // Number of holes in Y direction

    // Optional parameters
    corner_radius = 0,          // Radius for plate corners (mm)
    edge_radius_plate = 2,      // Radius for rounded edges (mm) -> Must be less than half of the thickness
    edge_radius_holes = 2,      // Radius for rounded edges (mm) -> Must be less than half of the thickness
    draw_holes = true,          // Set to false to disable hole cutting (for debugging)
    hole_type = "standard",   // Type of holes: "standard" or "chamfered"
    fn = 16                    // Resolution for curves

) {

    // Promoted locals (were inside function previously)
    bd = hole_width / 2 + hole_spacing_y; // border distance to match the outer edges of the holes of the baseplate

    // Set local resolution
    $fn = fn;

    plate_width = holes_x % 2 == 0 ? (holes_x / 2 - 1) * hole_spacing_x + row_offset + 2 * bd : floor(holes_x / 2) * hole_spacing_x + 2 * bd;
    plate_height = (holes_y - 1) * hole_spacing_y + 2 * bd;

    difference() {
        // Pass configurable border distance into the baseplate call
        skadis_baseplate(holes_x, holes_y, border_distance = bd, hole_type = "standard", draw_holes = true);

        // Cut out the edges
        if (holes_y % 2 == 0) {
            // Cut out the left edge
            triangle_size = 30;
            color("red")
            translate([0, 0, -1])
            linear_extrude(height = plate_thickness + 2)
            polygon(points = [
                [plate_width / 2 - triangle_size, plate_height / 2 + 1],
                [plate_width / 2 + 1, plate_height / 2 + 1],
                [plate_width / 2 + 1, plate_height / 2 + 1 - triangle_size]
            ]);

            // Cut out the right edge
            color("red")
            translate([0, 0, -1])
            linear_extrude(height = plate_thickness + 2)
            polygon(points = [
                [plate_width / 2 - triangle_size, -plate_height / 2 - 1],
                [plate_width / 2 + 1, -plate_height / 2 - 1],
                [plate_width / 2 + 1, -plate_height / 2 - 1 + triangle_size]
            ]);
        } else {
            // Cut out the left edge
            triangle_size = 70;
            color("red")
            translate([0, 0, -1])
            linear_extrude(height = plate_thickness + 2)
            polygon(points = [
                [plate_width / 2 - triangle_size, plate_height / 2 + 1],
                [plate_width / 2 + 1, plate_height / 2 + 1],
                [plate_width / 2 + 1, plate_height / 2 + 1 - triangle_size]
            ]);

            // Cut out the right edge
            color("red")
            translate([0, 0, -1])
            linear_extrude(height = plate_thickness + 2)
            polygon(points = [
                [plate_width / 2 - triangle_size, -plate_height / 2 - 1],
                [plate_width / 2 + 1, -plate_height / 2 - 1],
                [plate_width / 2 + 1, -plate_height / 2 - 1 + triangle_size]
            ]);
        }
    }
}


module skadis_hole(r, t, h){
    hull(){
        translate([-h / 2 + r, 0, 0])
        cylinder(r=r, h=t + 0.2);
        
        translate([h / 2 - r, 0, 0])
        cylinder(r=r, h=t + 0.2);
    }
}

// chamfercyl - create a cylinder with round chamfered ends
module skadis_hole_chamfered(
    r,               // cylinder radius
    t,               // cylinder height (thickness)
    h,               // hole length for elongated holes
    bcr=0,           // bottom chamfer radius (=0 none, >0 outside, <0 inside)
    tcr=0,           // top chamfer radius (=0 none, >0 outside, <0 inside)
    offset=undef,    // optional offsets in X and Y to create convex hulls at slice level
    slices=10,       // number of slices used for chamfering
    eps=0.01,        // tiny overlap of slices
     ){
    // Calculate offset positions for elongated hole if not provided
    hole_offset = offset != undef ? offset : [[-h/2 + r, 0], [h/2 - r, 0]];
    // Calculate angular step size for chamfering
    astep = 90 / slices;
    
    // Create main cylinder body with hull for offset positions
    hull() {
        for(o = hole_offset) {
            translate([o[0], o[1], abs(bcr) - eps])
                cylinder(r = r, h = t - abs(bcr) - abs(tcr) + 2*eps);
        }
    }
    
    // Create bottom chamfer if specified
    if(bcr) {
        for(a = [0:astep:89.999]) {
            hull() {
                for(o = hole_offset) {
                    translate([o[0], o[1], abs(bcr) - abs(bcr)*sin(a+astep) - eps])
                        cylinder(
                            r2 = r + (1-cos(a)) * bcr,
                            r1 = r + (1-cos(a+astep)) * bcr,
                            h = (sin(a+astep) - sin(a)) * abs(bcr) + 2*eps
                        );
                }
            }
        }
    }
    
    // Create top chamfer if specified
    if(tcr) {
        for(a = [0:astep:89.999]) {
            hull() {
                for(o = hole_offset) {
                    translate([o[0], o[1], t - abs(tcr) + abs(tcr)*sin(a) - eps])
                        cylinder(
                            r1 = r + (1-cos(a)) * tcr,
                            r2 = r + (1-cos(a+astep)) * tcr,
                            h = (sin(a+astep) - sin(a)) * abs(tcr) + 2*eps
                        );
                }
            }
        }
    }
}

// Helper module for rounded square
module rounded_square(s, r) {
    hull() {
        translate([r - s[0]/2, r - s[1]/2, 0])
            circle(r = r);
        translate([s[0]/2 - r, r - s[1]/2, 0])
            circle(r = r);
        translate([s[0]/2 - r, s[1]/2 - r, 0])
            circle(r = r);
        translate([r - s[0]/2, s[1]/2 - r, 0])
            circle(r = r);
    }
}

// color("grey")
// translate([0, 0, -5])
// skadis_baseplate(holes_x = 10, holes_y = 10, hole_type = "standard", draw_holes = true);


skadis_piggyback(holes_x = 7, holes_y = 8, hole_type = "standard", draw_holes = true);



