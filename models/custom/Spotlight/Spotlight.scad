
// ============================================================================
// Spotlight / Strahler
// ============================================================================
// Parametrisches Design eines runden LED-Strahlers (Downlight)
// für die Einbaulösung in Decke oder Wand.
//
// Features:
//   - Hohlkörper mit definierter Wandstärke
//   - Aussparung für Lampenfassung (z.B. E27)
//   - Flansch zur Aufnahme der Fassung
//
// Author: David
// ============================================================================


// --- Includes ----------------------------------------------------------

include <../../../modules/scad/BOSL2/std.scad>
include <../../../modules/scad/BOSL2/threading.scad>


// --- Render Settings ----------------------------------------------------

$fn = 100;  // Rendering-Auflösung, für schnelleres Rendern reduzieren (z.B. 20) [Segmente]

// --- Sichtbarkeit einzelner Bauteile (Performance) --------------------------
// Einzelne Bauteile lassen sich hier ein-/ausblenden, um beim Entwickeln die
// Render-Performance zu verbessern (v.a. die BOSL2-Gewinde sind teuer).

_show_light_fixture                 = false;  // light_fixture() rendern
_show_barndoor_housing              = false;   // barndoor_housing() rendern
_show_barndoor_clamp_ring           = false;   // barndoor_clamp_ring() rendern
_show_barndoor_bracket              = false;   // barndoor_bracket() rendern (Ein-/Ausschalten des Bügels)
_show_barndoor_bracket_holder       = false;  // barndoor_bracket_holder() rendern (Halter/Gegenplatte)
_show_barndoor_bracket_holder_case  = true; // barndoor_bracket_holder_case() rendern (Gehäuse unter dem Holder)
_show_cable_connection              = false;  // cable_connection() rendern
_show_barndoor_clamp_screw          = false;   // freistehende BCR-Schraube rendern
_show_barndoor_clamp_screw_hollow   = false;  // freistehende BCR-Schraube mit Durchgangsloch rendern


// --- Außenmaße des Strahlers ------------------------------------------------

_spotlight_dia            = 100;   // Außendurchmesser des Strahlers [mm]
_spotlight_height         = 30;   // Gesamthöhe des Strahlers [mm]
_spotlight_material_thickness = 5; // Wandstärke des Hohlkörpers [mm]

// --- Fassungs-Aussparungen --------------------------------------------------

_spotlight_bulb_socket_dia       = 40;   // Durchmesser der Bohrung für Lampenfassung [mm]
_spotlight_bulb_socket_holder_dia = 57;  // Durchmesser des Flanschs/Sitzes für die Fassung [mm]

// --- Gewinde-Verschluss (Kranz / Gegenstück) --------------------------------
// Buttress-Gewinde (druckfreundlich, wie bei Flaschenverschlüssen) verbindet
// das Gegenstück (männlich, am Hauptzylinder) mit dem Kranz (weiblich, an der
// Halbkugel). Pitch bewusst auf 3mm reduziert (statt 5mm): Die Gewindetiefe
// von buttress_threaded_rod ist fest auf pitch*0.75 gesetzt; bei 5mm
// Wandstärke bräuchte ein 5mm-Pitch-Gewinde 3.75mm Tiefe und ließe nur noch
// ~1.25mm Restwand am Gewindegrund. Mit 3mm Pitch (Tiefe 2.25mm) bleibt
// ausreichend Sicherheitsabstand zur Innenbohrung.

_thread_engagement_length = 25;   // Länge der Schraubverbindung zwischen Kranz und Gegenstück [mm]
_thread_pitch             = 4;    // Gewindesteigung [mm]
_thread_starts            = 1;    // Anzahl Gewindegänge (mehrgängig => weniger Umdrehungen zum Schließen)
_thread_slop              = 0.3;  // Zusätzliches Spiel am Innengewinde für Druckertoleranz [mm]

// --- Kabeldurchführung an der cable_connection -------------------------
// Bohrung durch die Wölbung der Halbkugel, radial zum Kugelmittelpunkt
// ausgerichtet. Bei offset = 0 liegt sie exakt mittig im tiefsten Punkt
// der Wölbung; mit zunehmendem offset wandert sie entlang der X-Achse von
// der Mitte weg (bleibt dabei senkrecht zur Kugeloberfläche).

_cable_hole_dia    = 16;   // Durchmesser der Kabeldurchführung [mm]
_cable_hole_offset = 15;    // Versatz vom tiefsten Punkt der Wölbung [mm]

// --- Barndoor-Gehäuse (Aufsatz für Streulichtblenden) -----------------------
// Rohrförmiger Aufsatz, der oben auf dem light_fixture sitzt. Gleicher
// Außendurchmesser und gleiche Wandstärke wie das light_fixture, sodass er
// bündig anschließt.

_barndoor_housing_length = 150;  // Länge des Barndoor-Gehäuses [mm]

// --- Dekorative Ringe an der Verbindung light_fixture <-> barndoor_housing --
// Je ein Ring sitzt an der Nahtstelle: einer am oberen Rand des
// light_fixture (Oberkante bündig mit dem Beginn des oberen Gewinde-Kragens),
// einer am barndoor_housing. _ring_gap ist der Gesamtabstand beider Ringe auf
// der Z-Achse im komplett verschraubten Zustand. In diesen Abstand fällt auch
// der Übergangs-Kragen des male_thread_boss (Höhe = _spotlight_material_thickness),
// auf dem das barndoor_housing aufsitzt; er ist Teil von _ring_gap und wird bei
// der Positionierung des barndoor-Rings berücksichtigt (siehe barndoor_housing()).

_ring_gap       = 40;  // Abstand der beiden Ringe zueinander, komplett verschraubt [mm]
_ring_thickness = 20;  // Dicke der Ringe entlang der Z-Achse [mm]

// --- Barndoor-Clamp-Ring (eigenständiger Klemmring ums barndoor_housing) ---
// Ringförmiges Bauteil, das konzentrisch um das barndoor_housing sitzt
// (Höhe = _ring_gap), mit links/rechts je einem zylindrischen Boss für
// Einschmelzmuttern. Dient z.B. zur Befestigung von Barndoors / Zubehör.

_bcr_ring_thickness    = _spotlight_material_thickness; // Materialdicke des Rings [mm]
_bcr_slide_clearance   = 0.2;                           // Toleranz für leichten Sitz um barndoor_housing [mm]
_bcr_insert_dia        = 25;                           // Bohrungsdurchmesser für Einschmelzmutter [mm]
_bcr_insert_depth      = 20;                             // Bohrtiefe für Einschmelzmutter [mm]
_bcr_insert_boss_dia   = 40;                            // Außendurchmesser des Boss-Zylinders [mm]
_bcr_insert_boss_length = 20;                           // Länge des Boss über Ringaußenwand hinaus [mm]

// --- Gewinde-Parameter für die BCR-Schrauben --------------------------------
// Buttress-Gewinde (druckfreundlich) für die Schrauben, die in die Bosse des
// barndoor_clamp_ring greifen. Eigene Parameter, da die Schrauben aus
// Kunststoff größere Abmessungen haben als das Hauptgewinde.

_bcr_thread_pitch  = 3;    // Gewindesteigung für BCR-Schrauben [mm]
_bcr_thread_starts = 1;    // Anzahl Gewindegänge
_bcr_thread_slop   = 0.3;  // Spiel am Innengewinde für Druckertoleranz [mm]

// --- BCR-Schraube (passend zum Innengewinde in den Bossen) ------------------
// Eigenständige Schraube mit Buttress-Außengewinde und Rändelkopf für
// Handbetätigung. Kann separat gedruckt und in die Bosse des
// barndoor_clamp_ring geschraubt werden.

_bcr_screw_head_dia      = 40;   // Außendurchmesser des Rändelkopfs [mm]
_bcr_screw_head_height   = 20;   // Höhe des Rändelkopfs [mm]
_bcr_screw_total_length  = 45;   // Gesamtlänge der Schraube (Kopf + Schaft) [mm]
_bcr_screw_knurl_depth   = 1;    // Tiefe der Rändelung am Kopf [mm]
_bcr_screw_knurl_count   = 24;   // Anzahl Rändel-Rippen am Kopfumfang
_bcr_screw_chamfer       = 2;    // Fase an Ober- und Unterseite des Rändelkopfs [mm]
_bcr_screw_hole_dia      = 10;   // Durchmesser des Durchgangslochs (nur barndoor_clamp_screw_hollow) [mm]

// --- Barndoor-Bügel (Haltebügel außen an den Bossen des barndoor_clamp_ring) --
// U-förmiger Bügel, dessen beide Arme außen an den Bossen des
// barndoor_clamp_ring anliegen. Je Arm ein Durchgangsloch, durch das die
// BCR-Schraube in das Innengewinde des Boss gedreht wird, um den Bügel am
// Ring zu befestigen. Rund um jedes Loch sitzt ein Verstärkungsring mit
// radialen Reib-Rillen: er gibt der Schraube mehr Material zum Festziehen und
// erzeugt beim Anpressen an die Boss-Stirnfläche Reibung (hält den Bügel im
// eingestellten Schwenkwinkel). Ein-/Ausschalten über _show_barndoor_bracket.

_bracket_length               = 180;                          // Länge der Bügelarme von der Drehachse bis zur Basis [mm]
_bracket_thickness            = _spotlight_material_thickness; // Materialstärke des Bügels [mm]
_bracket_width                = _bcr_insert_boss_dia;         // Breite der Bügelarme [mm]
_bracket_hole_clearance       = 1.0;                         // Zusätzliches Spiel im Durchgangsloch für die Schraube [mm]
_bracket_reinforcement_dia    = _bcr_insert_boss_dia;        // Außendurchmesser des Verstärkungsrings [mm]
_bracket_reinforcement_height = 4;                          // Höhe des Verstärkungsrings Richtung Boss (Reibfläche) [mm]
_bracket_tooth_count          = 12;                         // Anzahl der radialen Reib-Zähne im Verstärkungsring (Breite & Tiefe werden daraus abgeleitet)
_bracket_rib_width            = 20;                         // Basisbreite der dreieckigen Verstärkungsstege [mm]
_bracket_rib_height           = 10;                         // Höhe der dreieckigen Verstärkungsstege [mm]
_bracket_rib_ring_clearance   = 5;                          // Abstand der seitlichen Stege zum Verstärkungsring [mm]
_bracket_rib_taper_length     = 10;                         // Länge des Auslaufs in die Armoberfläche [mm]

