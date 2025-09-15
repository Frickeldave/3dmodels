
$fn = 100; 


difference() {
    union() {
        cylinder(h=5, d=20);
        translate([0, 0, 5])
        cylinder(h=5, d=12.5);

    }   
    
    
    translate([0, 0, -1])
    cylinder(h=12, d=7.4);
}
