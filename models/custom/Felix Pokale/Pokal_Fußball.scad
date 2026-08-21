// ============================================================
// Fußball_opus
// Parametrischer Fußball (Ikosaederstumpf / Truncated Icosahedron)
// mit eingeprägten Fünf- und Sechsecken.
//
// Hinweis: Parameter werden zentral in Pokal.scad gesteuert.
// Die Default-Werte in den Modulen werden nur bei direktem Öffnen
// dieser Datei verwendet (selten).
// ============================================================

// --- Includes -----------------------------------------------
include <../../../modules/scad/BOSL2/std.scad>
include <../../../modules/scad/BOSL2/polyhedra.scad>

// --- Render Settings ----------------------------------------
$fn = 96;

// --- Main Model ---------------------------------------------
// soccer_ball() wird nur ausgeführt, wenn diese Datei direkt geöffnet wird.
// Beim Einbinden über 'use <Pokal_Fußball.scad>' in Pokal.scad wird sie
// mit Parametern aufgerufen.
// --- Modules ------------------------------------------------

/**
 * @brief Halber Fußball (für Singlecolor-Modus)
 * @details Rückgabe des halbierten Fußballs mit optionaler Scheibe
 */
module half_soccer_ball(
    ball_diameter = 80,
    pentagon_scale = 0.92,
    pentagon_depth = 1.2,
    hexagon_scale = 0.92,
    hexagon_line_width = 1.4,
    hexagon_depth = 0.8,
    eps = 0.02,
    ball_scale = 0.5,
    ball_mode = 1,
    disc_enabled = true,
    disc_thickness = 3,
    disc_border = 2
) {
    _ball_radius_scaled = (ball_diameter * ball_scale) / 2;
    _disc_diameter = ball_diameter;
    
    if (ball_mode == 0) {
        // Halbierter Fußball mit Scheibe
        _disc_diameter = ball_diameter + 2 * disc_border;
        if (disc_enabled) {
            color("red")
            translate([0, -disc_thickness/2 + disc_thickness, 0])
                rotate([90, 0, 0])
                    cylinder(d = _disc_diameter, h = disc_thickness, center = true);
        }
        
        color("red")
        intersection() {
            soccer_ball(
                ball_diameter, pentagon_scale, pentagon_depth,
                hexagon_scale, hexagon_line_width, hexagon_depth, eps
            );
            // Halbierung: nur die vordere Hälfte behalten (negative Y)
            translate([0, -40, 0])
                cube([80, 80, 80], center=true);
        }
    }
    else {
        // Volle Kugel
        color("red")
        soccer_ball(
            ball_diameter, pentagon_scale, pentagon_depth,
            hexagon_scale, hexagon_line_width, hexagon_depth, eps
        );
    }
}

/**
 * @brief Scheibe hinter dem halbierten Fußball
 */
module ball_disc() {
    _ball_radius_scaled = (ball_diameter * ball_scale) / 2;
    _disc_diameter = ball_diameter + 2 * disc_border;
    
    translate([0, -disc_thickness/2 + disc_thickness, 0])
        rotate([90, 0, 0])
            cylinder(d = _disc_diameter, h = disc_thickness, center = true);
}

/**
 * @brief Hauptmodul: Kugel minus alle Prägestempel.
 * @details Pro Face wird ein "radialer Pyramidenstumpf" gebaut –
 *          ein konvexer Körper, aufgespannt zwischen dem
 *          Kugelmittelpunkt und den (skalierten) Face-Vertices,
 *          weit über die Kugel hinaus extrudiert. Geschnitten mit
 *          einer Kugelschale (Wandstärke = Prägetiefe) ergibt das
 *          eine flächige Aussparung mit konstanter Tiefe entlang
 *          der Krümmung.
 */
