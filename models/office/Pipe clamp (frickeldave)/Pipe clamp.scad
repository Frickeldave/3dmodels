// ============================================================
// Pipe clamp
// Kombinierte Datei: Single-Mount, Mount-Halter und Fixator in einer Datei.
// Die Geometrien sind direkt übernommen, ohne externe Dateien
// zu referenzieren. Jedes Teil ist als Modul gekapselt und
// über einen Schalter ein-/ausschaltbar.
// ============================================================

use <../../../modules/scad/roundedcube.scad>

// --- Render Settings ----------------------------------------
$fn = 400;

// --- Parameters ---------------------------------------------
// Schalter: Einzelteile an-/abschalten
_enable_mount   = true;   // Mount anzeigen [bool]
_enable_holder  = true;   // Mount-Halter anzeigen [bool]
_enable_fixator = true;   // Fixator anzeigen [bool]

// Ausrichtung der Mount-Öffnung: "up", "down", "left", "right"
_mount_orientation = "up";

// Gemeinsame Abmessungen
pcf_depth               = 60;   // Tiefe der Halterung (Y-Achse) [mm]
pcf_thickness           = 18;   // Dicke der Stütze [mm]
pcf_pipe_diameter       = 32;   // Durchmesser des Rohrs [mm]
pcf_screwhole_diameter  = 5;    // Durchmesser der Schraubenlöcher [mm]
pcf_clearance_hole_diameter = 5.5; // Durchmesser der Durchgangslöcher (Schraube frei durchsteckbar) [mm]
pcf_screw_head_diameter = 8.5;  // Durchmesser des Schraubenkopfs [mm]
pcf_screw_offset        = 7;    // Abstand der Schraubenlöcher vom Rand [mm]

// Schraubenkopf-Höhe je Variante
pcf_mount_screw_head_hight   = 5;  // Single-Mount [mm]
pcf_fixator_screw_head_hight = 4;  // Fixator [mm]

// Höhe des Single-Mounts (unabhängig vom Fixator konfigurierbar)
pcf_mount_single_height = 25;  // Höhe des Single-Mounts [mm]

// Z-Abstand zwischen Mount und Fixator
_fixator_clearance = 10;    // Freiraum über dem Mount [mm]

// Mount-Halter
_holder_height = 30;    // Höhe des Mount-Halters [mm]

// Zentrales Bohrloch im Mount-Halter
_holder_center_hole_diameter      = 5.5;    // Durchmesser des zentralen Bohrlochs [mm]
_holder_countersink_head_diameter = 12.4; // Durchmesser der Senkkopf-Versenkung (oben) [mm]
_holder_countersink_angle         = 90;   // Senkkopf-Winkel [Grad]

// Abstand zwischen Halter und Mount
_mount_clearance = 10;  // Anhebung des Mounts über dem Halter [mm]

// Nut am tiefsten Punkt der Rundung
_nut_width = 12;  // Breite der Nut [mm]
_nut_depth = 4;   // Tiefe unter dem tiefsten Punkt der Rundung [mm]

// Abrundung der Außenecken
_corner_radius = 2;  // Radius der Außenecken [mm]

// --- Computed Values ----------------------------------------
pcf_body_height   = pcf_pipe_diameter / 2 + 7;  // Höhe des Fixator-Körpers [mm]
_fixator_z_offset = _holder_height + _mount_clearance + pcf_mount_single_height + _fixator_clearance;  // Z-Position des Fixators [mm]

// Tiefe der Senkkopf-Versenkung aus Kopf-Durchmesser und Winkel
_holder_countersink_depth = (_holder_countersink_head_diameter - _holder_center_hole_diameter) / 2 / tan(_holder_countersink_angle / 2);

// --- Main Model ---------------------------------------------
if (_enable_holder)  mount_holder();
if (_enable_mount)   mount_single();
if (_enable_fixator) fixator();

// --- Modules ------------------------------------------------
// Rotationswinkel je Ausrichtung (Grundgeometrie: Öffnung zeigt nach unten)
function _mount_rotation(orientation) =
    orientation == "up"    ? [180, 0, 0] :
    orientation == "left"  ? [0, 90, 0] :
    orientation == "right" ? [0, -90, 0] :
    [0, 0, 0];  // "down"

// Verschiebung, damit die untere linke Ecke nach der Drehung auf (0,0,0) liegt
function _mount_translation(orientation) =
    orientation == "up"    ? [0, pcf_thickness, pcf_mount_single_height] :
    orientation == "left"  ? [0, 0, pcf_depth] :
    orientation == "right" ? [pcf_mount_single_height, 0, 0] :
    [0, 0, 0];  // "down"

