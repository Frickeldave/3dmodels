$fn = 100;
_height = 40;

difference() {
    union() {
        // Hauptkörper
        translate([0, 0, 3]) 
        cylinder(h=_height - 3, d=29.5);

        // Untere Fase 3mm
        translate([0, 0, _height])
        cylinder(h = 3, d1=29.5, d2=25.5); 
        
        // Obere Abdeckung
        cylinder(h = 3, d1=32, d2=36);
    }
    // Aussparung unten
    translate([0, 0, -1]) 
    cylinder(h=_height + 3 + 2, d=4.3);

    // Bohrung
    color("red")
    translate([0, 0, -1]) 
    cylinder(h=4, d2=4.3, d1=7.3);

}

