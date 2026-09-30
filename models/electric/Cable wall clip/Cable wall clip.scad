// ============================================================
// Cable Wall Clip
// wall_mount_base  – Grundplatte mit Gewinde-Zylinder & Kabelschlitz
// wall_mount_cap   – Deckel mit Innengewinde, passend zum Base
// ============================================================

// --- Render Settings ----------------------------------------
$fn = 60;

include <../../../modules/scad/BOSL2/std.scad>
include <../../../modules/scad/BOSL2/threading.scad>
use <../../../modules/scad/roundedcube.scad>

// --- Parameters ---------------------------------------------
_cylinder_dia  = 25;   // Zylinder-Durchmesser (außen) [mm]
_cylinder_h    = 25;   // Zylinder-Höhe [mm]
_wall          = 6;    // Wandstärke Zylinder [mm]
_pitch         = 2;    // Gewindesteigung [mm]
_slot_width    = 12;   // Breite des Kabelschlitzes [mm]
_slot_clearance = 3;   // Abstand Schlitzboden von Grundplatte [mm]
_corner_radius = 2;    // Eckradius Grundplatte [mm]
_ring_width    = 4;    // Breite Ring am Zylinderfuß [mm]
_ring_h        = 5;    // Höhe Ring am Zylinderfuß [mm]
_screw_dia      = 3.5;    // Durchmesser Schraubenloch [mm]
_screw_head_dia = 6;    // Durchmesser Senkkopf [mm]
_screw_head_h   = 0.9;  // Höhe Senkkopf (Fase) [mm]
_enable_base      = false;        // Grundplatte mit Zylinder rendern [bool]
_enable_cap       = true;        // Deckel mit Innengewinde rendern [bool]
_thread_tolerance = 0.2;         // Toleranz für Innengewinde [mm]
_grip_structure   = "none"; // Griffstruktur Cap: "hemispheres" | "diamonds" | "none"
_grip_size        = 2;            // Radius der Halbkugeln [mm]
_grip_depth       = 0.3;          // Tiefe der Rauten-Rillen [mm]
_grip_width       = 2.6;          // Breite der Rauten-Rillen [mm]
_cap_inner_h       = _cylinder_h - _slot_width + 1; // Höhe Innenraum Cap [mm]
_cap_solid_top     = 3;           // Massive Zone + Fase oben am Cap [mm]
_logo_mode         = "embossed";       // Logo auf Cap: "none" | "embossed" | "debossed"
_logo_size         = 20;          // Breite des Logos [mm]
_logo_height       = 0.5;           // Höhe Embossed / Tiefe Debossed [mm]
_logo_color        = "gold";       // Farbe des Logos
_clamp_tolerance   = 0.3;         // Toleranz Klemmzylinder [mm]
_base_h           = 3;           // Höhe der Grundplatte [mm]

// --- Computed Values ----------------------------------------
_base_side  = _cylinder_dia + 10;  // Kantenlänge Grundplatte (5 mm Überstand je Seite)
_cap_total_h = _cap_inner_h + _wall;          // Gesamthöhe Cap (inkl. Deckel) [mm]
_clamp_length = _cap_inner_h + _wall; // Länge Klemmzylinder [mm]
_eps        = 0.01;                // Überstand für saubere Differenz-Schnitte

// --- Main Model ---------------------------------------------
if (_enable_base) {
    wall_mount_base(
        cylinder_dia   = _cylinder_dia,
        cylinder_h     = _cylinder_h,
        wall           = _wall,
        pitch          = _pitch,
        slot_width     = _slot_width,
        slot_clearance = _slot_clearance,
        corner_radius  = _corner_radius,
        ring_width     = _ring_width,
        ring_h         = _ring_h,
        screw_dia      = _screw_dia,
        screw_head_dia = _screw_head_dia,
        screw_head_h   = _screw_head_h,
        base_h         = _base_h
    );
}