// --- Befestigungsscheibe am unteren Quersteg --------------------------------
// Mittig unter dem Quersteg sitzt eine gezahnte Scheibe, mit der der Bügel
// an einer beliebigen Halterung festgeschraubt werden kann. Die Zähne sind
// identisch zu den serration_diamonds an Boss/Bügel. Die zentrale Bohrung
// (durch Scheibe + Quersteg) ist passend zur barndoor_clamp_screw.

_bracket_mount_disc_dia          = _bcr_insert_boss_dia;    // Außendurchmesser der Scheibe [mm]
_bracket_mount_disc_thickness    = _spotlight_material_thickness; // Dicke der Scheibe ohne Zähne [mm]
_bracket_mount_disc_tooth_count  = _bracket_tooth_count;   // Anzahl der Radialzähne auf der Scheibe
_bracket_mount_hole_dia          = _bcr_insert_dia + _bracket_hole_clearance; // Durchmesser der zentralen Bohrung (mit Spiel, wie die seitlichen Löcher) [mm]

// --- Barndoor-Bracket-Holder (Gegenplatte zur Befestigungsscheibe) ---------
// Platte (rechteckig oder oval) mit zentralem Boss-Zylinder, in den die
// barndoor_clamp_screw geschraubt wird. Sitzt bündig unter der Befestigungsscheibe des barndoor_bracket.

_bracket_holder_connection     = "screw_connection";         // Verbindung Holder<->Case: "countersunk_screw" (Senkkopfschrauben) | "screw_connection" (Verschraubung)
_bracket_holder_size_x         = 100;                         // Länge der Grundplatte [mm]
_bracket_holder_size_y         = 100;                         // Breite der Grundplatte [mm]
_bracket_holder_round          = true;                      // true = ovale Scheibe (Halbachsen = size_x/2, size_y/2), false = rechteckig
_bracket_holder_reinf_width    = _spotlight_material_thickness; // Radiale Breite des Verstärkungsrings [mm]
_bracket_holder_reinf_height   = _spotlight_material_thickness; // Höhe des Verstärkungsrings [mm]
_bracket_holder_chamfer        = _spotlight_material_thickness; // 45°-Fase an der Außenkante des Rings [mm]
_bracket_holder_edge_chamfer   = 2;                          // 45°-Fase an den oberen Kanten der Platte [mm]
_bracket_holder_mount_hole_dia = 4.5;                        // Durchmesser der Montage-Durchgangsbohrung [mm]
_bracket_holder_mount_csk_dia  = 9.0;                        // Durchmesser der 90°-Senkung (Senkkopf) [mm]
_bracket_holder_mount_hole_offset = 10;                      // Abstand der Bohrungsmitten von den Plattenkanten [mm]

// --- Barndoor-Bracket-Holder-Case (Gehäuse unter dem Holder) ---------
_bracket_holder_case_height     = 40;                        // Höhe des Gehäuses unterhalb der Platte [mm]
_bracket_holder_case_wall       = _spotlight_material_thickness; // Wandstärke des Gehäuses [mm]
_bracket_holder_case_boss_extra = 3;                         // Zusätzlicher Durchmesser der Schraub-Bosse (auf _bracket_holder_mount_hole_dia) [mm]
_bracket_holder_case_boss_hole_dia = _bracket_holder_mount_hole_dia - 1; // Durchmesser des Durchgangslochs im Boss [mm]
_bracket_holder_case_side_hole_dia = 10;                        // Durchmesser des Seitenlochs in der Wand [mm]
_bracket_holder_case_side_hole_z_offset = 5;                    // Z-Versatz des Seitenlochs über dem Boden (0 = direkt über dem Boden) [mm]
_bracket_holder_case_bottom_hole_dia = 4.5;                     // Durchmesser der 4 Boden-Löcher [mm]
_bracket_holder_case_bottom_hole_x    = 35;                     // X-Abstand der Boden-Löcher (auf der X-Achse) von der Mitte [mm]
_bracket_holder_case_bottom_hole_y    = 35;                     // Y-Abstand der Boden-Löcher (auf der Y-Achse) von der Mitte [mm]
_bracket_holder_case_bottom_ring_dia  = 12;                     // Außendurchmesser der Verstärkungsringe [mm]
_bracket_holder_case_bottom_ring_height = _spotlight_material_thickness; // Höhe der Verstärkungsringe [mm]
_bracket_holder_case_bottom_hole_rotation = 20;                 // Rotation der 4 Boden-Löcher um die Z-Achse [°]
_bracket_holder_case_align_dia       = 3;                       // Durchmesser der 3 Positionier-Zylinder auf der Gehäuse-Oberseite [mm]
_bracket_holder_case_align_tolerance = 0.3;                     // Radialspiel der Aufnahmelöcher im Holder [mm]

// --- Computed Values ---------------------------------------------------

_spotlight_radius  = _spotlight_dia / 2; // Außenradius des Strahlers [mm]
_spotlight_bulb_socket_radius        = _spotlight_bulb_socket_dia / 2;        // Radius der Bohrung für Lampenfassung [mm]
_spotlight_bulb_socket_holder_radius = _spotlight_bulb_socket_holder_dia / 2; // Radius des Flanschs/Sitzes für die Fassung [mm]
_thread_mating_dia = 2 * (_spotlight_radius - _spotlight_material_thickness); // Nenndurchmesser auf der Passfläche [mm]

_dummy_thread_mating_dia_check = assert(
    _thread_mating_dia > 0,
    str(
        "_thread_mating_dia (", _thread_mating_dia, ") muss positiv sein. ",
        "_spotlight_radius (", _spotlight_radius, ") muss größer als _spotlight_material_thickness (",
        _spotlight_material_thickness, ") sein, d.h. _spotlight_dia muss größer als ",
        2 * _spotlight_material_thickness, " sein."
    )
);


// --- Geometrie: Hohlkörper mit Fassungs-Aussparungen ------------------------

union() {
    if (_show_light_fixture)
        translate([0, 0, 0])
        light_fixture();

    if (_show_barndoor_housing)
        color("pink")
        translate([0, 0, 3 * _spotlight_height])
        barndoor_housing();

    if (_show_barndoor_clamp_ring)
        color("green")
        translate([0, 0, 2 * _spotlight_height])
        barndoor_clamp_ring();

    // Der Bügel teilt sich denselben translate()-Bezugspunkt wie der
    // barndoor_clamp_ring, damit seine Arme exakt außen an dessen Bossen
    // anliegen und die Löcher mit den Boss-Gewinden fluchten.
    if (_show_barndoor_bracket)
        color("purple")
        translate([0, 0, 2 * _spotlight_height])
        barndoor_bracket();

    // Der Holder teilt sich denselben translate()-Bezugspunkt wie der
    // barndoor_bracket, damit sein Boss bündig unter der Befestigungsscheibe
    // des Bügels sitzt und die Verzahnung fluchtet.
    if (_show_barndoor_bracket_holder)
        color("yellow")
        translate([0, 0, 2 * _spotlight_height])
        barndoor_bracket_holder();

    // Das Gehäuse teilt sich denselben translate()-Bezugspunkt wie der Holder
    // und sitzt direkt unter dessen Platte.
    if (_show_barndoor_bracket_holder_case)
        color("cyan")
        translate([0, 0, 2 * _spotlight_height - 50])
        barndoor_bracket_holder_case();

    // cable_connection() erhält bewusst KEINEN eigenen Z-Versatz: Ihr Kranz
    // (Innengewinde) liegt intern bereits bei z = [-_thread_engagement_length, 0],
    // exakt wie das untere Gegenstück (Außengewinde) von light_fixture(). Beide
    // Bauteile müssen daher denselben äußeren translate()-Bezugspunkt teilen,
    // damit die Gewinde ineinander passen (verschraubt).
    if (_show_cable_connection)
        translate([0, 0, - _spotlight_height])
        cable_connection();

    // Freistehende BCR-Schraube (passend zum Innengewinde in den Bossen)
    if (_show_barndoor_clamp_screw)
        color("silver")
        translate([5 * _spotlight_radius + 30, 0, 0])
        barndoor_clamp_screw();

    if (_show_barndoor_clamp_screw_hollow)
        color("silver")
        translate([7 * _spotlight_radius + 40, 0, 0])
        barndoor_clamp_screw_hollow();
}


// --- Modules -----------------------------------------------------------

// Dekorativer Ring: schmales Band, das radial um einen Zylinder mit Radius r
// übersteht. Radialer Überstand entspricht fest _spotlight_material_thickness
// (nicht konfigurierbar); die Dicke entlang der Z-Achse ist über thickness
// konfigurierbar. Wird sowohl an light_fixture als auch an barndoor_housing
// als Positionsmarkierung für die Nahtstelle verwendet.
//
// Die Innenbohrung wird um _eps enger geschnitten als r, sodass der Ring
// geringfügig in den umschlossenen Zylinder (Hauptkörper) hineinragt, statt
// mit exakt gleichem Radius nur an ihm anzuliegen. Ohne diesen Überlapp
// liegen Ring-Innenwand und Zylinder-Außenwand exakt deckungsgleich
// übereinander, was in der OpenSCAD-Vorschau zu Flacker-Artefakten
// (Z-Fighting durch koinzidente Flächen) führt.
//
// chamfer_top steuert, an welcher Stirnseite die Schräge (Kegel-Übergang von
// der Ringaußenkante r + Wandstärke auf den Zylinderradius r) sitzt:
//   - false (Standard): Schräge am UNTEREN Rand (z = [-Wandstärke, 0]), die
//     obere Stirnfläche des Ringkörpers (z = thickness) bleibt flach.
//   - true: Schräge am OBEREN Rand (z = [thickness, thickness + Wandstärke]),
//     die untere Stirnfläche (z = 0) bleibt flach.
// Am barndoor_housing wird chamfer_top = true benötigt, damit dessen Ring mit
// einer flachen Unterseite zum light_fixture-Ring zeigt und der Abstand beider
// Ringe exakt _ring_gap beträgt (die Schräge würde sonst in den Spalt ragen).
module joint_ring(r, thickness = _ring_thickness, chamfer_top = false) {
    _eps = 0.01;

