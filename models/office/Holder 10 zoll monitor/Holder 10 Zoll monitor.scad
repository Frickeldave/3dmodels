// ============================================================
// Monitor-Halterung (10-Zoll-Monitor über dem Hauptmonitor)
// Der Arm startet an der Oberkante der VESA-Grundplatte (Y=60)
// und geht nach oben. In der Mitte ist er über einen Bogen um
// _tilt_angle nach vorn geneigt. An beiden Enden hat der Arm
// gerade Winkel-Übergänge (Hull), die Armbreite und -dicke auf
// die jeweilige Platte verjüngen. Oben schließt die Montage-
// platte bündig mit der Arm-Oberseite (+Z) ab; die Grundplatte
// ist an der Armseite eckig. Mittiges Loch spart Material.
// Arm und Montageplatte lassen sich linksbündig, zentriert oder
// rechtsbündig zur Grundplatte ausrichten (_alignment).
// ============================================================

use <VESA Plate.scad>

// --- Render Settings ----------------------------------------
$fn = 60;

// --- Parameters ---------------------------------------------
// VESA-Grundplatte
_bottom_plate_thickness = 2;  // Stärke der Grundplatte [mm]
_bottom_plate_size     = 120; // Kantenlänge der Grundplatte (VESA-Standard) [mm]
_center_hole_radius    = 30;  // Mittiges Loch (Materialersparnis), 0 = aus [mm]

// Arm
_arm_width     = 100; // Breite des Arms [mm]
_arm_height    = 130; // Höhe der Armspitze über der Plattenoberkante [mm]
_arm_thickness = 4;   // Dicke des Arms [mm]
_tilt_angle    = 20;  // Neigungswinkel des Arms nach vorn [°]
_bend_height   = 65;  // Höhe des Bogen-Mittelpunkts über der Plattenoberkante [mm]
_bend_radius   = 25;  // Radius des Bogens [mm]
_bottom_taper_h = 12; // Länge der Verjüngung Arm → Grundplatte [mm]

// Ausrichtung von Arm und Montageplatte auf der VESA-Grundplatte:
// "left" = linksbündig, "center" = zentriert, "right" = rechtsbündig
_alignment = "left";

// Obere Montageplatte (verlängert den Arm)
_top_plate_width     = 80;   // Breite der Montageplatte (quer zum Arm) [mm]
_top_plate_height    = 40;   // Höhe der Montageplatte (in Armrichtung) [mm]
_top_plate_thickness = 2;    // Stärke [mm]
// Eckenradius an den oberen Ecken der Montageplatte; bei aktiven Löchern
// wird er automatisch begrenzt, damit die Löcher nicht aufgeschnitten werden
_top_corner_radius   = 5;    // Eckenradius oben [mm]
_top_weld            = 1;    // Überlappung Arm/Platte am Übergang [mm]
_top_taper_len       = 15;   // Länge der Verjüngung Arm → Montageplatte [mm]
_top_screw_hole_d    = 4.5;  // M4-Löcher [mm]
_top_vesa_75_enable  = true;  // VESA 75 x 75 mm – nur aktiv bei Platte >= 81 mm (beide Richtungen) [bool]
_top_vesa_100_enable = false; // VESA 100 x 100 mm – nur aktiv bei Platte >= 106 mm (beide Richtungen) [bool]

// --- Computed Values ----------------------------------------
_eps         = 0.01; // Toleranz gegen Render-Artefakte
_arm_dir     = [sin(_tilt_angle), cos(_tilt_angle)]; // Armrichtung nach dem Bogen
_arc_end     = [_bend_radius - _bend_radius * cos(_tilt_angle),
                (_bend_height - _bottom_taper_h) + _bend_radius * sin(_tilt_angle)];
_arm_top_len = max(5, (_arm_height - _bottom_taper_h - _arc_end[1]) / _arm_dir[1]);
_arm_top_end = [_arc_end[0] + _arm_top_len * _arm_dir[0],
                _arc_end[1] + _arm_top_len * _arm_dir[1]];
// 3D-Positionen: Profil (x = vorn, y = oben) → global (z = vorn, y = oben)
// X-Versatz von Arm und Montageplatte relativ zur Grundplatten-Mitte
_align_shift     = _alignment == "left"  ? -(_bottom_plate_size - _arm_width) / 2
                 : _alignment == "right" ?  (_bottom_plate_size - _arm_width) / 2
                 : 0;
