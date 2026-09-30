// ============================================================
// Lochraster-Quader (z. B. Insulin-/Stift-Aufbewahrung)
// Quader mit hexagonal (halb) versetztem Lochraster.
// Die Lochanzahl passt sich automatisch an Grösse und
// Materialstärke an.
// ============================================================

// --- Render Settings ----------------------------------------
$fn = 60;

// --- Parameters ---------------------------------------------
_length        = 140;  // Länge (X) [mm]
_width         = 90;  // Breite (Y) [mm]
_height        = 45;   // Höhe (Z) [mm]
_hole_diameter = 13;   // Lochdurchmesser [mm]
_wall          = 4;    // Materialstärke (min. Wand zwischen Löchern und zum Rand) [mm]
_corner_radius = 8;    // Radius der 4 abgerundeten Außenecken [mm]
_step_depth = 5;    // Stufe (Kante) als Deckelauflage: Tiefe ins Material [mm]
_overcut    = 0.1;  // Überstand der Fräsung gegen Z-Fighting (5.1 mm gesamt, nur 5 mm ins Material) [mm]
_cartridge_height = 65;  // Höhe der Insulinkartusche [mm]
_lid_gap          = 40;  // Abstand zwischen Box und Deckel (nur Anzeige) [mm]
_fit_clearance    = 0.2; // Spiel für den Deckelrand (Drucktoleranz) [mm]
_magnet_diameter  = 6.2;   // Durchmesser der runden Magnete [mm]
_magnet_depth     = 3;   // Tiefe/Höhe der Magnete [mm]
_text_box         = "Super Soldaten Serum";  // Schriftzug auf der Box
_text_lid         = "Tresiba";               // Schriftzug auf dem Deckel (Bsp. Tresiba oder Lyumjev)
_text_size        = 10;  // Schriftgröße [mm]
_text_size_box    = _text_size * 0.8;  // Schriftgröße der Box (60 %)
_text_depth       = 1.5; // Erhöhung des Schriftzugs (Prägung) [mm]
// --- Computed Values ----------------------------------------
_eps       = 0.01;                          // Toleranz gegen Z-Fighting
_spacing   = _hole_diameter + _wall;        // Lochabstand in einer Reihe (Mitte zu Mitte) [mm]
_row_pitch = _spacing * sqrt(3) / 2;        // Reihenabstand bei Hex-Anordnung [mm]

// Nutzbare Innenfläche nach der Stufe (Stufe je _wall an allen vier Seiten)
_inner_length = _length - 2 * _wall;
_inner_width  = _width  - 2 * _wall;

// Spalten je Reihe (gerade Reihen ohne, ungerade Reihen halb versetzt)
_cols_even = max(floor((_inner_length - 2 * _wall - _hole_diameter) / _spacing) + 1, 0);
// ungerade Reihen eine Spalte weniger als gerade, damit das Raster mittig symmetrisch bleibt
_cols_odd  = max(min(floor((_inner_length - 2 * _wall - _hole_diameter - _spacing / 2) / _spacing) + 1, _cols_even - 1), 0);
_rows      = max(floor((_inner_width  - 2 * _wall - _hole_diameter) / _row_pitch) + 1, 0);

// Lochraster mittig zentrieren (Mitte zu Mitte)
_grid_x = max((_cols_even - 1) * _spacing,
              _spacing / 2 + (_cols_odd - 1) * _spacing);
_x0 = (_length - _grid_x) / 2;
_y0 = (_width  - (_rows - 1) * _row_pitch) / 2;

// Lochtiefen und Deckel-Abmessungen
_box_hole_depth      = _height - _wall;                      // Lochtiefe in der Box (blind) [mm]
_lid_cartridge_depth = _cartridge_height - _box_hole_depth;  // Kartusche ragt in den Deckel [mm]
_lid_body_height     = _lid_cartridge_depth + _wall;         // Deckel-Körperhöhe (Loch + Boden) [mm]
_lid_rim_depth       = _step_depth;                          // Deckelrand passt in die Fräsung [mm]

// Magnet-Positionen an den Enden der Reihen mit weniger Löchern (ungerade Reihen)
_magnet_x_left  = max(_x0 - _spacing / 2, _wall * 2 + _magnet_diameter / 2);
_magnet_x_right = min(_x0 + _spacing / 2 + _cols_odd * _spacing, _length - _wall * 2 - _magnet_diameter / 2);

// Gesamte Lochanzahl (nur zur Info in der Konsole)
_total_holes = ceil(_rows / 2) * _cols_even + floor(_rows / 2) * _cols_odd;
echo(str("Loecher gesamt: ", _total_holes,
         "  (", _cols_even, " Spalten gerade Reihen / ",
         _cols_odd, " Spalten ungerade Reihen / ",
         _rows, " Reihen)"));

