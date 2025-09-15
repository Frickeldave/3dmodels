/*
 * LED Panel Ceiling Mount Box
 * 
 * Dieses 3D-Modell erstellt ein komplettes Montagesystem für LED-Panels an der Decke.
 * Das System besteht aus drei Hauptkomponenten:
 * 1. Hauptgehäuse (panel_box) - Aufnahme für Elektronik und Verkabelung
 * 2. Deckel (panel_cover) - Verschluss mit Clips für einfachen Zugang
 * 3. Panel-Halterung (panel_mount) - Befestigung für das LED-Panel
 * 
 * Autor: frickeldave
 * Datum: 2025
 */

$fn = 50; // Auflösung für runde Objekte (höhere Werte = glattere Oberflächen)

// =============================================================================
// KONFIGURATIONSPARAMETER
// =============================================================================

// Innenmaße des Gehäuses
cm_width = 190;                 // Innenbreite des Gehäuses in mm
cm_depth = 60;                  // Innentiefe des Gehäuses in mm  
cm_height = 45;                 // Innenhöhe des Gehäuses in mm
cm_thickness = 4;               // Wandstärke des Materials in mm

// Kabelausgang-Parameter
cm_coh_diameter = 28.1;         // Durchmesser des Kabelausgangs in mm
cm_coh_length = 10;             // Länge des Kabelausgangs-Rohrs in mm
cm_coh_ceiling_distance = 15;   // Abstand des Kabelausgangs zur Decke in mm

// LED-Panel Montage
cm_led_mount = 16;              // Durchmesser des Montagestabs für das LED-Panel in mm


// =============================================================================
// MODUL: LED-PANEL HALTERUNG
// =============================================================================

/*
 * Erstellt eine Halterung für das LED-Panel
 * 
 * Parameter:
 * st = Stick thickness - Dicke des Montagestabs
 * md = Mount depth - Tiefe der Verstärkung 
 * mw = Mount width - Breite der Verstärkung
 */
module panel_mount(st, md, mw) {
    difference() {
        
        union() {
            // Verstärkungszylinder für die Panel-Halterung
            // Sorgt für zusätzliche Stabilität an der Befestigungsstelle
            translate([0, 0, -0])
            rotate([0, 90, 0])
            cylinder(h = mw, r = md / 2);

            // Montagestab für das LED-Panel
            // Angewinkelt für optimale Panel-Positionierung
            translate([40, 0, -0])
            rotate([0, 140, 0])
            cylinder(h = 100, r = st / 2);
        }

        // Abschrägung für den Verstärkungszylinder
        // Formel: d = a * sqrt(2) für 45-Grad-Abschrägung
        color("red")
        translate([-(md * sqrt(2)) / 2, -(md * sqrt(2)) / 2, -(md * sqrt(2)) / 2])
        rotate([0, 45, 0])
        cube([md, md * 2, md]);

        // Obere Aussparung für saubere Kanten
        color("red")
        translate([mw / 2, 0, md / 4])
        cube([mw + 2, md + 2, md / 2 + 30], center=true);

        // Befestigungsloch für Schraube (M5)
        color("red")
        translate([mw / 2, 0, - md / 2 - 1])
        cylinder(h=40, r = 2.5);

    }
}

// =============================================================================
// MODUL: HAUPTGEHÄUSE
// =============================================================================

/*
 * Erstellt das Hauptgehäuse für die LED-Panel Elektronik
 * 
 * Parameter:
 * w = inner width - Innenbreite des Gehäuses
 * d = inner depth - Innentiefe des Gehäuses
 * h = inner height - Innenhöhe des Gehäuses
 * t = thickness - Wandstärke des Materials
 * col = cable outlet length - Länge des Kabelausgang-Rohrs
 * codis = cable outlet distance - Abstand des Kabelausgangs zur Decke
 * cohdia = cable outlet diameter - Durchmesser des Kabelausgangs
 */
module panel_box(w, d, h, t, col, codis, cohdia) {
    
    /*
     * Hilfsfunktion: Verstärkungsrippen für das Gehäuse
     * Erhöht die Stabilität und verhindert Verformungen
     */
    module box_reinforcement(w, d, h) {
        difference() {
            cube([w, d, h]);

            // Aussparung für Materialersparnis bei gleicher Stabilität
            color("red")
            translate([-1, w, w])
            cube([w + 2, d - w * 2, h]);
        }
    }