if (_enable_cap) {
    translate([0, 0, _base_h / 2 + _cylinder_h + 10])
        wall_mount_cap(
            cylinder_dia    = _cylinder_dia,
            cap_inner_h     = _cap_inner_h,
            wall            = _wall,
            pitch           = _pitch,
            thread_tolerance = _thread_tolerance,
            grip_structure  = _grip_structure,
            grip_size       = _grip_size,
            grip_depth      = _grip_depth,
            grip_width      = _grip_width,
            cap_solid_top   = _cap_solid_top,
            logo_mode       = _logo_mode,
            logo_size       = _logo_size,
            logo_height     = _logo_height,
            logo_color      = _logo_color,
            clamp_length    = _clamp_length,
            clamp_tolerance = _clamp_tolerance
        );
}

// --- Modules ------------------------------------------------
module wall_mount_base(cylinder_dia, cylinder_h, wall, pitch, slot_width, slot_clearance, corner_radius, ring_width, ring_h, screw_dia, screw_head_dia, screw_head_h, base_h) {
    _eps = 0.01;
    _base_side = cylinder_dia + 10;
    _cyl_z = base_h / 2 + cylinder_h / 2;

    difference() {
        union() {
            // --- Grundplatte ---
            difference() {
                roundedcube(
                    size   = [_base_side, _base_side, base_h + corner_radius],
                    center = true,
                    radius = corner_radius
                );
                // untere Rundung abschneiden → Plattenhöhe exakt base_h
                translate([0, 0, -base_h / 2])
                    cube([_base_side + 2 * _eps, _base_side + 2 * _eps, corner_radius + _eps], center = true);
            }

            // --- Zylinder, Ring & Kabelschlitz ---
            translate([0, 0, _cyl_z])
                difference() {
                    union() {
                        // Zylinder mit Gewinde, innen hohl
                        difference() {
                            threaded_rod(d = cylinder_dia, l = cylinder_h, pitch = pitch, blunt_start = false);
                            cylinder(d = cylinder_dia - 2 * wall, h = cylinder_h + _eps, center = true);
                        }
                        // Konischer Ring am Zylinderfuß
                        translate([0, 0, -cylinder_h / 2 + ring_h / 2])
                            difference() {
                                cylinder(d1 = cylinder_dia + 2 * ring_width, d2 = cylinder_dia, h = ring_h, center = true);
                                cylinder(d = cylinder_dia, h = ring_h + _eps, center = true);
                            }
                        // Füllring – schließt Lücke zwischen Gewindegängen und konischem Ring
                        translate([0, 0, -cylinder_h / 2 + ring_h / 2])
                            difference() {
                                cylinder(d = cylinder_dia, h = ring_h, center = true);
                                cylinder(d = cylinder_dia - 2 * wall, h = ring_h + _eps, center = true);
                            }
                    }
                    // U-förmiger Kabelschlitz
                    _slot_bottom_z = -cylinder_h / 2 + slot_clearance + slot_width / 2;
                    _cube_h = (cylinder_h / 2 + _eps) - _slot_bottom_z;
                    _cube_center_z = (_slot_bottom_z + cylinder_h / 2 + _eps) / 2;
                    _overcut = _base_side + 2 * _eps;
                    union() {
                        translate([0, 0, _cube_center_z])
                            cube([slot_width, _overcut, _cube_h], center = true);
                        translate([0, 0, _slot_bottom_z])
                            rotate([90, 0, 0])
                                cylinder(d = slot_width, h = _overcut, center = true);
                    }
                }
        }

        // --- Schraubenloch (von unten durch die Platte) ---
        translate([0, 0, -base_h / 2 - corner_radius - _eps])
            cylinder(d = screw_dia, h = base_h + corner_radius + cylinder_h + 2 * _eps);

        // --- Senkkopf-Fase (von oben in die Platte) ---
        translate([0, 0, base_h / 2 + corner_radius + _eps])
            mirror([0, 0, 1])
                cylinder(d1 = screw_head_dia, d2 = screw_dia, h = screw_head_h + corner_radius + _eps);
    }
}

