// Platte mit gleichmäßig verteilten Löchern
// Erstellt mit OpenSCAD

// Parameter
loch_durchmesser = 20;     // Durchmesser der Löcher in mm
loch_abstand = 12;         // Abstand zwischen den Löchern in mm
rand_abstand = 15;         // Abstand der Löcher zum Rand in mm
anzahl_loecher = 9;        // Anzahl der Löcher (3x3 Grid)
platten_dicke = 3;         // Dicke der Platte in mm
abstandhalter_laenge = 10; // Länge der Abstandhalter in mm
abstandhalter_breite = 3;  // Breite der Abstandhalter in mm

// Berechnung der Plattengröße
loecher_pro_reihe = sqrt(anzahl_loecher);  // 3 Löcher pro Reihe bei 9 Löchern
platten_breite = (loecher_pro_reihe * loch_durchmesser) + 
                 ((loecher_pro_reihe - 1) * loch_abstand) + 
                 (2 * rand_abstand);
platten_laenge = platten_breite;  // Quadratische Platte

echo("Plattengröße:", platten_breite, "x", platten_laenge, "x", platten_dicke);

// Modul für Eck-Abstandhalter
module eck_abstandhalter(breite, laenge, hoehe, dicke) {
    // Horizontaler Balken
    cube([laenge, dicke, hoehe]);
    // Vertikaler Balken
    cube([dicke, laenge, hoehe]);
}

// Hauptobjekt
union() {
    difference() {
        // Grundplatte
        cube([platten_breite, platten_laenge, platten_dicke]);
        
        // Löcher erstellen
        for (x = [0:loecher_pro_reihe-1]) {
            for (y = [0:loecher_pro_reihe-1]) {
                // Position berechnen
                pos_x = rand_abstand + (loch_durchmesser / 2) + 
                        x * (loch_durchmesser + loch_abstand);
                pos_y = rand_abstand + (loch_durchmesser / 2) + 
                        y * (loch_durchmesser + loch_abstand);
                
                // Loch erstellen (Zylinder durch die gesamte Platte)
                translate([pos_x, pos_y, -0.5])
                    cylinder(h = platten_dicke + 1, 
                            d = loch_durchmesser, 
                            $fn = 50);
            }
        }
    }
    
    // Abstandhalter in den Ecken
    // Ecke oben links
    translate([0, 0, platten_dicke])
        eck_abstandhalter(platten_breite, abstandhalter_laenge, 22 - platten_dicke, abstandhalter_breite);
    
    // Ecke oben rechts
    translate([platten_breite, 0, platten_dicke])
        rotate([0, 0, 90])
        eck_abstandhalter(platten_breite, abstandhalter_laenge, 22 - platten_dicke, abstandhalter_breite);
    
    // Ecke unten rechts
    translate([platten_breite, platten_laenge, platten_dicke])
        rotate([0, 0, 180])
        eck_abstandhalter(platten_breite, abstandhalter_laenge, 22 - platten_dicke, abstandhalter_breite);
    
    // Ecke unten links
    translate([0, platten_laenge, platten_dicke])
        rotate([0, 0, 270])
        eck_abstandhalter(platten_breite, abstandhalter_laenge, 22 - platten_dicke, abstandhalter_breite);
}
