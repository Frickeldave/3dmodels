// Mauerdurchfuehrung fuer Lasergehäuse (z.B. Kabel, Schlaeuche).
// Besteht aus zwei ineinandergesteckten Teilen: Innenteil und Aussenteil.
//   - Innenteil (wall_bushing_inner): traegt die Anschlussplatte (connector_plate) und den
//     schmalen Steckkragen; wird von der Innenseite der Mauer eingesetzt.
//   - Aussenteil (wall_bushing_outer): bildet die Aufnahme-Buchse fuer den Steckkragen
//     und traegt ebenfalls eine identische Anschlussplatte (connector_plate);
//     wird von der Aussenseite der Mauer eingesetzt.
// Beide Teile werden von gegenueberliegenden Seiten durch die Mauer gesteckt und
// ineinandergeschoben, sodass sie zusammen exakt die Wandstaerke (wall_thickness) ueberbruecken.

// Renderqualitaet (Anzahl Segmente fuer Kreise)
$fn = 100;

// Kleiner Epsilon-Wert zur Vermeidung von koplanaren Boolean-Artefakten
eps = 0.01;

// --- Parameter ---

// Gesamte Wandstaerke, die die Mauerdurchfuehrung ueberbruecken muss (beide Teile zusammen)
wall_thickness = 370;

// Durchmesser der Wandoeffnung (Loch in der Mauer)
wall_opening_diameter = 150;

// Innerer Lichtdurchmesser der Mauerdurchfuehrung (Kabel-/Schlauchkanal)
wall_bushing_inner_diameter = 100;

// Radiale Wandstaerke jedes Rohres
wall_bushing_thickness = 8;

// Axiale Laenge des Steckbereichs, in dem Innen- und Aussenteil ineinandergreifen
wall_bushing_overlap = 60;

// Effektive Stecktiefe fuer die Laengenberechnung
wall_bushing_socket_depth = wall_bushing_overlap;

// Radiales Spiel zwischen Innen- und Aussenteil im Steckbereich (Passungstoleranz)
wall_bushing_overlap_offset = 0.1;

// Axiale Laenge jedes Teils, sodass bei vollstaendig ineinandergesteckten Teilen
// die Gesamtlaenge exakt wall_thickness ergibt:
// (part_length * 2) - wall_bushing_socket_depth = wall_thickness
wall_bushing_part_length = (wall_thickness + wall_bushing_socket_depth) / 2;

connector_plate_size = 300; // Kantenlaenge der quadratischen Anschlussplatte am Innenteil
connector_plate_thickness = 5; // Staerke der Anschlussplatte
connector_plate_chamfer = 2; // Fasengroesse an der Oberseite der Anschlussplatte

// Umlaufende Nut auf der Unterseite der Anschlussplatte
connector_plate_groove_width = 4; // Nutbreite
connector_plate_groove_depth = 2; // Nuttiefe (in die Platte hinein)
connector_plate_groove_inset = 14; // Abstand von der Plattenaußenkante zur äußeren Nutkante
connector_plate_groove_corner_radius = 20; // Eckradius des Nutpfads
connector_plate_inner_groove = true;  // Nut in der Platte des Innenteils einbauen
connector_plate_outer_groove = false;  // Nut in der Platte des Aussenteils einbauen

// Schraubenlocher in den Anschlussplatten
connector_plate_screw_diameter         = 5;    // Durchmesser der Schraubenlocher
connector_plate_screw_groove_clearance = 10;   // Mindestabstand von der Lochmitte zur naechsten Nutwand
                                               // (Locher werden automatisch auf die Nutmitte gesetzt)
connector_plate_inner_screws           = true; // Schraubenlocher in der Platte des Innenteils einbauen
connector_plate_outer_screws           = false; // Schraubenlocher in der Platte des Aussenteils einbauen

// Magnete in den Anschlussplatten (eingelassen in die Oberseite, um die Oeffnung herum)
connector_plate_inner_magnets          = true;  // Magnete in der Platte des Innenteils einlassen
connector_plate_outer_magnets          = true;  // Magnete in der Platte des Aussenteils einlassen
connector_plate_magnet_diameter        = 20.2;    // Durchmesser der Magnete
connector_plate_magnet_thickness       = 3;     // Dicke der Magnete (Tiefe der Ausnehmung)
connector_plate_magnet_count           = 8;     // Anzahl der Magnete
connector_plate_magnet_circle_diameter = 130;  // Durchmesser des Kreises, auf dem die Magnete angeordnet sind

// Schaum-Bohrungen in den Anschlussplatten (zum Einspritzen von Brunnenschaum)
connector_plate_foam_hole                   = true; // Schaum-Bohrungen global aktivieren/deaktivieren
connector_plate_foam_hole_diameter          = 10;    // Durchmesser der Bohrungen
connector_plate_foam_hole_count             = 4;    // Anzahl der Bohrungen
connector_plate_foam_holes_in_magnets       = false; // Bohrungen auf die innere Seite der Magnetloecher legen
connector_plate_foam_hole_circle_diameter   = 115;  // Bohrkreis-Durchmesser (ignoriert, wenn _in_magnets=true)