    difference() {
        cylinder(h = thickness, r = r + _spotlight_material_thickness);

        translate([0, 0, -1])
        cylinder(h = thickness + 2, r = r - _eps);
    }

    if (chamfer_top)
        translate([0, 0, thickness])
        difference() {
            cylinder(h = _spotlight_material_thickness, r1 = r + _spotlight_material_thickness, r2 = r);

            translate([0, 0, -1])
            cylinder(h = _spotlight_material_thickness + 2, r = r - _eps);
        }
    else
        translate([0, 0, -_spotlight_material_thickness])
        difference() {
            cylinder(h = _spotlight_material_thickness, r1 = r, r2 = r + _spotlight_material_thickness);

            translate([0, 0, -1])
            cylinder(h = _spotlight_material_thickness + 2, r = r - _eps);
        }

}

// Männliches Gewinde-Boss mit Übergangs-Kragen: identisch zum oberen
// Gegenstück des light_fixture (siehe dort für Details zum Kragen). Als
// eigenständiges Modul verwendbar.
module male_thread_boss() {
    // Bohrungsradien der Innenseite: unten (an der Nahtstelle zum
    // Hauptzylinder) identisch zu dessen Innenbohrung (_thread_mating_dia / 2
    // = _spotlight_radius - _spotlight_material_thickness), damit die
    // Bohrung nahtlos anschließt. Oben (im Gewindebereich) wie bisher enger
    // (_spotlight_radius - 2 * _spotlight_material_thickness), da dort mehr
    // Restwand für das Gewinde benötigt wird.
    _bore_r_bottom = _thread_mating_dia / 2;
    _bore_r_top    = _spotlight_radius - _spotlight_material_thickness * 2;

    // Der Kragen beginnt _eps unterhalb von z = 0 und überlappt so geringfügig
    // mit dem Hauptkörper, statt mit exakt gleichem Radius nur an dessen
    // oberer Stirnfläche anzuliegen. Ohne diesen Überlapp liegen Kragen-
    // Bodenfläche und Hauptkörper-Deckfläche exakt in derselben Ebene, was in
    // der OpenSCAD-Vorschau zu Flacker-Artefakten (Z-Fighting) führt.
    _eps = 0.01;

    difference() {
        union() {
            buttress_threaded_rod(
                d           = _thread_mating_dia,
                l           = _thread_engagement_length,
                pitch       = _thread_pitch,
                starts      = _thread_starts,
                internal    = false,
                bevel       = false,
                blunt_start = true,
                anchor      = BOTTOM
            );

            // Kragen: gerader Zylinder auf vollem Körperradius, Außenkontur
            // bleibt bündig mit dem Hauptzylinder (keine Änderung außen); um
            // _eps nach unten verlängert für den Überlapp (siehe oben).
            translate([0, 0, -_eps])
            cylinder(h = _spotlight_material_thickness + _eps, r = _spotlight_radius);
        }

        // Innenbohrung: läuft über die Höhe des Kragens konisch von
        // _bore_r_bottom (Anschluss an die Bohrung des Hauptzylinders) auf
        // _bore_r_top (engere Bohrung im Gewindebereich) zu, statt dort
        // abrupt zu springen. Vermeidet den 90°-Überhang auf der Innenseite,
        // der entstünde, wenn die engere Gewinde-Bohrung direkt unterhalb an
        // die weitere Bohrung des Hauptzylinders anschließen würde.
        union() {
            translate([0, 0, -1])
            cylinder(h = 1, r = _bore_r_bottom);

            cylinder(h = _spotlight_material_thickness, r1 = _bore_r_bottom, r2 = _bore_r_top);

            translate([0, 0, _spotlight_material_thickness])
            cylinder(h = _thread_engagement_length - _spotlight_material_thickness + 2, r = _bore_r_top);
        }
    }
}

// Weibliches Gewinde-Socket (Kranz + Rohr-Rest): identisch zur Innenkontur
// des barndoor_housing, mit konfigurierbarer Gesamtlänge. Als eigenständiges
// Modul verwendbar.
module female_thread_socket(length) {
    _eps = 0.01;

    difference() {
        cylinder(h = length, r = _spotlight_radius);

        // Siehe barndoor_housing() für die Begründung der _eps-Überlappung
        // an der Nahtstelle zwischen Gewindebohrung und Rohr-Hohlraum.
        union() {
            color("red")
            translate([0, 0, -1])
            buttress_threaded_rod(
                d           = _thread_mating_dia,
                l           = _thread_engagement_length + 1,
                pitch       = _thread_pitch,
                starts      = _thread_starts,
                internal    = true,
                bevel       = false,
                blunt_start = true,
                $slop       = _thread_slop,
                anchor      = BOTTOM
            );

            translate([0, 0, _thread_engagement_length - _eps])
            cylinder(h = length - _thread_engagement_length + _eps + 1, r = _spotlight_radius - _spotlight_material_thickness);
        }
    }
}

// Radiale Sägezahn-Schneider (Diamant-Querschnitt) in der Ebene z = 0, gemeinsam
// genutzt von Bügel-Verstärkungsring und Boss-Stirnfläche, damit die Verzahnungen
// formschlüssig ineinander greifen ("Hirth"-artige Rastverzahnung):
//   - Der Bügel subtrahiert diese Diamanten aus seiner Stirnfläche -> V-Nuten.
//   - Der Boss addiert dieselben Diamanten auf seine Stirnfläche -> Zähne, die
//     exakt in die V-Nuten des Bügels passen und beim Anziehen einrasten.
// Alle Kenngrößen werden allein aus _bracket_tooth_count abgeleitet:
//   - Bezugs-Teilung = Umfang am Lochrand / Zähnezahl (kleinster Radius -> engste
//     Teilung; die V-Nuten überschneiden sich dadurch nach außen nie).
//   - _tooth_depth = halbe Teilung => 90°-Zahnflanken; nach oben auf 70 % der
//     Verstärkungsring-Höhe begrenzt, damit die V-Nut nie tiefer als der Ring wird.
//   - _tooth_side = Kantenlänge des um 45° gedrehten Quaders (Diamant-
//     Querschnitt); halbe Diagonale = _tooth_depth.
// Die Zähne verlaufen radial von r_in bis r_out; offset_deg verdreht das Muster.
module serration_diamonds(r_in, r_out, offset_deg = 0) {
    _hole_r      = (_bcr_insert_dia + _bracket_hole_clearance) / 2;
    _tooth_depth = min(PI * _hole_r / _bracket_tooth_count, _bracket_reinforcement_height * 0.7);
    _tooth_side  = _tooth_depth * sqrt(2);
    _eps         = 0.01;

    for (i = [0 : _bracket_tooth_count - 1])
        rotate([0, 0, offset_deg + i * 360 / _bracket_tooth_count])
        rotate([45, 0, 0])
        translate([r_in, -_tooth_side / 2, -_tooth_side / 2])
        cube([r_out - r_in + _eps, _tooth_side, _tooth_side]);
}

// Barndoor-Clamp-Ring: eigenständiges Bauteil, das konzentrisch um das
// barndoor_housing sitzt (Höhe = _ring_gap), mit links/rechts je einem
// zylindrischen Boss für Einschmelzmuttern. Der Innendurchmesser ist um
// _bcr_slide_clearance größer als der Außendurchmesser des barndoor_housing
// (= 2 * _spotlight_radius), damit der Ring leicht über das Gehäuse gleitet.
// Die Materialdicke des Rings ist über _bcr_ring_thickness konfigurierbar.
module barndoor_clamp_ring() {
    _inner_r = _spotlight_radius + _bcr_slide_clearance / 2;
    _outer_r = _inner_r + _bcr_ring_thickness;

    // Boss mit Bohrung und Innengewinde für eine Schraube, radial ausgerichtet
    // und um _bcr_ring_thickness in die Ringwand eingebettet. So überlappt der
    // Boss die gesamte Wandstärke und ist fest mit dem Ring verbunden, statt
    // nur tangential anzuliegen. Die einfache Bohrung wird durch ein
    // Buttress-Innengewinde (buttress_threaded_rod, internal=true) ersetzt,
    // sodass eine passende Kunststoff-Schraube mit Außengewinde gedruckt und
    // eingeschraubt werden kann.
    // sign = 1 -> +X-Seite, sign = -1 -> -X-Seite.
    module insert_boss(sign) {
        _embed = _bcr_ring_thickness;
        _boss_total_length = _embed + _bcr_insert_boss_length;

        // Radiale Reichweite der Verzahnung: vom Bügel-Lochrand bis zum
        // Boss-Außenrand (deckungsgleich mit den V-Nuten im Verstärkungsring).
        _face_r_in  = (_bcr_insert_dia + _bracket_hole_clearance) / 2;
        _face_r_out = _bcr_insert_boss_dia / 2;

        translate([sign * (_outer_r - _embed), 0, _ring_gap / 2])
        rotate([0, sign * 90, 0])
        union() {
            difference() {
                cylinder(h = _boss_total_length, r = _bcr_insert_boss_dia / 2);

                // Buttress-Innengewinde über die gesamte Tiefe der Bohrung.
                // Die Schraube zeigt beim Einsetzen mit ihrer lokalen +Z-Achse
                // nach innen; daher wird der Schneidkörper axial umgedreht.
                // Die 180°-Rotation kehrt das asymmetrische Flankenprofil um,
                // ohne die Gewindehändigkeit zu ändern.
                translate([0, 0, _boss_total_length + 1])
                rotate([180, 0, 0])
                buttress_threaded_rod(
                    d           = _bcr_insert_dia,
                    l           = _bcr_insert_depth + 1,
                    pitch       = _bcr_thread_pitch,
                    starts      = _bcr_thread_starts,
                    internal    = true,
                    bevel       = false,
                    blunt_start = true,
                    $slop       = _bcr_thread_slop,
                    anchor      = BOTTOM
                );
            }

