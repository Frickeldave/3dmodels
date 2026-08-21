// ===== INFORMATION ===== //
/*
 IMPORTANT: rendering will be better in development builds and not the official release of OpenSCAD, but it makes rendering only take a couple seconds, even for comically large bins.
 the magnet holes can have an extra cut in them to make it easier to print without supports
 tabs will automatically be disabled when gridz is less than 3, as the tabs take up too much space
 base functions can be found in "gridfinity-rebuilt-utility.scad"
 comments like ' //.5' after variables are intentional and used by the customizer
 examples at end of file

 #BIN HEIGHT
 The original gridfinity bins had the overall height defined by 7mm increments.
 A bin would be 7*u millimeters tall with a stacking lip at the top of the bin (4.4mm) added onto this height.
 The stock bins have unit heights of 2, 3, and 6:
 * Z unit 2 -> 7*2 + 4.4 -> 18.4mm
 * Z unit 3 -> 7*3 + 4.4 -> 25.4mm
 * Z unit 6 -> 7*6 + 4.4 -> 46.4mm

 ## Note:
 The stacking lip provided here has a 0.6mm fillet instead of coming to a sharp point.
 Which has a height of 3.55147mm instead of the specified 4.4mm.
 This **has no impact on stacking height, and can be ignored.**

https://github.com/kennetek/gridfinity-rebuilt-openscad
*/

include <../../../modules/gridfinity/src/core/standard.scad>
use <../../../modules/gridfinity/src/core/gridfinity-rebuilt-utility.scad>
use <../../../modules/gridfinity/src/core/gridfinity-rebuilt-holes.scad>
use <../../../modules/gridfinity/src/core/bin.scad>
use <../../../modules/gridfinity/src/core/cutouts.scad>
use <../../../modules/gridfinity/src/helpers/generic-helpers.scad>
use <../../../modules/gridfinity/src/helpers/grid.scad>
use <../../../modules/gridfinity/src/helpers/grid_element.scad>
use <../../../modules/gridfinity/src/helpers/generic-helpers.scad>

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 4;
$fs = 0.25; // .01

/* [General Settings] */
// number of bases along x-axis
gridx = 1;
// number of bases along y-axis
gridy = 1;
// bin height. See bin height information and "gridz_define" below.
gridz = 3; //.1

// Half grid sized bins.  Implies "only corners".
half_grid = false;

/* [Height] */
// How "gridz" is used to calculate height.  Some exclude 7mm/1U base, others exclude ~3.5mm (4.4mm nominal) stacking lip.
gridz_define = 0; // [0:7mm increments - Excludes Stacking Lip, 1:Internal mm - Excludes Base & Stacking Lip, 2:External mm - Excludes Stacking Lip, 3:External mm]
// Overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
height_internal = 10;
// snap gridz height to nearest 7mm increment
enable_zsnap = false;
// If the top lip should exist.  Not included in height calculations.
include_lip = false;

/* [Compartments] */
// number of X Divisions (set to zero to have solid bin)
divx = 1;
// number of Y Divisions (set to zero to have solid bin)
divy = 1;
// Leave zero for default. Units: mm
depth = 0;  //.1

/* [Fixed Divider] */
// number of fixed walls running along X (positioned on Y)
divider_x_count = 0; // [0:1:12]
// thickness of X-direction walls. Units: mm
divider_x_thickness = 1.2; // .05
// number of fixed walls running along Y (positioned on X)
divider_y_count = 0; // [0:1:12]
// thickness of Y-direction walls. Units: mm
divider_y_thickness = 1.2; // .05