// Benennungskonvention fuer die Anschlussplatten (gilt fuer dieses Projekt und alle weiteren Chats):
// - Oberseite: die gefaste Seite der Anschlussplatte (zeigt von der Mauer weg).
// - Unterseite: die gegenueberliegende, nicht gefaste Seite (Rohr-Ansatzflaeche, zeigt zur Mauer).
// Beide Teile (Innenteil und Aussenteil) tragen je eine identische Anschlussplatte.

// Zentrierring (unabhaengiges Teil)
// Liegt um das Aussenrohr und zentriert es gleichmaessig in der Wandbohrung.
centering_ring_height           = 5;    // Hoehe (axiale Laenge) des Zentrierrings
centering_ring_inner_clearance  = 0.2;  // Radiales Spiel zwischen Ringinnenseite und Rohraussen
centering_ring_outer_clearance  = 0.2;  // Radiales Spiel between Ringaussenseite und Wandbohrung
centering_ring_chamfer          = 1.5;  // Fase an beiden Stirnkanten des Rings (Einfuehrhilfe)
centering_ring_notch_count      = 8;    // Anzahl der elliptischen Ausschnitte ("Bluetenblaetter")
centering_ring_notch_width      = 50;   // Tangentiale Breite jedes Ausschnitts an der Aussenkante
centering_ring_notch_depth      = 12;   // Radiale Tiefe des Ausschnitts (wie weit er in den Ring hineinschneidet)

// Anschlussstutzen mit Magnetrings (unabhaengiges Teil)
// Kreisring mit Magnetausnehmungen auf einer Seite, Gegenseite mit hohlem Anschlussstutzen.
// Die Bohrungen im Ring und Stutzen sind gleich gross fuer durchgaengigen Luftstrom.
exhaust_hose_connector_ring_height          = 5;    // Hoehe des Ringkörpers
exhaust_hose_connector_outer_diameter       = 150;  // Mittlerer Aussendurchmesser des Rings

// Wellige Aussenkante des Rings (an Magnetpositionen nach aussen gewölbt, dazwischen eingezogen)
exhaust_hose_connector_wave_depth           = 10;    // Maximale radiale Auswölbung an den Magnetpositionen
exhaust_hose_connector_wave_count           = 8;    // Anzahl der Wellen (entspricht Magnetanzahl)

// Magnetloecher auf der Oberseite (negative Z-Seite)
exhaust_hose_connector_magnet_count        = 8;     // Anzahl der Magnete
exhaust_hose_connector_magnet_diameter     = 20.1;    // Durchmesser der Magnete
exhaust_hose_connector_magnet_thickness    = 3;     // Tiefe der Ausnehmung
exhaust_hose_connector_magnet_circle_diameter = 130; // Durchmesser des Kreises fuer die Magnete

// Anschlussstutzen auf der der Magnetgegensetzten Seite (positive Z-Seite), hohler Zylinder
// Der Stutzen und die Ringbohrung haben identischen Durchmesser fuer durchgaengigen Luftstrom.
exhaust_hose_connector_dia         = 90;    // Durchmesser des Stutzens UND der Ringbohrung
exhaust_hose_connector_thickness   = 4;     // Wandstaerke des Stutzens
exhaust_hose_connector_stub_height = 60;    // Axiale Hoehe des Stutzens (ueber den Ring hinaus)

// 90-Grad-Bogen-Variante: Parameter fuer den Rohrbogen
exhaust_hose_connector_bend_radius = 80;    // Biegeradius (Mitte des Rohrquerschnitts zur Bogenachse)
exhaust_hose_connector_bend_entry  = 0;    // Laenge des geraden Abschnitts VOR dem Bogen (Einlauf)
exhaust_hose_connector_bend_straight = 60;  // Laenge des geraden Abschnitts nach dem Bogen (Auslauf)

// --- Module ---

// Zentrierring: liegt um das Aussenrohr und zentriert es in der Wandbohrung.
// Innenradius = Aussenradius des Rohres + centering_ring_inner_clearance
// Aussenradius = Radius der Wandbohrung - centering_ring_outer_clearance
// An beiden Stirnkanten ist eine Einfuehrfase angebracht.
// Runde Ausschnitte ("Bluetenblaetter") durchdringen die Ringwand radial, damit
// Brunnenschaum durch den Ring hindurchquellen kann.
module centering_ring() {
    inner_r = (wall_bushing_inner_diameter + wall_bushing_thickness * 2) / 2
              + centering_ring_inner_clearance;
    outer_r = wall_opening_diameter / 2
              - centering_ring_outer_clearance;

    assert(outer_r > inner_r,
        "Zentrierring: Aussenradius muss groesser als Innenradius sein (Wandbohrung zu klein oder Rohr zu gross)");
    assert(centering_ring_chamfer >= 0, "centering_ring_chamfer darf nicht negativ sein");
    assert(centering_ring_chamfer < centering_ring_height / 2,
        "centering_ring_chamfer ist zu gross fuer centering_ring_height");
    assert(centering_ring_chamfer < (outer_r - inner_r),
        "centering_ring_chamfer ist zu gross fuer die Wandstaerke des Rings");
    assert(centering_ring_notch_count >= 0, "centering_ring_notch_count darf nicht negativ sein");
    assert(centering_ring_notch_width >= 0, "centering_ring_notch_width darf nicht negativ sein");
    assert(centering_ring_notch_depth >= 0, "centering_ring_notch_depth darf nicht negativ sein");
    assert(centering_ring_notch_depth <= (outer_r - inner_r),
        "centering_ring_notch_depth ist groesser als die Ringwandstaerke — der Ring wuerde durchgeschnitten");

