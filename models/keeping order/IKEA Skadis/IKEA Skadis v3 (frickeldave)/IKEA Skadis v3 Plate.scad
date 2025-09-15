$fn=100;

hook_width = 4.5; // Hook width from the hook module
hook_height = 46; // The height of an hook
hook_spacing = 40; // Standard IKEA Skadis spacing (middle to middle)

use <./IKEA Skadis v3 hook.scad>

module ikea_skadis_backwall(_w, _h, _t, _rh) {
    
    // Set width to minimum of 50 (2 hooks are required)
    _w = _w >= 50  ? _w : 50;
    // Set height to minimum of 50 (needed to position the hooks)
    _h = _h >= 50  ? _h : 50;

    // Calculate maximum number of hooks needed based on width
    _max_hooks = floor(_w / hook_spacing);
    // Minimum 2 hooks, then add more based on available space
    _hook_count = _max_hooks < 2 ? 2 : _max_hooks;
    // Calculate the mm from the edge to the first hook
    _margin_edge = ((_w - (hook_spacing * (_hook_count - 1))) / 2) - hook_width / 2;

    // Set the first margin
    _margin = _margin_edge;

    // Just add cutouts to glue the hooks into the plate afterwards
    if(_rh == 0) {
        
        difference() {
            // create the backwall
            cube([_w, _t, _h]);

            for(i = [0 : 1 : _hook_count - 1]) {
                x_pos = _margin + i * hook_spacing;
                color("green")
                translate([x_pos - 0.1, _t - 1.95,  _h - hook_height -2 - 0.1])
                cube([hook_width + 0.2, 2, hook_height + 0.2]);
            }
        }
    }



    if(_rh == 1) {

        // create the backwall
        cube([_w, _t, _h]);

        // Position hooks along X-axis, centered vertically in Z
        for(i = [0 : 1 : _hook_count - 1]) {
            x_pos = _margin + i * hook_spacing;
            translate([x_pos, _t, _h - hook_height -2])
            ikea_skadis_holder();
        }
    }
}

ikea_skadis_backwall(100, 70, 4, 1);