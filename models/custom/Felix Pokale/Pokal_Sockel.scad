// =====================================================================
// Sockel mit Schriftzug – WM-Tippspiel 2026 / Effertz GmbH
// ---------------------------------------------------------------------
// Rechteckiger Sockel mit Zierrahmen und vertieftem Text auf der
// Vorderseite.
//
// Reines OpenSCAD – keine externen Bibliotheken, keine Meshes.
//
// Hinweis: Parameter werden zentral in Pokal.scad gesteuert.
// Die Default-Werte in den Modulen werden nur bei direktem Öffnen
// dieser Datei verwendet (selten).
// =====================================================================

// --- Render Settings ----------------------------------------
$fa = 2;
$fs = 0.6;

// --- Main Model ---------------------------------------------
// sockel_mit_text() wird nur ausgeführt, wenn diese Datei direkt geöffnet wird.
// Beim Einbinden über 'use <Pokal_Sockel.scad>' in Pokal.scad wird sie mit
// Parametern aufgerufen.
// --- Modules ------------------------------------------------
module rounded_rect(w, d, r) {
    offset(r=r) offset(r=-r) square([w, d], center=true);
}

// =====================================================================
// Sockel – rechteckige Basis mit abgerundeten Kanten
// =====================================================================
module sockel(
    base_width = 100,
    base_depth = 35,
    base_height = 35,
    base_fillet = 2.5
) {
    linear_extrude(height = base_height)
        rounded_rect(base_width, base_depth, base_fillet);
}

// =====================================================================
// Pyramide – gestutzter pyramidaler Aufbau auf dem Sockel
// =====================================================================
module pyramide(
    base_width = 100,
    base_depth = 35,
    base_height = 35,
    base_fillet = 2.5,
    pyramid_height = 7,
    pyramid_top_scale = 0.7,
    EPS = 0.02
) {
    translate([0, 0, base_height])
        hull() {
            // Untere Basis (Sockelgröße)
            linear_extrude(height = EPS)
                rounded_rect(base_width, base_depth, base_fillet);
            
            // Obere Fläche (skaliert)
            translate([0, 0, pyramid_height])
                linear_extrude(height = EPS)
                    rounded_rect(base_width * pyramid_top_scale,
                                base_depth * pyramid_top_scale,
                                base_fillet * pyramid_top_scale);
        }
}

// =====================================================================
// Zierrahmen – eingeprägt (für difference)
// =====================================================================
module sockel_frame_eingepraegt(
    base_width = 100,
    base_depth = 35,
    base_height = 35,
    frame_inset_xy = 4,
    frame_depth = 1.2,
    frame_radius = 2,
    frame_band = 1.6,
    EPS = 0.02
) {
    fw = base_width  - 2*frame_inset_xy;
    fh = base_height - 2*frame_inset_xy;

    translate([0, -base_depth/2 + frame_depth, base_height/2])
        rotate([90, 0, 0])
            linear_extrude(height = frame_depth + EPS)
                difference() {
                    rounded_rect(fw, fh, frame_radius);
                    offset(r = -frame_band) rounded_rect(fw, fh, frame_radius);
                }
}

// =====================================================================
// Zierrahmen – aufgesetzt (für union)
// =====================================================================
module sockel_frame_aufgesetzt(
    base_width = 100,
    base_depth = 35,
    base_height = 35,
    frame_inset_xy = 4,
    frame_depth = 1.2,
    frame_radius = 2,
    frame_band = 1.6
) {
    fw = base_width  - 2*frame_inset_xy;
    fh = base_height - 2*frame_inset_xy;

    // Rahmen steht NACH AUSSEN (in -Y Richtung)
    translate([0, -base_depth/2, base_height/2])
        rotate([90, 0, 0])
            linear_extrude(height = frame_depth)
                difference() {
                    rounded_rect(fw, fh, frame_radius);
                    offset(r = -frame_band) rounded_rect(fw, fh, frame_radius);
                }
}

// =====================================================================
// Textplatte – eingeprägt (für difference)
// =====================================================================
module textplatte_eingepraegt(
    base_depth = 35,
    base_height = 35,
    text_depth = 0.8,
    text_line1 = "1. Platz",
    text_line2 = "WM-Tippspiel 2026",
    text_line3 = "Effertz GmbH",
    text_size_big = 7.0,
    text_size_small = 4.5,
    text_font = "Liberation Sans:style=Bold",
    EPS = 0.02
) {
    y_front = -base_depth/2;

    z1 = base_height * 0.70;
    z2 = base_height * 0.44;
    z3 = base_height * 0.26;

    translate([0, y_front + text_depth, 0])
        rotate([90, 0, 0])
            linear_extrude(height = text_depth + EPS)
                union() {
                    translate([0, z1])
                        text(text_line1, size = text_size_big,
                             font = text_font,
                             halign = "center", valign = "center");
                    translate([0, z2])
                        text(text_line2, size = text_size_small,
                             font = text_font,
                             halign = "center", valign = "center");
                    translate([0, z3])
                        text(text_line3, size = text_size_small,
                             font = text_font,
                             halign = "center", valign = "center");
                }
}