// --- Main Model ---------------------------------------------
main();

// --- Modules ------------------------------------------------
module main() {
    box();                                        // Unterteil
    translate([0, 0, _height + _lid_gap])         // Deckel mit Abstand darüber
        lid();
}

// Unterteil: Grundkörper mit Stufe und blinden Löchern
module box() {
    difference() {
        body();                                     // Grundkörper mit Stufe
        hole_grid(_wall, _box_hole_depth);          // Löcher von unten, _wall Boden
        magnet_holes(_height - _magnet_depth);      // Magnetlöcher oben
    }
    side_text(_text_box, _height / 2, _text_size_box);   // erhöhter Schriftzug vorn
}

// Grundkörper: abgerundete Außenecken, oben außenrum eine senkrechte Stufe abgefräst
// (Ring Breite _wall, Tiefe _step_depth)
module body() {
    difference() {
        // Grundkörper: volle Höhe, abgerundete Ecken
        linear_extrude(height = _height)
            outline();
        // Stufe außenrum abfräsen: umlaufender Ring, _wall breit, _step_depth tief
        translate([0, 0, _height - _step_depth])
            linear_extrude(height = _step_depth + _overcut)
                difference() {
                    offset(delta = _overcut) outline();   // außen überstehen (gegen Artefakt)
                    offset(delta = -_wall) outline();      // innen _wall eingezogen
                }
    }
}

// Deckel: gleiche Außenkontur und Löcher wie die Box, unten ein Rand für die Fräsung
module lid() {
    difference() {
        union() {
            // Deckel-Körper (Loch + Boden)
            linear_extrude(height = _lid_body_height)
                outline();
            // umlaufender Rand unten (passt in die Fräsung der Box)
            translate([0, 0, -_lid_rim_depth])
                linear_extrude(height = _lid_rim_depth)
                    difference() {
                        outline();
                        offset(delta = -(_wall - _fit_clearance)) outline();
                    }
        }
        // Löcher: blind, die Kartusche ragt _lid_cartridge_depth hinein
        hole_grid(0, _lid_cartridge_depth);
        // Magnetlöcher unten (fluchten mit den Magnetlöchern der Box)
        magnet_holes(0);
    }
    side_text(_text_lid, _lid_body_height / 2, _text_size);  // erhöhter Schriftzug vorn
}

// 2D-Grundriss des Quaders bei [0,0] bis [_length,_width], Ecken mit _corner_radius abgerundet
module outline() {
    translate([_corner_radius, _corner_radius])
        offset(r = _corner_radius)
            square([_length - 2 * _corner_radius,
                    _width  - 2 * _corner_radius], center = false);
}

// Hexagonal (halb) versetztes Lochraster, mittig zentriert
// hole_bottom: Z-Position der Lochbohrung (unten), hole_depth: Lochtiefe
module hole_grid(hole_bottom, hole_depth) {
    for (r = [0 : _rows - 1]) {
        if (r % 2 == 0) {
            // gerade Reihe: ohne Versatz
            for (c = [0 : _cols_even - 1]) {
                translate([_x0 + c * _spacing, _y0 + r * _row_pitch, hole_bottom])
                    cylinder(d = _hole_diameter, h = hole_depth + _eps);
            }
        } else {
            // ungerade Reihe: um halben Lochabstand versetzt
            if (_cols_odd > 0) {
                for (c = [0 : _cols_odd - 1]) {
                    translate([_x0 + _spacing / 2 + c * _spacing,
                               _y0 + r * _row_pitch, hole_bottom])
                        cylinder(d = _hole_diameter, h = hole_depth + _eps);
                }
            }
        }
    }
}

// Magnetlöcher an den Enden der Reihen mit weniger Löchern (ungerade Reihen)
// z_bottom: Z-Position der Bohrung (unten)
module magnet_holes(z_bottom) {
    for (r = [1 : 2 : _rows - 1]) {   // nur ungerade Reihen (weniger Löcher)
        translate([_magnet_x_left,  _y0 + r * _row_pitch, z_bottom])
            cylinder(d = _magnet_diameter, h = _magnet_depth + _eps);
        translate([_magnet_x_right, _y0 + r * _row_pitch, z_bottom])
            cylinder(d = _magnet_diameter, h = _magnet_depth + _eps);
    }
}

// Erhöhter Schriftzug auf der vorderen Längsseite (y = 0), mittig
// txt: Text, z_center: vertikale Mitte des Schriftzugs
module side_text(txt, z_center, size) {
    translate([_length / 2, 0, z_center])
        rotate([90, 0, 0])
            linear_extrude(height = _text_depth)
                text(txt, size = size, halign = "center", valign = "center");
}
