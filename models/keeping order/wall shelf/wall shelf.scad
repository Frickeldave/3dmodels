// ============================================================
// Wandhalter für ein Brett (Regalwinkel) – wall shelf bracket
// ============================================================
//
// ÜBERSICHT
// ---------
// Dieses Modell erzeugt einen parametrischen Wandhalter, bestehend aus:
//   1. Einem U-förmigen Klemm-Halter (Klemmer), der das Brett von unten
//      und an der Seite umschließt (Breite: _shelves_edging + _thickness).
//   2. Einem dreieckigen Stützwinkel, der oberhalb des Halters sitzt
//      und die Last auf die Wand ableitet.
//
// Der Halter unterstützt eine Neigung des Bretts (_tilt_angle), sodass
// die Vorderkante des Bretts nach unten geneigt werden kann (z.B. für
// schräge Regale oder geneigte Präsentationsflächen).
//
// ============================================================
// KOORDINATENSYSTEM
// ============================================================
//
// Weltkoordinaten (OpenSCAD-Standard):
//   +X = rechts (Breite des Halters, von der Wand aus gesehen nach links)
//   +Y = Tiefe (von der Wand nach vorne, also weg von der Wand)
//   +Z = Höhe (nach oben)
//
// Klemmer (ungeneigt):
//   - Rückwand (Wandseite): Y = _shelves_depth + _thickness  bis  Y = _shelves_depth + _thickness*2
//   - Vorderkante: Y = 0
//   - Unterkante: Z = 0
//   - Oberkante:  Z = _shelves_thickness + _thickness
//   - Breite:     X = 0 bis X = _shelves_edging + _thickness
//
// ============================================================
// NEIGUNG (_tilt_angle)
// ============================================================
//
// Der Klemmer und das Brett werden um den DREHPUNKT P geneigt:
//   P = (beliebiges X,  Y = _shelves_depth + _thickness*2,  Z = 0)
//
// Das ist die hintere UNTERKANTE des Klemmers (Rückwand-Außenseite unten).
// Dieser Punkt bleibt bei der Drehung ortsfest.
//
// OpenSCAD-Umsetzung der Drehung (im Klemmer-Teil):
//   translate([0, sd+2t, 0])       // Zum Drehpunkt verschieben
//   rotate([-_tilt_angle, 0, 0])   // Drehen (negatives Vorzeichen: Rx um +angle)
//   translate([0, -(sd+2t), 0])    // Zurück zum Ursprung
//
// Rotation Rx(α) mit α = -_tilt_angle:
//   Y' = Y*cos(α) - Z*sin(α)
//   Z' = Y*sin(α) + Z*cos(α)
//
// Warum negativer Drehwinkel?
//   OpenSCAD rotate([a,0,0]) dreht um +a Grad (Rechtshandregel: Daumen in +X).
//   Wir wollen, dass die Vorderkante nach UNTEN sinkt. Das entspricht einer
//   Rotation, bei der Y>0 nach -Z zieht. Mit rotate([-_tilt_angle, 0, 0])
//   und _tilt_angle=-10 wird rotate([+10, 0, 0]) ausgeführt, was korrekt ist.
//
// ============================================================
// DREHPUNKT-WAHL UND GEOMETRISCHE KONSEQUENZEN
// ============================================================
//
// Drehpunkt bei Z=0 (Klemmer-Unterkante-Rückseite):
//   - Die hintere Unterkante des Klemmers bewegt sich NICHT (dZ=0 zum Pivot).
//   - Die hintere Oberkante (Z=st+2t) bewegt sich auf:
//       Z_new = (st+2t)*cos(angle)   [bei angle=_tilt_angle negativ → kleiner als st+2t]
//       Y_new = (sd+2t) - (st+2t)*sin(angle)  [nach vorne, da sin(neg.Winkel)<0]
//   - Die vordere Unterkante (Y=0, Z=0 → dY=-(sd+2t), dZ=0) bewegt sich auf:
//       Y_new = (sd+2t) - (sd+2t)*cos(angle)
//       Z_new = -(sd+2t)*sin(angle)  [bei neg. angle: positiv, also nach oben → vorne höher]
//     Warte: Vorderkante sinkt → Z sinkt. Mit angle=-10°: sin(-10°)<0 → Z_new>0.
//     Tatsächlich dreht sich die Vorderkante NACH UNTEN, weil die gesamte
//     Drehung "vorwärts kippen" entspricht. Die Z-Koordinate der vorderen
//     Unterkante wird negativ:
//       Z_VU = 0 + (-(sd+2t))*sin(α)  mit α>0 → negativ → Brett senkt sich.
//
// HINWEIS Brett vs. Klemmer:
//   Das Demo-Brett dreht sich um Z=_thickness (= Unterkante des Bretts, nicht
//   Unterkante des Klemmers), weil das Brett bei Z=_thickness beginnt.
//   Der Klemmer dreht sich um Z=0 (Unterkante des Klemmers, also 4mm tiefer).
//   Das ist geometrisch korrekt: Das Brett wird vom Klemmer GEHALTEN, beide
//   neigen sich, aber mit leicht unterschiedlicher Achse (das Brett hat keinen
//   Spielraum im Klemmer in Z-Richtung wegen _thickness).
//   In der Praxis ist dieser Unterschied vernachlässigbar (4mm bei 150mm Tiefe).
//   Vorne steht das Brett leicht über das Dreieck hinaus – das ist akzeptiert.
//
// ============================================================
// DREIECKIGER STÜTZWINKEL – KOORDINATENSYSTEM
// ============================================================
//
// Das Dreieck wird als 2D-Polygon erzeugt und mit linear_extrude extrudiert.
// Der Dreieck-Block sitzt nach folgenden Transformationen:
//
//   translate([se+t, sd+2t, Z_tri])
//   rotate([90, 0, 270])
//
// wobei:
//   se = _shelves_edging,  t = _thickness,  st = _shelves_thickness
//   sd = _shelves_depth,   Z_tri = (st+t)*cos(_tilt_angle)
//
// Mapping lokale → Welt-Koordinaten:
//   lokal X  →  Welt  -Y  (Tiefe: x_lok=0 liegt an der Wand Y=sd+2t)
//   lokal Y  →  Welt  +Z  (Höhe)
//   lokal Z  →  Welt  -X  (Breite: Extrusion von X=se+t nach X=0)
//   Umkehrung: x_lok = (sd+2t) - Welt_Y,  y_lok = Welt_Z - Z_tri
//
// Z_tri = (st+2t)*cos(angle):
//   Das ist die Welt-Z-Koordinate der hinteren Oberkante des geneigten Klemmers.
//   (Klemmer-Außenkörper: st+2t hoch, Wand oben und unten je _thickness)
//   Der Dreieck-Ursprung liegt genau dort, sodass Ecke A (bei y_lok=-(st+2t)*cos(angle))
//   auf Welt-Z=0 landet (= Klemmer-Unterkante-Rückseite, der Drehpunkt).
//
// ============================================================
// DREIECK-ECKEN-BERECHNUNG
// ============================================================
//
// Alle drei Ecken werden aus der tatsächlichen Position des geneigten
// Klemmers berechnet, sodass die Dreieck-Unterkante (A→C) bündig mit
// der Klemmer-Unterkante abschließt.
//
// Ecke A  (Wand, Klemmer-Rückseite-Unterkante):
//   Weltposition: Y=sd+2t, Z=0  (Drehpunkt → bewegt sich nicht)
//   x_lok = (sd+2t) - (sd+2t) = 0
//   y_lok = 0 - Z_tri = -(st+2t)*cos(angle)
//   → _tri_A_x = 0
//   → _tri_A_y = -(st+2t)*cos(angle)
//
// Ecke B  (Wand, Spitze oben – liegt an der Wand, nicht am Klemmer):
//   Liegt bei x_lok=0 (Wandseite), y_lok = _tri_h = _shelves_depth - _shelves_thickness
//   Bleibt bei allen Winkeln fest (Wandkante).
//   → [0, _tri_h]
//
// Ecke C  (Vorderseite, Klemmer-Vorderkante-Unterkante):
//   Ungeneigt: Y=0, Z=0, dY=-(sd+2t) vom Drehpunkt, dZ=0
//   Nach Rotation Rx(α) mit α=-_tilt_angle:
//     dY' = dY*cos(α) = -(sd+2t)*cos(α)
//     dZ' = dY*sin(α) = -(sd+2t)*sin(α)
//   Weltposition: Y = (sd+2t) + dY' = (sd+2t)*(1-cos(α))
//                 Z = 0 + dZ' = -(sd+2t)*sin(α)
//   x_lok = (sd+2t) - Welt_Y = (sd+2t)*cos(α) = (sd+2t)*cos(angle)
//   y_lok = Welt_Z - Z_tri   = -(sd+2t)*sin(α) - (st+2t)*cos(α)
//         = (sd+2t)*sin(angle) - (st+2t)*cos(angle)
//         [sin(angle) negativ bei neg. angle → y_lok sehr negativ = weit unten]
//   → _tri_C_x = (sd+2t)*cos(angle)
//   → _tri_C_y = (sd+2t)*sin(angle) - (st+2t)*cos(angle)
//
// Probe bei angle=0°:
//   A = (0, -21),  B = (0, 137),  C = (158, -21)
//   → flache Unterkante 21mm unter dem Dreieck-Ursprung = -(st+2t) →✓
//   → Gesamthöhe = 137 + 21 = 158 = sd + 2t ✓
//
// Probe bei angle=-20°:
//   A = (0, -19.73),  C = (148.47, -73.77)
//   RU-Klemmer liegt bei Welt-Z=0, Welt-Y=158 → kein Überstand hinten ✓
//
// ============================================================
// INNERE AUSSCHNITTE (offset-basiert)
// ============================================================
//
// Statt die Innenecken manuell zu berechnen, wird offset(r=-_thickness)
// auf das identische Außenpolygon angewendet. Das erzeugt einen
// gleichmäßigen Wandabstand auf allen drei Seiten, auch bei spitzen Winkeln
// (OpenSCAD rechnet den Innenoffset korrekt).
//
// Wandausschnitt (_bracket_wall_cutout_offset):
//   Gleiches Prinzip mit offset(r=-_bwco). Dieser Ausschnitt geht durch
//   die gesamte Breite des Dreiecks, damit das Wandmaterial (Putz, Fliesen)
//   keinen Spalt bildet und die Schrauben direkt an die Wand kommen.
//
// ============================================================

