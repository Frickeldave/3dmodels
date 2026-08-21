// ============================================================
// Pokal_Motiv
// Parametrische 3D-Zahl (1, 2, 3) als Pokal-Körper
// Wird auf Pokal_Sockel.scad montiert und kann mit
// Motiven (z.B. Fußball) kombiniert werden.
// ============================================================

// --- Render Settings ----------------------------------------
$fn = 60;                              // Glatte Rundungen

// --- Hinweis: Parameter werden zentral in Pokal.scad gesteuert
// --- Die Default-Werte in pokal_number() / number_3d() werden nur bei
// --- direktem Öffnen dieser Datei verwendet (selten).
// --- Main Model ---------------------------------------------
// pokal_number() wird nur ausgeführt, wenn diese Datei direkt geöffnet wird.
// Beim Einbinden über 'use <Pokal_Motiv.scad>' in Pokal.scad wird sie mit
// Parametern aufgerufen.
// --- Modules ------------------------------------------------
pokal_number();

// --- Modules ------------------------------------------------

/**
 * @brief Hauptmodul: 3D-Zahl als extrudierter Text
 * @param[in] number Welche Zahl (1, 2 oder 3)
 * @param[in] font_size Schriftgröße in mm
 * @param[in] thickness Dicke der Zahl in mm
 * @param[in] edge_radius Radius der Kantenabrundung in mm
 * @param[in] font Schriftart
 */
module pokal_number(
    number = 1,
    font_size = 100,
    thickness = 12,
    edge_radius = 2,
    font = "Liberation Serif:style=Bold"
) {
    number_3d(number = number, font_size = font_size, thickness = thickness, edge_radius = edge_radius, font = font);
}

/**
 * @brief Die 3D-Zahl als linear extrudierter Text, aufrecht stehend
 * @details Optional mit abgerundeten Kanten via minkowski()
 * @param[in] number Welche Zahl (1, 2 oder 3)
 * @param[in] font_size Schriftgröße in mm
 * @param[in] thickness Dicke der Zahl in mm
 * @param[in] edge_radius Radius der Kantenabrundung in mm
 * @param[in] font Schriftart
 */
module number_3d(
    number = 1,
    font_size = 100,
    thickness = 12,
    edge_radius = 2,
    font = "Liberation Serif:style=Bold"
) {
    rotate([90, 0, 0]) {
        translate([0, 0, -thickness / 2]) {
            if (edge_radius > 0) {
                // Mit Minkowski-Summe abrunden
                minkowski() {
                    linear_extrude(height = thickness - 2 * edge_radius, center = false) {
                        offset(delta = -edge_radius) {
                            offset(delta = 0) {  // Normalisierung
                                text(
                                    str(number),
                                    size = font_size,
                                    font = font,
                                    halign = "center",
                                    valign = "center"
                                );
                            }
                        }
                    }
                    sphere(r = edge_radius);
                }
            } else {
                // Ohne Abrundung
                linear_extrude(height = thickness, center = false) {
                    offset(delta = 0) {  // Normalisierung
                        text(
                            str(number),
                            size = font_size,
                            font = font,
                            halign = "center",
                            valign = "center"
                        );
                    }
                }
            }
        }
    }
}
