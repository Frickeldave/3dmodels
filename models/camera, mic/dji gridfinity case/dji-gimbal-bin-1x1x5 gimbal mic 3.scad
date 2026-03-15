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

include <../../../../../gridfinity-rebuilt-openscad/src/core/standard.scad>
use <../../../../../gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <../../../../../gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <../../../../../gridfinity-rebuilt-openscad/src/core/bin.scad>
use <../../../../../gridfinity-rebuilt-openscad/src/core/cutouts.scad>
use <../../../../../gridfinity-rebuilt-openscad/src/helpers/generic-helpers.scad>
use <../../../../../gridfinity-rebuilt-openscad/src/helpers/grid.scad>
use <../../../../../gridfinity-rebuilt-openscad/src/helpers/grid_element.scad>
use <../../../../../gridfinity-rebuilt-openscad/src/helpers/generic-helpers.scad>

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
gridz = 5; //.1

// Half grid sized bins.  Implies "only corners".
half_grid = false;

/* [Height] */
// How "gridz" is used to calculate height.  Some exclude 7mm/1U base, others exclude ~3.5mm (4.4mm nominal) stacking lip.
gridz_define = 0; // [0:7mm increments - Excludes Stacking Lip, 1:Internal mm - Excludes Base & Stacking Lip, 2:External mm - Excludes Stacking Lip, 3:External mm]
// Overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
height_internal = 15;
// snap gridz height to nearest 7mm increment
enable_zsnap = false;
// If the top lip should exist.  Not included in height calculations.
include_lip = true;

/* [Compartments] */
// number of X Divisions (set to zero to have solid bin)
divx = 0;
// number of Y Divisions (set to zero to have solid bin)
divy = 0;
// Leave zero for default. Units: mm
depth = 0;  //.1

/* [Cylindrical Compartments] */
// Use this instead of bins
cut_cylinders = false;
// diameter of cylindrical cut outs
cd = 1; // .1
// chamfer around the top rim of the holes
c_chamfer = 0.5; // .1

/* [Compartment Features] */
// the type of tabs
style_tab = 5; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]
// which divisions have tabs
place_tab = 0; // [0:Everywhere-Normal,1:Top-Left Division]
// scoop weight percentage. 0 disables scoop, 1 is regular scoop. Any real number will scale the scoop.
scoop = 1; //[0:0.1:1]

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

// ===== IMPLEMENTATION ===== //

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

difference() {
    bin_render(bin1) {
        bin_subdivide(bin1, [divx, divy]) {
            depth_real = cgs(height=depth).z;
            if (cut_cylinders) {
                cut_chamfered_cylinder(cd/2, depth_real, c_chamfer);
            } else {
                cut_compartment_auto(
                    cgs(height=depth),
                    style_tab,
                    place_tab != 0,
                    scoop
                );
            }
        }
    }
    
    // DJI Mic 3 Sender
    translate([-106, -120, 4])
    linear_extrude(height = 50)
    scale([1.0, 1.0, 1.0])
    import("dji-gimbal-mic.svg");

}