_top_align_shift = _alignment == "left"  ? -(_bottom_plate_size - _top_plate_width) / 2
                 : _alignment == "right" ?  (_bottom_plate_size - _top_plate_width) / 2
                 : 0;
// Montageplatte relativ zum Arm (lokales X der oberen Baugruppe)
_top_dx = _top_align_shift - _align_shift;
_arm_tip    = [_align_shift, 60 + _bottom_taper_h + _arm_top_end[1], _arm_top_end[0]];
// Montageplatte bündig mit der Arm-Oberseite (+Z): Platte in +Z-Richtung verschoben
_top_shift  = (_arm_thickness - _top_plate_thickness) / 2
              * [0, -sin(_tilt_angle), cos(_tilt_angle)];
_top_center = _arm_tip
              + (_top_plate_height / 2 - _top_weld)
                * [0, _arm_dir[1], _arm_dir[0]]
              + _top_shift;
// Löcher der Montageplatte: abschaltbar; verschwinden automatisch,
// wenn die Platte zu klein für das jeweilige Lochbild ist
_vesa_75_min_size  = 81;  // Mindest-Plattengröße für 75er-Löcher [mm]
_vesa_100_min_size = 106; // Mindest-Plattengröße für 100er-Löcher [mm]
_top_75_active  = _top_vesa_75_enable
                  && _top_plate_width  >= _vesa_75_min_size
                  && _top_plate_height >= _vesa_75_min_size;
_top_100_active = _top_vesa_100_enable
                  && _top_plate_width  >= _vesa_100_min_size
                  && _top_plate_height >= _vesa_100_min_size;
// Mittiges Loch der Grundplatte: gegen die Schraubenlöcher abgesichert
_center_hole_r = _center_hole_radius > 0
    ? min(_center_hole_radius, 75 / sqrt(2) - 4.5 / 2 - 5)
    : 0;
// Eckenradius der Montageplatte: auf die kleinere Kantenlänge begrenzen;
// bei aktiven Löchern zusätzlich, damit die Rundung die Löcher nicht aufschneidet
_top_corner_limit = ((min(_top_plate_width, _top_plate_height) / 2 - 37.5) * sqrt(2) - 3.25)
                    / (1 + sqrt(2));
_top_corner_r = _top_75_active
    ? max(0, min(_top_corner_radius, _top_plate_width / 2, _top_plate_height / 2,
                 _top_corner_limit))
    : min(_top_corner_radius, _top_plate_width / 2, _top_plate_height / 2);

// --- Main Model ---------------------------------------------
monitor_holder();

// --- Modules ------------------------------------------------
module monitor_holder() {
    // VESA-Grundplatte (mittiges Loch, an der Armseite eckige Ecken)
    vesa_plate(plate_thickness = _bottom_plate_thickness,
               center_hole_radius = _center_hole_r,
               square_top = true);

    // Arm: 2D-Bogenprofil (vorn/oben), über die Armbreite extrudiert,
    // startet oberhalb der Verjüngung zur Grundplatte; _align_shift
    // richtet den Arm auf der Grundplatte aus
    translate([_align_shift, 60 + _bottom_taper_h, 0])
        rotate([0, -90, 0])
            linear_extrude(_arm_width, center = true)
                arm_profile();

    // Winkel-Übergang zwischen Grundplatte und Arm
    bottom_transition();

    // Obere Montageplatte: verlängert den Arm, nach vorn geneigt;
    // top_transition verjüngt Armbreite und -dicke auf die Platte;
    // _top_dx richtet die Platte unabhängig vom Arm aus
    translate(_top_center)
        rotate([_tilt_angle, 0, 0]) {
            translate([_top_dx, 0, 0])
                top_plate();
            top_transition();
        }
}

// 2D-Profil des Arms (x = vorn, y = oben): senkrechter Teil und
// Bogen; endet oben mit flacher Kante bei ts (die Verjüngung auf
// die Montageplatte macht top_transition)
module arm_profile() {
    t   = _arm_thickness;
    cx  = _bend_radius;
    cy  = _bend_height - _bottom_taper_h; // Bogenhöhe im Profil
    ro  = cx + t / 2;              // Außenradius des Bogens
    ri  = max(0.5, cx - t / 2);    // Innenradius des Bogens
    a0  = 180;                     // Bogenanfang (senkrecht nach oben)
    a1  = 180 - _tilt_angle;       // Bogenende (nach vorn geneigt)
    n   = 24;                      // Segmente je Bogen
    d_  = [sin(_tilt_angle), cos(_tilt_angle)];  // Richtung nach dem Bogen
    p_  = [cos(_tilt_angle), -sin(_tilt_angle)]; // senkrecht dazu
    tt  = min(_top_taper_len, _arm_top_len - 5); // Länge der oberen Verjüngung
    ts  = _arm_top_end - tt * d_;                // Beginn der oberen Verjüngung