/* [Solid Fill Holes] */
// Cut holes into the solid fill
cut_fill_holes = true;
// Shape of the holes: 0=round, 1=hexagon (for bits)
fill_hole_shape = 0; // [0:Round, 1:Hexagon]
// Diameter of round holes in mm
fill_hole_diameter = 3.5; // .1
// Flat-to-flat width of hexagon holes in mm (1/4" bit = 6.35mm)
fill_hex_width = 8; // .1
// Number of holes in X direction
fill_holes_x = 3; // [1:20]
// Number of holes in Y direction
fill_holes_y = 3; // [1:20]
// Depth of holes in mm (0 = full depth)
fill_hole_depth = 0; // .1
// Chamfer around top rim of holes
fill_hole_chamfer = 0.9; // .1

/* [Cylindrical Compartments] */
// Use this instead of bins
cut_cylinders = false;
// diameter of cylindrical cut outs
cd = 70; // .1
// chamfer around the top rim of the holes
c_chamfer = 0.5; // .1

/* [Compartment Features] */
// the type of tabs
style_tab = 5; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]
// which divisions have tabs
place_tab = 0; // [0:Everywhere-Normal,1:Top-Left Division]
// scoop weight percentage. 0 disables scoop, 1 is regular scoop. Any real number will scale the scoop.
scoop = 0.0; //[0:0.1:1]

/* [Base Hole Options] */
// only cut magnet/screw holes at the corners of the bin to save uneccesary print time
only_corners = false;
//Use gridfinity refined hole style. Not compatible with magnet_holes!
refined_holes = false;
// Base will have holes for 6mm Diameter x 2mm high magnets.
magnet_holes = true;
// Base will have holes for M3 screws.
screw_holes = false;
// Magnet holes will have crush ribs to hold the magnet.
crush_ribs = false;
// Magnet/Screw holes will have a chamfer to ease insertion.
chamfer_holes = false;
// Magnet/Screw holes will be printed so supports are not needed.
printable_hole_top = false;
// Enable "gridfinity-refined" thumbscrew hole in the center of each base: https://www.printables.com/model/413761-gridfinity-refined
enable_thumbscrew = false;

hole_options = bundle_hole_options(refined_holes, magnet_holes, screw_holes, crush_ribs, chamfer_holes, printable_hole_top);

module cut_compartment_fixed_dividers(
    size_mm,
    wall_x_count, wall_x_thickness,
    wall_y_count, wall_y_thickness,
    scoop_percent=0
) {
    wall_x_thickness_limited = max(wall_x_thickness, 0);
    wall_y_thickness_limited = max(wall_y_thickness, 0);
    wall_x_count_int = max(0, floor(wall_x_count));
    wall_y_count_int = max(0, floor(wall_y_count));

    wall_x_max = wall_x_thickness_limited > TOLLERANCE
        ? max(0, floor((size_mm.y - TOLLERANCE) / wall_x_thickness_limited))
        : 0;
    wall_y_max = wall_y_thickness_limited > TOLLERANCE
        ? max(0, floor((size_mm.x - TOLLERANCE) / wall_y_thickness_limited))
        : 0;

    wall_x_count_limited = min(wall_x_count_int, wall_x_max);
    wall_y_count_limited = min(wall_y_count_int, wall_y_max);

    y_open_span = size_mm.y - wall_x_count_limited * wall_x_thickness_limited;
    x_open_span = size_mm.x - wall_y_count_limited * wall_y_thickness_limited;

    y_segment = wall_x_count_limited > 0 ? y_open_span / (wall_x_count_limited + 1) : size_mm.y;
    x_segment = wall_y_count_limited > 0 ? x_open_span / (wall_y_count_limited + 1) : size_mm.x;

    x_ranges = wall_y_count_limited == 0
        ? [[0, size_mm.x]]
        : [
            for (i = [0:wall_y_count_limited])
                [
                    -size_mm.x/2 + x_segment/2 + i * (x_segment + wall_y_thickness_limited),
                    x_segment
                ]
        ];

    y_ranges = wall_x_count_limited == 0
        ? [[0, size_mm.y]]
        : [
            for (i = [0:wall_x_count_limited])
                [
                    -size_mm.y/2 + y_segment/2 + i * (y_segment + wall_x_thickness_limited),
                    y_segment
                ]
        ];

    if (x_segment <= TOLLERANCE || y_segment <= TOLLERANCE || len(x_ranges) == 0 || len(y_ranges) == 0) {
        cut_compartment_auto(size_mm, 5, false, scoop_percent);
    } else {
        for (xr = x_ranges)
            for (yr = y_ranges)
                translate([xr[0], yr[0], 0])
                compartment_cutter([xr[1], yr[1], size_mm.z], scoop_percent, 0, 90);
    }
}