            // Eingreifende Zähne an der Boss-Stirnfläche: dieselben Diamant-
            // Zähne, die im Bügel als V-Nuten ausgeschnitten werden, hier als
            // positives Material aufgesetzt. Die vorstehende Hälfte jedes
            // Diamanten ragt über die Stirnfläche hinaus und füllt exakt die
            // zugehörige V-Nut des Bügels -> formschlüssiges Einrasten.
            // Auf der -X-Seite (sign < 0) wird das Muster gespiegelt, damit es
            // - wie der ebenfalls gespiegelte Bügelarm - für beliebige
            // Zähnezahlen deckungsgleich bleibt.
            translate([0, 0, _boss_total_length])
            if (sign > 0)
                serration_diamonds(_face_r_in, _face_r_out);
            else
                mirror([1, 0, 0]) serration_diamonds(_face_r_in, _face_r_out);
        }
    }

    difference() {
        cylinder(h = _ring_gap, r = _outer_r);

        translate([0, 0, -1])
        cylinder(h = _ring_gap + 2, r = _inner_r);
    }

    insert_boss(sign = 1);
    insert_boss(sign = -1);
}

// Barndoor-Bügel: U-förmiger Haltebügel, dessen beide Arme außen an den
// Bossen des barndoor_clamp_ring anliegen. Jeder Arm hat ein Durchgangsloch,
// durch das die BCR-Schraube in das Innengewinde des Boss greift und so den
// Bügel am Ring befestigt. Um jedes Loch sitzt auf der zum Boss zeigenden
// Innenseite ein Verstärkungsring mit radialen Reib-Rillen (mehr Material zum
// Festziehen der Schraube + Reibung gegen die Boss-Stirnfläche, damit der
// eingestellte Schwenkwinkel gehalten wird). Die Arme sind unten über eine
// flache Basisplatte (U-Form) verbunden. Alle tragenden Teile sind flache
// Platten (Flachbügel), kein runder Griff.
//
// Geometrie-Bezug zum barndoor_clamp_ring: Dessen Boss endet außen bei
// x = _outer_r + _bcr_insert_boss_length (= _boss_outer_x). Die Innenfläche
// des Bügelarms liegt um die Höhe des Verstärkungsrings weiter außen, sodass
// dessen gerillte Stirnfläche bündig an der Boss-Stirnfläche anliegt.
module barndoor_bracket() {
    _inner_r      = _spotlight_radius + _bcr_slide_clearance / 2;
    _outer_r      = _inner_r + _bcr_ring_thickness;
    _boss_outer_x = _outer_r + _bcr_insert_boss_length;      // Stirnfläche des Boss
    _arm_inner_x  = _boss_outer_x + _bracket_reinforcement_height; // Innenfläche des Arms
    _arm_outer_x  = _arm_inner_x + _bracket_thickness;       // Außenfläche des Arms
    _z_pivot      = _ring_gap / 2;                           // Höhe der Boss-/Schraubenachse
    _z_base       = _z_pivot - _bracket_length;              // Höhe der Basis-Querstrebe
    _hole_r       = (_bcr_insert_dia + _bracket_hole_clearance) / 2;
    _reinf_r      = _bracket_reinforcement_dia / 2;
    _eps          = 0.01;
    _rib_start_z  = _z_base + _bracket_thickness;
    _rib_end_z    = _z_pivot - _reinf_r - _bracket_rib_ring_clearance;
    _rib_taper_z  = _rib_end_z - _bracket_rib_taper_length;

    // Ein Bügelarm im kanonischen Frame:
    //   - Drehachse (Schraubenachse) = lokale Z-Achse, Drehpunkt im Ursprung
    //   - lokal +Z = nach außen (Schraubenkopf-Seite), lokal -Z = zum Boss
    //   - lokal +X = Richtung Basis (Arm-Länge), Breite entlang Y
    //   - Plattendicke entlang Z (_bracket_thickness)
    module arm_canonical() {
        difference() {
            union() {
                // Flache Armplatte: erstreckt sich vom Drehpunkt bis zur Basis
                // (+X). Breite _bracket_width (Y), Dicke _bracket_thickness (Z).
                translate([0, -_bracket_width / 2, 0])
                cube([_bracket_length, _bracket_width, _bracket_thickness]);

                // Abgerundete obere Kappe am Drehpunkt (Halbkreis, Radius
                // _bracket_width/2). Ersetzt das rechteckige Armende, damit keine
                // Ecken über den gezackten Verstärkungsring hinausragen.
                cylinder(h = _bracket_thickness, r = _bracket_width / 2);

                // Verstärkungsring am Drehpunkt, ragt Richtung Boss (-Z) und
                // überlappt die Platte um _eps (vermeidet koplanare Flächen).
                translate([0, 0, -_bracket_reinforcement_height])
                cylinder(h = _bracket_reinforcement_height + _eps, r = _reinf_r);
            }

            // Durchgangsloch für die Schraube (durch Verstärkungsring + Platte)
            translate([0, 0, -_bracket_reinforcement_height - 1])
            cylinder(h = _bracket_reinforcement_height + _bracket_thickness + 2, r = _hole_r);

            // Radiale Sägezahn-V-Nuten in der zum Boss zeigenden Stirnfläche des
            // Verstärkungsrings (z = -_bracket_reinforcement_height). Dieselbe
            // Verzahnung wird als positives Material auf die Boss-Stirnfläche
            // gesetzt (serration_diamonds im barndoor_clamp_ring), sodass die
            // Boss-Zähne in diese V-Nuten eingreifen und der eingestellte
            // Schwenkwinkel formschlüssig einrastet.
            translate([0, 0, -_bracket_reinforcement_height])
            serration_diamonds(0, _reinf_r);
        }
    }

    // Platziert einen Arm auf der +X-Seite: kanonisches +Z (außen) -> Welt +X,
    // kanonisches +X (Basis) -> Welt -Z (nach unten), Drehpunkt bei _z_pivot.
    module arm_placed() {
        translate([_arm_inner_x, 0, _z_pivot])
        rotate([0, 90, 0])
        arm_canonical();
    }

    // +X-Arm sowie sein an der YZ-Ebene gespiegeltes Gegenstück (-X-Arm).
    arm_placed();
    mirror([1, 0, 0]) arm_placed();

    // Gleichschenkliger Verstärkungssteg an der Innenseite eines Arms. Der
    // dreieckige Querschnitt liegt in X-Y und läuft entlang Z. Vor dem
    // Verstärkungsring geht seine Höhe über einen linearen Auslauf auf null
    // zurück, sodass der Steg weich mit der Armoberfläche verschmilzt.
    module inner_arm_rib_profile(rib_height) {
        polygon([
            [_arm_inner_x, -_bracket_rib_width / 2],
            [_arm_inner_x, _bracket_rib_width / 2],
            [_arm_inner_x - rib_height, 0]
        ]);
    }

    module inner_arm_rib() {
        translate([0, 0, _rib_start_z])
        linear_extrude(height = _rib_taper_z - _rib_start_z + _eps)
        inner_arm_rib_profile(_bracket_rib_height);

        hull() {
            translate([0, 0, _rib_taper_z])
            linear_extrude(height = _eps)
            inner_arm_rib_profile(_bracket_rib_height);

            translate([0, 0, _rib_end_z - _eps])
            linear_extrude(height = _eps)
            inner_arm_rib_profile(_eps);
        }
    }

    inner_arm_rib();
    mirror([1, 0, 0]) inner_arm_rib();

    // Basis-Platte: flache, rechteckige Platte, die die unteren Enden beider
    // Arme verbindet (U-Form). Breite _bracket_width (Y), Dicke
    // _bracket_thickness (Z), spannt in X über beide Arme hinweg.
    // Zentrale Bohrung für die Befestigungsschraube (passend zur
    // barndoor_clamp_screw).
    translate([-_arm_outer_x, -_bracket_width / 2, _z_base])
    difference() {
        cube([2 * _arm_outer_x, _bracket_width, _bracket_thickness]);

        // Zentrale Bohrung für die Befestigungsschraube
        translate([_arm_outer_x, _bracket_width / 2, -1])
        cylinder(h = _bracket_thickness + 2, r = _bracket_mount_hole_dia / 2);
    }

    // Gleichschenkliger Mittelsteg auf der Basisplatte. Der dreieckige
    // Querschnitt liegt in Y-Z und wird von einem Bügelarm zum anderen
    // entlang X extrudiert. Zentrale Bohrung für die Befestigungsschraube
    // (deckungsgleich mit der Bohrung in der Basis-Platte).
    // Die Bohrung wird VOR dem rotate() abgezogen, damit sie in Welt-Z-
    // Richtung verläuft und mit der Bohrung in der Basis-Platte fluchtet.
    // Der Mittelsteg liegt in der YZ-Ebene bei x = 0 (Welt), was nach
    // translate([-_arm_outer_x, 0, ...]) der lokalen Position x = _arm_outer_x
    // entspricht. Die Bohrung sitzt mittig im Dreieck bei y = 0 (Welt)
    // = lokales y = 0, und in halber Dreieckhöhe.
    difference() {
        translate([-_arm_outer_x, 0, _z_base + _bracket_thickness])
        rotate([0, 90, 0])
        linear_extrude(height = 2 * _arm_outer_x)
        polygon([
            [0, -_bracket_rib_width / 2],
            [-_bracket_rib_height, 0],
            [0, _bracket_rib_width / 2]
        ]);

        // Bohrung in Welt-Z-Richtung durch den Mittelsteg
        translate([0, 0, _z_base + _bracket_thickness + _bracket_rib_height / 2])
        cylinder(h = _bracket_rib_height + 2, r = _bracket_mount_hole_dia / 2, center = true);

        // Plane Auflagefläche für den Schraubenkopf auf der Innenseite
        // (Spitze des Dreiecks, Welt +X). Ein Zylinder in Welt-X-Richtung,
        // zentriert bei x = 0, schneidet die Dreiecksspitze auf eine plane
        // Fläche mit Radius (_bcr_screw_head_dia + 2) / 2 frei, sodass der
        // Schraubenkopf plan aufliegen kann.
        translate([0, 0, _z_base + _bracket_thickness + _bracket_rib_height / 2])
        rotate([0, 90, 0])
        cylinder(h = _bcr_screw_head_dia + 4, r = (_bcr_screw_head_dia + 4) / 2, center = true);
    }

