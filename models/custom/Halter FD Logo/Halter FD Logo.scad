
// ===========================
// FD Logo Holder
// ===========================

difference() {
    // Union: Create the main structure
    union() {
        // Top conical section
        translate([0, 0, 190])
        cylinder(h = 4, d = 40);

        // Top conical section
        translate([0, 0, 170])
        cylinder(h = 20, d1 = 20, d2 = 40);
        
        // Middle shaft / mounting pole
        translate([0, 0, 70])
        cylinder(h = 100, d = 20);
        
        // Transition cone (between shaft and base)
        translate([0, 0, 50])
        cylinder(h = 20, d1 = 40, d2 = 20);
        
        // Base disc
        cylinder(h = 50, d = 40);
    }
    
    // Subtraction: Cut-out hole through the center
    translate([0, 0, -2])
    cylinder(h = 50, d = 36);

    // Subtraction: Cut-out hole through the middle shaft
    color("red")
    translate([0, 0, 47])
    cylinder(h = 149, d = 16);

    // Subtraction: Cut-out hole through the transition cone
    color("blue")
    translate([0, 0, 47])
    cylinder(h = 20, d1 = 37, d2 = 16);

    // Subtraction: Cut-out hole through the top conical section
    color("red")
    translate([6, -2, -1])
    cube([20, 4, 62], center = false);

}




