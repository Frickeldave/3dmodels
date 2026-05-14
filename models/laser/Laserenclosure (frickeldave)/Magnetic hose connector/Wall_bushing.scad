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
connector_plate_magnet_diameter        = 20;    // Durchmesser der Magnete
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
// Der Zwischenraum zwischen Ring und Wandbohrung / Ring und Rohr wird mit Brunnenschaum ausgefuellt.
centering_ring_height           = 5;    // Hoehe (axiale Laenge) des Zentrierrings
centering_ring_inner_clearance  = 0.2;  // Radiales Spiel zwischen Ringinnenseite und Rohraussen
centering_ring_outer_clearance  = 0.2;  // Radiales Spiel zwischen Ringaussenseite und Wandbohrung
centering_ring_chamfer          = 1.5;  // Fase an beiden Stirnkanten des Rings (Einfuehrhilfe)
centering_ring_notch_count      = 8;    // Anzahl der elliptischen Ausschnitte ("Bluetenblaetter")
centering_ring_notch_width      = 50;   // Tangentiale Breite jedes Ausschnitts an der Aussenkante
centering_ring_notch_depth      = 12;   // Radiale Tiefe des Ausschnitts (wie weit er in den Ring hineinschneidet)

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

// --- Vorschau ---

// translate([0, 60, 0])
// wall_bushing_inner();

color("lightblue")
//translate([0, 60, wall_bushing_part_length - wall_bushing_socket_depth + 10])
translate([150, 0, -200])
wall_bushing_outer();

// Zentrierring separat daneben anzeigen
// color("orange")
// translate([0, 60, 100])
// centering_ring();

// // Zentrierring separat daneben anzeigen
// color("orange")
// translate([0, 60, 300])
// centering_ring();