    // Befestigungsscheibe: mittig unter dem Quersteg, mit radialen Zähnen
    // auf der Unterseite (identisch zu serration_diamonds an Boss/Bügel).
    // Die zentrale Bohrung fluchtet mit der Bohrung im Quersteg, sodass
    // eine barndoor_clamp_screw durch beide Teile gesteckt werden kann.
    module bracket_mount_disc() {
        _disc_r      = _bracket_mount_disc_dia / 2;
        _hole_r      = _bracket_mount_hole_dia / 2;
        _tooth_depth = min(PI * _hole_r / _bracket_mount_disc_tooth_count, _bracket_mount_disc_thickness * 0.7);
        _tooth_side  = _tooth_depth * sqrt(2);
        _eps         = 0.01;

        difference() {
            union() {
                // Scheiben-Grundkörper
                cylinder(h = _bracket_mount_disc_thickness, r = _disc_r);

                // Zähne auf der Unterseite (z = 0): serration_diamonds als
                // positives Material aufgesetzt, analog zur Boss-Stirnfläche.
                // Die Diamanten ragen zur Hälfte über die Unterkante hinaus.
                serration_diamonds(_hole_r, _disc_r);
            }

            // Zentrale Bohrung für die Schraube (durch Scheibe + Zähne)
            translate([0, 0, -_tooth_side / 2 - 1])
            cylinder(h = _bracket_mount_disc_thickness + _tooth_side + 2, r = _hole_r);
        }
    }

    // Scheibe mittig unter dem Quersteg positionieren: Oberseite der Scheibe
    // (z = _bracket_mount_disc_thickness) schließt bündig an die Unterkante
    // des Querstegs (z = _z_base) an.
    translate([0, 0, _z_base - _bracket_mount_disc_thickness])
    bracket_mount_disc();
}

// Position der 3 Positionier-Zylinder (i = 0..2) auf der Wand-Oberseite des
// Gehäuses. Die Punkte liegen 120° versetzt auf der Wand-Mittellinie (halbe
// Wandstärke innerhalb der Außenkante), damit die Zylinder auf Material stehen
// und die Aufnahmelöcher im Holder (mit Toleranz) innerhalb der Platte bleiben.
function bracket_holder_align_points(i) =
    let(
        _rx = _bracket_holder_size_x / 2 - _bracket_holder_case_wall / 2,
        _ry = _bracket_holder_size_y / 2 - _bracket_holder_case_wall / 2,
        _a  = i * 120
    )
    _bracket_holder_round
        ? [_rx * cos(_a), _ry * sin(_a)]
        : let(_t = min(_rx / abs(cos(_a)), _ry / abs(sin(_a))))
          [_t * cos(_a), _t * sin(_a)];

// Barndoor-Bracket-Holder: Gegenplatte zur Befestigungsscheibe des Bügels.
// Grundplatte (Dicke = _spotlight_material_thickness), wahlweise rechteckig
// oder oval (_bracket_holder_round), mit einem zentralen Boss-Zylinder, der
// exakt die Maße des insert_boss am barndoor_clamp_ring hat (Durchmesser/
// Höhe/Innengewinde). Auf der
// Boss-Stirnfläche sitzen V-Nuten (subtrahierte serration_diamonds, identisch
// zum Bügel-Verstärkungsring), in die die Zähne der Befestigungsscheibe
// formschlüssig eingreifen. Um die Boss-Basis läuft ein Verstärkungsring mit
// 45°-Fase an der oberen Außenkante. Das Modul wird so positioniert, dass die
// Boss-Stirnfläche bündig an der Zahn-Ebene der Befestigungsscheibe anliegt.
module barndoor_bracket_holder() {
    _z_base  = _ring_gap / 2 - _bracket_length;               // identisch zu barndoor_bracket()
    _boss_r  = _bcr_insert_boss_dia / 2;                      // Boss-Radius (wie insert_boss)
    _boss_h  = _bcr_insert_boss_length + _bcr_ring_thickness; // Boss-Länge (wie insert_boss)
    _plate_t = _spotlight_material_thickness;
    _ring_r  = _boss_r + _bracket_holder_reinf_width;         // Außenradius des Verstärkungsrings
    _eps     = 0.01;
    _align_peg_h = _spotlight_material_thickness / 2;         // Höhe der Positionier-Zylinder [mm]

    // Zahn-/Nut-Ebene der Befestigungsscheibe (bündige Anlage)
    _mating_z = _z_base - _bracket_mount_disc_thickness;
    // Platten-Unterkante, sodass die Boss-Stirnfläche exakt auf _mating_z liegt
    _holder_z = _mating_z - _plate_t - _boss_h;

    // Nut-Radialbereich deckungsgleich zur Befestigungsscheibe
    _face_r_in  = _bracket_mount_hole_dia / 2;
    _face_r_out = _bracket_mount_disc_dia / 2;

    // Scheiben-Halbmesser und Bohrungspositionen. Der Randabstand wird so
    // geklemmt, dass die Senkkopf-Senkung (Radius _csk_r) unabhängig von der
    // gewählten Plattengröße immer vollständig auf der Scheibe bleibt.
    _half_x = _bracket_holder_size_x / 2;
    _half_y = _bracket_holder_size_y / 2;
    _csk_r  = _bracket_holder_mount_csk_dia / 2;

    // Scheiben-Radius entlang der Diagonalen (45°): bei gleichen Maßen der
    // Kreisradius, bei ovaler Scheibe der Ellipsen-Radius in Diagonalrichtung.
    _diag_r = 1 / sqrt(pow(cos(45) / _half_x, 2) + pow(sin(45) / _half_y, 2));

    // Rechteck: Bohrungen in den vier Ecken
    _off_x  = min(_bracket_holder_mount_hole_offset, max(0, _half_x - _csk_r));
    _off_y  = min(_bracket_holder_mount_hole_offset, max(0, _half_y - _csk_r));
    _hole_x = _half_x - _off_x;
    _hole_y = _half_y - _off_y;

    // Oval: Bohrungen auf den Diagonalen (45°), radialer Randabstand
    _off_r   = min(_bracket_holder_mount_hole_offset, max(0, _diag_r - _csk_r));
    _hole_r  = max(0, _diag_r - _off_r);
    _hole_dx = _hole_r * cos(45);
    _hole_dy = _hole_r * sin(45);

    // Senkbohrung für eine Senkkopfschraube: zylindrische Durchgangsbohrung
    // mit konischer 90°-Fase (Senkung) an der Plattenoberseite.
    module mount_screw_hole(hx, hy) {
        _csk_h = (_bracket_holder_mount_csk_dia - _bracket_holder_mount_hole_dia) / 2;

        translate([hx, hy, -1])
        cylinder(h = _plate_t + 2, r = _bracket_holder_mount_hole_dia / 2);

        // Senkung 0.1 mm über die Plattenoberseite hinaus verlängert, damit die
        // Senkkante nicht exakt auf der Deckfläche liegt (Z-Fighting/Artefakt).
        translate([hx, hy, _plate_t - _csk_h])
        cylinder(h = _csk_h + 0.1, r1 = _bracket_holder_mount_hole_dia / 2, r2 = _bracket_holder_mount_csk_dia / 2);
    }

    // Ring mit Außengewinde unter der Platte (nur bei Verschraubung): greift
    // in das Innengewinde des Gehäuses ein. Identische Gewinde-Parameter wie
    // light_fixture <-> barndoor_housing (passen exakt); um 180° gespiegelt,
    // damit das Gewinde nach unten zeigt (von oben in das Gehäuse eingreift).
    module holder_case_ring() {
        _ring_in_r = _thread_mating_dia / 2 - _spotlight_material_thickness; // Innenradius (Wandstärke = _spotlight_material_thickness)

        difference() {
            // Außengewinde, nach unten zeigend (um _eps in die Platte überlappt)
            translate([0, 0, _eps])
            rotate([180, 0, 0])
            buttress_threaded_rod(
                d           = _thread_mating_dia,
                l           = _thread_engagement_length,
                pitch       = _thread_pitch,
                starts      = _thread_starts,
                internal    = false,
                bevel       = false,
                blunt_start = true,
                anchor      = BOTTOM
            );

            // Innenbohrung des Rings (reicht bis über die Ring-Oberkante, damit
            // die zentrale Bohrung komplett durchgängig bleibt und keine dünne
            // Membran an der Platten-Unterseite stehen bleibt)
            translate([0, 0, -_thread_engagement_length - 1])
            cylinder(h = _thread_engagement_length + 2, r = _ring_in_r);
        }
    }