// Single-Mount: Halterung ohne mittleres Loch
// (übernommen aus "Pipe clamp mount single.scad")
module mount_single() {
    // Über dem Mount-Halter platzieren
    translate([0, 0, _holder_height + _mount_clearance])
    // Öffnung in die gewünschte Richtung drehen und auf (0,0,0) ausrichten
    translate(_mount_translation(_mount_orientation))
    rotate(_mount_rotation(_mount_orientation))
    // Längsachse (Tiefe 50 mm) von +Y auf +X drehen
    translate([0, pcf_thickness, 0])
    rotate([0, 0, -90])
    difference() {
        // Grundkörper
        color("grey")
        roundedcube([pcf_thickness, pcf_depth, pcf_mount_single_height], false, _corner_radius, "z");

        // Auflagefläche für den Wasserzähler
        translate([-1, pcf_depth / 2, -1])
        rotate([0, 90, 0])
        cylinder(r = pcf_pipe_diameter / 2, h = pcf_pipe_diameter + 2);

        // Nut am tiefsten Punkt der Rundung, komplett nach oben offen
        translate([-1, pcf_depth / 2 - _nut_width / 2, 0])
        cube([pcf_thickness + 2, _nut_width, pcf_pipe_diameter / 2 - 1 + _nut_depth]);

        // linke Schraube (Durchgangsloch – Schraube frei durchsteckbar)
        color("red")
        translate([pcf_thickness / 2, pcf_screw_offset, -1])
        cylinder(pcf_pipe_diameter / 2 + 9, pcf_clearance_hole_diameter / 2, pcf_clearance_hole_diameter / 2);

        // rechte Schraube (Durchgangsloch – Schraube frei durchsteckbar)
        color("red")
        translate([pcf_thickness / 2, pcf_depth - pcf_screw_offset, -1])
        cylinder(pcf_pipe_diameter / 2 + 9, pcf_clearance_hole_diameter / 2, pcf_clearance_hole_diameter / 2);
    }
}

// Mount-Halter: Grundplatte unter dem Mount auf Z = 0
module mount_holder() {
    difference() {
        // Grundplatte (X/Y immer wie der Mount)
        color("grey")
        roundedcube([pcf_depth, pcf_thickness, _holder_height], false, _corner_radius, "z");

        // linkes Loch (identisch zum Mount)
        color("red")
        translate([pcf_screw_offset, pcf_thickness / 2, -1])
        cylinder(h = _holder_height + 2, r = pcf_screwhole_diameter / 2 - 0.5);

        // rechtes Loch (identisch zum Mount)
        color("red")
        translate([pcf_depth - pcf_screw_offset, pcf_thickness / 2, -1])
        cylinder(h = _holder_height + 2, r = pcf_screwhole_diameter / 2 - 0.5);

        // zentrales Bohrloch
        color("red")
        translate([pcf_depth / 2, pcf_thickness / 2, -1])
        cylinder(h = _holder_height + 2, r = _holder_center_hole_diameter / 2);

        // Senkkopf-Versenkung (oben)
        color("pink")
        translate([pcf_depth / 2, pcf_thickness / 2, _holder_height - _holder_countersink_depth])
        cylinder(h = _holder_countersink_depth + 1, r1 = _holder_center_hole_diameter / 2, r2 = _holder_countersink_head_diameter / 2);
    }
}

// Fixator: Halterung mit Schraubenkopf-Senkungen links/rechts
// (übernommen aus "Pipe clamp fixator.scad")
module fixator() {
    // Fixator immer oberhalb des Mounts platzieren
    translate([0, 0, _fixator_z_offset])
    // Längsachse (Tiefe 50 mm) von +Y auf +X drehen
    translate([0, pcf_thickness, 0])
    rotate([0, 0, -90])
    difference() {
        // Grundkörper
        color("grey")
        roundedcube([pcf_thickness, pcf_depth, pcf_body_height], false, _corner_radius, "zmax");

        // Auflagefläche für den Wasserzähler
        translate([-1, pcf_depth / 2, -1])
        rotate([0, 90, 0])
        cylinder(r = pcf_pipe_diameter / 2, h = pcf_pipe_diameter + 2);

        // linke Schraube (Durchgangsloch – Schraube frei durchsteckbar)
        color("red")
        translate([pcf_thickness / 2, pcf_screw_offset, -1])
        cylinder(pcf_pipe_diameter / 2 + 9, pcf_clearance_hole_diameter / 2, pcf_clearance_hole_diameter / 2);

        // linke Schraubenkopf-Senkung
        color("pink")
        translate([pcf_thickness / 2, pcf_screw_offset, pcf_body_height - pcf_fixator_screw_head_hight])
        cylinder(h = pcf_fixator_screw_head_hight + 1, r1 = pcf_clearance_hole_diameter / 2, r2 = pcf_screw_head_diameter / 2 + 1);

        // rechte Schraube (Durchgangsloch – Schraube frei durchsteckbar)
        color("red")
        translate([pcf_thickness / 2, pcf_depth - pcf_screw_offset, -1])
        cylinder(pcf_pipe_diameter / 2 + 9, pcf_clearance_hole_diameter / 2, pcf_clearance_hole_diameter / 2);

        // rechte Schraubenkopf-Senkung
        color("pink")
        translate([pcf_thickness / 2, pcf_depth - pcf_screw_offset, pcf_body_height - pcf_fixator_screw_head_hight])
        cylinder(h = pcf_fixator_screw_head_hight + 1, r1 = pcf_clearance_hole_diameter / 2, r2 = pcf_screw_head_diameter / 2 + 1);
    }
}
