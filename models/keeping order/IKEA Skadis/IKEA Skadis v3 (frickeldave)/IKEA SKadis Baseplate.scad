// IKEA Skadis Baseplate
// Parametric model for creating custom sized baseplates
// By frickeldave

// Main function to create IKEA Skadis baseplate
// Call this function from external files with your desired parameters
module skadis_baseplate(
    // Primary parameters
    holes_x = 2,                // Number of holes in X direction
    holes_y = 2,                // Number of holes in Y direction
    plate_thickness = 5,        // Thickness of the baseplate in mm
    
    // IKEA Skadis specifications (usually don't need to be changed)
    hole_spacing_x = 40,        // Distance between hole centers in X (mm)
    hole_spacing_y = 20,        // Distance between hole centers in Y (mm)
    row_offset = 20,            // Offset for every second row in X direction (mm)
    hole_width = 5,             // Width of the slot holes (mm)
    hole_height = 15,           // Height of the slot holes (mm)
    hole_radius = 2.5,          // Radius of the rounded ends of holes (mm)
    border_distance = 20,       // Distance from hole center to plate edge (mm)
    corner_radius = 0,          // Radius for plate corners (mm)
    edge_radius_plate = 2,      // Radius for rounded edges (mm) -> Must be less than half of the thickness
    edge_radius_holes = 2,      // Radius for rounded edges (mm) -> Must be less than half of the thickness
    fn = 16                     // Resolution for curves
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
                    skadis_hole2(hole_width/2, plate_thickness + 0.2, edge_radius_holes, edge_radius_holes, [[-2,0],[2,0]]);
                }
            }
        }
    }
}

// chamfercyl - create a cylinder with round chamfered ends
module skadis_hole2(
   r,              // cylinder radius
   h,              // cylinder height
   b=0,            // bottom chamfer radius (=0 none, >0 outside, <0 inside)
   t=0,            // top chamfer radius (=0 none, >0 outside, <0 inside)
   offset=[[0,0]], // optional offsets in X and Y to create
                   // convex hulls at slice level
   slices=10,      // number of slices used for chamfering
   eps=0.01,       // tiny overlap of slices
    ){
        astep=90/slices;
        hull()for(o = offset)
        translate([o[0],o[1],abs(b)-eps])cylinder(r=r,h=h-abs(b)-abs(t)+2*eps);
        if(b)for(a=[0:astep:89.999])hull()for(o = offset)
        translate([o[0],o[1],abs(b)-abs(b)*sin(a+astep)-eps])
            cylinder(r2=r+(1-cos(a))*b,r1=r+(1-cos(a+astep))*b,h=(sin(a+astep)-sin(a))*abs(b)+2*eps);
        if(t)for(a=[0:astep:89.999])hull()for(o = offset)
        translate([o[0],o[1],h-abs(t)+abs(t)*sin(a)-eps])
            cylinder(r1=r+(1-cos(a))*t,r2=r+(1-cos(a+astep))*t,h=(sin(a+astep)-sin(a))*abs(t)+2*eps);
}

// Helper module for rounded square
module rounded_square(size, radius) {
    hull() {
        translate([radius - size[0]/2, radius - size[1]/2, 0])
            circle(r = radius);
        translate([size[0]/2 - radius, radius - size[1]/2, 0])
            circle(r = radius);
        translate([size[0]/2 - radius, size[1]/2 - radius, 0])
            circle(r = radius);
        translate([radius - size[0]/2, size[1]/2 - radius, 0])
            circle(r = radius);
    }
}
