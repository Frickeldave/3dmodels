// =====================================================================
// Siegerpokal "1" – WM-Tippspiel 2026 / Effertz GmbH
// ---------------------------------------------------------------------
// Vollständig parametrisierbarer Trophäen-Pokal: große Zahl "1" auf
// rechteckigem Sockel, halber Fußball als Relief auf der Vorderseite,
// vertiefter Text auf dem Sockel.
//
// Reines OpenSCAD – keine externen Bibliotheken, keine Meshes.
//
// Achsenkonvention:
//   X = Breite  (links/rechts)
//   Y = Tiefe   (vorne = -Y, hinten = +Y)
//   Z = Höhe    (oben  = +Z)
// =====================================================================

// ---------------------- Renderqualität ------------------------------
$fa = 2;
$fs = 0.6;

// ---------------------- Sockel --------------------------------------
base_width    = 70;
base_depth    = 35;
base_height   = 35;
base_fillet   = 2.5;

// ---------------------- Zahl "1" ------------------------------------
digit_height  = 110;
digit_depth   = 14;
digit_stroke  = 20;
digit_serif_w = 36;
digit_serif_h = 10;
digit_flag_l  = 22;
digit_flag_h  = 14;
digit_top_cut = 6;
digit_y_inset = 2;     // Einrückung der Zahn-Front zur Sockel-Front

// ---------------------- Zierrahmen ----------------------------------
frame_inset_xy = 4;
frame_depth    = 1.2;
frame_band     = 1.6;
frame_radius   = 2;

// ---------------------- Fußball -------------------------------------
ball_diameter      = 28;
ball_z_offset      = 18;
ball_engrave_depth = 0.6;

// ---------------------- Text ----------------------------------------
text_line1     = "1. Platz";
text_line2     = "WM-Tippspiel 2026";
text_line3     = "Effertz GmbH";
text_font      = "Liberation Sans:style=Bold";
text_size_big  = 7.0;
text_size_small= 4.5;
text_depth     = 0.8;

// ---------------------- Globales ------------------------------------
EPS = 0.02;

// =====================================================================
// Hilfsmodule
// =====================================================================
module rounded_rect(w, d, r) {
    offset(r=r) offset(r=-r) square([w, d], center=true);
}

// =====================================================================
// Sockel
// ---------------------------------------------------------------------
// Flache Ober- und Unterseite, nur seitliche Kanten gerundet.
// (Minkowski mit Sphere würde die Oberseite kugelig wölben und den
//  Sockel zusätzlich vertikal verschieben.)
// =====================================================================
module sockel() {
    linear_extrude(height = base_height)
        rounded_rect(base_width, base_depth, base_fillet);
}

// Vertiefter Zierrahmen auf der Sockel-Vorderseite.
// linear_extrude wird in +Z extrudiert, dann per rotate([90,0,0]) so
// gekippt, dass die Extrusionsachse zu -Y wird. Translation bringt die
// hintere Stirnfläche genau auf die Sockel-Front (y = -base_depth/2),
// wodurch der Cut frame_depth tief INs Sockelmaterial reicht.
module sockel_frame_cut() {
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
// Zahl "1" als 2D-Profil
// =====================================================================
// Polygon mit Schaft-Zentrum bei x=0, untere Kante bei y=0.
module zahl_eins_2d() {
    s   = digit_stroke;
    H   = digit_height;
    fw  = digit_serif_w;
    fh  = digit_serif_h;
    fl  = digit_flag_l;
    flh = digit_flag_h;
    tc  = digit_top_cut;

    pts = [
        [-fw/2,            0      ],
        [-fw/2,            fh     ],
        [-s/2,             fh     ],
        [-s/2,             H - flh],
        [-s/2 - fl,        H - flh - 2],
        [-s/2 - fl + 4,    H - flh + 4],
        [-s/2 + 2,         H      ],
        [ s/2,             H      ],
        [ s/2,             H - tc ],
        [ s/2,             fh     ],
        [ fw/2,            fh     ],
        [ fw/2,            0      ]
    ];