include <../../../modules/gridfinity/gridfinity-rebuilt-baseplate.scad>

//BRETT: 300x800

// --- Parameter ---

// Wandstärke aller Außenwände des Halters
_thickness = 4;

// Dicke des Bretts, das gehalten werden soll
_shelves_thickness = 13;

// Breite des Randes, der das Brett seitlich umgreift (Einfassung)
_shelves_edging = 15;

// Tiefe des Bretts (wie weit es von der Wand absteht)
_shelves_depth = 130;

// Versatz des Wandausschnitts am Stützwinkel (wie viel kleiner das Ausschnitt-Dreieck
// gegenüber dem Außendreieck ist – gleichmäßig an allen drei Seiten)
_bracket_wall_cutout_offset = 15;

// Neigungswinkel des Bretts nach vorne-unten (in Grad)
// 0 = waagerecht, negative Werte neigen die Vorderkante nach unten
_tilt_angle = -20;

// --- Schlüsselloch-Parameter ---
// Durchmesser des kleinen Lochs oben (Schraubenschaft)
_keyhole_shaft_d  = 3.1;
// Durchmesser des großen Lochs unten (Schraubenkopf)
_keyhole_head_d   = 7;
// Abstand zwischen den Mittelpunkten beider Kreise (Lochlänge)
_keyhole_length   = 10;

