$fn = 100;
_height = 40;
_dia = 29.5;
_hole = 5;
_hole_offset = _dia / 4 - _hole / 2; // Offset vom Rand, für zentrieren = "_dia / 2 - _hole / 2"

// if(_hole_offset == 0) {
//     _hole_offset = _dia - (_hole / 2);
// }

difference() {
    union() {
        // Hauptkörper
        translate([0, 0, 3]) 
        cylinder(h = _height - 3, d = _dia);

        // Untere Fase 3mm
        translate([0, 0, _height])
        cylinder(h = 3, d1 = _dia, d2 = _dia - 4); 
        
        // Obere Abdeckung
        cylinder(h = 3, d1=32, d2=36);
    }
    // Aussparung unten
    translate([_dia / 2 - _hole / 2 - _hole_offset, 0, -1]) 
    cylinder(h = _height + 3 + 2, d = _hole);

    // Bohrung
    color("red")
    translate([_dia / 2 - _hole / 2 - _hole_offset, 0, -1]) 
    cylinder(h = 4, d2 = _hole, d1 = _hole + 3);

}

