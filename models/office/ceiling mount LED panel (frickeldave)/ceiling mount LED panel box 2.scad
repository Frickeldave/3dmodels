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
cm_width = 190;                 // Außenbreite des Gehäuses in mm
cm_depth = 80;                  // Außentiefe des Gehäuses in mm
cm_height = 60;                 // Außenhöhe des Gehäuses in mm
cm_thickness = 4;               // Wandstärke des Materials in mm

cm_tolerance = 0.2;              // Fertigungstoleranz in mm

// Kabelausgang-Parameter
cm_coh_diameter = 30;         // Außendurchmesser des Kabelausgangs in mm (Innendurchmesser ist Außendurchmesser - t)
cm_coh_length = 8;             // Länge des Kabelausgangs-Rohrs in mm (Für Netzteil und LED Anschluß)
cm_coh_ceiling_distance = 11;   // Abstand des Kabelausgangs zur Decke in mm

// LED-Panel Montage
cm_led_mount_stick_dia = 16;              // Durchmesser des Montagestabs für das LED-Panel in mm
cm_led_mount_width = 70;              // Durchmesser des Montagestabs für das LED-Panel in mm
cm_led_mount_depth = 60;              // Durchmesser des Montagestabs für das LED-Panel in mm

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
module panel_mount2(st, md, mw) {
    difference() {
        
        union() {
            // Verstärkungszylinder für die Panel-Halterung
            // Sorgt für zusätzliche Stabilität an der Befestigungsstelle
            translate([0, 0, -0])
            rotate([0, 90, 0])
            cylinder(h = mw, d = md);

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

/*
 * MODUL: GEHÄUSE-DECKEL VERSION 2 (EINSCHMELZMUTTER-SYSTEM)
 * 
 * Erstellt einen verstärkten Deckel für das LED-Panel Gehäuse mit Einschmelzmutter-Befestigung.
 * Dieses System ersetzt die anfälligen Clips durch robuste Gewindebefestigungen.
 * 
 * KONSTRUKTIONSPRINZIP:
 * - Hauptdeckel mit Verstärkungsrahmen für optimale Passgenauigkeit
 * - 6 Einschmelzmutter-Halterungen für werkzeuglose Montage/Demontage
 * - 2 zentrale Befestigungspunkte für zusätzliche Stabilität
 * - Toleranzkompensation für 3D-Druck-Ungenauigkeiten
 * 
 * PARAMETER:
 * w   = width - Außenbreite des Deckels in mm
 * d   = depth - Außentiefe des Deckels in mm  
 * t   = thickness - Wandstärke des Materials in mm
 * tol = tolerance - Fertigungstoleranz für Passgenauigkeit in mm
 * dsh = distance screw holes - Abstand zwischen den zentralen Befestigungslöchern in mm
 * 
 * VERWENDUNG:
 * panel_cover2(190, 80, 4, 0.2, 153);
 * 
 * MONTAGE:
 * 1. Einschmelzmuttern in die 6 Halterungen einsetzen
 * 2. Case auf Deckel aufsetzen
 * 3. Mit 6 Schrauben (M4) von unten befestigen
 * 4. 2 zentrale Schrauben (M4) für Montage an Decke oder Wand
 */
module panel_cover2(w, d, t, tol, dsh) {

    /*
     * HILFSFUNKTION: EINSCHMELZMUTTER-HALTERUNG
     * 
     * Erstellt eine spezielle Halterung für Einschmelzmuttern (Threaded Inserts).
     * Die Form ermöglicht sicheren Halt der Mutter und einfache Montage.
     * 
     * KONSTRUKTIONSDETAILS:
     * - Zylindrische Aufnahme für die Einschmelzmutter
     * - Rechteckige Verlängerung für Stabilität am Deckel
     * - Zentrales Loch (5mm) für Einschmelzmuttern
     * 
     * PARAMETER:
     * w = width - Durchmesser der Mutter-Aufnahme in mm
     * h = height - Höhe/Tiefe der Halterung in mm
     * t = thickness - Wandstärke der Halterung in mm
     *
     */
    module nutholder(w, h, t) {
        
        difference() {
            union() {
                // Zylindrische Aufnahme für die Einschmelzmutter
                // Durchmesser passend für Standard M5 Einschmelzmuttern
                color("lightblue")
                cylinder(h = t, d = w);

                // Rechteckige Verstärkung zur Befestigung am Deckel
                // Sorgt für stabile Verbindung und verhindert Rotation
                color("blue")
                translate([- w / 2, 0, 0])
                cube([w, h - w / 2, t]);
            }

            // Aussparung für saubere Kanten und Materialersparnis
            // Entfernt überstehende Teile der rechteckigen Verstärkung
            color("red")
            translate([- w / 2 - 1, h - w / 2, - 1])
            cube([w + 2, h, t + 2]);

            // Zentrales Durchgangsloch für M5-Schraube
            // 5mm Durchmesser für freien Schraubendurchgang
            translate([0, 0, -1])
            cylinder(h = t + 2, d = 5);

        }
    }



    /*
     * HAUPTKONSTRUKTION DES DECKELS
     * 
     * Der Deckel besteht aus mehreren Schichten für optimale Funktion:
     * 1. Grundplatte - Hauptstruktur des Deckels
     * 2. Verstärkungsrahmen - Führung und Passgenauigkeit
     * 3. Zentrale Befestigungspunkte
     */
    difference() {
        
        union() {

            // GRUNDPLATTE DES DECKELS
            // Bildet die Hauptstruktur und verschließt das Gehäuse
            color("red")
            cube([w, d, t]);

            /*
             * VERSTÄRKUNGSRAHMEN FÜR PASSGENAUIGKEIT
             * 
             * Dieser Rahmen ragt in das Gehäuse hinein und sorgt für:
             * - Exakte Positionierung des Deckels
             * - Schutz vor seitlichem Verrutschen
             * - Verstärkung der Deckelfläche
             */
            difference() {
                // Äußerer Verstärkungsrahmen
                // Abmessungen berücksichtigen Wandstärke und Toleranzen
                color("green")
                translate([t + tol, t + tol, t])
                cube([w - t * 2 - tol * 2, d - t * 2 - tol * 2, t]);

                // Innere Aussparung für Materialersparnis
                // Reduziert Gewicht ohne Stabilitätsverlust
                color("green")
                translate([t * 2 + tol, t * 2 + tol, t + 0])
                cube([w - t * 4 - tol * 2, d - t * 4 - tol * 2, t + 1]);
            }

            /*
             * ZENTRALE BEFESTIGUNGSPUNKTE
             * 
             * Zusätzliche Schraubbefestigung für kritische Anwendungen.
             * Position berechnet sich aus der Gesamtbreite minus dem 
             * Abstand der Schraubenlöcher (dsh).
             */
            
            // Verstärkungspunkt links für M4-Schraube
            // Zylindrische Verstärkung um das Schraubenloch
            color("cyan")
            translate([(w - dsh) / 2, d / 2, t + 0])
            cylinder(h = 2, r = 5);

            // Verstärkungspunkt rechts für M4-Schraube
            // Symmetrische Anordnung für gleichmäßige Kraftverteilung
            color("cyan")
            translate([w - ((w - dsh) / 2), d / 2, t + 0])
            cylinder(h = 2, r = 5);
        }

        /*
         * ZENTRALE BEFESTIGUNGSLÖCHER
         * 
         * M4-Schraubenlöcher für optionale zusätzliche Befestigung.
         * Durchmesser 4mm für freien Durchgang von M4-Schrauben.
         */
        
        // Schraubenloch links (M4)
        color("cyan")
        translate([(w - dsh) / 2, d / 2, - 1])
        cylinder(h = t * 2 + 2, r = 2);

        // Schraubenloch rechts (M4)  
        color("cyan")
        translate([w - ((w - dsh) / 2), d / 2, - 1])
        cylinder(h = t * 2 + 2, r = 2);
    }

    /*
     * EINSCHMELZMUTTER-HALTERUNGEN
     * 
     * 6 Halterungen für robuste Befestigung des Deckels.
     * Anordnung: 3 vorne, 3 hinten für gleichmäßige Kraftverteilung.
     * 
     * PARAMETER DER HALTERUNGEN:
     * - Durchmesser: 16mm (passend für M5 Einschmelzmuttern)
     * - Höhe: 15mm (ausreichend für sichere Aufnahme)
     * - Tiefe: 10mm (Eindringtiefe in den Deckel)
     */

    // VORDERE HALTERUNGEN (Zugänglichkeitsseite)
    
    // Halterung unten links
    translate([20, t + tol, 11])
    rotate([-90, 0, 0])
    nutholder(16, 15, 10);
    
    // Halterung unten mitte
    translate([w / 2, t + tol, 11])
    rotate([-90, 0, 0])
    nutholder(16, 15, 10);

    // Halterung unten rechts
    translate([w - 20, t + tol, 11])
    rotate([-90, 0, 0])
    nutholder(16, 15, 10);

    // HINTERE HALTERUNGEN (Wandseite)
    
    // Halterung oben links
    translate([20, d - t - tol - 10, 11])
    rotate([-90, 0, 0])
    nutholder(16, 15, 10);

    // Halterung oben mitte
    translate([w / 2, d - t - tol - 10, 11])
    rotate([-90, 0, 0])
    nutholder(16, 15, 10);

    // Halterung oben rechts
    translate([w - 20, d - t - tol - 10, 11])
    rotate([-90, 0, 0])
    nutholder(16, 15, 10);

}


module panel_case2(w, d, h, t, cohl, cohd, cohc) {

        
    /*
     * Hilfsfunktion: 2mm Verstärkungsrippen für das Gehäuse
     * Erhöht die Stabilität und verhindert Verformungen
     * Sorgt für Unterlüftung, da das Netzteil nicht flach anliegt
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
            cube([w, d, h - t]);

            // Äußerer Ring des Kabelausgangs
            // Verstärkung um das Kabelausgangsloch
            color("cyan")
            translate([-cohl, d / 2, h - cohd / 2 - cohc])
            rotate([0, 90, 0])
            cylinder(h=cohl, d=cohd);

        }
        
        // Innenraum des Gehäuses ausschneiden
        translate([t, t, t])
        cube([w - t * 2, d - t * 2, h + 1]);

        // Kabelausgang an der Unterseite für LED Anschluss
        translate([-cohl - 1, d / 2, h - cohd / 2 - cohc])
        rotate([0, 90, 0])
        cylinder(h = cohl + t + 2, d = cohd - t * 2);

        // Befestigungslöcher für Montageschrauben (vorne links)
        color("red")
        translate([20, 1 + t, h - 11])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2.5);

        // Befestigungslöcher für Montageschrauben (vorne mitte)
        color("red")
        translate([w / 2, 1 + t, h - 11])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2.5);

        // Befestigungslöcher für Montageschrauben (vorne rechts)
        color("red")
        translate([w - 20, 1 + t, h - 11])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2.5);


        // Befestigungslöcher für Montageschrauben (hinten links)
        color("red")
        translate([20, d + 1, h - 11])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2.5);

        // Befestigungslöcher für Montageschrauben (hinten mitte)
        color("red")
        translate([w / 2, d + 1, h - 11])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2.5);

        // Befestigungslöcher für Montageschrauben (hinten rechts)
        color("red")
        translate([w - 20, d + 1, h - 11])
        rotate([90, 0, 0])
        cylinder(h = t * 2, r = 2.5);

        // Kabeldurchführung für LED-Panel Stromkabel
        // Durchmesser 15mm für Standard-Stromkabel
        color("red")
        translate([w - 35, d / 2, -1])
        cylinder(h = t + 2, r = 7.5);

        // Belüftungsschlitze für Wärmeableitung
        // Gleichmäßig verteilt mit festem Abstand zur Außenkante
        // Um 90° gedreht für bessere 3D-Druckbarkeit
        
        // Berechnung für gleichmäßige Verteilung der Schlitze
        slot_count = 5;                                        // Anzahl der Belüftungsschlitze
        slot_start = t + 10;                                    // Abstand zur Außenkante (links)
        slot_end = w - t - 10;                                  // Abstand zur Außenkante (rechts)
        available_width = slot_end - slot_start;               // Verfügbare Breite für Schlitze
        slot_section_width = available_width / slot_count;     // Breite pro Schlitz-Bereich
        slot_length = slot_section_width * 0.7;               // 70% für Schlitz, 30% für Abstand
        
        for(i = [0 : slot_count - 1]) {
            
            // Position jedes Schlitzes berechnen
            slot_x = slot_start + i * slot_section_width + (slot_section_width - 3) / 2;
            
            // Belüftungsschlitze vorne
            color("red")
            translate([slot_x, -1, h - 20])
            rotate([0, 90, 0])
            box_cooling(slot_length, t + 2, 3);

            // Belüftungsschlitze hinten
            color("red")
            translate([slot_x, d - t - 1, h - 20])
            rotate([0, 90, 0])
            box_cooling(slot_length, t + 2, 3);
        }

        // Befestigungsloch für die LED-Halterung
        // M5 Schraube zur Montage der Panel-Halterung
        color("red")
        translate([32, d / 2, -20])
        cylinder(h=40, r = 2.5);

    }

    // Verstärkungsrippen im Inneren
    // Erhöhen die Stabilität ohne viel zusätzliches Material
    // Gleichmäßig verteilt mit maximal 30mm Abstand zwischen den Rippen
    
    // Berechnung für gleichmäßige Verteilung der Verstärkungsrippen
    max_rib_spacing = 40;                                      // Maximaler Abstand zwischen Rippen
    rib_start = t + 20;                                         // Abstand zur Außenkante (links)
    rib_end = w - t - 20;                                       // Abstand zur Außenkante (rechts)
    available_rib_width = rib_end - rib_start;                 // Verfügbare Breite für Rippen
    rib_count = ceil(available_rib_width / max_rib_spacing);   // Anzahl benötigter Rippen
    rib_spacing = available_rib_width / (rib_count - 1);       // Tatsächlicher Abstand zwischen Rippen
    
    for(i = [0 : rib_count - 1]) {
        
        // Position jeder Verstärkungsrippe berechnen
        rib_x = rib_start + i * rib_spacing;
        
        echo("Verstärkungsrippe", i + 1, "von", rib_count, "bei X =", rib_x);
        color("cyan")
        translate([rib_x, t, t + 2])
        box_reinforcement(2, d - t - t, h - 35);
    }

}

// translate([0, cm_depth, cm_height])
// rotate([180, 0, 0])
// panel_cover2(cm_width, cm_depth, cm_thickness, cm_tolerance, 153);

panel_case2(cm_width, cm_depth, cm_height, cm_thickness, cm_coh_length, cm_coh_diameter, cm_coh_ceiling_distance);

// translate([0, cm_depth, cm_height])
// panel_mount2(cm_led_mount_stick_dia, cm_led_mount_depth, cm_led_mount_width);