    translate([0, 0, _holder_z]) {

        // Grundplatte: 45°-Fase an den oberen Kanten, 4 Senkbohrungen.
        // Wahlweise rechteckig oder oval; die Bohrungen liegen immer innerhalb.
        difference() {
            if (_bracket_holder_round) {
                // Ovale Scheibe (Halbachsen _half_x/_half_y) mit 45°-Fase an der
                // oberen Außenkante: Grundkörper + eingezogene Oberseite per hull().
                hull() {
                    linear_extrude(height = _plate_t - _bracket_holder_edge_chamfer)
                    scale([_half_x, _half_y]) circle(r = 1);

                    translate([0, 0, _plate_t - _bracket_holder_edge_chamfer])
                    linear_extrude(height = _bracket_holder_edge_chamfer)
                    scale([
                        _half_x - _bracket_holder_edge_chamfer,
                        _half_y - _bracket_holder_edge_chamfer
                    ]) circle(r = 1);
                }
            } else {
                // Rechteckige Scheibe: Quader mit 45°-Fase an den oberen Kanten
                hull() {
                    translate([-_bracket_holder_size_x / 2, -_bracket_holder_size_y / 2, 0])
                    cube([_bracket_holder_size_x, _bracket_holder_size_y, _plate_t - _bracket_holder_edge_chamfer]);

                    translate([0, 0, _plate_t - _bracket_holder_edge_chamfer])
                    linear_extrude(height = _bracket_holder_edge_chamfer)
                    square([
                        _bracket_holder_size_x - 2 * _bracket_holder_edge_chamfer,
                        _bracket_holder_size_y - 2 * _bracket_holder_edge_chamfer
                    ], center = true);
                }
            }

            // Montage-Senkbohrungen nur bei Verbindung per Senkkopfschrauben
            if (_bracket_holder_connection == "countersunk_screw")
                for (sx = [-1, 1], sy = [-1, 1])
                    if (_bracket_holder_round)
                        mount_screw_hole(sx * _hole_dx, sy * _hole_dy);
                    else
                        mount_screw_hole(sx * _hole_x, sy * _hole_y);

            // Zentrale Durchgangsbohrung (Durchmesser = _bcr_insert_dia,
            // identisch zum Innengewinde im Boss darüber)
            translate([0, 0, -1])
            cylinder(h = _plate_t + 2, r = _bcr_insert_dia / 2);

            // Aufnahmelöcher für die 3 Positionier-Zylinder des Gehäuses
            // (mit Toleranz, damit der Holder sauber aufgesetzt werden kann)
            if (_bracket_holder_connection == "countersunk_screw")
                for (i = [0 : 2]) {
                    _p = bracket_holder_align_points(i);
                    translate([_p.x, _p.y, -1])
                    cylinder(h = _align_peg_h + 0.5, r = _bracket_holder_case_align_dia / 2 + _bracket_holder_case_align_tolerance);
                }
        }

        // Boss-Zylinder mit Innengewinde und V-Nuten (sitzt auf der Platte)
        translate([0, 0, _plate_t])
        difference() {
            cylinder(h = _boss_h, r = _boss_r);

            // Buttress-Innengewinde, identisch zum insert_boss des
            // barndoor_clamp_ring: Schraube tritt von oben ein (lokale +Z
            // nach unten), daher Schneidkörper axial um 180° gedreht.
            translate([0, 0, _boss_h + 1])
            rotate([180, 0, 0])
            buttress_threaded_rod(
                d           = _bcr_insert_dia,
                l           = _bcr_insert_depth + 1,
                pitch       = _bcr_thread_pitch,
                starts      = _bcr_thread_starts,
                internal    = true,
                bevel       = false,
                blunt_start = true,
                $slop       = _bcr_thread_slop,
                anchor      = BOTTOM
            );

            // V-Nuten auf der Stirnfläche: subtrahierte serration_diamonds,
            // damit die Zähne der Befestigungsscheibe formschlüssig eingreifen.
            translate([0, 0, _boss_h])
            serration_diamonds(_face_r_in, _face_r_out);

            // Zentrale Durchgangsbohrung durch den Boss: im unthreaded unteren
            // Bereich (unterhalb des Innengewindes) auf _bcr_insert_dia, damit
            // das Loch durchgängig bleibt — im Gewindebereich übernimmt das
            // Innengewinde selbst die (größere) Bohrung. +0.1 mm in das
            // Gewinde hinein, damit an der Übergangskante kein Artefakt entsteht.
            translate([0, 0, -1])
            cylinder(h = _boss_h - _bcr_insert_depth + 1.1, r = _bcr_insert_dia / 2);
        }

        // Verstärkungsring um die Boss-Basis, mit 45°-Fase an der oberen
        // Außenkante (Fase aufgesetzt, analog joint_ring / Rändelkopf).
        translate([0, 0, _plate_t]) {
            difference() {
                cylinder(h = _bracket_holder_reinf_height, r = _ring_r);

                translate([0, 0, -1])
                cylinder(h = _bracket_holder_reinf_height + 2, r = _boss_r - _eps);
            }

            translate([0, 0, _bracket_holder_reinf_height])
            difference() {
                cylinder(
                    h = _bracket_holder_chamfer,
                    r1 = _ring_r,
                    r2 = _ring_r - _bracket_holder_chamfer
                );

                translate([0, 0, -1])
                cylinder(h = _bracket_holder_chamfer + 2, r = _boss_r - _eps);
            }
        }

        // Ring mit Außengewinde unter der Platte (nur bei Verschraubung)
        if (_bracket_holder_connection == "screw_connection")
            holder_case_ring();
    }
}

// Barndoor-Bracket-Holder-Case: offenes Gehäuse (Boden + Wände) unterhalb der
// Holder-Platte; die Holder-Platte bildet den Deckel. Außenmaße folgen
// _bracket_holder_size_x/_y, Form folgt _bracket_holder_round (rechteckig oder
// oval). Höhe und Wandstärke sind über _bracket_holder_case_height/_wall
// konfigurierbar.
module barndoor_bracket_holder_case() {
    _z_base   = _ring_gap / 2 - _bracket_length;              // identisch zu barndoor_bracket()
    _boss_h   = _bcr_insert_boss_length + _bcr_ring_thickness;
    _plate_t  = _spotlight_material_thickness;
    _mating_z = _z_base - _bracket_mount_disc_thickness;
    // Platten-Unterkante des Holders = Oberkante des Gehäuses
    _case_top = _mating_z - _plate_t - _boss_h;

    _half_x = _bracket_holder_size_x / 2;
    _half_y = _bracket_holder_size_y / 2;
    _h      = _bracket_holder_case_height;
    _w      = _bracket_holder_case_wall;
    _align_peg_h = _spotlight_material_thickness / 2;         // Höhe der Positionier-Zylinder [mm]

    // Bohrungspositionen (identisch zum Holder, damit die Bosse exakt unter
    // den Schraubenlöchern sitzen)
    _csk_r  = _bracket_holder_mount_csk_dia / 2;
    _diag_r = 1 / sqrt(pow(cos(45) / _half_x, 2) + pow(sin(45) / _half_y, 2));

    _off_x  = min(_bracket_holder_mount_hole_offset, max(0, _half_x - _csk_r));
    _off_y  = min(_bracket_holder_mount_hole_offset, max(0, _half_y - _csk_r));
    _hole_x = _half_x - _off_x;
    _hole_y = _half_y - _off_y;

    _off_r   = min(_bracket_holder_mount_hole_offset, max(0, _diag_r - _csk_r));
    _hole_r  = max(0, _diag_r - _off_r);
    _hole_dx = _hole_r * cos(45);
    _hole_dy = _hole_r * sin(45);

    // Endpunkte der Verbindungsrippen an der Außenwand (1 mm in die Wand hinein)
    _diag_in = 1 / sqrt(pow(cos(45) / (_half_x - _w), 2) + pow(sin(45) / (_half_y - _w), 2));
    _rib_dx  = (_diag_in + 1) * cos(45);   // oval: radialer Wandpunkt auf der Diagonalen
    _rib_dy  = (_diag_in + 1) * sin(45);
    _rib_x   = _half_x - _w + 1;           // rechteckig: innerer Eckpunkt
    _rib_y   = _half_y - _w + 1;

    // Vertikaler Boss mit Durchgangsloch plus Verbindungsrippe zur Außenwand
    module screw_boss(hx, hy, ex, ey) {
        _boss_dia = _bracket_holder_mount_hole_dia + _bracket_holder_case_boss_extra;
        _hole_dia = _bracket_holder_case_boss_hole_dia;

        // Rippenlänge und -richtung (vom Boss zur Außenwand)
        _dx  = ex - hx;
        _dy  = ey - hy;
        _len = sqrt(pow(_dx, 2) + pow(_dy, 2));
        _ang = atan2(_dy, _dx);

        // Bohrung ZULETZT abziehen, damit die Rippe das Loch nicht wieder füllt
        difference() {
            union() {
                // Boss-Zylinder
                translate([hx, hy, 0])
                cylinder(h = _h, r = _boss_dia / 2);

                // Verbindungsrippe (volle Gehäusehöhe)
                translate([(hx + ex) / 2, (hy + ey) / 2, _h / 2])
                rotate([0, 0, _ang])
                cube([_len, _boss_dia, _h], center = true);
            }

            // Durchgangsloch (durch Boss und Rippenüberlapp)
            translate([hx, hy, -1])
            cylinder(h = _h + 2, r = _hole_dia / 2);
        }
    }

    translate([0, 0, _case_top - _h]) {
        difference() {
            union() {
                if (_bracket_holder_round) {
                    // Ovale Hülse: Boden + ovale Wand, oben offen
                    difference() {
                        linear_extrude(height = _h)
                        scale([_half_x, _half_y]) circle(r = 1);

                        translate([0, 0, _w])
                        linear_extrude(height = _h - _w + 1)
                        scale([_half_x - _w, _half_y - _w]) circle(r = 1);
                    }
                } else {
                    // Rechteckige Hülse: Boden + Wände, oben offen
                    difference() {
                        translate([-_half_x, -_half_y, 0])
                        cube([2 * _half_x, 2 * _half_y, _h]);

                        translate([-_half_x + _w, -_half_y + _w, _w])
                        cube([2 * _half_x - 2 * _w, 2 * _half_y - 2 * _w, _h - _w + 1]);
                    }
                }

                // Bosse unter den Schraubenlöchern (durchgehend vom Boden bis
                // zur Oberkante), jeweils über eine Rippe mit der Außenwand
                // verbunden — nur bei Verbindung per Senkkopfschrauben
                if (_bracket_holder_connection == "countersunk_screw")
                    for (sx = [-1, 1], sy = [-1, 1])
                        if (_bracket_holder_round)
                            screw_boss(sx * _hole_dx, sy * _hole_dy, sx * _rib_dx, sy * _rib_dy);
                        else
                            screw_boss(sx * _hole_x, sy * _hole_y, sx * _rib_x, sy * _rib_y);

                // Verstärkungsringe um die Boden-Löcher (innen, auf dem Boden)
                rotate([0, 0, _bracket_holder_case_bottom_hole_rotation]) {
                    for (sx = [-1, 1])
                        translate([sx * _bracket_holder_case_bottom_hole_x, 0, _w])
                        cylinder(h = _bracket_holder_case_bottom_ring_height, r = _bracket_holder_case_bottom_ring_dia / 2);

                    for (sy = [-1, 1])
                        translate([0, sy * _bracket_holder_case_bottom_hole_y, _w])
                        cylinder(h = _bracket_holder_case_bottom_ring_height, r = _bracket_holder_case_bottom_ring_dia / 2);
                }

                // Positionier-Zylinder auf der Wand-Oberseite (120° versetzt);
                // greifen in die Aufnahmelöcher des Holders ein — nur bei
                // Verbindung per Senkkopfschrauben
                if (_bracket_holder_connection == "countersunk_screw")
                    for (i = [0 : 2]) {
                        _p = bracket_holder_align_points(i);
                        translate([_p.x, _p.y, _h - 0.01])
                        cylinder(h = _align_peg_h + 0.01, r = _bracket_holder_case_align_dia / 2);
                    }

                // Zähne des Innengewindes (nur bei Verschraubung): Der
                // Gehäuse-Hohlraum wird bis zum Nenndurchmesser
                // (_thread_mating_dia/2) ausgeschnitten und schneidet damit die
                // Gewindezähne ab. Die Zähne werden deshalb hier als positives
                // Material ergänzt: Zylinderring, aus dem der Schneidkörper des
                // Innengewindes herausgeschnitten wird — übrig bleiben die
                // Zähne. 180° gedreht, da der Holder von oben eingreift
                // (analog zum Boss-Innengewinde).
                if (_bracket_holder_connection == "screw_connection")
                    translate([0, 0, _h - _thread_engagement_length])
                    difference() {
                        // +1 mm über den Gewinde-Schneidkörper hinaus, damit die
                        // Zähne fest in die Gehäusewand eingebettet sind.
                        cylinder(h = _thread_engagement_length, r = _thread_mating_dia / 2 + 2 * _thread_slop + 1);

                        translate([0, 0, _thread_engagement_length + 1])
                        rotate([180, 0, 0])
                        buttress_threaded_rod(
                            d           = _thread_mating_dia,
                            l           = _thread_engagement_length + 1,
                            pitch       = _thread_pitch,
                            starts      = _thread_starts,
                            internal    = true,
                            bevel       = false,
                            blunt_start = true,
                            $slop       = _thread_slop,
                            anchor      = BOTTOM
                        );
                    }
            }

            // Seitenloch in der +Y-Wand (x = 0), durchgängig durch die Wand.
            // Z-Position = _w + _bracket_holder_case_side_hole_z_offset
            // (0 = direkt über dem Boden).
            translate([0, _half_y - _w / 2, _w + _bracket_holder_case_side_hole_z_offset])
            rotate([90, 0, 0])
            cylinder(h = _w + 6, r = _bracket_holder_case_side_hole_dia / 2, center = true);

            // Boden-Löcher (4x auf den Achsen, durch Boden + Verstärkungsring)
            rotate([0, 0, _bracket_holder_case_bottom_hole_rotation]) {
                for (sx = [-1, 1])
                    translate([sx * _bracket_holder_case_bottom_hole_x, 0, -1])
                    cylinder(h = _w + _bracket_holder_case_bottom_ring_height + 2, r = _bracket_holder_case_bottom_hole_dia / 2);

                for (sy = [-1, 1])
                    translate([0, sy * _bracket_holder_case_bottom_hole_y, -1])
                    cylinder(h = _w + _bracket_holder_case_bottom_ring_height + 2, r = _bracket_holder_case_bottom_hole_dia / 2);
            }
        }
    }
}

