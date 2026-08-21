// ============================================================
// Bootsname Oliver
// Chinesischer Schriftzug "叔叔湖畔", 2mm extrudiert
// ============================================================

// --- Render Settings ----------------------------------------
$fn = 60;

// --- Parameters -----------------------------------------------
_main_header_text            = "叔叔湖畔";       // Schriftzug [string]
_main_header_font            = "Noto Sans CJK SC:style=Regular"; // Font mit CJK-Unterstützung
_main_header_font_size       = 20;               // Schriftgröße [mm]
_main_header_extrusion_height = 2;               // Extrusionshöhe [mm]
_main_header_letter_spacing  = 1;                // Zeichenabstand-Faktor [1 = normal]
_main_header_halign          = "center";         // Horizontale Ausrichtung
_main_header_valign          = "center";         // Vertikale Ausrichtung

_sub_header_text            = "Seeseitn";        // Schriftzug [string]
_sub_header_font            = "Dancing Script:style=Regular";   // Font
_sub_header_font_size       = 10;                // Schriftgröße [mm]
_sub_header_extrusion_height = 2;                // Extrusionshöhe [mm]
_sub_header_letter_spacing  = 1;                 // Zeichenabstand-Faktor [1 = normal]
_sub_header_halign          = "center";          // Horizontale Ausrichtung
_sub_header_valign          = "center";          // Vertikale Ausrichtung

// --- Main Model -----------------------------------------------
//_main_header();

translate([0, -25, 0])
    _sub_header();

// --- Modules ----------------------------------------------------
module _main_header() {
    linear_extrude(height = _main_header_extrusion_height)
        text(
            text    = _main_header_text,
            size    = _main_header_font_size,
            font    = _main_header_font,
            spacing = _main_header_letter_spacing,
            halign  = _main_header_halign,
            valign  = _main_header_valign
        );
}

module _sub_header() {
    linear_extrude(height = _sub_header_extrusion_height)
        text(
            text    = _sub_header_text,
            size    = _sub_header_font_size,
            font    = _sub_header_font,
            spacing = _sub_header_letter_spacing,
            halign  = _sub_header_halign,
            valign  = _sub_header_valign
        );
}
