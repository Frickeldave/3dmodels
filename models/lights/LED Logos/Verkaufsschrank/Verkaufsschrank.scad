$fn = 100;

// ── Globale Parameter ────────────────────────────────────────
_height             = 200;
_width              = 700;
_depth              = 200;
_thickness          = 4;
_diffusor_thickness = 2;

// ── Kanten-Parameter ────────────────────────────────────────
_ledge_width  = 6;    // Auflagefläche (wie weit die Kante ins Innere ragt)
_ledge_height = 8;    // Höhe der Kante
_bevel_angle  = 60;   // Schrägungswinkel in Grad (nach innen-unten abfallend)


// ── Modul: Lightbox ─────────────────────────────────────────
module lightbox(_h, _w, _d, _t) {
    difference() {
        hull() {
            translate([_h / 2, 0, 0])
                cylinder(h = _d, d = _h);
            translate([_w - _h / 2, 0, 0])
                cylinder(h = _d, d = _h);
        }
        color("red")
        hull() {
            translate([_h / 2, 0, _t])
                cylinder(h = _d, d = _h - _t);
            translate([_w - _h / 2, 0, _t])
                cylinder(h = _d, d = _h - _t);
        }
    }
}


// ── Modul: Abgeschrägte Innenkante ──────────────────────────
// Positionierung erfolgt außen per translate()
// _h  : Höhe / Durchmesser der Lightbox
// _w  : Breite der Lightbox
// _t  : Wandstärke
// _lw : Breite der Kante (Auflagefläche)
// _lh : Höhe der Kante
// _ba : Schrägungswinkel in Grad
module inner_ledge(_h, _w, _t, _lw, _lh, _ba) {
    _boff = tan(_ba) * _lh;

    difference() {
        // Außenkontur: oben (d2) bündig mit Innenwand, unten (d1) um _boff zurückgesetzt
        hull() {
            translate([_h / 2, 0, 0])
                cylinder(h = _lh, d1 = _h - _t - _boff, d2 = _h - _t);
            translate([_w - _h / 2, 0, 0])
                cylinder(h = _lh, d1 = _h - _t - _boff, d2 = _h - _t);
        }
        // Innenaussparung: erzeugt die Ringbreite _lw
        hull() {
            translate([_h / 2, 0, -1])
                cylinder(h = _lh + 2, d1 = _h - _t - _lw * 2 - _boff, d2 = _h - _t - _lw * 2);
            translate([_w - _h / 2, 0, -1])
                cylinder(h = _lh + 2, d1 = _h - _t - _lw * 2 - _boff, d2 = _h - _t - _lw * 2);
        }
    }
}


// ── Ausgabe ──────────────────────────────────────────────────
lightbox(_height, _width, _depth, _thickness);

color("blue")
translate([0, 0, _depth - _ledge_height])
inner_ledge(
    _h  = _height,
    _w  = _width,
    _t  = _thickness,
    _lw = _ledge_width,
    _lh = _ledge_height,
    _ba = _bevel_angle
);