    difference() {
        // Ring mit Fase an beiden Stirnkanten (rotate_extrude eines Trapez-Profils)
        rotate_extrude()
        polygon(points = [
            // Innenkontur (unten nach oben)
            [inner_r,                             0],
            [inner_r + centering_ring_chamfer,    0],
            [inner_r,                             centering_ring_chamfer],
            [inner_r,                             centering_ring_height - centering_ring_chamfer],
            [inner_r + centering_ring_chamfer,    centering_ring_height],
            // Aussenkontur (oben nach unten)
            [outer_r - centering_ring_chamfer,    centering_ring_height],
            [outer_r,                             centering_ring_height - centering_ring_chamfer],
            [outer_r,                             centering_ring_chamfer],
            [outer_r - centering_ring_chamfer,    0],
        ]);

        // Elliptische Ausschnitte gleichmaessig um die Aussenkante des Rings verteilt ("Bluetenblaetter").
        // Jeder Ausschnitt ist eine Ellipse, deren Mittelpunkt auf dem Aussenradius liegt:
        //   - Tangentiale Halbachse = centering_ring_notch_width / 2  (Breite des Blatts)
        //   - Radiale Halbachse     = centering_ring_notch_depth       (Tiefe in den Ring)
        // Da der Mittelpunkt auf outer_r liegt, schneidet die Ellipse centering_ring_notch_depth
        // in den Ring hinein und ragt centering_ring_notch_depth nach aussen (dort ist Luft).
        if (centering_ring_notch_count > 0 && centering_ring_notch_width > 0 && centering_ring_notch_depth > 0)
            for (i = [0 : centering_ring_notch_count - 1])
                rotate([0, 0, i * 360 / centering_ring_notch_count])
                translate([outer_r, 0, -eps])
                scale([centering_ring_notch_depth, centering_ring_notch_width / 2, 1])
                cylinder(h=centering_ring_height + 2 * eps, r=1);
    }
}

// Hilfsfunktion: zentriertes abgerundetes Quadrat (2D).
module rounded_square_2d(side_length, corner_radius) {
    assert(corner_radius >= 0, "corner_radius darf nicht negativ sein");
    assert(corner_radius * 2 < side_length, "corner_radius ist zu gross fuer side_length");

    offset(r=corner_radius)
    square([side_length - 2 * corner_radius, side_length - 2 * corner_radius], center=true);
}

// Quadratische Anschlussplatte (wird an Innen- UND Aussenteil verwendet).
// Wichtige Benennungsregel: "Oberseite" ist die gefaste Seite (zeigt von der Mauer weg).
// "Unterseite" ist die gegenueberliegende, nicht gefaste Seite an der Rohr-Ansatzflaeche.
// Geometrisch erstreckt sich die Platte in negativer Z-Richtung ab der Rohr-Ansatzflaeche.
// Beim Aussenteil wird sie per mirror() gespiegelt, sodass die Oberseite nach aussen zeigt.
// Parameter with_screws:  true = 4 Schraubenlocher symmetrisch einbauen, false = keine Locher.
// Parameter with_groove:  true = umlaufende Nut auf der Unterseite einbauen, false = keine Nut.
// Parameter with_magnets: true = Magnet-Ausnehmungen auf der Oberseite einlassen, false = keine Magnete.
module connector_plate(with_screws = false, with_groove = false, with_magnets = false) {
    groove_inset = connector_plate_groove_inset;
    groove_outer_side = connector_plate_size - 2 * groove_inset;
    groove_inner_side = groove_outer_side - 2 * connector_plate_groove_width;

    assert(connector_plate_chamfer >= 0, "connector_plate_chamfer darf nicht negativ sein");
    assert(connector_plate_chamfer <= connector_plate_thickness, "connector_plate_chamfer darf nicht groesser als connector_plate_thickness sein");
    assert(connector_plate_chamfer * 2 < connector_plate_size, "connector_plate_chamfer ist zu gross fuer connector_plate_size");

    assert(connector_plate_groove_width >= 0, "connector_plate_groove_width darf nicht negativ sein");
    assert(connector_plate_groove_depth >= 0, "connector_plate_groove_depth darf nicht negativ sein");
    assert(connector_plate_groove_inset >= 0, "connector_plate_groove_inset darf nicht negativ sein");
    assert(connector_plate_groove_depth <= connector_plate_thickness, "connector_plate_groove_depth darf nicht groesser als connector_plate_thickness sein");
    if (with_groove) {
        assert(connector_plate_groove_corner_radius >= connector_plate_groove_width, "connector_plate_groove_corner_radius muss mindestens connector_plate_groove_width betragen");
        assert(groove_outer_side > 0, "connector_plate_groove_inset ist zu gross fuer connector_plate_size");
        assert(groove_inner_side > 0, "connector_plate_groove_width ist zu gross fuer connector_plate_size");
        assert(connector_plate_groove_corner_radius * 2 < groove_outer_side, "connector_plate_groove_corner_radius ist zu gross fuer die aeussere Nutgroesse");
    }