// --- Verstärkung hinter den Schlüssellöchern ---
// Keine Zwischenvariablen mehr, alles direkt berechnet

// --- Schlüsselloch-Modul ---
// Erzeugt ein Schlüsselloch-Profil, das in Y-Richtung (durch die Rückwand) extrudiert wird.
// Aufruf-Ursprung: X/Z = Mitte des Kopf-Kreises (Schraubenkopf), bei Y = Innenseite der Rückwand.
// Der Kopf (groß) sitzt unten (bei Z=0 des Aufrufs), der Schaft (klein) liegt bei Z = +length.
// Die Extrusion geht von Y-1 bis Y+depth+1, also komplett durch die Rückwand.
// Erzeugt ein Schlüsselloch das in +Y-Richtung durch eine Wand der Dicke "depth" schneidet.
// Aufruf-Ursprung: Mitte des Kopf-Kreises (Schraubenkopf, groß/unten) an der Innenseite der Wand.
// Der Schaft (klein) liegt bei Z = +length oberhalb des Kopfes.
// Kopf (groß, unten) = Schraubenkopf passt durch; Schaft (klein, oben) = Schraubenschaft hält.
module keyhole(shaft_d, head_d, length, depth) {
    // Profil liegt in der XZ-Ebene, Extrusion in Y-Richtung
    rotate([90, 0, 0])             // XZ-Ebene → Extrusion entlang Y
    translate([0, 0, -depth - 1])  // von Außenseite der Wand startend nach innen
    linear_extrude(height = depth + 2)
    union() {
        // Verbindungskanal: Schlitz zwischen Kopf und Schaft
        hull() {
            circle(d = shaft_d, $fn = 32);                        // Schaft-Kreis unten (Kopfmitte)
            translate([0, length]) circle(d = shaft_d, $fn = 32); // Schaft-Kreis oben
        }
        // Großer Kopf-Kreis am unteren Ende
        circle(d = head_d, $fn = 32);
    }
}