// =====================================================================
// Textplatte – aufgesetzt (für union)
// =====================================================================
module textplatte_aufgesetzt(
    base_depth = 35,
    base_height = 35,
    text_depth = 0.8,
    text_line1 = "1. Platz",
    text_line2 = "WM-Tippspiel 2026",
    text_line3 = "Effertz GmbH",
    text_size_big = 7.0,
    text_size_small = 4.5,
    text_font = "Liberation Sans:style=Bold"
) {
    y_front = -base_depth/2;

    z1 = base_height * 0.70;
    z2 = base_height * 0.44;
    z3 = base_height * 0.26;

    translate([0, y_front, 0])
        rotate([90, 0, 0])
            linear_extrude(height = text_depth)
                union() {
                    translate([0, z1])
                        text(text_line1, size = text_size_big,
                             font = text_font,
                             halign = "center", valign = "center");
                    translate([0, z2])
                        text(text_line2, size = text_size_small,
                             font = text_font,
                             halign = "center", valign = "center");
                    translate([0, z3])
                        text(text_line3, size = text_size_small,
                             font = text_font,
                             halign = "center", valign = "center");
                }
}

// =====================================================================
// Hauptmodul – Sockel mit Pyramide, Text und Rahmen
// =====================================================================
module sockel_mit_text(
    base_width = 100,
    base_depth = 35,
    base_height = 35,
    base_fillet = 2.5,
    frame_inset_xy = 4,
    frame_depth = 1.2,
    frame_band = 1.6,
    frame_radius = 2,
    frame_raised = true,
    pyramid_height = 7,
    pyramid_top_scale = 0.7,
    text_line1 = "1. Platz",
    text_line2 = "WM-Tippspiel 2026",
    text_line3 = "Effertz GmbH",
    text_size_big = 7.0,
    text_size_small = 4.5,
    text_depth = 0.8,
    text_raised = true,
    text_font = "Liberation Sans:style=Bold",
    _text_print_mode = 0,
    _text_recess_depth = 1.0,
    _text_recess_expansion = 0.1,
    _frame_print_mode = 0,
    _frame_recess_depth = 1.2,
    _frame_recess_expansion = 0.1,
    EPS = 0.02
) {
    difference() {
        union() {
            // Sockel (Gold/Hauptfarbe)
            color("gold")
            union() {
                sockel(
                    base_width, base_depth, base_height, base_fillet
                );
                pyramide(
                    base_width, base_depth, base_height, base_fillet,
                    pyramid_height, pyramid_top_scale, EPS
                );
            }
            
            // Text aufgesetzt (Multicolor-Modus oder text_raised aktiv) - schwarz
            if (_text_print_mode == 1 && text_raised) {
                color("black")
                textplatte_aufgesetzt(
                    base_depth, base_height, text_depth,
                    text_line1, text_line2, text_line3,
                    text_size_big, text_size_small, text_font
                );
            }
            
            // Rahmen aufgesetzt (Multicolor-Modus) - schwarz
            if (_frame_print_mode == 1 && frame_raised) {
                color("black")
                sockel_frame_aufgesetzt(
                    base_width, base_depth, base_height,
                    frame_inset_xy, frame_depth, frame_radius, frame_band
                );
            }
        }

        // ---- vertiefte Details ----
        
        // Rahmen eingeprägt (wenn nicht aufgesetzt und nicht Singlecolor)
        if (!frame_raised && _frame_print_mode == 1) {
            sockel_frame_eingepraegt(
                base_width, base_depth, base_height,
                frame_inset_xy, frame_depth, frame_radius, frame_band, EPS
            );
        }
        
        // Rahmen-Vertiefung im Singlecolor-Modus
        if (_frame_print_mode == 0) {
            color("silver")
            sockel_frame_eingepraegt_recess(
                base_width, base_depth, base_height,
                frame_inset_xy, frame_radius, frame_band,
                _frame_recess_depth, _frame_recess_expansion, EPS
            );
        }
        
        // Text eingeprägt (wenn nicht aufgesetzt und nicht Singlecolor)
        if (!text_raised && _text_print_mode == 1) {
            textplatte_eingepraegt(
                base_depth, base_height, text_depth,
                text_line1, text_line2, text_line3,
                text_size_big, text_size_small, text_font, EPS
            );
        }
        
        // Text-Vertiefung im Singlecolor-Modus
        if (_text_print_mode == 0) {
            color("silver")
            textplatte_eingepraegt_recess(
                base_depth, base_height, _text_recess_depth,
                _text_recess_expansion,
                text_line1, text_line2, text_line3,
                text_size_big, text_size_small, text_font, EPS
            );
        }
    }
}