// BCR-Schraube: Schraube mit Buttress-Außengewinde und Rändelkopf, passend
// zum Innengewinde in den Bossen des barndoor_clamp_ring. Der Schaft trägt
// das Außengewinde; der Kopf ist ein Zylinder mit umlaufender Rändelung
// (senkrechte Rillen) für Handbetätigung.
module barndoor_clamp_screw() {
    _shaft_length = _bcr_screw_total_length - _bcr_screw_head_height;
    _knurl_r = _bcr_screw_head_dia / 2;

    union() {
        // Schaft mit Außengewinde
        translate([0, 0, _bcr_screw_head_height])
        buttress_threaded_rod(
            d           = _bcr_insert_dia,
            l           = _shaft_length,
            pitch       = _bcr_thread_pitch,
            starts      = _bcr_thread_starts,
            internal    = false,
            bevel       = false,
            blunt_start = true,
            anchor      = BOTTOM
        );

        // Rändelkopf: Kopf-Grundkörper (Zylinder) mit aufgesetzten
        // Fasen-Kegelringen an Ober- und Unterseite, aus dem die
        // Rändel-Rillen subtrahiert werden.
        difference() {
            union() {
                // Kopf-Grundkörper: planer Zylinder, Stirnflächen oben und
                // unten bleiben glatt.
                cylinder(h = _bcr_screw_head_height, r = _knurl_r + _bcr_screw_knurl_depth);

                // Fase an der oberen Außenkante: Kegelring, der von außen
                // auf die Kante gesetzt wird. Der Innenradius entspricht dem
                // Radius des Grundkörpers minus Fasen-Höhe (45°), sodass nur
                // die scharfe Kante abgetragen wird.
                translate([0, 0, _bcr_screw_head_height])
                cylinder(
                    h = _bcr_screw_chamfer,
                    r1 = _knurl_r + _bcr_screw_knurl_depth,
                    r2 = _knurl_r + _bcr_screw_knurl_depth - _bcr_screw_chamfer
                );

                // Fase an der unteren Außenkante: Kegelring, der von außen
                // auf die untere Kante gesetzt wird.
                translate([0, 0, -_bcr_screw_chamfer])
                cylinder(
                    h = _bcr_screw_chamfer,
                    r1 = _knurl_r + _bcr_screw_knurl_depth - _bcr_screw_chamfer,
                    r2 = _knurl_r + _bcr_screw_knurl_depth
                );
            }

            // Rändel-Rillen: schmale Zylinder radial um den Kopf, die aus
            // dem Grundkörper subtrahiert werden und so Vertiefungen zwischen
            // den stehenbleibenden Rippen erzeugen.
            for (i = [0 : _bcr_screw_knurl_count - 1]) {
                _angle = i * 360 / _bcr_screw_knurl_count;
                rotate([0, 0, _angle])
                translate([_knurl_r + _bcr_screw_knurl_depth, 0, -1])
                cylinder(h = _bcr_screw_head_height + 2, r = _bcr_screw_knurl_depth);
            }
        }
    }
}

// Hohle BCR-Schraube: identisch zur barndoor_clamp_screw, aber mittig mit
// einem Durchgangsloch (Durchmesser _bcr_screw_hole_dia) entlang der Z-Achse
// durchbohrt — z.B. für eine Kabeldurchführung durch die Schraube.
module barndoor_clamp_screw_hollow() {
    difference() {
        barndoor_clamp_screw();

        // Durchgangsloch über die volle Schraubenhöhe
        translate([0, 0, -_bcr_screw_chamfer - 1])
        cylinder(h = _bcr_screw_total_length + 2 * _bcr_screw_chamfer + 2, r = _bcr_screw_hole_dia / 2);
    }
}

// Lichtgehäuse: Hohlzylinder mit Fassungs-Aussparungen und dem männlichen
// Gewinde-Gegenstück, in das der Kranz von cable_connection() eingeschraubt
// wird.
module light_fixture() {

    difference() {

        // === Äußerer Zylinder (Volumen des Strahlers) ==========================
        cylinder(h = _spotlight_height, r = _spotlight_radius);

        // === Innerer Hohlraum (abzüglich Wandstärke) ===========================
        // Wird vom Boden aus um eine Materialstärke versetzt, sodass der
        // Boden ebenfalls die gewünschte Wandstärke besitzt.
        translate([0, 0, _spotlight_material_thickness])
        cylinder(h = _spotlight_height, r = _spotlight_radius - _spotlight_material_thickness);

        // === Bodenbohrung für Kabel/Lampenfassung ==============================
        // Bohrung durch den Boden des Strahlers für den Kabeldurchtritt
        // und Aufnahme der Lampenfassung.
        translate([0, 0, -1])
        cylinder(h = _spotlight_material_thickness + 2, r = _spotlight_bulb_socket_radius);

        // === Flansch-Sitz für Lampenfassung ====================================
        // Vertiefung im Inneren, damit die Lampenfassung bündig oder
        // leicht versenkt sitzt.
        translate([0, 0, _spotlight_material_thickness - 2])
        cylinder(h = 3, r = _spotlight_bulb_socket_holder_radius);

    }

    // === Gegenstück (männliches Gewinde) ====================================
    // Trägt das Außengewinde auf der Passfläche (Radius = _spotlight_radius -
    // _spotlight_material_thickness), das in das Innengewinde des Kranzes
    // (siehe hollow_hemisphere()) eingeschraubt wird. Die innere Bohrung
    // bleibt als Hohlraum erhalten wie zuvor.
    color("gray")
    translate([0, 0, -_thread_engagement_length])
    difference() {
        buttress_threaded_rod(
            d           = _thread_mating_dia,
            l           = _thread_engagement_length,
            pitch       = _thread_pitch,
            starts      = _thread_starts,
            internal    = false,
            bevel       = false,
            blunt_start = true,
            anchor      = BOTTOM
        );
        translate([0, 0, -1])
        cylinder(h = _thread_engagement_length + 2, r = _spotlight_radius - _spotlight_material_thickness * 2);
    }

    // === Gegenstück oben (männliches Gewinde) ===============================
    // Spiegelbildlich zum Gegenstück unten: Trägt das Außengewinde am oberen
    // Ende des light_fixture, auf das der Kranz von barndoor_housing()
    // geschraubt wird. Anders als unten (wo die Bodenplatte samt
    // Fassungs-Aussparung für Materialüberlapp sorgt) endet die Zylinderwand
    // oben nur als dünner Ring (r = _spotlight_radius - _spotlight_material_thickness
    // bis r = _spotlight_radius); der Gewinderohling (r bis _thread_mating_dia / 2)
    // läge sonst nur tangential an, ohne echte Überlappung. Ein kurzer
    // Übergangs-Kragen in voller Wandbreite verbindet beide fest miteinander.
    // Die Innenbohrung ist dort konisch verjüngt statt abrupt gestuft (siehe
    // male_thread_boss()), damit auf der Innenseite kein scharfer,
    // rechtwinkliger Überhang entsteht.
    color("gray")
    translate([0, 0, _spotlight_height])
    male_thread_boss();

    // === Ring an der Nahtstelle zum barndoor_housing ========================
    // Endet exakt an der Nahtstelle (oberer Rand des Hauptzylinders, Beginn
    // des oberen Gewindes) und reicht von dort aus nach unten, damit er sich
    // nie mit dem Gewinde überschneidet, unabhängig von _ring_thickness.
    // Siehe _ring_gap für den Gesamtabstand zum Ring am barndoor_housing.
    color("orange")
    translate([0, 0, _spotlight_height - _ring_thickness])
    joint_ring(r = _spotlight_radius);

}

// translate([0, 0, 110])
// cube([100, 100, 40  ], center = true);

// color("orange")
// translate([0, 0, 135])
// cube([100, 100, 10  ], center = true);

