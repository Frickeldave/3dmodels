// ============================================================
// Pokal - Komplettmodell
// Kombiniert Sockel, Motiv (Zahl) und Fußball
// ============================================================

// --- Render Settings ----------------------------------------
$fn = 60;
$fa = 2;
$fs = 0.6;

// --- Includes -----------------------------------------------
// BOSL2 muss mit include geladen werden, da Pokal_Fußball.scad es benötigt
include <../../../modules/scad/BOSL2/std.scad>
include <../../../modules/scad/BOSL2/polyhedra.scad>

use <Pokal_Sockel.scad>
use <Pokal_Motiv.scad>
use <Pokal_Fußball.scad>

// --- Parameters ---------------------------------------------

/* [Sockel] */
_base_height          = 42;            // Höhe des Sockels [mm]
_base_width           = 130;           // Breite des Sockels [mm]
_base_depth           = 40;            // Tiefe des Sockels [mm]
_base_fillet          = 2.5;           // Abrundung der Sockelkanten [mm]
_pyramid_height       = 7;             // Höhe der Pyramide [mm]
_pyramid_top_scale    = 0.7;           // Skalierung der Pyramiden-Oberfläche [-]
_sockel_total_height  = _base_height + _pyramid_height;  // Gesamthöhe [mm]

/* [Zierrahmen] */
_frame_inset_xy       = 4;             // Abstand des Rahmens vom Rand [mm]
_frame_depth          = 3;           // Dicke des Rahmens [mm]
_frame_band           = 1.6;           // Breite des Rahmens [mm]
_frame_radius         = 2;             // Abrundung des Rahmens [mm]
_frame_raised         = true;          // Rahmen aufgesetzt [bool]

/* [Text allgemein] */
_text_line1           = "3. Platz";    // Erste Textzeile [-]
_text_line2           = "WM-Tippspiel 2026"; // Zweite Textzeile [-]
_text_line3           = "BiDa GmbH"; // Dritte Textzeile [-]
_text_size_big        = 7.0;           // Schriftgröße große Zeile [mm]
_text_size_small      = 4.5;           // Schriftgröße kleine Zeilen [mm]
_text_font            = "Liberation Sans:style=Bold"; // Schriftart [-]

/* [Motiv/Zahl] */
_number               = 3;             // Welche Zahl (1, 2 oder 3) [-]
_font_size            = 190;           // Schriftgröße/Größe der Zahl [mm]
_number_thickness     = 20;            // Dicke der Zahl [mm]
_edge_radius          = 2;             // Radius der Kantenabrundung [mm]
_number_offset_z      = 15;            // Z-Verschiebung des Motivs [mm]
_font                 = "Liberation Serif:style=Bold"; // Schriftart

/* [Ball] */
_ball_mode            = 1;             // 0 = halbiert mit Scheibe, 1 = volle Kugel [-]
_ball_scale           = 0.7;           // Skalierung des Fußballs (0.5 = 50%) [-]
_ball_diameter        = 80;            // Außendurchmesser des Balls [mm]
_ball_offset_x        = 50;            // Horizontale Position (rechts) [mm]
_ball_offset_y        = 0;             // Position nach vorne [mm]
_ball_offset_z        = 60;            // Vertikale Position auf dem Motiv [mm]

/* [Ball-Prägung] */
_pentagon_scale       = 0.92;          // Fünfeck-Größe relativ zur Face [-]
_pentagon_depth       = 1.2;           // Prägetiefe Fünfecke [mm]
_hexagon_scale        = 0.92;          // Sechseck-Größe relativ zur Face [-]
_hexagon_line_width   = 1.4;           // Strichbreite Umrandung [mm]
_hexagon_depth        = 0.8;           // Prägetiefe Umrandung [mm]

/* [Scheibe hinter Fußball] */
_disc_enabled         = true;          // Scheibe aktivieren [bool]
_disc_thickness       = 3;             // Dicke der Scheibe [mm]
_disc_border          = 2;             // Zusätzlicher Rand um den Fußball [mm]