module wall_shelf() {
    // Hilfsvariable: vertikale Absenkung der Vorderkante (nur informativ, nicht direkt verwendet)
    _tilt_drop = _shelves_depth * tan(_tilt_angle);

    // --- Teil 1: U-förmiger Brett-Klemm-Halter ---
    // Drehpunkt P: Y = sd+2t (Rückwand-Außenseite), Z = 0 (Klemmer-Unterkante)
    // → hintere Unterkante bleibt ortsfest (dZ=0 zum Pivot)
    // Siehe Hauptkommentar oben für vollständige Herleitung.

    translate([0, _shelves_depth + _thickness * 2, 0])             // Drehpunkt (Klemmer-Unterkante-Rückseite)
    rotate([-_tilt_angle, 0, 0])                                   // Neigung nach vorne-unten
    translate([0, -(_shelves_depth + _thickness * 2), 0])           // zurück in lokale Ursprungskoordinaten
    difference() {
        // Außenkörper des Halters
        // Höhe: st + 2t → je _thickness Wandstärke unten (Z=0..t) und oben (Z=st+t..st+2t)
        cube([_shelves_edging + _thickness,
            _shelves_depth + _thickness * 2,
            _shelves_thickness + _thickness * 2]);

        // Innenausschnitt: wird um _thickness in alle Richtungen eingerückt,
        // sodass rundum eine Wandstärke von _thickness übrig bleibt.
        // +1 in X damit der Ausschnitt die Vorderseite vollständig öffnet
        // (kein geschlossenes Vorderpanel – das Brett kann eingeschoben werden).
        translate([_thickness, _thickness, _thickness])
        cube([_shelves_edging + 1,
            _shelves_depth,
            _shelves_thickness]);

        // Bohrungen zur Befestigung des eingeschobenen Bretts
        color("red")
        for (z_pos = [_thickness + 20, _shelves_depth + _thickness - 20]) {
            translate([_shelves_edging / 2 + _thickness, z_pos, -1])
            cylinder(h=_thickness + 2, d=5, $fn=32);
        }

    }

    // --- Teil 2: Dreieckiger Stützwinkel ---
    // 2D-Polygon, extrudiert über die Halterbreite.
    // Koordinatensystem und Ecken-Herleitung: siehe Hauptkommentar am Dateianfang.
    // Kurzform: lokal-X = Welt-(-Y), lokal-Y = Welt-Z, Extrusion = Welt-(-X)

    _triangle_width = _shelves_edging + _thickness;

    // Dreieck-Ecken (aus Hauptkommentar):
    //   A: hintere Klemmer-Unterkante  (Wand, Z=0, bewegt sich nicht)
    //   B: Wandkante oben              (fest, unabhängig von Neigung)
    //   C: vordere Klemmer-Unterkante  (berechnet aus Rotation)

    _tri_A_x  = 0;
    _tri_A_y  = -(_shelves_thickness + _thickness * 2) * cos(_tilt_angle);
    _tri_C_x  = (_shelves_depth + _thickness * 2) * cos(_tilt_angle);
    _tri_C_y  = (_shelves_depth + _thickness * 2) * sin(_tilt_angle)
                - (_shelves_thickness + _thickness * 2) * cos(_tilt_angle);

    // Höhe der Dreiecks-Wandkante (von Ursprung bis Spitze, bleibt unverändert)
    _tri_h    = _shelves_depth - _shelves_thickness;

    // Wandausschnitt-Offset
    _bwco    = _bracket_wall_cutout_offset;

