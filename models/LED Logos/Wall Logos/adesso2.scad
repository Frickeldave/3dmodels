$fn=40;

// === KONFIGURATION ===
_file = "adesso.svg";
_t = 2;                    // Wandstärke
_logo_height = 20;         // Korpus Höhe
_frame_width = 10;         // Rahmenbreite
_cover_height = 7;         // Cover Höhe
_tolerance = -0.4;         // Passtoleranz
_scale_factor = 0.39;      // Logo Skalierung

// Kabelausschnitte als Array [x, y, z, width, depth, height]
_cable_cuts = [
    [5, 67, 2, 10, 10, 10],     // Kabelausschnitt 1
    [-15, 45, 2, 10, 15, 10],   // Kabelausschnitt 2
    // Weitere Ausschnitte hier hinzufügen...
];

// Rendering-Optionen
render_corpus = false;
render_cover = false;
render_inlay = false;
show_assembly_view = true;  // Assembly-Ansicht aktivieren

/*
=== DRUCK-EINSTELLUNGEN ===
- Layer Height: 0.2mm
- Infill: 15%
- Support: Nur für Cover nötig
- Orientation: Logo flach auf Druckbett
*/


module logo_base(h, o) {
    
    scale([_scale_factor, _scale_factor, 1])
    linear_extrude(height=h)
    offset(o)
    import(file=_file, center=true);

}

// Parametrische Kabelausschnitte
module add_cable_cuts() {
    for (cut = _cable_cuts) {
        color("green")
        translate([cut[0], cut[1], cut[2]])
        cube([cut[3], cut[4], cut[5]]);
    }
}

// LED-Strip Führungskanal
module led_channel(width = 10, depth = 3) {
    difference() {
        logo_base(_t + depth, 2);
        logo_base(_t + depth + 1, 2 - width);
    }
}

// Wandbefestigungslöcher
module mounting_holes() {
    translate([-50, 0, -1])
    cylinder(h = _t + 2, d = 4);
    
    translate([50, 0, -1])
    cylinder(h = _t + 2, d = 4);
}


module logo_corpus(h, t) {

    module logo_inlay(_h) {

        difference() {
            color("violet")
            logo_base(_h, 0);

            color("red")
            translate([0, 0, -1])
            logo_base(_h + 2, -_t);
        }
        
    }

    difference() {
        union() {
            logo_base(h, t);
            
            // LED-Kanal hinzufügen
            if (render_inlay) {
                translate([0, 0, _t])
                led_channel();
            }
        }

        color("red")
        translate([0, 0, _t])
        logo_base(h, 0);
        
        // Wandbefestigungslöcher
        mounting_holes();
    }

    if (render_inlay) {
        logo_inlay(h - 5 -_t);
    }

}


module logo_cover(h,o) {

    color("white")
    translate([0, 0, h])
    logo_base(_t, 0);

    difference() {
        color("green")
        logo_base(h, o);

        color("red")
        translate([0, 0, -1])
        logo_base(h + 2, -_t - o);
    }
}

// Assembly-Ansicht für Entwicklung
module show_assembly() {
    // Korpus mit Kabelausschnitten (fest, undurchsichtig)
    difference() {
        logo_corpus(_logo_height, _frame_width);
        add_cable_cuts();
    }
    
    // Cover transparent und versetzt zeigen
    %translate([0, 0, _logo_height + 2])
    logo_cover(_cover_height, _tolerance);
    
    // Optional: LED-Strip Simulation
    #translate([0, 0, _t + 1])
    color("yellow")
    led_channel(8, 1);  // Gelber LED-Strip zur Visualisierung
}

// === HAUPTCODE ===

if (show_assembly_view) {
    // Komplette Montageansicht
    show_assembly();
} else {
    // Einzelteile rendern
    if (render_corpus) {
        difference() {
            logo_corpus(_logo_height, _frame_width);
            
            // Kabelausschnitte anwenden
            add_cable_cuts();
        }
    }

    if (render_cover) {
        color("white")
        translate([0, 0, _logo_height + 2])
        logo_cover(_cover_height, _tolerance);
    }
}
