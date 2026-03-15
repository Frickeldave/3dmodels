use <./../../modules/scad/roundedcube.scad>

_box_width = 140;
_box_depth = 140;
_box_height = 35;
_thickness = 3;
_box_radius = 5;
// Anzahl Löcher pro Segment und Wand: -1 = automatisch (so viele wie möglich), 0 = keine, 1-n = genau diese Anzahl
// Untere Wand (y=0, entlang X):  _left = linkes Segment (kleine X), _right = rechtes Segment (große X)
_num_holes_bottom_left  = 1;
_num_holes_bottom_right = 2;
// Obere Wand (y=_d, entlang X):
_num_holes_top_left  = 1;
_num_holes_top_right = 1;
// Linke Wand (x=0, entlang Y):   _front = vorderes Segment (kleine Y), _back = hinteres Segment (große Y)
_num_holes_left_front = 1;
_num_holes_left_back  = 1;
// Rechte Wand (x=_w, entlang Y):
_num_holes_right_front = 1;
_num_holes_right_back  = 1;
_hole_diameter = 16;  // Durchmesser der Kabeldurchführungs-Löcher in mm
_hole_distance = 5;   // Mindestabstand zwischen zwei Löchern in mm

// ---------------------------------------------------------------------------
// Parameter für die 4 verstärkten Montagelöcher im Boden (Z-Richtung)
// ---------------------------------------------------------------------------
_floor_hole_diameter         = 5;   // Innendurchmesser des Lochs (z.B. 5 für M4-Schraube)
_floor_hole_reinforce_diam   = 12;  // Außendurchmesser des Verstärkungsrings
_floor_hole_reinforce_height = 2;   // Höhe des Verstärkungsrings über dem Boden (nach innen)
_floor_hole_offset           = 25;  // Abstand der Loch-Mittelpunkte von den Ecken (X und Y)

// nut holder radius (used for collision check)
// Radius der Schmelzmuttern-Halter – wird für die Kollisionsprüfung genutzt
_nut_holder_r = 5;

// Gesperrte Positionen entlang X (für untere/obere Wand): Ecken und Mitte
_nut_x_positions = [7, _box_width / 2, _box_width - 7];
// Gesperrte Positionen entlang Y (für linke/rechte Wand): Ecken und Mitte
_nut_y_positions = [7, _box_depth / 2, _box_depth - 7];

// ---------------------------------------------------------------------------
// Hilfsfunktion: Summiert alle Elemente eines Vektors (rekursiv)
// ---------------------------------------------------------------------------
function _sum(v, i=0) = i >= len(v) ? 0 : v[i] + _sum(v, i + 1);

// ---------------------------------------------------------------------------
// Hilfsfunktion: Berechnet alle freien Segmente (gültige Bereiche für
// Loch-Mittelpunkte) entlang einer Wand.
//
// Die Wand ist in der Mitte durch Schmelzmuttern-Halter unterbrochen.
// Jeder Halter sperrt einen Bereich von ±clear_gap um seinen Mittelpunkt.
// Die freien Segmente sind die Lücken zwischen diesen Sperrzonen,
// begrenzt durch die Wandgrenzen [min_x, max_x].
//
// Voraussetzung: blocked muss aufsteigend sortiert sein.
// ---------------------------------------------------------------------------
function _free_segments(min_x, max_x, blocked, clear_gap) = [
    for (i = [-1 : len(blocked) - 1])
    let(
        // Linke Grenze: entweder Wandrand oder rechter Rand der vorherigen Sperrzone
        lo = (i == -1) ? min_x : blocked[i] + clear_gap,
        // Rechte Grenze: entweder Wandrand oder linker Rand der nächsten Sperrzone
        hi = (i == len(blocked) - 1) ? max_x : blocked[i + 1] - clear_gap
    )
    if (hi > lo) [lo, hi]  // Nur ausnehmen wenn tatsächlich Platz vorhanden
];

// ---------------------------------------------------------------------------
// Hilfsfunktion: Maximale Anzahl Löcher die in ein Segment passen.
// Berechnung: (Segmentbreite + Abstand) / (Durchmesser + Abstand)
// ---------------------------------------------------------------------------
function _max_holes_in_seg(seg, hole_diam, hole_dist) =
    max(0, floor((seg[1] - seg[0] + hole_dist) / (hole_diam + hole_dist)));

