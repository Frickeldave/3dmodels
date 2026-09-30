// ============================================================
// VESA-Monitor-Mount-Platte (10-Zoll-Monitor)
// 2 mm dünne, parametrische Adapterplatte mit VESA-Lochbild
// 75 x 75 mm und/oder 100 x 100 mm für M4-Schrauben
// Als Modul nutzbar: use <VESA Plate.scad> + vesa_plate(...)
// ============================================================

// --- Render Settings ----------------------------------------
$fn = 60;

// --- Main Model (Standalone-Render) ---------------------------
vesa_plate();

// --- Modules ------------------------------------------------
module vesa_plate(
    plate_thickness    = 2,     // Plattenstärke [mm]
    vesa_75_enable     = true,  // Lochbild 75 x 75 mm [bool]
    vesa_100_enable    = true,  // Lochbild 100 x 100 mm [bool]
    border             = 10,    // Rand um das Lochbild [mm]
    screw_hole_d       = 4.5,   // Durchgangsloch für M4 [mm]
    corner_radius      = 5,     // Eckenradius der Platte [mm]
    countersink_enable = false, // Senkung für Senkkopfschrauben [bool]
    countersink_d      = 8.4,   // Senkkopf-Durchmesser M4 [mm]
    countersink_depth  = 1.4,   // Senktiefe [mm]
    center_hole_radius = 0,     // Mittiges Loch (Materialersparnis) [mm]
    square_top         = false  // Obere Ecken eckig (für Arm-Anschluss) [bool]
) {
    eps         = 0.01; // Toleranz gegen Render-Artefakte
    pattern_max = max(vesa_75_enable ? 75 : 0, vesa_100_enable ? 100 : 0);
    plate_size  = pattern_max + 2 * border; // Kantenlänge der Platte

    difference() {
        // Grundplatte: abgerundetes Quadrat, auf Plattenstärke extrudiert
        translate([0, 0, -plate_thickness / 2])
            linear_extrude(plate_thickness)
                plate_profile(plate_size, corner_radius, square_top);
        // Lochbilder ausschneiden
        if (vesa_75_enable)
            vesa_holes(75, plate_thickness, screw_hole_d,
                       countersink_enable, countersink_d, countersink_depth, eps);
        if (vesa_100_enable)
            vesa_holes(100, plate_thickness, screw_hole_d,
                       countersink_enable, countersink_d, countersink_depth, eps);
        // mittiges Loch zum Materialsparen
        if (center_hole_radius > 0)
            cylinder(r = center_hole_radius,
                     h = plate_thickness + 2 * eps, center = true);
    }
}

// 2D-Profil der Platte: unten abgerundete Ecken, oben wahlweise eckig
module plate_profile(size, r, square_top, n = 24) {
    if (square_top) {
        pts = concat(
            [[-size / 2 + r, -size / 2]],
            [[size / 2 - r, -size / 2]],
            [for (i = [0 : n]) [size / 2 - r + r * cos(270 + 90 * i / n),
                                -size / 2 + r + r * sin(270 + 90 * i / n)]],
            [[size / 2, size / 2]],
            [[-size / 2, size / 2]],
            [for (i = [0 : n]) [-size / 2 + r + r * cos(180 + 90 * i / n),
                                -size / 2 + r + r * sin(180 + 90 * i / n)]]
        );
        polygon(pts);
    } else {
        offset(r = r)
            square([size - 2 * r, size - 2 * r], center = true);
    }
}

// Vier Schraubenlöcher im VESA-Raster um den Mittelpunkt
module vesa_holes(pattern, plate_thickness, screw_hole_d,
                  countersink_enable, countersink_d, countersink_depth, eps) {
    for (x = [-pattern / 2, pattern / 2], y = [-pattern / 2, pattern / 2]) {
        translate([x, y, 0])
            screw_hole(plate_thickness, screw_hole_d,
                       countersink_enable, countersink_d, countersink_depth, eps);
    }
}

// Einzelnes Schraubenloch mit optionaler Senkung (von oben)
module screw_hole(plate_thickness, screw_hole_d,
                  countersink_enable, countersink_d, countersink_depth, eps) {
    // Durchgangsloch
    cylinder(d = screw_hole_d, h = plate_thickness + 2 * eps, center = true);
    // Senkung für flach versenkte Schraubenköpfe
    if (countersink_enable)
        translate([0, 0, plate_thickness / 2 - countersink_depth + eps])
            cylinder(h = countersink_depth + eps,
                     d1 = screw_hole_d, d2 = countersink_d);
}
