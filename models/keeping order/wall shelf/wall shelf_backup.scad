// ============================================================
// Wandhalter für ein Brett (Regalwinkel)
// ============================================================
// Dieses Modell besteht aus zwei Teilen:
//   1. Einem U-förmigen Klemm-Halter, der das Brett von unten
//      und an der Seite umschließt.
//   2. Einem dreieckigen Stützwinkel (45°), der oberhalb des
//      Halters sitzt und die Last auf die Wand ableitet.
// ============================================================

// --- Parameter ---

// Wandstärke aller Außenwände des Halters
_thickness = 4;

// Dicke des Bretts, das gehalten werden soll
_shelves_thickness = 13;

// Breite des Randes, der das Brett seitlich umgreift (Einfassung)
_shelves_edging = 15;

// Tiefe des Bretts (wie weit es von der Wand absteht)
_shelves_depth = 150;

// Winkel des Stützwinkels an der oberen Ecke (zwischen hinterer Wand und Schrägstütze)
// 90° = rechtwinklig, >90° = stumpfwinklig (stütze neigt sich nach vorne)
_bracket_angle = 110;  // in Grad

// Verstärkung hinter den Schlüssellöchern
_reinforcement_depth = 2;  // Tiefe der Verstärkung in Y-Richtung
_reinforcement_top_margin = 8; // Abstand von den Schlüssellöchern zur Ober-/Unterseite der Verstärkung

// Versatz des Wandausschnitts am Stützwinkel (wie viel kleiner das Ausschnitt-Dreieck
// gegenüber dem Außendreieck ist – gleichmäßig an allen drei Seiten)
_bracket_wall_cutout_offset = 15;

// --- Schlüsselloch-Parameter ---
// Durchmesser des kleinen Lochs oben (Schraubenschaft)
_keyhole_shaft_d  = 2.5;
// Durchmesser des großen Lochs unten (Schraubenkopf)
_keyhole_head_d   = 6;
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

// --- Teil 1: U-förmiger Brett-Klemm-Halter ---
// Bei Winkeln >90° neigt sich der Halter nach unten
// Berechnung des Neigungswinkels (Abweichung von 90°)
_tilt_angle = _bracket_angle - 90;  // positive Werte = Halter neigt sich nach unten
_tilt_rad = _tilt_angle * PI / 180;

// Außenquader, aus dem der Innenraum herausgeschnitten wird.
// Bei Neigung wird die Bounding Box größer
difference() {
    // Bei Neigung: gedrehter Außenkörper
    if (_tilt_angle != 0) {
        rotate([0, 0, -_tilt_angle])
        cube([_shelves_edging + _thickness,
              _shelves_depth + _thickness * 2,
              _shelves_thickness + _thickness]);
    } else {
        // Ohne Neigung: normaler Quader
        cube([_shelves_edging + _thickness,
              _shelves_depth + _thickness * 2,
              _shelves_thickness + _thickness]);
    }

    // Innenausschnitt: wird um _thickness in alle Richtungen eingerückt,
    // sodass rundum eine Wandstärke von _thickness übrig bleibt.
    // +1 in X damit der Ausschnitt die Vorderseite vollständig öffnet
    // (kein geschlossenes Vorderpanel – das Brett kann eingeschoben werden).
    if (_tilt_angle != 0) {
        rotate([0, 0, -_tilt_angle])
        translate([_thickness, _thickness, _thickness])
        cube([_shelves_edging + 1,
              _shelves_depth,
              _shelves_thickness]);
    } else {
        translate([_thickness, _thickness, _thickness])
        cube([_shelves_edging + 1,
              _shelves_depth,
              _shelves_thickness]);
    }

    // Bohrungen zur Befestigung des eingeschobenen Bretts
    color("red")
    for (z_pos = [_thickness + 20, _shelves_depth + _thickness - 20]) {
        if (_tilt_angle != 0) {
            rotate([0, 0, -_tilt_angle])
            translate([_shelves_edging / 2 + _thickness, z_pos, -1])
            cylinder(h=_thickness + 2, d=5, $fn=32);
        } else {
            translate([_shelves_edging / 2 + _thickness, z_pos, -1])
            cylinder(h=_thickness + 2, d=5, $fn=32);
        }
    }

}