// ---------------------------------------------------------------------------
// Hilfsfunktion: Platziert n Löcher gleichmäßig zentriert in einem Segment.
// Gibt eine Liste der Loch-Mittelpunkte zurück.
// ---------------------------------------------------------------------------
function _place_in_seg(seg, n, hole_diam, hole_dist) =
    n <= 0 ? [] :
    let(
        step = hole_diam + hole_dist,
        total_span = n * hole_diam + (n - 1) * hole_dist,
        center = (seg[0] + seg[1]) / 2,
        start = center - total_span / 2 + hole_diam / 2
    )
    [for (i = [0 : n - 1]) start + i * step];

// ---------------------------------------------------------------------------
// Hauptfunktion: Berechnet die endgültigen Lochpositionen entlang einer Wand.
//
// Funktionsweise:
//   1. Die Wand wird in freie Segmente zwischen den Schmelzmuttern-Haltern
//      aufgeteilt (Sperrzonen = Halter-Mittelpunkt ± (Lochradius + Halterradius))
//   2. Jedes Segment wird unabhängig gesteuert und zentriert befüllt
//
// Parameter:
//   wall_len  – Länge der Wand
//   num_segs  – Liste mit gewünschter Lochanzahl je Segment, z.B. [2, 1]:
//                 -1  → automatisch, so viele wie in das Segment passen
//                  0  → keine Löcher in diesem Segment
//                 1-n → genau diese Anzahl; passt sie nicht, werden 0 Löcher
//                       gesetzt (Warnung erfolgt im aufrufenden Modul)
//   dist      – Mindestabstand zwischen zwei Löchern (_hole_distance)
//   hole_r    – Lochradius (_hole_diameter / 2)
//   blocked   – Liste der gesperrten Positionen (aufsteigend sortiert)
//   t         – Wandstärke (_thickness)
//
// Rückgabe: Flache Liste aller Loch-Mittelpunkte (leer = keine Löcher)
// ---------------------------------------------------------------------------
function calc_hole_positions(wall_len, num_segs, dist, hole_r, blocked, t) =
    let(
        min_x = t + hole_r,
        max_x = wall_len - t - hole_r,
        hole_diam = hole_r * 2,
        // Mindestabstand Lochmittelpunkt zu Halter-Mittelpunkt (Kante-zu-Kante = 0)
        clear_gap = hole_r + _nut_holder_r,
        segs = _free_segments(min_x, max_x, blocked, clear_gap)
    )
    len(segs) == 0 ? [] :
    [for (i = [0 : len(segs) - 1])
        let(
            num   = (i < len(num_segs)) ? num_segs[i] : 0,
            max_n = _max_holes_in_seg(segs[i], hole_diam, dist),
            // Bei num > max_n ist Platzierung unmöglich → 0 Löcher (Warnung im Modul)
            n = (num == -1) ? max_n : ((num > max_n) ? 0 : num)
        )
        each _place_in_seg(segs[i], n, hole_diam, dist)
    ];

// Löcher in der unteren Wand (entlang X, bei y=0)
// num_left: Segment links (kleine X-Werte), num_right: Segment rechts (große X-Werte)
module wall_holes_bottom(_w, _d, _h, _t, num_left, num_right, dist, diam) {
    hole_r = diam / 2;
    positions = calc_hole_positions(_w, [num_left, num_right], dist, hole_r, _nut_x_positions, _t);
    // Warnung wenn eine feste Anzahl (> 0) nicht vollständig platziert werden konnte
    fixed = (num_left > 0 ? num_left : 0) + (num_right > 0 ? num_right : 0);
    if (fixed > 0 && len(positions) < fixed) {
        echo(str("INFO: Untere Wand – nicht alle Löcher platzierbar (gewünscht=", fixed, ", platziert=", len(positions), ", dist=", dist, ", diam=", diam, ")"));
    }
    for (p = positions) {
        translate([p, -1, _h / 2])
        rotate([-90, 0, 0])
        cylinder(h = _t + 2, d = diam);
    }
}

// Löcher in der oberen Wand (entlang X, bei y=_d)
// num_left: Segment links (kleine X-Werte), num_right: Segment rechts (große X-Werte)
module wall_holes_top(_w, _d, _h, _t, num_left, num_right, dist, diam) {
    hole_r = diam / 2;
    positions = calc_hole_positions(_w, [num_left, num_right], dist, hole_r, _nut_x_positions, _t);
    fixed = (num_left > 0 ? num_left : 0) + (num_right > 0 ? num_right : 0);
    if (fixed > 0 && len(positions) < fixed) {
        echo(str("INFO: Obere Wand – nicht alle Löcher platzierbar (gewünscht=", fixed, ", platziert=", len(positions), ", dist=", dist, ", diam=", diam, ")"));
    }
    for (p = positions) {
        translate([p, _d - _t - 1, _h / 2])
        rotate([-90, 0, 0])
        cylinder(h = _t + 2, d = diam);
    }
}