    difference() {
        if (connector_plate_chamfer == 0) {
            translate([-connector_plate_size / 2, -connector_plate_size / 2, -connector_plate_thickness])
            cube([connector_plate_size, connector_plate_size, connector_plate_thickness]);
        } else {
            union() {
                // Gerader oberer Abschnitt der Platte
                translate([-connector_plate_size / 2, -connector_plate_size / 2, -connector_plate_thickness + connector_plate_chamfer])
                cube([connector_plate_size, connector_plate_size, connector_plate_thickness - connector_plate_chamfer]);

                // Gefaster Abschnitt auf der definierten Oberseite (weitet sich zur z=0-Ebene auf volle Plattengroesse auf)
                translate([0, 0, -connector_plate_thickness])
                linear_extrude(height=connector_plate_chamfer, scale=connector_plate_size / (connector_plate_size - 2 * connector_plate_chamfer))
                square([connector_plate_size - 2 * connector_plate_chamfer, connector_plate_size - 2 * connector_plate_chamfer], center=true);
            }
        }

        // Umlaufende Nut auf der definierten Unterseite (bei z=0).
        // Die Nut ist um groove_inset von der Plattenaußenkante eingerueckt und hat abgerundete Ecken.
        if (with_groove && connector_plate_groove_depth > 0 && connector_plate_groove_width > 0) {
            translate([0, 0, -connector_plate_groove_depth])
            linear_extrude(height=connector_plate_groove_depth + eps)
            difference() {
                rounded_square_2d(groove_outer_side, connector_plate_groove_corner_radius);
                rounded_square_2d(groove_inner_side, connector_plate_groove_corner_radius - connector_plate_groove_width);
            }
        }

        // 4 Schraubenlocher symmetrisch in den Ecken der Platte (optional).
        // Die Lochmitten liegen INNERHALB der von der Nut umschlossenen Flaeche,
        // mit einem Mindestabstand connector_plate_screw_groove_clearance zur inneren Nutkante.
        // Position: Plattenhalbe - Randabstand - Nutbreite - Mindestabstand - Lochradius
        if (with_screws && connector_plate_screw_diameter > 0) {
            screw_offset = connector_plate_size / 2
                           - groove_inset
                           - connector_plate_groove_width
                           - connector_plate_screw_groove_clearance
                           - connector_plate_screw_diameter / 2;
            assert(screw_offset > 0,
                "Schraubenlocher passen nicht in die Platte: Nut zu weit innen oder Mindestabstand zu gross");
            for (sx = [-screw_offset, screw_offset])
            for (sy = [-screw_offset, screw_offset])
                translate([sx, sy, -connector_plate_thickness - eps])
                cylinder(h=connector_plate_thickness + 2 * eps, d=connector_plate_screw_diameter);
        }

        // Magnet-Ausnehmungen auf der Oberseite (gefaste Seite), gleichmaessig auf einem Kreis verteilt.
        // Die Ausnehmungen gehen von der Oberseite (z=-connector_plate_thickness) nach innen.
        if (with_magnets && connector_plate_magnet_count > 0 && connector_plate_magnet_diameter > 0) {
            assert(connector_plate_magnet_thickness <= connector_plate_thickness,
                "connector_plate_magnet_thickness darf nicht groesser als connector_plate_thickness sein");
            assert(connector_plate_magnet_circle_diameter / 2 + connector_plate_magnet_diameter / 2
                   <= connector_plate_size / 2,
                "Magnete liegen ausserhalb der Platte");
            assert(connector_plate_magnet_circle_diameter / 2 - connector_plate_magnet_diameter / 2
                   >= wall_bushing_inner_diameter / 2,
                "Magnete ueberschneiden sich mit der Zentralbohrung");
            for (i = [0 : connector_plate_magnet_count - 1])
                rotate([0, 0, i * 360 / connector_plate_magnet_count])
                translate([connector_plate_magnet_circle_diameter / 2, 0, -connector_plate_thickness - eps])
                cylinder(h=connector_plate_magnet_thickness + eps, d=connector_plate_magnet_diameter);
        }

        // Schaum-Bohrungen (durchgehend durch die Platte).
        // Option A: Position auf frei waehlbarem Bohrkreis.
        // Option B: Position auf der innenliegenden Seite der Magnetloecher (Richtung Rohr),
        //           damit die Bohrungen nach Montage mit Magneten ueberdeckt werden.
        if (connector_plate_foam_hole && connector_plate_foam_hole_count > 0 && connector_plate_foam_hole_diameter > 0) {
            if (connector_plate_foam_holes_in_magnets) {
                assert(with_magnets && connector_plate_magnet_count > 0,
                    "connector_plate_foam_holes_in_magnets=true erfordert aktivierte Magnete");
                assert(connector_plate_foam_hole_diameter <= connector_plate_magnet_diameter,
                    "Schaum-Bohrung ist groesser als Magnetloch");
                assert(connector_plate_foam_hole_count <= connector_plate_magnet_count,
                    "Anzahl Schaum-Bohrungen darf nicht groesser als Anzahl Magnete sein");

                // Bohrungsmitte innen im Magnetloch (tangential zur inneren Magnetkante)
                foam_hole_r = connector_plate_magnet_circle_diameter / 2
                              - connector_plate_magnet_diameter / 2
                              + connector_plate_foam_hole_diameter / 2;

                assert(foam_hole_r - connector_plate_foam_hole_diameter / 2 >= wall_bushing_inner_diameter / 2,
                    "Schaum-Bohrungen ueberschneiden sich mit der Zentralbohrung");

                // Gleichmaessig ueber alle Magnetpositionen verteilen (z.B. 8 Magnete / 4 Bohrungen -> jede 2. Position)
                magnet_step = connector_plate_magnet_count / connector_plate_foam_hole_count;
                for (i = [0 : connector_plate_foam_hole_count - 1])
                    rotate([0, 0, floor(i * magnet_step) * 360 / connector_plate_magnet_count])
                    translate([foam_hole_r, 0, -connector_plate_thickness - eps])
                    cylinder(h=connector_plate_thickness + 2 * eps, d=connector_plate_foam_hole_diameter);
            } else {
                foam_hole_r = connector_plate_foam_hole_circle_diameter / 2;
                assert(foam_hole_r + connector_plate_foam_hole_diameter / 2 <= connector_plate_size / 2,
                    "Schaum-Bohrungen liegen ausserhalb der Platte");
                assert(foam_hole_r - connector_plate_foam_hole_diameter / 2 >= wall_bushing_inner_diameter / 2,
                    "Schaum-Bohrungen ueberschneiden sich mit der Zentralbohrung");
                // Bei aktiven Magneten die Schaum-Bohrungen entlang der Kreislinie versetzen,
                // damit sie zwischen den Magnetpositionen liegen.
                foam_hole_angle_offset = (with_magnets && connector_plate_magnet_count > 0)
                                         ? (180 / connector_plate_magnet_count)
                                         : 0;

                for (i = [0 : connector_plate_foam_hole_count - 1])
                    rotate([0, 0, i * 360 / connector_plate_foam_hole_count + foam_hole_angle_offset])
                    translate([foam_hole_r, 0, -connector_plate_thickness - eps])
                    cylinder(h=connector_plate_thickness + 2 * eps, d=connector_plate_foam_hole_diameter);
            }
        }
    }
}