// --- Teil 2: Dreieckiger Stützwinkel (45°) ---
// Das Dreieck wird als 2D-Polygon erzeugt und dann extrudiert.
// Es sitzt direkt über dem Klemm-Halter und lehnt sich von der
// Oberkante des Halters schräg nach oben zur Wand.
//
// Da Höhe = Breite des Dreiecks, ergibt sich automatisch 45°.
// Gesamtdicke des Stützwinkels in Extrusionsrichtung
_triangle_width = _shelves_edging + _thickness; // = 18 mm

// Innenmaß: Gesamtdicke minus 2× Wandstärke (je eine Wand vorne und hinten)
_triangle_inner = _triangle_width - _thickness * 2;

// Versatz des inneren Dreiecks: um _thickness eingerückt auf allen Seiten.
// Bei einem rechtwinkligen gleichschenkligen Dreieck (45°) beträgt der
// Inradius r = a / (2 + sqrt(2)). Der Einrück-Offset entlang der Katheten
// entspricht direkt _thickness; für die Hypotenuse ergibt sich durch die
// Geometrie derselbe senkrechte Abstand.
_tri_h = (_shelves_depth + _thickness * 2) - (_shelves_thickness + _thickness * 2);
_tri_base = _shelves_depth + _thickness * 2;

// Offset entlang der Katheten (senkrecht zur jeweiligen Achse) = _thickness.
// Für die Hypotenuse (45°) muss der Offset entlang beider Achsen
// _thickness * sqrt(2) betragen, damit der senkrechte Abstand zur
// Hypotenuse ebenfalls _thickness ergibt.
_tri_offset_k = _thickness;                  // Offset entlang Katheten
_tri_offset_h = _thickness * sqrt(2);        // Offset entlang der Hypotenuse-Richtung

_bwco   = _bracket_wall_cutout_offset;           // Kurzname für Katheten-Offset
_bwco_h = _bracket_wall_cutout_offset * sqrt(2); // Offset entlang der Hypotenuse


union() {



    difference() {
        
        translate([_shelves_edging + _thickness,
                _shelves_depth + _thickness * 2,
                _shelves_thickness + _thickness])  // Dreieck an die Oberkante des Halters setzen
        rotate([90, 0, 270])   // Dreieck von der XY-Ebene in die richtige Ausrichtung drehen
        
        difference() {
            // Außenkörper: volles Dreieck, extrudiert auf Gesamtdicke
            linear_extrude(height = _triangle_width)
            polygon([
                [0, 0],
                [0, _tri_h],
                [_tri_base, 0]
            ]);

            // Innenausschnitt: korrekt eingerücktes Dreieck.
            // - Katheten-Ecken: um _tri_offset_k eingerückt (senkrecht zur Achse)
            // - Hypotenuse-Ecke: um _tri_offset_h eingerückt (damit senkrechter
            //   Abstand zur Hypotenuse = _thickness)
            // Startet bei Z = -1 (linke Seite offen), endet bei _triangle_width - _thickness,
            // sodass die rechte Wand (Außenseite, vom Halter abgewandt) mit _thickness stehen bleibt.
            translate([0, 0, -1])
            linear_extrude(height = _triangle_width - _tri_offset_k + 1)
            polygon([
                [_tri_offset_k, _tri_offset_k],                              // Katheten-Ecke
                [_tri_offset_k, _tri_h - _tri_offset_h - _tri_offset_k],    // Y-Kathete eingerückt
                [_tri_base - _tri_offset_h - _tri_offset_k, _tri_offset_k]  // X-Kathete eingerückt
            ]);

            // Wandausschnitt: Dreieck um _bracket_wall_cutout_offset verkleinert.
            // Katheten-Offset = _bracket_wall_cutout_offset, Hypotenuse-Offset = * sqrt(2).
            translate([0, 0, -1])
            linear_extrude(height = _triangle_width + 2)
            polygon([
                [_bwco,              _bwco],
                [_bwco,              _tri_h - _bwco_h - _bwco],
                [_tri_base - _bwco_h - _bwco, _bwco]
            ]);

        
        }

    // Schlüssellöcher durch Rückwand und Verstärkung
        color("red")
        for (z_pos = [(_shelves_thickness + _thickness) + _keyhole_head_d / 2 + 10, _shelves_depth - _keyhole_length - _keyhole_head_d - 10]) {
            translate([(_shelves_edging + _thickness) / 2,
                    _shelves_depth + _thickness,  // Außenseite der Rückwand
                    z_pos])
            keyhole(_keyhole_shaft_d, _keyhole_head_d, _keyhole_length, 
                    _thickness + _reinforcement_depth);
        }
    }
}