/* [Druckverfahren] */
_print_mode           = 0;             // 0 = Singlecolor (mit Ballvertiefung), 1 = Multicolor (Ball fest montiert) [-]
_ball_recess_depth    = 10;            // Tiefe der Ballvertiefung im Singlecolor-Modus [mm]
_ball_recess_expansion = 0.1;          // Erweiterung der Ball-Vertiefung in alle Richtungen [mm]
_ball_recess_offset_x = 5;             // Zusätzlicher X-Versatz der Ballvertiefung: - links, + rechts [mm]. Empfehlung: 1 = 0; 2 = 0; 3 = 5;
_text_print_mode      = 0;             // 0 = Singlecolor (Text trennbar), 1 = Multicolor (Text fest) [-]
_text_recess_depth    = 1.0;           // Tiefe der Text-Vertiefung [mm]
_text_recess_expansion= 0.1;           // Erweiterung der Text-Vertiefung [mm]
_frame_print_mode     = 0;             // 0 = Singlecolor (Rahmen trennbar), 1 = Multicolor (Rahmen fest) [-]
_frame_recess_depth   = 1.2;           // Tiefe der Rahmen-Vertiefung [mm]
_frame_recess_expansion = 0.1;         // Erweiterung der Rahmen-Vertiefung [mm]

/* [Text-Sticker] */
_sticker_plate_thickness = 2.0;        // Dicke der aufgesetzten Platte (cube) [mm]
_sticker_text_depth      = 0.4;        // Dicke der eingelassenen Textschicht [mm]
_sticker_text_raise      = 0.4;        // Hoehe der erhabenen Schrift ueber der Platte [mm]
_sticker_frame_depth     = 0.5;        // Tiefe des separaten Sticker-Rahmens [mm]
_sticker_fit_offset_xy   = 0.2;       // Verkleinerung je Seite fuer passgenauen Sitz im Rahmen [mm]

/* [Einzelbauteile zum Einzeldruck] */
render_pokal          = false;          // Pokal (Sockel + Pyramide + Zahl) rendern [bool]
render_text_frame     = false;          // Nur Textrahmen (getrennt) rendern [bool]
render_text_sticker   = true;          // Text-Sticker (Plakette + Text) rendern [bool]
render_ball           = false;          // Fußball rendern [bool]

// --- Computed Values ----------------------------------------
_ball_radius = (_ball_diameter * _ball_scale) / 2;  // Radius des skalierten Balls

// --- Main Model ---------------------------------------------
pokal_complete();

// --- Modules ------------------------------------------------

/**
 * @brief Komplettes Pokal-Modell
 * @details Je nach _print_mode: Multicolor = Ball fest montiert, Singlecolor = Ball mit Ablage
 */
module pokal_complete() {
    // Hauptkörper: Sockel + Motiv + (optional) Ball
    if (render_pokal) {
        difference() {
            union() {
                // 1. Sockel unten (aus Pokal_Sockel.scad)
                sockel_mit_text(
                    base_width = _base_width,
                    base_depth = _base_depth,
                    base_height = _base_height,
                    base_fillet = _base_fillet,
                    frame_inset_xy = _frame_inset_xy,
                    frame_depth = _frame_depth,
                    frame_band = _frame_band,
                    frame_radius = _frame_radius,
                    frame_raised = _frame_raised,
                    pyramid_height = _pyramid_height,
                    pyramid_top_scale = _pyramid_top_scale,
                    text_line1 = _text_line1,
                    text_line2 = _text_line2,
                    text_line3 = _text_line3,
                    text_size_big = _text_size_big,
                    text_size_small = _text_size_small,
                    text_font = _text_font,
                    _text_print_mode = _text_print_mode,
                    _text_recess_depth = _text_recess_depth,
                    _text_recess_expansion = _text_recess_expansion,
                    _frame_print_mode = _frame_print_mode,
                    _frame_recess_depth = _frame_recess_depth,
                    _frame_recess_expansion = _frame_recess_expansion
                );
                
                // 2. Motiv (Zahl "1") auf dem Sockel
                // Der Text ist mit valign="center" zentriert. Nach rotate([90,0,0])
                // liegt der Mittelpunkt bei Z=0. Die tatsächliche Höhe der "1" ist
                // bei Liberation Sans Bold ca. 70% der font_size.
                // Mit Minkowski-Abrundung kommt oben und unten je _edge_radius dazu.
                // Unterkante = -(_font_size * 0.35 + _edge_radius)
                // Verschiebung = _sockel_total_height - Unterkante
                translate([0, 0, _sockel_total_height + _font_size * 0.35 + _edge_radius + _number_offset_z]) {
                    pokal_number(
                        number = _number,
                        font_size = _font_size,
                        thickness = _number_thickness,
                        edge_radius = _edge_radius,
                        font = _font
                    );
                }
                
                // 3. Fußball - NUR im Multicolor-Modus fest montiert
                if (_print_mode == 1) {
                    translate([_ball_offset_x, _ball_offset_y, _ball_offset_z]) {
                        scale([_ball_scale, _ball_scale, _ball_scale]) {
                            half_soccer_ball(
                                ball_diameter = _ball_diameter,
                                pentagon_scale = _pentagon_scale,
                                pentagon_depth = _pentagon_depth,
                                hexagon_scale = _hexagon_scale,
                                hexagon_line_width = _hexagon_line_width,
                                hexagon_depth = _hexagon_depth,
                                eps = 0.02,
                                ball_scale = 1,
                                ball_mode = _ball_mode,
                                disc_enabled = _disc_enabled,
                                disc_thickness = _disc_thickness,
                                disc_border = _disc_border
                            );
                        }
                    }
                }
            }
            
            // 4. Ball-Ablage im Singlecolor-Modus
            // Halbkugelförmige Vertiefung oben auf der Pyramide
            if (_print_mode == 0) {
                color("silver")
                translate([_ball_offset_x + _ball_recess_offset_x, _ball_offset_y, _ball_offset_z]) {
                    // Halbkugel (oben offen) für den Ball
                    intersection() {
                        sphere(r = _ball_radius + 2 + _ball_recess_expansion);
                        halfspace(bottom=true);
                    }
                }
            }
        }
    }