    /*
     * Hilfsfunktion: Belüftungsschlitze
     * Sorgt für Luftzirkulation und Wärmeableitung
     */
    module box_cooling(w, d, h) {
        
        // Runde Enden für besseren Luftstrom
        translate([0, d, h / 2])
        rotate([90, 0, 0])
        cylinder(h = d, r = h / 2);
        
        // Rechteckiger Hauptschlitz
        cube([w, d, h]);

        // Runde Enden (andere Seite)
        translate([w, d, h / 2])
        rotate([90, 0, 0])
        cylinder(h = d, r = h / 2);

    }

    difference() {
        
        union() {
            // Das Hauptgehäuse - Außenwände mit Wandstärke
            cube([w + t * 2, d + t * 2, h + t * 2]);

            // Äußerer Ring des Kabelausgangs
            // Verstärkung um das Kabelausgangsloch
            translate([-col, d / 2 + t, h - cohdia / 2 - codis + t])
            rotate([0, 90, 0])
            cylinder(h=col, r=cohdia / 2 + t * 2);

        }

        // Unterkante des äußeren Rings abschneiden 
        // Sorgt für eine gerade Kante am Gehäuse
        color("green")
        translate([-col - 1, 0, - t - 1])
        cube([col + 2 + 1, d + t * 2, t + 1]);
        
        // Innenraum des Gehäuses ausschneiden
        translate([t, t, t])
        cube([w, d, h + t + 1]);

        // Kabelausgang an der Rückseite
        // Für Netzanschlusskabel zur Decke
        translate([-col - 1, d / 2 + t,  h - cohdia / 2 - codis + t])
        rotate([0, 90, 0])
        cylinder(h = col + t + 2, r = cohdia / 2);

        // Befestigungslöcher für Montageschrauben (vorne links)
        color("red")
        translate([t + 5, 1 + t, h - 5])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2);

        // Befestigungslöcher für Montageschrauben (vorne mitte)
        color("red")
        translate([w /2, 1 + t, h - 5])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2);

        // Befestigungslöcher für Montageschrauben (vorne rechts)
        color("red")
        translate([w - t - 5, 1 + t, h - 5])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2);

        // Befestigungslöcher für Montageschrauben (hinten links)
        color("red")
        translate([t + 5, d + 1 + t * 2, h - 5])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2);

        // Befestigungslöcher für Montageschrauben (hinten mitte)
        color("red")
        translate([w /2, d + 1 + t * 2, h - 5])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2);

        // Befestigungslöcher für Montageschrauben (hinten rechts)
        color("red")
        translate([w - t - 5, d + 1 + t * 2, h - 5])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2);

        // Kabeldurchführung für LED-Panel Stromkabel
        // Durchmesser 15mm für Standard-Stromkabel
        color("red")
        translate([w -20, d / 2, -1])
        cylinder(h = t + 2, r = 7.5);

        // Belüftungsschlitze für Wärmeableitung
        // Verteilt über die gesamte Breite für optimale Kühlung
        for(i = [0 : w / 5 : w]) {

            if(i < w) {
                // Belüftungsschlitze vorne
                color("red")
                translate([i + 8, -1, h - 15])
                box_cooling(w / 5 - 12, t + 2, 3);

                // Belüftungsschlitze hinten
                color("red")
                translate([i + 8, d + t -1, h - 15])
                box_cooling(w / 5 - 12, t + 2, 3);
            }
        }

        // Befestigungsloch für die LED-Halterung
        // M5 Schraube zur Montage der Panel-Halterung
        color("red")
        translate([28.5, d / 2 + 2.0, -20])
        cylinder(h=40, r = 2.5);
    }

    // Verstärkungsrippen im Inneren
    // Erhöhen die Stabilität ohne viel zusätzliches Material
    for(i = [0 : w / 5 : w]) {
        color("cyan")
        translate([i + 1, t, t])
        box_reinforcement(2, d, h - 12);
    }

}

// =============================================================================
// MODUL: GEHÄUSE-DECKEL
// =============================================================================

/*
 * Erstellt den Deckel für das Hauptgehäuse
 * 
 * Parameter:
 * w = width - Breite des Deckels
 * d = depth - Tiefe des Deckels  
 * h = height - Höhe des Deckels
 * t = thickness - Wandstärke des Materials
 */
module panel_cover(w, d, h, t) {

    /*
     * Hilfsfunktion: Befestigungsclips
     * Ermöglicht werkzeuglose Montage des Deckels
     * 
     * Parameter:
     * d = depth - Tiefe des Clips
     */
    // module clip(d) {