// --- wall_mount_cap ------------------------------------------
module wall_mount_cap(cylinder_dia, cap_inner_h, wall, pitch, thread_tolerance, grip_structure, grip_size, grip_depth, grip_width, cap_solid_top, logo_mode, logo_size, logo_height, logo_color, clamp_length, clamp_tolerance) {
    _eps = 0.01;
    _cap_total_h = cap_inner_h + wall;
    _outer_dia   = cylinder_dia + 2 * wall;
    _outer_r     = _outer_dia / 2;

    difference() {
        union() {
            // Äußerer Zylinderkörper mit angefastem oberen Rand
            cylinder(d = _outer_dia, h = _cap_total_h - cap_solid_top);
            translate([0, 0, _cap_total_h - cap_solid_top])
                cylinder(d1 = _outer_dia, d2 = _outer_dia - 2 * cap_solid_top, h = cap_solid_top);

            // Griffstruktur
            if (grip_structure == "hemispheres") {
                _grip_z0   = grip_size + 1;         // erster Z-Ring (Abstand vom Boden)
                _grip_z1   = _cap_total_h - cap_solid_top - grip_size; // letzter Z-Ring (vor massiver Zone)
                _grip_step_z = grip_size * 2.5;     // Z-Abstand zwischen Ringen
                _grip_count_ring = floor(PI * _outer_dia / (grip_size * 2.5)); // Anzahl pro Ring
                _grip_angle_step = 360 / _grip_count_ring;

                for (iz = [_grip_z0 : _grip_step_z : _grip_z1]) {
                    _row = round(iz / _grip_step_z);
                    _angle_off = (_row % 2 == 0) ? 0 : _grip_angle_step / 2;
                    for (ia = [0 : _grip_count_ring - 1]) {
                        _angle = _angle_off + ia * _grip_angle_step;
                        translate([_outer_r * cos(_angle), _outer_r * sin(_angle), iz])
                            sphere(r = grip_size);
                    }
                }
            }
            // Logo (erhaben)
            if (logo_mode == "embossed") {
                translate([0, 0, _cap_total_h])
                    linear_extrude(height = logo_height)
                        resize([logo_size, 0], auto = true)
                            import("../../../graphics/Logo.svg", center = true);
            }
        }

        // Innenraum mit Innengewinde (von unten offen)
        translate([0, 0, wall - _eps])
            threaded_rod(
                d            = cylinder_dia,
                l            = cap_inner_h + _eps,
                pitch        = pitch,
                internal     = true,
                blunt_start  = false,
                $slop        = thread_tolerance
            );

        // Rautenmuster: eingravierte, sich kreuzende Linien
        if (grip_structure == "diamonds") {
            _groove_depth = grip_depth;
            _groove_width = grip_width;
            _groove_count = floor(PI * _outer_dia / (grip_size * 5));
            _groove_angle_step = 360 / _groove_count;
            _groove_h = _cap_total_h - cap_solid_top + _eps;

            for (i = [0 : _groove_count - 1]) {
                rotate([0, 0, i * _groove_angle_step])
                    linear_extrude(height = _groove_h, twist = 360, slices = 80)
                        translate([_outer_r - _groove_depth / 2, 0])
                            square([_groove_depth + _eps, _groove_width], center = true);

                rotate([0, 0, i * _groove_angle_step])
                    linear_extrude(height = _groove_h, twist = -360, slices = 80)
                        translate([_outer_r - _groove_depth / 2, 0])
                            square([_groove_depth + _eps, _groove_width], center = true);
            }
        }

        // Logo (vertieft)
        if (logo_mode == "debossed") {
            translate([0, 0, _cap_total_h + _eps])
                mirror([0, 0, 1])
                    linear_extrude(height = logo_height + _eps)
                        resize([logo_size, 0], auto = true)
                            import("../../../graphics/Logo.svg", center = true);
        }
    }

    // Klemmzylinder – ragt nach unten, drückt auf das Kabel
    _clamp_dia = cylinder_dia - 2 * wall - 2 * clamp_tolerance;
    color("blue")
    translate([0, 0, _cap_total_h])
        mirror([0, 0, 1])
            cylinder(d = _clamp_dia, h = clamp_length);
}