    // 5. Separater Ball im Singlecolor-Modus (neben dem Pokal)
    if (render_ball && _print_mode == 0) {
        translate([_ball_offset_x + 60, -30, _ball_offset_z]) {
            scale([_ball_scale, _ball_scale, _ball_scale]) {
                half_soccer_ball(
                    ball_diameter = _ball_diameter,
                    pentagon_scale = _pentagon_scale,
                    pentagon_depth = _pentagon_depth,
                    hexagon_scale = _hexagon_scale,
                    hexagon_line_width = _hexagon_line_width,
                    hexagon_depth = _hexagon_depth,
                    eps = 0.02,
                    ball_scale = 1,
                    ball_mode = _ball_mode,
                    disc_enabled = _disc_enabled,
                    disc_thickness = _disc_thickness,
                    disc_border = _disc_border
                );
            }
        }
    }
    
    // 6. Separater Textrahmen im Singlecolor-Modus (neben dem Pokal)
    if (render_text_frame && _print_mode == 0) {
        if (_frame_print_mode == 0) {
            translate([-30, -30, 20]) {
                sockel_frame_separat(
                    base_width = _base_width,
                    base_depth = _base_depth,
                    base_height = _base_height,
                    frame_inset_xy = _frame_inset_xy,
                    frame_depth = _frame_depth,
                    frame_radius = _frame_radius,
                    frame_band = _frame_band
                );
            }
        }
    }

    // 7. Text-Sticker: separate Plakette passend fuer den Textrahmen
    if (render_text_sticker) {
        translate([0, 80, 20]) {
            text_sticker_separat(
                base_width = _base_width - 2 * _sticker_fit_offset_xy,
                base_depth = _base_depth,
                base_height = _base_height - 2 * _sticker_fit_offset_xy,
                frame_inset_xy = _frame_inset_xy,
                frame_depth = _sticker_frame_depth,
                frame_radius = _frame_radius,
                frame_band = _frame_band,
                plate_thickness = _sticker_plate_thickness,
                sticker_text_depth = _sticker_text_depth,
                sticker_text_raise = _sticker_text_raise,
                text_line1 = _text_line1,
                text_line2 = _text_line2,
                text_line3 = _text_line3,
                text_size_big = _text_size_big,
                text_size_small = _text_size_small,
                text_font = _text_font
            );
        }
    }
}

/**
 * @brief Scheibe hinter dem Fußball
 * @details Runde Scheibe, die 5mm größer als der Fußball ist
 */
module ball_disc() {
    // Originaler Fußball-Durchmesser ist 80mm, skaliert = 80 * _ball_scale
    _ball_diameter_scaled = 80 * _ball_scale;
    _disc_diameter = _ball_diameter_scaled + 2 * _disc_border;
    
    // Scheibe hinter dem Fußball (in -Y Richtung)
    translate([0, -_disc_thickness/2 + _disc_thickness, 0])
        rotate([90, 0, 0])
            cylinder(d = _disc_diameter, h = _disc_thickness, center = true);
}