// Löcher in der linken Wand (entlang Y, bei x=0)
// num_front: Segment vorne (kleine Y-Werte, nahe untere Wand), num_back: Segment hinten (große Y-Werte)
module wall_holes_left(_w, _d, _h, _t, num_front, num_back, dist, diam) {
    hole_r = diam / 2;
    positions = calc_hole_positions(_d, [num_front, num_back], dist, hole_r, _nut_y_positions, _t);
    fixed = (num_front > 0 ? num_front : 0) + (num_back > 0 ? num_back : 0);
    if (fixed > 0 && len(positions) < fixed) {
        echo(str("INFO: Linke Wand – nicht alle Löcher platzierbar (gewünscht=", fixed, ", platziert=", len(positions), ", dist=", dist, ", diam=", diam, ")"));
    }
    for (p = positions) {
        translate([-1, p, _h / 2])
        rotate([0, 90, 0])
        cylinder(h = _t + 2, d = diam);
    }
}

// Löcher in der rechten Wand (entlang Y, bei x=_w)
// num_front: Segment vorne (kleine Y-Werte, nahe untere Wand), num_back: Segment hinten (große Y-Werte)
module wall_holes_right(_w, _d, _h, _t, num_front, num_back, dist, diam) {
    hole_r = diam / 2;
    positions = calc_hole_positions(_d, [num_front, num_back], dist, hole_r, _nut_y_positions, _t);
    fixed = (num_front > 0 ? num_front : 0) + (num_back > 0 ? num_back : 0);
    if (fixed > 0 && len(positions) < fixed) {
        echo(str("INFO: Rechte Wand – nicht alle Löcher platzierbar (gewünscht=", fixed, ", platziert=", len(positions), ", dist=", dist, ", diam=", diam, ")"));
    }
    for (p = positions) {
        translate([_w - _t - 1, p, _h / 2])
        rotate([0, 90, 0])
        cylinder(h = _t + 2, d = diam);
    }
}

module box_base(_w, _d, _h, _t, _r) {
    difference() {
        roundedcube(size = [_w, _d, _h], center = false, radius = _r, "z");
        translate([_t, _t, _t])
        roundedcube(size = [_w - _t * 2, _d - _t * 2, _h], center = false, radius = _r, "z");
    }
}

module lid_base(_w, _d, _h, _t, _r) {
    difference() {
        roundedcube(size = [_w + _t * 2, _d + _t * 2, _t * 2], center = false, radius = _r, "z");
        translate([_t + 0.1, _t + 0.1, _t])
        roundedcube(size = [_w + 0.2, _d + 0.2, _h], center = false, radius = _r, "z");
    }
}


module fusable_nuts_holder(_h) {
    difference() {
        cylinder(h = _h, r = 5);
        translate([0, 0, -1])
        cylinder(h = _h + 2, r = 2.5);
    }
}

// ---------------------------------------------------------------------------
// Verstärkter Montageloch-Einsatz im Boden.
//
// Besteht aus zwei Teilen:
//   1. boss()  – der Verstärkungsring, der aus dem Boden nach innen ragt
//                (wird in union() zur Box addiert)
//   2. cut()   – das Durchgangsloch durch Boden + Ring
//                (wird in difference() von der Box subtrahiert)
//
// Beide Module müssen an derselben [x, y]-Position aufgerufen werden.
// ---------------------------------------------------------------------------
module floor_hole_boss(_t, _reinforce_d, _reinforce_h) {
    // Verstärkungsring sitzt auf der Innenseite des Bodens
    translate([0, 0, _t])
    cylinder(h = _reinforce_h, d = _reinforce_d);
}

module floor_hole_cut(_t, _hole_d, _reinforce_h) {
    // Durchgangsloch durch Boden und Verstärkungsring (mit 1mm Überstand je Seite)
    translate([0, 0, -1])
    cylinder(h = _t + _reinforce_h + 2, d = _hole_d);
}