module cut_fill_holes_grid(size_mm, hole_d, hex_width, holes_x, holes_y, hole_depth, chamfer, shape) {
    depth_real = hole_depth > 0 ? hole_depth : size_mm.z;
    step_x = size_mm.x / holes_x;
    step_y = size_mm.y / holes_y;
    for (ix = [0:holes_x-1])
        for (iy = [0:holes_y-1])
            translate([
                -size_mm.x/2 + step_x * (ix + 0.5),
                -size_mm.y/2 + step_y * (iy + 0.5),
                0
            ])
            if (shape == 1) {
                // Hexagon (flat-to-flat = hex_width), rotated 90° so flat side faces up
                rotate([0, 0, 90])
                translate([0, 0, -depth_real])
                union() {
                    linear_extrude(depth_real)
                        circle(d=hex_width, $fn=6);
                    if (chamfer > 0)
                        // Chamfer: hull between hex at top (slightly larger) and hex at chamfer depth
                        hull() {
                            translate([0, 0, depth_real])
                            linear_extrude(0.01)
                                circle(d=hex_width + 2*chamfer, $fn=6);
                            translate([0, 0, depth_real - chamfer])
                            linear_extrude(0.01)
                                circle(d=hex_width, $fn=6);
                        }
                }
            } else {
                cut_chamfered_cylinder(hole_d / 2, depth_real, chamfer);
            }
}

// ===== IMPLEMENTATION ===== //

module gridbin() {
    bin1 = new_bin(
        grid_size = [gridx, gridy],
        height_mm = height(gridz, gridz_define, enable_zsnap),
        fill_height = height_internal,
        include_lip = include_lip,
        hole_options = hole_options,
        only_corners = only_corners || half_grid,
        thumbscrew = enable_thumbscrew,
        grid_dimensions = GRID_DIMENSIONS_MM / (half_grid ? 2 : 1)
    );

    echo(str(
        "\n",
        "Infill Dimensions*: ", bin_get_infill_size_mm(bin1), "\n",
        "Bounding Box: ", bin_get_bounding_box(bin1), "\n",
        "  *Excludes Stacking Lip Support Height (if stacking lip enabled)\n",
    ));
    echo("Height breakdown:");
    pprint(bin_get_height_breakdown(bin1));

    bin_render(bin1) {
        if (cut_fill_holes) {
            infill = bin_get_infill_size_mm(bin1);
            cut_fill_holes_grid(
                infill,
                fill_hole_diameter,
                fill_hex_width,
                fill_holes_x,
                fill_holes_y,
                fill_hole_depth,
                fill_hole_chamfer,
                fill_hole_shape
            );
        } else {
            bin_subdivide(bin1, [divx, divy]) {
                compartment_size = cgs(height=depth);
                depth_real = compartment_size.z;
                if (cut_cylinders) {
                    cut_chamfered_cylinder(cd/2, depth_real, c_chamfer);
                } else {
                    if (divider_x_count > 0 || divider_y_count > 0) {
                        cut_compartment_fixed_dividers(
                            compartment_size,
                            divider_x_count,
                            divider_x_thickness,
                            divider_y_count,
                            divider_y_thickness,
                            scoop
                        );
                    } else {
                        cut_compartment_auto(
                            compartment_size,
                            style_tab,
                            place_tab != 0,
                            scoop
                        );
                    }
                }
            }
        }
    }
}

gridbin();