// =====================================================================
// Aufruf
// =====================================================================
// sockel_mit_text() wird nur ausgeführt, wenn diese Datei direkt geöffnet wird.
// Beim Einbinden über 'use <Pokal_Sockel.scad>' in Pokal.scad wird sie mit
// Parametern aufgerufen.

// =====================================================================
// Textplatte – eingeprägt als Vertiefung (Singlecolor-Modus)
// =====================================================================
module textplatte_eingepraegt_recess(
    base_depth = 35,
    base_height = 35,
    _text_recess_depth = 1.0,
    _text_recess_expansion = 0.1,
    text_line1 = "1. Platz",
    text_line2 = "WM-Tippspiel 2026",
    text_line3 = "Effertz GmbH",
    text_size_big = 7.0,
    text_size_small = 4.5,
    text_font = "Liberation Sans:style=Bold",
    EPS = 0.02
) {
    y_front = -base_depth/2;
    e = _text_recess_expansion;

    z1 = base_height * 0.70;
    z2 = base_height * 0.44;
    z3 = base_height * 0.26;

    translate([0, y_front + _text_recess_depth, 0])
        rotate([90, 0, 0])
            linear_extrude(height = _text_recess_depth + EPS)
                union() {
                    offset(r = e)
                        translate([0, z1])
                            text(text_line1, size = text_size_big,
                                 font = text_font,
                                 halign = "center", valign = "center");
                    offset(r = e)
                        translate([0, z2])
                            text(text_line2, size = text_size_small,
                                 font = text_font,
                                 halign = "center", valign = "center");
                    offset(r = e)
                        translate([0, z3])
                            text(text_line3, size = text_size_small,
                                 font = text_font,
                                 halign = "center", valign = "center");
                }
}

// =====================================================================
// Textplatte – separates Bauteil (Singlecolor-Modus)
// =====================================================================
module textplatte_separat(
    base_depth = 35,
    base_height = 35,
    text_depth = 0.8,
    text_line1 = "1. Platz",
    text_line2 = "WM-Tippspiel 2026",
    text_line3 = "Effertz GmbH",
    text_size_big = 7.0,
    text_size_small = 4.5,
    text_font = "Liberation Sans:style=Bold"
) {
    y_front = -base_depth/2;

    z1 = base_height * 0.70;
    z2 = base_height * 0.44;
    z3 = base_height * 0.26;

    translate([0, y_front, 0])
        rotate([90, 0, 0])
            linear_extrude(height = text_depth)
                color("black")
                union() {
                    translate([0, z1])
                        text(text_line1, size = text_size_big,
                             font = text_font,
                             halign = "center", valign = "center");
                    translate([0, z2])
                        text(text_line2, size = text_size_small,
                             font = text_font,
                             halign = "center", valign = "center");
                    translate([0, z3])
                        text(text_line3, size = text_size_small,
                             font = text_font,
                             halign = "center", valign = "center");
                }
}

// =====================================================================
// Zierrahmen – eingeprägt als Vertiefung (Singlecolor-Modus)
// =====================================================================
module sockel_frame_eingepraegt_recess(
    base_width = 100,
    base_depth = 35,
    base_height = 35,
    frame_inset_xy = 4,
    frame_radius = 2,
    frame_band = 1.6,
    _frame_recess_depth = 1.2,
    _frame_recess_expansion = 0.1,
    EPS = 0.02
) {
    fw = base_width  - 2*frame_inset_xy;
    fh = base_height - 2*frame_inset_xy;
    e = _frame_recess_expansion;

    translate([0, -base_depth/2 + _frame_recess_depth, base_height/2])
        rotate([90, 0, 0])
            linear_extrude(height = _frame_recess_depth + EPS)
                difference() {
                    rounded_rect(fw + 2*e, fh + 2*e, frame_radius);
                    offset(r = -frame_band) rounded_rect(fw - 2*e, fh - 2*e, frame_radius);
                }
}