    // weiche Ecken
    offset(r = 1.2) offset(r = -1.2)
        polygon(points = pts);
}

// 3D-Zahl: Breite=X, Höhe=Z, Tiefe=Y (zentriert um Y=0).
// Konstruktion:
//   1) Profil in XY-Ebene
//   2) extrudieren entlang Z (= Tiefe), zentriert
//   3) per rotate([90,0,0]) in die aufrechte Lage kippen:
//      Profil-X bleibt X, Profil-Y -> +Z (Höhe), Extrusion-Z -> -Y (Tiefe).
module zahl_eins_3d() {
    rotate([90, 0, 0])
        linear_extrude(height = digit_depth, center = true, convexity = 4)
            zahl_eins_2d();
}

// =====================================================================
// Fußball – halbe Kugel als Relief
// =====================================================================
module fussball() {
    r = ball_diameter / 2;
    difference() {
        // vordere Halbkugel: y <= 0
        intersection() {
            sphere(r = r);
            translate([0, -r, 0])
                cube([2*r + 1, 2*r + 1, 2*r + 1], center = true);
        }
        // angedeutete Paneellinien als feine Gravuren
        ball_panel_engrave(r);
    }
}

// Einfaches Linienmuster auf der Halbkugel-Vorderseite
module ball_panel_engrave(r) {
    // 3 Längengrade durch den Pol, je 60° versetzt
    for (a = [0:60:179]) {
        rotate([0, 0, a])
            translate([0, -r - EPS, 0])
                rotate([-90, 0, 0])
                    cylinder(h = ball_engrave_depth + 0.5,
                             r = 0.7, $fn = 12);
    }
    // Äquator-Ring (vorderseitig)
    rotate([90, 0, 0])
        difference() {
            cylinder(h = ball_engrave_depth + 0.5,
                     r = r + 0.05, center = true, $fn = 96);
            cylinder(h = ball_engrave_depth + 1.0,
                     r = r - 0.4, center = true, $fn = 96);
        }
}

// =====================================================================
// Textplatte – vertiefter Text auf der Sockel-Vorderseite
// =====================================================================
// Wichtig: Text liegt im XZ-Profil und wird so platziert, dass die
// Lesefläche aus -Y-Richtung normal lesbar ist.
module textplatte() {
    y_front = -base_depth/2;

    z1 = base_height * 0.74;   // "1. Platz"
    z2 = base_height * 0.50;   // "WM-Tippspiel 2026"
    z3 = base_height * 0.26;   // "Effertz GmbH"

    // Eine Extrusion für alle drei Zeilen (effizient).
    // Translation y_front + text_depth: Cut reicht text_depth tief in
    // den Sockel hinein und schaut EPS über die Front hinaus.
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
// Gesamtmodell
// =====================================================================
module trophy_1() {

    // Zahl mittig in Y auf dem Sockel positionieren.
    digit_y = 0;

    difference() {
        union() {
            // Sockel
            sockel();

            // Zahl mittig auf dem Sockel
            translate([0, digit_y, base_height])
                zahl_eins_3d();

            // Fußball-Relief – vorne mittig auf der Zahn, unteres Drittel
            translate([0,
                       digit_y - digit_depth/2,   // bündig an Zahn-Vorderseite
                       base_height + ball_z_offset])
                fussball();
        }

        // ---- vertiefte Details ----
        sockel_frame_cut();

        // Zierrahmen auf der Zahn-Front (in +Y-Richtung in die Zahl hinein)
        translate([0,
                   digit_y - digit_depth/2 + frame_depth,
                   base_height])
            rotate([90, 0, 0])
                linear_extrude(height = frame_depth + EPS)
                    difference() {
                        offset(r = -frame_inset_xy) zahl_eins_2d();
                        offset(r = -(frame_inset_xy + frame_band))
                            zahl_eins_2d();
                    }

        // Text auf dem Sockel
        textplatte();
    }
}

// =====================================================================
// Aufruf
// =====================================================================
trophy_1();