module soccer_ball(
    ball_diameter = 80,
    pentagon_scale = 0.92,
    pentagon_depth = 1.2,
    hexagon_scale = 0.92,
    hexagon_line_width = 1.4,
    hexagon_depth = 0.8,
    eps = 0.02
) {
    _ball_radius = ball_diameter / 2;
    _poly_vertices = regular_polyhedron_info(
        "vertices",
        "truncated icosahedron",
        or = _ball_radius
    );
    _poly_faces = regular_polyhedron_info(
        "faces",
        "truncated icosahedron",
        or = _ball_radius
    );

    difference() {
        sphere(r = _ball_radius);

        union() {
            render(convexity = 6) pentagon_stamps(ball_diameter, pentagon_scale, pentagon_depth, hexagon_scale, hexagon_line_width, hexagon_depth, eps);
            render(convexity = 6) hexagon_stamps(ball_diameter, pentagon_scale, pentagon_depth, hexagon_scale, hexagon_line_width, hexagon_depth, eps);
        }
    }
}

/**
 * @brief Alle 12 Pentagon-Stempel als ein einziges Geometrie-Objekt.
 */
module pentagon_stamps(ball_diameter = 80, pentagon_scale = 0.92, pentagon_depth = 1.2, hexagon_scale = 0.92, hexagon_line_width = 1.4, hexagon_depth = 0.8, eps = 0.02) {
    _ball_radius = ball_diameter / 2;
    _poly_vertices = regular_polyhedron_info(
        "vertices",
        "truncated icosahedron",
        or = _ball_radius
    );
    _poly_faces = regular_polyhedron_info(
        "faces",
        "truncated icosahedron",
        or = _ball_radius
    );
    intersection() {
        sphere_shell(_ball_radius, pentagon_depth, eps);
        union() {
            for (face_indices = _poly_faces) {
                if (len(face_indices) == 5) {
                    _verts = [for (i = face_indices) _poly_vertices[i]];
                    radial_cone(scale_face_vertices(_verts, pentagon_scale), _ball_radius);
                }
            }
        }
    }
}

/**
 * @brief Alle 20 Hexagon-Umrandungen als ein einziges Geometrie-Objekt.
 */
module hexagon_stamps(ball_diameter = 80, pentagon_scale = 0.92, pentagon_depth = 1.2, hexagon_scale = 0.92, hexagon_line_width = 1.4, hexagon_depth = 0.8, eps = 0.02) {
    _ball_radius = ball_diameter / 2;
    _poly_vertices = regular_polyhedron_info(
        "vertices",
        "truncated icosahedron",
        or = _ball_radius
    );
    _poly_faces = regular_polyhedron_info(
        "faces",
        "truncated icosahedron",
        or = _ball_radius
    );
    intersection() {
        sphere_shell(_ball_radius, hexagon_depth, eps);
        union() {
            for (face_indices = _poly_faces) {
                if (len(face_indices) == 6) {
                    _verts = [for (i = face_indices) _poly_vertices[i]];
                    hexagon_ring_volume(_verts, hexagon_scale, hexagon_line_width, _ball_radius);
                }
            }
        }
    }
}

/**
 * @brief Ring-Volumen (äußerer Kegel minus innerer Kegel) für eine
 *        Sechseck-Face. Wird im großen union() zusammengefasst und
 *        anschließend GEMEINSAM mit der Kugelschale geschnitten –
 *        das hält den CSG-Baum flach.
 * @param verts_3d   3D-Vertices der Face (auf der Kugel).
 * @param scale_f    Äußere Skalierung (0..1).
 * @param line_width Strichbreite der Umrandung [mm].
 * @param ball_radius  Kugelradius für radial_cone.
 */
module hexagon_ring_volume(verts_3d, scale_f, line_width, ball_radius) {
    _center      = face_center(verts_3d);
    _r_outer_avg = avg_radius(verts_3d, _center) * scale_f;
    _r_inner     = max(0.001, _r_outer_avg - line_width);
    _scale_inner = _r_inner / _r_outer_avg * scale_f;

    _outer = scale_face_vertices(verts_3d, scale_f);
    _inner = scale_face_vertices(verts_3d, _scale_inner);

