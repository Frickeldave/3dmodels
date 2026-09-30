// ============================================================
// CFS Feet – Erhöhungsfüße für das Creality CFS
// TPU-Fuß mit umlaufender Kante, damit das CFS nicht verrutscht.
// Die 4 Außenecken sind abgerundet, nach unten hin wird er breiter.
// ============================================================

use <../../../modules/scad/roundedcube.scad>

// --- Render Settings ----------------------------------------
$fn = 60;

// --- Parameters ---------------------------------------------
_foot_x        = 52;  // Breite des CFS-Fußes [mm]
_foot_y        = 21;  // Tiefe des CFS-Fußes [mm]
_height        = 10;  // Erhöhung des CFS (bestimmt, wie viel höher das CFS steht) [mm]
_oversize      = 3;   // Überstand rundherum [mm]
_rim_height    = 3;   // Höhe der umlaufenden Kante [mm]
_corner_radius = 2;   // Rundung der 4 Außenecken [mm]
_fit_tolerance = 0.4; // Spiel für den Sitz des CFS-Fußes [mm]
_bottom_flare  = 3;   // Verbreiterung nach unten je Seite [mm]
_cut_overhang  = 0.1; // Ausschnitt ragt über die Oberkante (gegen Artefakte) [mm]

// --- Computed Values ----------------------------------------
_eps      = 0.01;                        // Toleranz gegen Render-Artefakte [mm]
_base_x   = _foot_x + 2 * _oversize;     // 56 mm – Breite des Quaders
_base_y   = _foot_y + 2 * _oversize;     // 25 mm – Tiefe des Quaders
_bottom_x = _base_x + 2 * _bottom_flare; // Breite des Fußes unten
_bottom_y = _base_y + 2 * _bottom_flare; // Tiefe des Fußes unten
_total_z  = _height + _rim_height;       // Gesamthöhe inkl. Kante
_pocket_x = _foot_x + _fit_tolerance;    // Breite der Aufnahme für den CFS-Fuß
_pocket_y = _foot_y + _fit_tolerance;    // Tiefe der Aufnahme für den CFS-Fuß

// --- Main Model ---------------------------------------------
cfs_foot();

// --- Modules ------------------------------------------------
module cfs_foot() {
    difference() {
        // Korpus: verjüngt sich nach oben – unten breiter, oben 56 × 25 mm
        hull() {
            // Unterer, breiterer Fußabdruck mit abgerundeten Ecken
            translate([_base_x / 2, _base_y / 2, 0])
                linear_extrude(_eps)
                offset(r = _corner_radius)
                square([_bottom_x - 2 * _corner_radius, _bottom_y - 2 * _corner_radius], center = true);

            // Quader mit abgerundeten Außenecken
            roundedcube([_base_x, _base_y, _total_z], false, _corner_radius, "z");
        }

        // Aussparung für den CFS-Fuß – es bleibt eine umlaufende Kante stehen
        // (ragt oben 0.1 mm über, damit keine Deckfläche-Artefakte entstehen)
        translate([
            (_base_x - _pocket_x) / 2,
            (_base_y - _pocket_y) / 2,
            _total_z - _rim_height - _eps
        ])
        cube([_pocket_x, _pocket_y, _rim_height + _eps + _cut_overhang]);
    }
}