    pts = concat(
        [[-t / 2, 0]],
        [[-t / 2, cy]],
        // Außenbogen
        [for (i = [0 : n]) [cx + ro * cos(a0 + (a1 - a0) * i / n),
                            cy + ro * sin(a0 + (a1 - a0) * i / n)]],
        // flache Kante bei ts (Verjüngung übernimmt top_transition)
        [ts - (t / 2) * p_],
        [ts + (t / 2) * p_],
        // Innenbogen
        [for (i = [0 : n]) [cx + ri * cos(a1 + (a0 - a1) * i / n),
                            cy + ri * sin(a1 + (a0 - a1) * i / n)]],
        [[t / 2, cy]],
        [[t / 2, 0]]
    );
    polygon(pts);
}

// Obere Montageplatte (Breite x Höhe), verlängert den Arm
module top_plate() {
    difference() {
        translate([0, 0, -_top_plate_thickness / 2])
            linear_extrude(_top_plate_thickness)
                top_plate_profile();
        if (_top_75_active)  top_holes(75);
        if (_top_100_active) top_holes(100);
    }
}

// 2D-Profil der Montageplatte mit abgerundeten oberen Ecken
module top_plate_profile() {
    plate_base_profile();
}

// Grundform der Montageplatte mit abgerundeten oberen Ecken
module plate_base_profile() {
    w = _top_plate_width;   // Plattenbreite (quer zum Arm)
    h = _top_plate_height;  // Plattenhöhe (in Armrichtung)
    r = _top_corner_r;
    n = 24; // Segmente je Eckbogen
    pts = concat(
        [[-w / 2, -h / 2]],
        [[w / 2, -h / 2]],
        [[w / 2, h / 2 - r]],
        [for (i = [0 : n]) [w / 2 - r + r * cos(90 * i / n),
                            h / 2 - r + r * sin(90 * i / n)]],
        [[-w / 2 + r, h / 2]],
        [for (i = [0 : n]) [-w / 2 + r + r * cos(90 + 90 * i / n),
                            h / 2 - r + r * sin(90 + 90 * i / n)]],
        [[-w / 2, h / 2 - r]]
    );
    polygon(pts);
}

// Verjüngung Armbreite und -dicke auf die Grundplatte (Winkel-Übergang)
module bottom_transition() {
    hull() {
        // Armquerschnitt oberhalb des Übergangs (mit _align_shift ausgerichtet)
        translate([_align_shift, 60 + _bottom_taper_h, 0])
            cube([_arm_width, 1, _arm_thickness], center = true);
        // Kantenquerschnitt der Grundplatte
        translate([0, 60, 0])
            cube([_bottom_plate_size, 1, _bottom_plate_thickness], center = true);
    }
}

// Verjüngung Armbreite und -dicke auf die Montageplatte
// (Plattenkoordinaten: y = Armrichtung, z = Plattennormale);
// die +Z-Seite (Oberseite) bleibt bündig
module top_transition() {
    tip_y = -(_top_plate_height / 2 - _top_weld); // Armspitze in Platten-Y
    hull() {
        // Armquerschnitt am Beginn der Verjüngung
        translate([0, tip_y - _top_taper_len - 0.5,
                   -(_arm_thickness - _top_plate_thickness) / 2])
            cube([_arm_width, 1, _arm_thickness], center = true);
        // Plattenquerschnitt an der Einbindung (mit _top_dx ausgerichtet)
        translate([_top_dx, tip_y - 0.5, 0])
            cube([_top_plate_width, 1, _top_plate_thickness], center = true);
    }
}

// Vier Schraubenlöcher senkrecht zur Platte
module top_holes(pattern) {
    for (x = [-pattern / 2, pattern / 2], y = [-pattern / 2, pattern / 2])
        translate([x, y, 0])
            cylinder(d = _top_screw_hole_d,
                     h = _top_plate_thickness + 2 * _eps, center = true);
}