// Innenteil der Mauerdurchfuehrung.
// Traegt einen schmalen Steckkragen, der in die Buchse des Aussenteils greift.
// Der breite Flansch liegt buerdig an der Innenseite der Mauer an.
module wall_bushing_inner() {
    difference() {
        union() {
            // Anschlussplatte (INNENTEIL): Oberseite ist gefast, Unterseite liegt an der Rohr-Ansatzflaeche.
            // Sitzt unterhalb des Rohres, damit die Rohrgeometrie unveraendert bleibt.
            connector_plate(connector_plate_inner_screws, connector_plate_inner_groove, connector_plate_inner_magnets);

            // Schmaler Steckkragen, der in das Aussenteil eingesteckt wird
            cylinder(h=wall_bushing_part_length, d=wall_bushing_inner_diameter + wall_bushing_thickness);
            // Breiter Flansch (liegt buerdig an der Mauerinnenseite an)
            cylinder(h=wall_bushing_part_length - wall_bushing_socket_depth, d=wall_bushing_inner_diameter + wall_bushing_thickness * 2);
        }

        // Zentralbohrung — der eigentliche Durchgangskanal der Mauerdurchfuehrung
        color("red")
        translate([0, 0, -connector_plate_thickness - eps])
        cylinder(h=connector_plate_thickness + wall_bushing_part_length + 2 * eps, d=wall_bushing_inner_diameter);
    }
}

// Aussenteil der Mauerdurchfuehrung.
// Bildet die Buchse, die den Steckkragen des Innenteils von der Gegenseite aufnimmt.
// Traegt am oberen Ende (Aussenseite der Mauer) eine identische Anschlussplatte wie das Innenteil.
// Die Platte ist gespiegelt montiert, sodass ihre Oberseite (Fase) von der Mauer weg zeigt.
module wall_bushing_outer() {
    difference() {
        union() {
            // Aussenkoerper
            cylinder(h=wall_bushing_part_length, d=wall_bushing_inner_diameter + wall_bushing_thickness * 2);

            // Anschlussplatte (AUSSENTEIL): identisch zum Innenteil, gespiegelt an der Oberkante des Rohres.
            // Oberseite (Fase) zeigt von der Mauer weg.
            translate([0, 0, wall_bushing_part_length])
            mirror([0, 0, 1])
            connector_plate(connector_plate_outer_screws, connector_plate_outer_groove, connector_plate_outer_magnets);
        }

        // Buchsenausnehmung fuer den Steckkragen des Innenteils (mit Passungstoleranz)
        color("pink")
        translate([0, 0, -eps])
        cylinder(h=wall_bushing_socket_depth + eps, d=wall_bushing_inner_diameter + wall_bushing_thickness + wall_bushing_overlap_offset);

        // Zentralbohrung — durchgehend durch Rohr und Anschlussplatte
        color("red")
        translate([0, 0, -eps])
        cylinder(h=wall_bushing_part_length + connector_plate_thickness + 2 * eps, d=wall_bushing_inner_diameter);
    }
}

// Anschlussstutzen mit Magnetrings
// Kreisring mit Magnetausnehmungen auf der negativen Z-Seite,
// und einem hohlen Zylinder-Anschlussstutzen auf der positiven Z-Seite.
module exhaust_hose_connector() {
    r = exhaust_hose_connector_dia / 2;
    outer_r = exhaust_hose_connector_outer_diameter / 2;
    stub_r = r + exhaust_hose_connector_thickness;
    half_ring_h = exhaust_hose_connector_ring_height / 2;

