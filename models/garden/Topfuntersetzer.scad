// ============================================================
//  Square plant pot saucer
// ============================================================
//  Outer wall tapered outward (classic bowl shape):
//  the body widens upward by _rim_taper per side.
//  _inner_size is the inner dimension at the bottom.
// ============================================================

// --- Parameters -------------------------------------------
_inner_size          = 220;  // Inner dimension (width = depth) at bottom [mm]
_total_height        = 20;   // Total height [mm]
_base_thickness      = 3;    // Base/floor thickness [mm]
_wall_thickness      = 4;    // Wall thickness [mm]
_rim_taper           = 4;    // Outward taper per side towards top [mm]
_corner_radius       = 12;   // Inner corner radius at bottom [mm]

_drain_holes         = false; // Drain holes on/off
_drain_hole_d        = 8;    // Drain hole diameter [mm]
_drain_hole_grid     = 3;    // Number of holes per axis (e.g. 3 = 3×3 grid)
_drain_hole_spacing  = 25;   // Hole spacing [mm]

$fn = 64;

// --- Computed variables -----------------------------------
// Outer size and radius at bottom
_outer_size_bottom       = _inner_size + 2 * _wall_thickness;
_outer_corner_radius     = _corner_radius + _wall_thickness;

// Outer size and radius at top
_outer_size_top          = _outer_size_bottom + 2 * _rim_taper;
_outer_corner_radius_top = _outer_corner_radius + _rim_taper;

// Inner size and radius at top (follows same taper as outer wall)
_inner_size_top          = _outer_size_top - 2 * _wall_thickness;
_inner_corner_radius_top = max(_outer_corner_radius_top - _wall_thickness, 1);

// Small epsilon to avoid z-fighting in difference()
_eps = 0.01;

// --- Helper: rounded square (2D, centered) ----------------
module rounded_sq(w, r) {
    hull() {
        for (x = [-(w/2 - r), (w/2 - r)])
            for (y = [-(w/2 - r), (w/2 - r)])
                translate([x, y]) circle(r = r);
    }
}

// --- Main body --------------------------------------------
difference() {

    // Outer body: hull between bottom and top layer
    hull() {
        linear_extrude(_eps)
            rounded_sq(_outer_size_bottom, _outer_corner_radius);
        translate([0, 0, _total_height - _eps])
            linear_extrude(_eps)
                rounded_sq(_outer_size_top, _outer_corner_radius_top);
    }

    // Inner cavity: starts at base thickness, extends 1 mm above top
    translate([0, 0, _base_thickness])
        hull() {
            linear_extrude(_eps)
                rounded_sq(_inner_size, _corner_radius);
            translate([0, 0, _total_height - _base_thickness + 1 - _eps])
                linear_extrude(_eps)
                    rounded_sq(_inner_size_top, _inner_corner_radius_top);
        }

    // Drain holes (optional)
    if (_drain_holes) {
        _half = floor(_drain_hole_grid / 2);
        for (ix = [-_half : _half], iy = [-_half : _half]) {
            translate([ix * _drain_hole_spacing, iy * _drain_hole_spacing, -_eps])
                cylinder(d = _drain_hole_d, h = _base_thickness + 2 * _eps);
        }
    }
}