// =====================================================================
// Zierrahmen – separates Bauteil (Singlecolor-Modus)
// =====================================================================
module sockel_frame_separat(
    base_width = 100,
    base_depth = 35,
    base_height = 35,
    frame_inset_xy = 4,
    frame_depth = 1.2,
    frame_radius = 2,
    frame_band = 1.6
) {
    fw = base_width  - 2*frame_inset_xy;
    fh = base_height - 2*frame_inset_xy;

    translate([0, -base_depth/2, base_height/2])
        rotate([90, 0, 0])
            linear_extrude(height = frame_depth)
                color("black")
                difference() {
                    rounded_rect(fw, fh, frame_radius);
                    offset(r = -frame_band) rounded_rect(fw, fh, frame_radius);
                }
}

// =====================================================================
// Platte mit umlaufender Fase auf der Au\u00dfenseite (Hilfsmodul)
// Extrudiert entlang +Z; die Fase liegt am oberen Ende (z = thick).
// =====================================================================
module plate_with_chamfer(
    w = 100,
    h = 35,
    r = 2,
    thick = 2,
    chamfer = 1,
    EPS = 0.02
) {
    union() {
        // Hauptk\u00f6rper mit vollem Querschnitt
        linear_extrude(height = thick - chamfer)
            rounded_rect(w, h, r);

        // Umlaufende Fase am \u00e4u\u00dferen Ende
        translate([0, 0, thick - chamfer])
            hull() {
                linear_extrude(height = EPS)
                    rounded_rect(w, h, r);
                translate([0, 0, chamfer])
                    linear_extrude(height = EPS)
                        rounded_rect(w - 2*chamfer, h - 2*chamfer,
                                     max(r - chamfer, 0.5));
            }
    }
}

// =====================================================================
// Text-Sticker - separates Bauteil
// ---------------------------------------------------------------------
// Separate Plakette, die in die Innenkontur des separaten Rahmens passt.
// Auf der Vorderseite liegt der Text auf einer planen Platte.
// =====================================================================
module text_sticker_separat(
    base_width = 100,
    base_depth = 35,
    base_height = 35,
    frame_inset_xy = 4,
    frame_depth = 1.2,
    frame_radius = 2,
    frame_band = 1.6,
    plate_thickness = 2.0,
    sticker_text_depth = 0.4,
    sticker_text_raise = 0.4,
    text_line1 = "1. Platz",
    text_line2 = "WM-Tippspiel 2026",
    text_line3 = "Effertz GmbH",
    text_size_big = 7.0,
    text_size_small = 4.5,
    text_font = "Liberation Sans:style=Bold",
    EPS = 0.02
) {
    fw = base_width  - 2*frame_inset_xy;
    fh = base_height - 2*frame_inset_xy;
    y_outer = -base_depth/2 - frame_depth - plate_thickness;

    z1 = base_height * 0.70;
    z2 = base_height * 0.44;
    z3 = base_height * 0.26;

    // Textumriss (gleiche Anordnung wie textplatte_separat)
    module _sticker_text_outline() {
        translate([0, z1])
            text(text_line1, size = text_size_big, font = text_font,
                 halign = "center", valign = "center");
        translate([0, z2])
            text(text_line2, size = text_size_small, font = text_font,
                 halign = "center", valign = "center");
        translate([0, z3])
            text(text_line3, size = text_size_small, font = text_font,
                 halign = "center", valign = "center");
    }

    // 1. Plakette in Rahmen-Innenkontur, ohne Rueckseiten-Falz
    color("green")
    difference() {
        // Exakt dieselbe Innenkontur wie im Rahmen:
        // offset(r = -frame_band) rounded_rect(fw, fh, frame_radius)
        translate([0, -base_depth/2 - frame_depth, base_height/2])
            rotate([90, 0, 0])
                linear_extrude(height = plate_thickness)
                    offset(r = -frame_band)
                        rounded_rect(fw, fh, frame_radius);

        // Optionale Textvertiefung in der Aussen-/Fasenseite.
        // Wird nur ausgespart, wenn sticker_text_depth > 0 ist.
        if (sticker_text_raise <= 0 && sticker_text_depth > 0)
            translate([0, y_outer + sticker_text_depth, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = sticker_text_depth + EPS)
                        _sticker_text_outline();
    }

    // 2. Text als separates Farbteil:
    //    - sticker_text_raise > 0: erhabene Schrift
    //    - sonst: eingelassen und buendig
    color("gold")
    if (sticker_text_raise > 0)
        translate([0, y_outer, 0])
            rotate([90, 0, 0])
                linear_extrude(height = sticker_text_raise)
                    _sticker_text_outline();
    else
        translate([0, y_outer + sticker_text_depth, 0])
            rotate([90, 0, 0])
                linear_extrude(height = sticker_text_depth)
                    _sticker_text_outline();
}

// =====================================================================
// Aufruf
// =====================================================================
sockel_mit_text();