    assert(outer_r > r,
        "exhaust_hose_connector: Aussenradius muss groesser als Bohrungsradius sein");
    assert(stub_r <= outer_r,
        "exhaust_hose_connector: Anschlussstutzen ragt ausserhalb des Rings");
    assert(exhaust_hose_connector_dia > 0,
        "exhaust_hose_connector: Durchmesser muss groesser 0 sein");

    // Magnetparameter-Pruefung
    assert(exhaust_hose_connector_magnet_count > 0, "exhaust_hose_connector_magnet_count muss groesser 0 sein");
    assert(exhaust_hose_connector_magnet_diameter > 0, "exhaust_hose_connector_magnet_diameter muss groesser 0 sein");
    assert(exhaust_hose_connector_magnet_thickness <= exhaust_hose_connector_ring_height,
        "exhaust_hose_connector_magnet_thickness darf nicht groesser als Ringhoehe sein");
    assert(exhaust_hose_connector_magnet_circle_diameter / 2 + exhaust_hose_connector_magnet_diameter / 2
               <= outer_r + exhaust_hose_connector_wave_depth / 2,
        "Magnete liegen ausserhalb des Rings (auch mit Wellenauswoelbung)");
    assert(exhaust_hose_connector_magnet_circle_diameter / 2 - exhaust_hose_connector_magnet_diameter / 2 >= r,
        "Magnete ueberschneiden sich mit der Zentralbohrung");

    // Wellige Außenkontur: Außenradius variiert sinusförmig zwischen
    // (outer_r - wave_depth/2) und (outer_r + wave_depth/2).
    // Maxima liegen an Magnetpositionen, Minima dazwischen.
    wave_steps = exhaust_hose_connector_wave_count * 32; // Segmente fuer glatte Kurve
    wave_depth = exhaust_hose_connector_wave_depth;
    wave_count = exhaust_hose_connector_wave_count;

    // 2D-Profil des welligen Rings (XY-Ebene), wird dann linear_extrude'd.
    // Zwei separate paths verhindern den Schlitz, der bei einer einfachen
    // concat()-Punktliste zwischen letztem Aussen- und erstem Innenpunkt entsteht.
    module wavy_ring_2d() {
        pts_outer = [for (i = [0 : wave_steps - 1])
            let(
                angle = i * 360 / wave_steps,
                wave_r = outer_r + (wave_depth / 2) * cos(angle * wave_count)
            )
            [wave_r * cos(angle), wave_r * sin(angle)]
        ];
        pts_inner = [for (i = [0 : wave_steps - 1])
            let(angle = i * 360 / wave_steps)
            [r * cos(angle), r * sin(angle)]
        ];
        polygon(
            points = concat(pts_outer, pts_inner),
            paths  = [
                [for (i = [0 : wave_steps - 1]) i],
                [for (i = [0 : wave_steps - 1]) wave_steps + i]
            ]
        );
    }

    difference() {
        union() {
            // Ringkörper mit welliger Aussenkante
            linear_extrude(height=exhaust_hose_connector_ring_height)
            wavy_ring_2d();

            // Anschlussstutzen auf der positiven Z-Seite (demagnets abgewandte Seite)
            cylinder(h=exhaust_hose_connector_stub_height, d=stub_r * 2);
        }

        // Zentrale Bohrung durch den Ring (1mm tiefer zum Boden hin zur Vermeidung von OpenSCAD-Artefakten)
        translate([0, 0, -1])
        cylinder(h=exhaust_hose_connector_ring_height + 2 * eps + 1, d=exhaust_hose_connector_dia);

        // Magnetloecher auf der negativen Z-Seite
        for (i = [0 : exhaust_hose_connector_magnet_count - 1])
            rotate([0, 0, i * 360 / exhaust_hose_connector_magnet_count])
            translate([exhaust_hose_connector_magnet_circle_diameter / 2, 0, -eps])
            cylinder(h=exhaust_hose_connector_magnet_thickness + eps, d=exhaust_hose_connector_magnet_diameter);

        // Innendurchlass des Stutzens
        cylinder(h=exhaust_hose_connector_stub_height + exhaust_hose_connector_ring_height + 2 * eps, d=exhaust_hose_connector_dia);
    }
}

// Anschlussstutzen mit Magnetring und 90-Grad-Bogen.
// Identisch zu exhaust_hose_connector, aber anstelle des geraden Stutzens
// wird ein 90°-Rohrbogen angesetzt, der den Luftstrom um 90° umlenkt.
// Am Ende des Bogens folgt ein kurzer gerader Auslauf (exhaust_hose_connector_bend_straight).
// Der Bogen beginnt an der Oberkante des Ringkoerpers und biegt in positive X-Richtung ab.
module exhaust_hose_connector_90_degree() {
    r_inner = exhaust_hose_connector_dia / 2;
    r_outer = r_inner + exhaust_hose_connector_thickness;
    bend_r  = exhaust_hose_connector_bend_radius;
    ring_h  = exhaust_hose_connector_ring_height;
    entry_len    = exhaust_hose_connector_bend_entry;
    straight_len = exhaust_hose_connector_bend_straight;

    assert(bend_r > r_outer,
        "exhaust_hose_connector_bend_radius muss groesser als der Stutzen-Aussenradius sein");

    // Ringkoerper mit Magneten aus dem Basismodul wiederverwenden:
    // Wir bauen den Ring und die Magnete identisch zu exhaust_hose_connector,
    // aber ersetzen den geraden Stutzen durch den 90°-Bogen.