    //     difference() {
    //         union() {
                
    //             // Oberer Teil des Clips (vorne)
    //             // Bildet die Haltekante
    //             color("green")
    //             translate([0, 0, 0])
    //             cube([10, 4, 10]);

    //             // Unterer runder Teil des Clips (vorne)
    //             // Ermöglicht das Einrasten
    //             color("green")
    //             translate([5, 4, 0])
    //             rotate([90, 0, 0])
    //             cylinder(h = 4, r = 5);

    //             // Verstärkung zwischen vorderem und hinterem Clip
    //             color("green")
    //             translate([0, 4, 8])
    //             cube([10, d - 8, 2]);

    //             // Oberer Teil des Clips (hinten)
    //             color("green")
    //             translate([0, d - 4, 0])
    //             cube([10, 4, 10]);

    //             // Unterer runder Teil des Clips (hinten)
    //             color("green")
    //             translate([5, d, 0])
    //             rotate([90, 0, 0])
    //             cylinder(h = 4, r = 5);
    //         }

    //         // Befestigungsloch für Einschmelzmutter (vorne)
    //         // M5 Gewinde für sichere Verbindung
    //         color("red")
    //         translate([5, 5, 1])
    //         rotate([90, 0, 0])
    //         cylinder(h = 4 + 2, r = 2.5);

    //         // Befestigungsloch für Einschmelzmutter (hinten)
    //         color("red")
    //         translate([5, d + 1, 1])
    //         rotate([90, 0, 0])
    //         cylinder(h = 4 + 2, r = 2.5);
    //     }
    // }

    difference() {
        union() {
            // Die Deckelplatte
            color("blue")
            cube([w, d, t]);

            // Innenrahmen für bessere Passgenauigkeit
            // Verhindert seitliches Verrutschen des Deckels
            difference() {

                color("cyan")
                translate([t + 0.2, t + 0.2, - t + 2])
                cube([w - t * 2 - 0.4, d - t * 2 - 0.4, 2]);

                // Innere Aussparung für Materialersparnis
                translate([t * 2 + 0.2, t * 2 + 0.2, - t +1])
                cube([w - t * 4 - 0.4, d - t * 4 - 0.4, 4]);
            }

            // // Befestigungsclip links
            // translate([t, t + 0.2, -10])
            // clip(d - t * 2 - 0.4);

            // // Befestigungsclip mitte
            // translate([w / 2 - 7, t + 0.2, -10])
            // clip(d - t * 2 - 0.4);

            // // Befestigungsclip rechts
            // translate([w - 16, t + 0.2, -10])
            // clip(d - t * 2 - 0.4);

            // Zusätzlicher Befestigungspunkt links
            // Für optionale Schraubverbindung
            color("cyan")
            translate([20, d / 2, -t +2])
            cylinder(h = 2, r = 5);

            // Zusätzlicher Befestigungspunkt rechts
            color("cyan")
            translate([w - 20, d / 2, -t + 2])
            cylinder(h = 2, r = 5);
        }

        // Befestigungsloch links (M4 Schraube)
        color("red")
        translate([20, d / 2, -t +1])
        cylinder(h = t + 2 + 2, r = 2);

        // Befestigungsloch rechts (M4 Schraube)
        color("red")
        translate([w - 20, d / 2, -t + 1])
        cylinder(h = t + 2 + 2, r = 2);

    }
}

// =============================================================================
// OBJEKTERSTELLUNG UND RENDERING
// =============================================================================

/*
 * Hier werden die einzelnen Komponenten gerendert.
 * Kommentiere die gewünschten Teile ein/aus je nach Bedarf.
 */

// LED-Panel Halterung rendern
// Aktivieren für 3D-Druck der Halterung
//translate([-10, cm_depth / 2 + cm_thickness, 15])
//panel_mount(cm_led_mount, cm_depth, 77);

// Hauptgehäuse rendern  
// Aktivieren für 3D-Druck des Gehäuses
//panel_box(cm_width, cm_depth, cm_height, cm_thickness, cm_coh_length, cm_coh_ceiling_distance, cm_coh_diameter);

// Deckel rendern
// Aktivieren für 3D-Druck des Deckels
// Position: Oberhalb des Gehäuses für Montage-Vorschau
translate([0, 0, cm_height + cm_thickness * 2])
panel_cover(cm_width + cm_thickness * 2, cm_depth + cm_thickness * 2, cm_height, cm_thickness); 