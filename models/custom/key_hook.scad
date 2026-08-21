// ============================================================
// Key Hook Bar
// Leiste mit Haken zum Aufhängen von Schlüsseln
// ============================================================

// --- Render Settings ----------------------------------------
$fn = 100;

// --- Parameters ---------------------------------------------
_thickness     = 3;   // Wandstärke der Leiste [mm]
_width         = 160; // Breite der Leiste [mm]
_height        = 40;  // Höhe der Leiste [mm]
_corner_r      = 2;   // Fase an den Kanten [mm]

_screw_margin     = 8;  // Abstand Schraubenmitte zur Kante [mm]
_screw_d          = 4;  // Durchmesser Schraubenschaft [mm]
_screw_head_d     = 8;  // Durchmesser Schraubenkopf-Senkung [mm]
_screw_head_depth = 2;  // Tiefe der Senkung [mm]
_screw_holes      = false; // Schraubenlöcher ein/aus

_hook_r        = 4;   // Profilradius des Hakens [mm]
_hook_arm      = 8;  // Länge des geraden Arms [mm]
_hook_bend_r   = 10;  // Biegeradius des Hakenbogens [mm]
_hook_angle    = 60; // Bogenwinkel – > 180° ergibt einen Schnapper [°]
_hook_segments = 20;  // Segmente für den Bogen
_hook_count    = 6;   // Anzahl Haken
_hook_margin   = 10;  // Abstand zur Außenkante [mm]

_disc_r        = 7;  // Radius der runden Platte hinter dem Haken [mm]
_disc_t        = 4;   // Dicke der runden Platte [mm]
_disc_chamfer  = 3;   // Fase an der Vorderkante der Platte [mm]

// --- Computed Values ----------------------------------------
_hook_spacing = _hook_count > 1
    ? (_width - 2 * _hook_margin) / (_hook_count - 1)
    : 0;

// --- Main Model ---------------------------------------------
difference() {
    chamfered_cube([_width, _thickness, _height], _corner_r);

// Schraubenlöcher in den vier Ecken
if (_screw_holes) for (x = [_screw_margin, _width - _screw_margin],
        z = [_screw_margin, _height - _screw_margin]) {
    translate([x, -0.5, z]) {
        // Durchgangsloch
        rotate([-90, 0, 0])
        color("red")
        cylinder(h = _thickness + 10, d = _screw_d);
        // Senkung für Schraubenkopf (Rückseite)
        rotate([-90, 0, 0])
        color("blue")
        cylinder(h = _screw_head_depth + 0.01, d1 = _screw_head_d, d2 = _screw_d);
    }
}
}



for (i = [0 : _hook_count - 1]) {
    _x = _hook_count > 1
        ? _hook_margin + i * _hook_spacing
        : _width / 2;
    rotate([0, 180, 0])
    translate([-_x, -1, -_height / 2]) {
        hook();
        disc();
    }
}

// --- Modules ------------------------------------------------
module chamfered_cube(size, chamfer) {
    c  = min([chamfer, size[0]/2, size[2]/2]);
    cf = min([chamfer, size[1]/2]);
    intersection() {
        // Fase an den 4 Eckenkanten (entlang Y)
        hull() {
            translate([c, 0, 0]) cube([size[0]-2*c, size[1], size[2]      ]);
            translate([0, 0, c]) cube([size[0],      size[1], size[2]-2*c]);
        }
        // Fase an den 4 Vorderkanten (Frontfläche y = 0)
        hull() {
            translate([0, cf, 0]) cube([size[0],       size[1]-cf, size[2]      ]);
            translate([cf, 0, cf]) cube([size[0]-2*cf, cf,         size[2]-2*cf]);
        }
    }
}

module disc() {
    translate([0, 1.1, 0])
    rotate([90, 0, 0])
    union() {
        cylinder(h = _disc_t - _disc_chamfer, r = _disc_r);
        translate([0, 0, _disc_t - _disc_chamfer])
            cylinder(h = _disc_chamfer, r1 = _disc_r, r2 = _disc_r - _disc_chamfer);
    }
}

module hook() {
    // Gerader Arm (von der Leiste weg in -Y-Richtung)
    hull() {
        sphere(_hook_r);
        translate([0, -_hook_arm, 0]) sphere(_hook_r);
    }

    // Gebogener Teil: Kette von hull()-Segmenten entlang eines Kreisbogens
    // Öffnung zeigt nach oben – Schlüssel können eingehängt werden
    for (i = [0 : _hook_segments - 1]) {
        a1 = i       * (_hook_angle / _hook_segments);
        a2 = (i + 1) * (_hook_angle / _hook_segments);
        hull() {
            translate([0,
                -_hook_arm - _hook_bend_r * sin(a1),
                _hook_bend_r * (cos(a1) - 1)]) sphere(_hook_r);
            translate([0,
                -_hook_arm - _hook_bend_r * sin(a2),
                _hook_bend_r * (cos(a2) - 1)]) sphere(_hook_r);
        }
    }
}