    outer_r = exhaust_hose_connector_outer_diameter / 2;
    stub_r  = r_outer;
    wave_steps = exhaust_hose_connector_wave_count * 32;
    wave_depth = exhaust_hose_connector_wave_depth;
    wave_count = exhaust_hose_connector_wave_count;

    // 2D-Profil des welligen Rings (identisch zum Basismodul)
    module wavy_ring_2d() {
        pts_outer = [for (i = [0 : wave_steps - 1])
            let(
                angle = i * 360 / wave_steps,
                wave_r = outer_r + (wave_depth / 2) * cos(angle * wave_count)
            )
            [wave_r * cos(angle), wave_r * sin(angle)]
        ];
        pts_inner = [for (i = [0 : wave_steps - 1])
            let(angle = i * 360 / wave_steps)
            [r_inner * cos(angle), r_inner * sin(angle)]
        ];
        polygon(
            points = concat(pts_outer, pts_inner),
            paths  = [
                [for (i = [0 : wave_steps - 1]) i],
                [for (i = [0 : wave_steps - 1]) wave_steps + i]
            ]
        );
    }

    // Geometrie des 90°-Bogens:
    // rotate_extrude(angle=90) dreht ein 2D-Profil um die Z-Achse.
    // Profil bei x=bend_r → Torusmittelpunkt auf Z-Achse, Rohrquerschnitt im Abstand bend_r.
    //
    // Rohes Ergebnis (vor Transformation):
    //   Bogenstart (Winkel  0°): Profilmitte bei ( bend_r,      0, 0), Tangente zeigt in +Y.
    //   Bogenende  (Winkel 90°): Profilmitte bei (      0,  bend_r, 0), Tangente zeigt in -X.
    //
    // Gewuenschtes Ergebnis:
    //   Bogenstart: Profilmitte bei (0, 0, ring_h), Tangente zeigt in +Z  → setzt an Ringoberkante an.
    //   Bogenende:  Profilmitte bei (0, 0, ring_h + bend_r), Tangente zeigt in -X (Ausgang seitlich).
    //   Bogen liegt in der YZ-Ebene, biegt von oben nach links (-X).
    //
    // Transformationskette (OpenSCAD liest von innen nach aussen):
    //   1. translate([bend_r, 0])            → Profil auf Abstand bend_r von Z-Achse.
    //   2. rotate_extrude(angle=90)          → Bogen in XY-Ebene (Start bei +X, Ende bei +Y).
    //   3. rotate([90, 0, 0])                → kippt XY→XZ: Start (bend_r,0,0)→(bend_r,0,0),
    //                                          Ende (0,bend_r,0)→(0,0,bend_r). Tangenten kippen mit.
    //                                          Start-Tangente: war +Y, wird +Z.  ✓
    //                                          Ende-Tangente:  war -X, bleibt -X. ✓
    //   4. translate([0, 0, ring_h])         → Bogenstart auf Z=ring_h (Ringoberkante).
    //      Start: (bend_r, 0, ring_h).  ← Noch nicht auf Z-Achse!
    //   5. translate([-bend_r, 0, 0])        → Verschiebt Start auf Z-Achse.
    //      Start: (0, 0, ring_h).  ✓
    //      Ende:  (-bend_r, 0, ring_h + bend_r). → Ausgang zeigt in -X. ✓
    //
    // Kurzform: translate([-bend_r, 0, ring_h+entry_len]) rotate([90,0,0]) rotate_extrude(angle=90) translate([bend_r,0]) ...
    //
    // Gerader Einlauf: auf Z-Achse von Z=ring_h bis Z=ring_h+entry_len.
    // Gerader Auslauf: bei (-bend_r, 0, ring_h+entry_len+bend_r), zeigt in -X.

    difference() {
        union() {
            // Ringkoerper mit welliger Aussenkante (identisch zum Basismodul)
            linear_extrude(height=ring_h)
            wavy_ring_2d();

            // Gerader Einlauf vor dem Bogen, auf der Z-Achse zentriert.
            // Verbindet Ringoberkante (Z=ring_h) mit dem Bogeneintritt (Z=ring_h+entry_len).
            if (entry_len > 0)
                translate([0, 0, ring_h])
                cylinder(h=entry_len, r=r_outer);

            // 90-Grad-Bogen (Torusabschnitt), setzt am Ende des Einlaufs an.
            // Eingang: zentriert auf Z-Achse bei Z=ring_h+entry_len, Rohr zeigt +Z.
            // Ausgang: bei (-bend_r, 0, ring_h+entry_len+bend_r), Rohr zeigt -X.
            translate([-bend_r, 0, ring_h + entry_len])
            rotate([90, 0, 0])
            rotate_extrude(angle=90)
            translate([bend_r, 0, 0])
            circle(r=r_outer);

            // Gerader Auslauf am Bogenende, zeigt in -X-Richtung.
            translate([-bend_r, 0, ring_h + entry_len + bend_r])
            rotate([0, -90, 0])
            cylinder(h=straight_len, r=r_outer);
        }

        // Magnetloecher auf der negativen Z-Seite (identisch zum Basismodul)
        for (i = [0 : exhaust_hose_connector_magnet_count - 1])
            rotate([0, 0, i * 360 / exhaust_hose_connector_magnet_count])
            translate([exhaust_hose_connector_magnet_circle_diameter / 2, 0, -eps])
            cylinder(h=exhaust_hose_connector_magnet_thickness + eps, d=exhaust_hose_connector_magnet_diameter);

        // Innenbohrung durch Ringkoerper und geraden Einlauf
        translate([0, 0, -1])
        cylinder(h=ring_h + entry_len + 1 + eps, r=r_inner);

        // Innenbohrung des 90°-Bogens (gleiche Transformation, nur r_inner)
        translate([-bend_r, 0, ring_h + entry_len])
        rotate([90, 0, 0])
        rotate_extrude(angle=90)
        translate([bend_r, 0, 0])
        circle(r=r_inner);

        // Innenbohrung des geraden Auslaufs
        translate([-bend_r, 0, ring_h + entry_len + bend_r])
        rotate([0, -90, 0])
        cylinder(h=straight_len + eps, r=r_inner);
    }
}