module box(_w, _d, _h, _t, _r) {
    difference() {

        union() {
            box_base(_w, _d, _h, _t, _r);

            color("pink") {
                // Fusable nuts holder in den 4 Ecken
                translate([7, 7, 0]) fusable_nuts_holder(_h); // ul
                translate([_w - 7, 7, 0]) fusable_nuts_holder(_h); // ur
                translate([_w - 7, _d - 7, 0]) fusable_nuts_holder(_h); // or
                translate([7, _box_depth - 7, 0]) fusable_nuts_holder(_box_height); // ol

                // Fusable nuts holder mittig an den 4 Seiten
                translate([_w / 2, 7, 0]) fusable_nuts_holder(_h); // u
                translate([_w - 7, _d / 2, 0]) fusable_nuts_holder(_h); // r
                translate([_w / 2, _d - 7, 0]) fusable_nuts_holder(_h); // o
                translate([7, _d / 2, 0]) fusable_nuts_holder(_h); // l
            }

            // Verstärkungsringe der 4 Bodenlöcher (nach innen ragend)
            color("lightblue") {
                translate([_floor_hole_offset,      _floor_hole_offset,      0]) floor_hole_boss(_t, _floor_hole_reinforce_diam, _floor_hole_reinforce_height); // vl
                translate([_w - _floor_hole_offset, _floor_hole_offset,      0]) floor_hole_boss(_t, _floor_hole_reinforce_diam, _floor_hole_reinforce_height); // vr
                translate([_w - _floor_hole_offset, _d - _floor_hole_offset, 0]) floor_hole_boss(_t, _floor_hole_reinforce_diam, _floor_hole_reinforce_height); // hr
                translate([_floor_hole_offset,      _d - _floor_hole_offset, 0]) floor_hole_boss(_t, _floor_hole_reinforce_diam, _floor_hole_reinforce_height); // hl
            }
        }



        // Holes in walls
        wall_holes_bottom(_w, _d, _h, _t, _num_holes_bottom_left,  _num_holes_bottom_right, _hole_distance, _hole_diameter);
        wall_holes_top   (_w, _d, _h, _t, _num_holes_top_left,     _num_holes_top_right,    _hole_distance, _hole_diameter);
        wall_holes_left  (_w, _d, _h, _t, _num_holes_left_front,   _num_holes_left_back,    _hole_distance, _hole_diameter);
        wall_holes_right (_w, _d, _h, _t, _num_holes_right_front,  _num_holes_right_back,   _hole_distance, _hole_diameter);

        // Durchgangslöcher der 4 verstärkten Bodenlöcher
        translate([_floor_hole_offset,      _floor_hole_offset,      0]) floor_hole_cut(_t, _floor_hole_diameter, _floor_hole_reinforce_height); // vl
        translate([_w - _floor_hole_offset, _floor_hole_offset,      0]) floor_hole_cut(_t, _floor_hole_diameter, _floor_hole_reinforce_height); // vr
        translate([_w - _floor_hole_offset, _d - _floor_hole_offset, 0]) floor_hole_cut(_t, _floor_hole_diameter, _floor_hole_reinforce_height); // hr
        translate([_floor_hole_offset,      _d - _floor_hole_offset, 0]) floor_hole_cut(_t, _floor_hole_diameter, _floor_hole_reinforce_height); // hl
    }
}

module lid(_w, _d, _h, _t, _r) {

    difference() {
        lid_base(_w, _d, _h, _t, _r);

        // Srew holes in corners
        color("Red")
        translate([_thickness + 7, _thickness + 7, -10]) cylinder(h = _t + 20, r = 2.5); // ul
        translate([_w - 7 + _thickness, _thickness + 7, -10]) cylinder(h = _t + 20, r = 2.5); // ur
        translate([_w - 7 + _thickness, _d - 7 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // or
        translate([7 + _thickness, _box_depth - 7 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // ol

        // Screw holes at the sides
        translate([_w / 2 + _thickness, 7 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // u
        translate([_w - 7 + _thickness, _d / 2 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // r
        translate([_w / 2 + _thickness, _d - 7 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // o
        translate([7 + _thickness, _d / 2 + _thickness, -10]) cylinder(h = _t + 20, r = 2.5); // l

    }
}


// translate([_box_width +_thickness, - _thickness, 180])
// rotate([0, 180, 0])
// lid(_box_width, _box_depth, _box_height, _thickness, _box_radius);
box(_box_width, _box_depth, _box_height, _thickness, _box_radius);