// Barndoor-Gehäuse: rohrförmiger Aufsatz, der oben auf dem light_fixture
// sitzt (gleicher Außendurchmesser und gleiche Wandstärke), z.B. zur
// Aufnahme von Barndoors / Streulichtblenden. Wird über eine Gewinde-
// verbindung (Kranz am unteren Ende, analog zu cable_connection) auf das
// obere Gegenstück von light_fixture() geschraubt. Am oberen Ende bleibt
// das Rohr offen.
module barndoor_housing() {
    female_thread_socket(length = _barndoor_housing_length);

    // === Ring an der Nahtstelle zum light_fixture ===========================
    // Der Abstand der beiden Ringe zueinander soll insgesamt _ring_gap
    // betragen. Zwischen der Unterkante des barndoor_housing und dem Ring am
    // light_fixture liegt jedoch noch der Übergangs-Kragen (Kragen des
    // male_thread_boss, Höhe = _spotlight_material_thickness), auf dem das
    // barndoor_housing im verschraubten Zustand aufsitzt. Dieser Kragen ist
    // Teil des Gesamtabstands _ring_gap und wird daher hier abgezogen, damit
    // Ring-Oberkante(light_fixture) <-> Ring-Unterkante(barndoor) exakt
    // _ring_gap sind. chamfer_top = true dreht die Schräge auf die dem
    // light_fixture abgewandte (obere) Seite, sodass die flache Unterseite
    // dieses Rings dem light_fixture-Ring zugewandt ist.
    color("orange")
    translate([0, 0, _ring_gap - _spotlight_material_thickness])
    joint_ring(r = _spotlight_radius, chamfer_top = true);
}

// Kabelanschluss: ausgehöhlte Halbkugel-Abdeckung mit dem weiblichen Kranz-
// Gewinde, das auf das Gegenstück von light_fixture() geschraubt wird.
// Sitzt mit der flachen Seite bündig auf der unteren (flachen) Stirnseite
// des Zylinders (z = 0) an; die Wölbung zeigt nach unten (in -z-Richtung).
// Der Außenradius entspricht exakt dem Zylinderradius, sodass beide
// Bauteile denselben Durchmesser haben. Die Wandstärke entspricht der
// Wandstärke des Hohlkörpers, sodass der Innenradius genau an den
// Hohlraum des Zylinders anschließt.
//
// WICHTIG: Nur die (rotationssymmetrische) Wölbung wird per mirror() nach
// unten gespiegelt, NICHT das Gewinde. buttress_threaded_rod() erzeugt ein
// axial asymmetrisches Sägezahnprofil (steile Flanke auf einer Seite, flache
// auf der anderen). Ein 180°-rotate() des gesamten Bauteils (wie früher
// hier verwendet) würde diese Rotation zwar die Gewinde-Händigkeit
// unangetastet lassen, aber die axiale Profil-Asymmetrie spiegeln – die
// steile Flanke läge dann auf der falschen Seite und würde nicht mehr
// komplementär zum (nie rotierten) Außengewinde an light_fixture passen.
// Deshalb bleibt das Gewinde hier unrotiert, exakt in derselben
// Orientierung (anchor = BOTTOM, lokale +z-Richtung = Welt-+z-Richtung)
// wie das Gegenstück an light_fixture.
module cable_connection() {

    // Halbkugel mit der flachen Schnittfläche in der Ebene z = 0
    // (Kugelmittelpunkt liegt in der Schnittebene), Wölbung zeigt in +z.
    // Nur lokal innerhalb von cable_connection() benötigt.
    module hemisphere(r) {
        intersection() {
            sphere(r = r);
            translate([0, 0, r / 2])
            cube([2 * r + 2, 2 * r + 2, r], center = true);
        }
    }

    // Bohrung durch die Halbkugel-Wandung, ausgerichtet entlang der
    // Radialen vom Kugelmittelpunkt (Ursprung) zum Bohrungspunkt auf der
    // Kugelaußenfläche. Der Bohrungspunkt liegt bei horizontalem Abstand
    // "offset" vom Pol (0, 0, r) entfernt; bei offset = 0 verläuft die
    // Bohrung exakt entlang der Z-Achse durch den Pol (= tiefster Punkt
    // der Wölbung nach der Montage-Drehung um 180°).
    module cable_hole(r, dia, offset = 0) {
        assert(abs(offset) < r, str("cable_hole: offset (", offset, ") muss kleiner als r (", r, ") sein, sonst liegt der Bohrpunkt außerhalb der Kugel"));
        _hole_z     = sqrt(pow(r, 2) - pow(offset, 2));
        _hole_pos   = [offset, 0, _hole_z];
        _hole_angle = atan2(offset, _hole_z);

        translate(_hole_pos)
        rotate([0, _hole_angle, 0])
        cylinder(h = r, r = dia / 2, center = true);
    }

    // Ausgehöhlte Halbkugel (Schale) mit definierter Wandstärke, samt Kranz
    // (weibliches Gewinde) in einem Stück. Wölbung und Kranz-Zylinder
    // (Außenkontur) sowie die zugehörigen Hohlräume (Innenkontur) werden
    // jeweils VOR der Differenz zu einem Körper vereint. So entsteht an der
    // Nahtstelle z = 0 (Übergang Wölbung/Gewinde) kein Bauteil aus zwei
    // separat differenzierten und erst danach verklebten Hälften – das
    // vermeidet deckungsgleiche Flächen und das dadurch typische
    // Z-Fighting-Artefakt oberhalb des Gewindes. Wölbungs-Hohlraum und
    // Gewindebohrung treffen sich in der Nahtebene z = -engagement_length,
    // wo die flache Äquatorfläche der inneren Halbkugel den gesamten
    // Bohrungsquerschnitt abdeckt.
    //
    // Die Wölbung (hemisphere) wird per translate()+mirror() an die
    // Unterseite des Kranzes gesetzt, statt das gesamte Bauteil (inkl.
    // Gewinde) zu rotieren – siehe Kommentar an cable_connection() für die
    // Begründung (Rotation würde die axiale Asymmetrie des Buttress-
    // Gewindeprofils spiegeln und ein nicht passendes Gewinde erzeugen).
    module hollow_hemisphere(r, thickness, engagement_length = 30, pitch = 0, starts = 1, slop = 0, hole_dia = 0, hole_offset = 0) {
        _eps = 0.01;

        difference() {

            // === Außenkontur: Wölbung + Kranz-Zylinder ======================
            union() {
                translate([0, 0, -engagement_length])
                mirror([0, 0, 1])
                hemisphere(r = r);

                color("lightgreen")
                translate([0, 0, -engagement_length])
                cylinder(h = engagement_length, r = r);
            }

            // === Innenkontur: Kugel-Hohlraum + Gewindebohrung ===============
            // KEIN separater Verbindungs-Zylinder mehr: Die flache
            // Äquatorfläche der inneren Halbkugel (Radius r - thickness) liegt
            // exakt in der Nahtebene z = -engagement_length und deckt dort den
            // gesamten Querschnitt der Gewindebohrung ab, sodass Wölbungs-
            // Hohlraum und Gewindebohrung ohne Zwischenzylinder zu einem
            // durchgängigen Hohlraum verschmelzen.
            //
            // WICHTIG: Der frühere Verbindungs-Zylinder hatte exakt den Radius
            // r - thickness = d/2 (Außenradius des internen Gewinde-
            // Schneidkörpers). Im union() verschluckte er damit das komplette
            // Gewindeprofil – nach der difference() blieb nur eine glatte
            // Bohrung ohne erkennbares Gewinde übrig, weshalb sich der
            // Kranz nicht mit dem Gegenstück verschrauben ließ. Daher entfernt.
            union() {
                translate([0, 0, -engagement_length])
                mirror([0, 0, 1])
                hemisphere(r = r - thickness);

                // Gewinde bewusst UNROTIERT: identische Ausrichtung wie das
                // Außengewinde von light_fixture (anchor = BOTTOM, lokale
                // +z-Richtung = Welt-+z-Richtung), damit das asymmetrische
                // Buttress-Profil exakt komplementär passt.
                //
                // An BEIDEN Enden um _eps verlängert (Start _eps unter der
                // Nahtebene z = -engagement_length, Ende _eps über der Kranz-
                // Oberkante z = 0):
                //   - Oben: ohne Überstand läge die Deckfläche des Gewinde-
                //     Schneidkörpers exakt in der Ebene der Kranz-Deckfläche
                //     (z = 0) -> Artefakt oben am Modell.
                //   - Unten: ohne Überstand läge die Bodenfläche des Gewinde-
                //     Schneidkörpers exakt in der Äquatorebene der inneren
                //     Halbkugel (z = -engagement_length). Diese koinzidenten,
                //     ebenfalls subtrahierten Flächen flackern in der Vorschau
                //     und lassen das Gewinde am unteren Ende wie abgeschnitten
                //     wirken. Der _eps-Überlapp in die Halbkugel behebt das.
                // Der dadurch entstehende Phasenversatz von _eps (0.01 mm) ist
                // fürs Verschrauben (separat gedrucktes Bauteil) bedeutungslos.
                color("red")
                translate([0, 0, -engagement_length - _eps])
                buttress_threaded_rod(
                    d           = 2 * (r - thickness),
                    l           = engagement_length + 2 * _eps,
                    pitch       = pitch,
                    starts      = starts,
                    internal    = true,
                    bevel       = false,
                    blunt_start = true,
                    $slop       = slop,
                    anchor      = BOTTOM
                );

                // Kabeldurchführung: Bohrpunkt liegt auf der (gespiegelten)
                // Wölbung, daher mit derselben translate()+mirror()-Kette wie
                // die Wölbung selbst positioniert.
                if (hole_dia > 0)
                    color("red")
                    translate([0, 0, -engagement_length])
                    mirror([0, 0, 1])
                    cable_hole(r = r, dia = hole_dia, offset = hole_offset);
            }
        }
    }

    hollow_hemisphere(
        r                 = _spotlight_radius,
        thickness         = _spotlight_material_thickness,
        engagement_length = _thread_engagement_length,
        pitch             = _thread_pitch,
        starts            = _thread_starts,
        slop              = _thread_slop,
        hole_dia          = _cable_hole_dia,
        hole_offset       = _cable_hole_offset
    );
}