module exhaust_hose_connector_kg_adapter() {

    _parts_thickness = wall_bushing_thickness / 2;
    _parts_height = 40;
    _chamfer = 4; // Fasengroesse (radial und axial)

    difference() {
        union() {
            // Fase unten: Aussendurchmesser wächst von (dia - 2*chamfer) auf dia
            cylinder(d1 = exhaust_hose_connector_dia - 2 * _chamfer, d2 = exhaust_hose_connector_dia, h = _chamfer);
            translate([0, 0, _chamfer])
            cylinder(d = exhaust_hose_connector_dia, h = _parts_height - _chamfer);
            translate([0, 0, _parts_height])
            cylinder(d1 = exhaust_hose_connector_dia, d2 = 110, h = _parts_height);
            // Oberer Zylinder mit Fase oben: Aussendurchmesser läuft von 110 auf (110 - 2*chamfer)
            translate([0, 0, 2 * _parts_height])
            cylinder(d = 110, h = _parts_height - _chamfer);
            translate([0, 0, 3 * _parts_height - _chamfer])
            cylinder(d1 = 110, d2 = 110 - 2 * _chamfer, h = _chamfer);
        }
        union() {
            translate([0, 0, -1])
            cylinder(d = exhaust_hose_connector_dia - _parts_thickness * 2, h = _parts_height + 2);
            translate([0, 0, _parts_height - 1])
            cylinder(d1 = exhaust_hose_connector_dia - _parts_thickness * 2, d2 = 110 - _parts_thickness * 2, h = _parts_height + 2);
            translate([0, 0, 2 * _parts_height - 1])
            cylinder(d = 110 - _parts_thickness * 2, h = _parts_height + 2);
        }
    }
}

module wall_bushing_ring() {
    // Fasengroesse an der Aussenkante des aeusseren Rings
    ring_chamfer = 2; // radiale Breite der Fase (und axiale Hoehe = Ringhoehe = 2)

    difference() {
        union() {
            // Aeusserer Ring mit Fase an der Unterkante:
            // Bei Z=0 (unten) ist der Aussendurchmesser um 2*ring_chamfer kleiner,
            // bei Z=2 (oben) hat er den vollen Aussendurchmesser 246.
            cylinder(h=2, d1=246 - 2 * ring_chamfer, d2=246);
            cylinder(h=16, d=190);
        }
        translate([0, 0, -1])
        cylinder(h=18, d=186);
    }
}

module wall_bushing_led_ring_holder_bottom() {

    difference() {
        cylinder(h=7, d=57);

        translate([0, 0, 2])
        cylinder(h=7, d=53);

        translate([12, -12, -1])
        cylinder(h=4, d=18);

        // 2 Schraubenlöcher diagonal auf Kreisdurchmesser 40mm
        for (i = [0 : 1])
            rotate([0, 0, 45 + i * 180])
            translate([40 / 2, 0, -eps])
            cylinder(h=7 + 2 * eps, d=3);
    }

    // 4 Zylinder auf Kreisdurchmesser 46,5mm, Durchmesser 2mm
    for (i = [0 : 3])
        rotate([0, 0, i * 90])
        translate([46.5 / 2, 0, 2])
        cylinder(h=2, d=2);

}

module wall_bushing_led_ring_holder_top() {

    difference() {
        cylinder(h=9, d=61.1);

        translate([0, 0, -1])
        cylinder(h=9.6, d=57.1);
    }
}

// --- Vorschau ---

// // translate([0, 60, 0])
// wall_bushing_inner();

// color("lightblue", 0.2)
// translate([0, 0, 0])
// wall_bushing_outer();

// //Zentrierring separat daneben anzeigen
// color("orange")
// translate([0, 60, 100])
// centering_ring();

// // Zentrierring separat daneben anzeigen
// color("orange")
// translate([0, 60, 300])
// centering_ring();

//Magnetring anzeigen
// color("gold", 0.8)
// translate([0, 0, 230])
// exhaust_hose_connector();

// 90-Grad-Bogen-Variante anzeigen
// color("limegreen", 0.8)
// translate([400, 0, 230])
// exhaust_hose_connector_90_degree();

// KG Rohr apdaper innne
color("brown", 0.8)
exhaust_hose_connector_kg_adapter();



// wall_bushing_ring();

// wall_bushing_led_ring_holder_bottom();

// translate([0, 0, 0])
// wall_bushing_led_ring_holder_top();

