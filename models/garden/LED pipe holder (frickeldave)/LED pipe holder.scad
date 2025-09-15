$fn = 100;

_inner_size_radius=7; //7=LED pipe holder


difference() {
    
    union() {
        difference() {
            cylinder(h=15, r=_inner_size_radius+2);
            translate([0, 0, -1])
            cylinder(h=17, r=_inner_size_radius);

            color("red")
            translate([0, 0, -1])
            cube([9, 10, 17]); 
        }


        color("pink")
        translate([7, 0, 0])
        cube([2, 20, 15]);

        color("lightgreen")
        translate([0, 7, 0])
        cube([5, 2, 15]);

        color("lightblue")
        translate([3, 7, 0])
        cube([2, 13, 15]);

        color("lightgrey")
            linear_extrude(15)
            polygon(points=[
                [0,9],
                [3,9],
                [3,12],
                [0,9]
            ]);
    }

    color("red")
    translate([0, 15, 7.5])
    rotate([90, 0, 90])
    cylinder(h=20, r=1);

}