    difference() {
        radial_cone(_outer, ball_radius);
        radial_cone(_inner, ball_radius);
    }
}

/**
 * @brief Dünne Kugelschale.
 */
module sphere_shell(ball_radius, depth, eps) {
    difference() {
        sphere(r = ball_radius + eps);
        sphere(r = ball_radius - depth);
    }
}

/**
 * @brief Radialer Pyramidenkegel als polyhedron(): Spitze im Ursprung,
 *        Basis-Polygon aus den nach außen verlängerten Face-Vertices.
 *        Reicht garantiert durch die Kugelschale hindurch.
 * @details Spitze = (0,0,0). Basis = jeder Vertex normalisiert und
 *          auf das 1,5-fache des Kugelradius verlängert. Die Faces des
 *          polyhedrons sind: das Basis-Polygon (in CCW-Reihenfolge von
 *          außen gesehen) plus n Dreiecks-Seitenflächen zur Spitze.
 *          Die Vertex-Reihenfolge wird so gewählt, dass die Normalen
 *          nach außen zeigen (Spitze ist Vertex 0, Basis-Vertices
 *          1..n in CCW vom Ursprung aus betrachtet).
 */
module radial_cone(verts_3d, ball_radius) {
    _r_far      = ball_radius * 1.5;
    _far_points = [for (v = verts_3d) v / norm(v) * _r_far];
    _n          = len(_far_points);

    // Sicherstellen, dass die Basis CCW (gegen den Uhrzeigersinn) von
    // AUSSEN gesehen ist. Wir prüfen das Vorzeichen des Skalarprodukts
    // zwischen Face-Normalenkandidat und Mittelpunkt der Basis.
    _v0    = _far_points[0];
    _v1    = _far_points[1];
    _v2    = _far_points[2];
    _nrm   = cross(_v1 - _v0, _v2 - _v0);
    _bc    = face_center(_far_points);
    _ccw   = (_nrm * _bc) > 0;
    _base  = _ccw
        ? _far_points
        : [for (i = [_n - 1 : -1 : 0]) _far_points[i]];

    // Vertex 0 = Spitze, Vertices 1..n = Basis
    _all_verts = concat([[0, 0, 0]], _base);

    // Basis-Face + Seitenflächen: Normalen müssen nach AUSSEN zeigen
    // (vom Kegel weg). Reihenfolge hängt davon ab, ob _base CCW oder CW
    // von außen ist.
    _base_face = _ccw
        ? [for (i = [1 : _n]) i]
        : [for (i = [_n : -1 : 1]) i];

    _side_faces = _ccw
        ? [for (i = [0 : _n - 1]) [0, 1 + i, 1 + ((i + 1) % _n)]]
        : [for (i = [0 : _n - 1]) [0, 1 + ((i + 1) % _n), 1 + i]];

    polyhedron(
        points = _all_verts,
        faces  = concat([_base_face], _side_faces),
        convexity = 4
    );
}

// --- Helper Functions ---------------------------------------

/**
 * @brief Mittelpunkt einer Face (Schwerpunkt der Vertices).
 */
function face_center(verts) =
    [for (i = [0:2]) sum_axis(verts, i) / len(verts)];

function sum_axis(verts, axis) =
    let (vals = [for (v = verts) v[axis]])
    _sum(vals, 0);

function _sum(list, i) =
    i >= len(list) ? 0 : list[i] + _sum(list, i + 1);

/**
 * @brief Mittlerer Abstand der Vertices vom angegebenen Zentrum.
 */
function avg_radius(verts, center) =
    let (dists = [for (v = verts) norm(v - center)])
    _sum(dists, 0) / len(dists);

/**
 * @brief Skaliert die Face-Vertices in 3D zum Face-Zentrum hin.
 *        scale_f = 1.0  ⇒  unverändert
 *        scale_f = 0.5  ⇒  halb so weit vom Zentrum entfernt
 */
function scale_face_vertices(verts, scale_f) =
    let (c = face_center(verts))
    [for (v = verts) c + (v - c) * scale_f];