    union() {
        difference() {
            translate([_shelves_edging + _thickness,
                    _shelves_depth + _thickness * 2,
                    (_shelves_thickness + _thickness * 2) * cos(_tilt_angle)])  // Z_tri = Klemmer-Oberkante nach Drehung
            rotate([90, 0, 270])

            difference() {
                // Außenkörper
                // Ecken aus der echten Position des geneigten Klemmers berechnet:
                //   A = Klemmer-Rückseite-Oberkante nach Drehung
                //   B = Wand, Spitze oben (fixiert)
                //   C = Klemmer-Vorderseite-Oberkante nach Drehung
                // Außenkörper des Dreiecks
                linear_extrude(height = _triangle_width)
                polygon([
                    [_tri_A_x,  _tri_A_y],   // A: Klemmer-Rückseite-Unterkante (Wand)
                    [0,         _tri_h  ],   // B: Wandkante oben (fest)
                    [_tri_C_x,  _tri_C_y]    // C: Klemmer-Vorderseite-Unterkante
                ]);

                // Innenausschnitt: gleichmäßiger Offset -_thickness auf allen Seiten.
                // offset(r=-t) ist robuster als manuelle Innenecken (korrekt auch bei spitzen Winkeln).
                translate([0, 0, -1])
                linear_extrude(height = _triangle_width - _thickness + 1)
                offset(r = -_thickness)
                polygon([
                    [_tri_A_x,  _tri_A_y],
                    [0,         _tri_h  ],
                    [_tri_C_x,  _tri_C_y]
                ]);

                // Wandausschnitt: tieferer Offset, damit Schrauben direkt an die Wand kommen.
                // Geht durch die gesamte Breite (Wand-Putz/Fliesen passen darunter).
                translate([0, 0, -1])
                linear_extrude(height = _triangle_width + 2)
                offset(r = -_bwco)
                polygon([
                    [_tri_A_x,  _tri_A_y],
                    [0,         _tri_h  ],
                    [_tri_C_x,  _tri_C_y]
                ]);
            }

        // Schlüssellöcher durch die Rückwand
            color("red")
            for (z_pos = [(_shelves_thickness + _thickness) + _keyhole_head_d / 2 + 10, _shelves_depth - _keyhole_length - _keyhole_head_d - 10]) {
                translate([(_shelves_edging + _thickness) / 2,
                        _shelves_depth + _thickness,  // Außenseite der Rückwand
                        z_pos])
                keyhole(_keyhole_shaft_d, _keyhole_head_d, _keyhole_length,
                        _thickness);
            }

            // Brett-Innenraum aus dem Dreieck herausschneiden:
            // Gleiche Rotation wie der Klemmer, damit der Bereich wo das Brett
            // sitzt auch im Stützwinkel freigeschnitten wird.
            translate([0, _shelves_depth + _thickness * 2, 0])
            rotate([-_tilt_angle, 0, 0])
            translate([0, -(_shelves_depth + _thickness * 2), 0])
            translate([_thickness, _thickness, _thickness])
            cube([_shelves_edging + 1,
                _shelves_depth,
                _shelves_thickness]);
        }
    }
}

// // left shelf
// wall_shelf();



// //Board (geneigt, dreht sich um die hintere Unterkante des Bretts = Z=t)
// color("brown")
// translate([0, _shelves_depth + _thickness * 2, _thickness])
// rotate([-_tilt_angle, 0, 0])
// translate([0, -(_shelves_depth + _thickness * 2), -_thickness])
// translate([_thickness, _thickness, _thickness])
// cube([350, _shelves_depth, _shelves_thickness]);


// // right shelf
// mirror([1, 0, 0])
// translate([-350 - _thickness * 2, 0, 0])
// wall_shelf();



// Gridfinity Baseplate (Demo, pink)
// Nutzbare Breite: 350mm - 2*(se+t) = 350 - 2*19 = 312mm → 4 Slots (168mm)
// Nutzbare Tiefe:  216mm → 5 Slots (210mm)
// X-Start: hinter dem linken Bretthalter (= _shelves_edging + _thickness*2)
_gf_slots_x = 7;
_gf_slots_y = 3;
_gf_x_offset = _shelves_edging + _thickness * 2;  // linker Halter
color("DeepPink")
translate([0, _shelves_depth + _thickness * 2, _thickness])
rotate([-_tilt_angle, 0, 0])
translate([0, -(_shelves_depth + _thickness * 2), -_thickness])
// Plate zentriert im nutzbaren Bereich:
//   X: zwischen linkem Halter (_gf_x_offset=23) und rechtem Halter (216-19=197) → Mitte=110
//   Y: zwischen Brettvorderkante (_thickness=4) und Brettende (4+216=220) → Mitte=112
// Gridfinity-Ursprung liegt im Zentrum der Plate → direkt auf Mitte positionieren
translate([
    (_gf_x_offset + 350 - _shelves_edging - _thickness) / 2,          // X-Mitte nutzbarer Bereich
    _thickness + _shelves_depth / 2,                                    // Y-Mitte Brett
    _thickness + _shelves_thickness                                      // Auf Brettoberfläche
])
// hole_options kommt aus gridfinity-rebuilt-baseplate.scad (include):
// enable_magnet=true, crush_ribs=true, chamfer_holes=true → Magnetlöcher aktiv
// sp=2 (skeletonized): einziger Stil der Magnetlöcher UND minimales Gewicht kombiniert.
// sp=0 (thin) und sp=4 setzen minimal=true → kein hole_pattern, keine Magnetlöcher!
gridfinityBaseplate([_gf_slots_x, _gf_slots_y], 42, [0, 0], 2,
    hole_options,
    0, [0, 0]);



