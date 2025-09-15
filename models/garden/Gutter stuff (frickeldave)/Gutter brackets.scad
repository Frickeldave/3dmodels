$fn=30;

module holder() {
    
    difference() {
        color("pink")
        linear_extrude(30)
        polygon(points=[
            [0,70],
            [70,75],
            [85,72],
            [85,70],
            [0,65]
        ]);

        color("red")
        translate([15, 80, 15])
        rotate([90, 0, 0])
        cylinder(h = 20, r = 2.5);

        color("red")
        translate([55, 80, 15])
        rotate([90, 0, 0])
        cylinder(h = 20, r = 2.5);
    }
}

difference() {
    union() {
        translate([-69, 76.5, -95])
        rotate([90, 0, 0])
        import ("./Gutter brackets (printables 643018)/GutterBracket.stl", convexity=3);
        
        translate([85, 6.5, 0])
        holder();
    }

    //remove the original holder nose
    color("red")
    translate([-10, 50, -1])
    cube([20, 20, 32]);

}


color("lightblue")
linear_extrude(30)
polygon(points=[
    [0,50],
    [0,55],
    [-4,56],
    [-5,56],
    [-5,58],
    [2,58],
    [2,50]
]);

color("green")
translate([74.96, 71, 6])
rotate([0, 90, 0])
cylinder(h=12.02, r =3);

color("green")
translate([74.96, 71, 24])
rotate([0, 90, 0])
cylinder(h=12.02, r =3);