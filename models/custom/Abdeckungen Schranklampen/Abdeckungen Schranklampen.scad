$fn = 100; 


module Einsatz(){
    difference(){
        cylinder(h=12, d=73);

        translate([0,0,-2])
        cylinder(h=12, d=69);

        translate([0,0,-25]) 
        rotate([0,90,0])
        cylinder(h=135, d=73);
    }

    difference(){
    
        color("green")
        translate([0,0,-40])
        cylinder(h=40, d=73);
        
        color("red")
        translate([0,0,-41])
        cylinder(h=42, d=69);
    
    }

}

module Kanal(){

    difference(){
        translate([0,0,-25]) 
        rotate([0,90,0])
        cylinder(h=135, d=73);

        color("pink")
        translate([-2,0,-25])
        rotate([0,90,0])
        cylinder(h=138, d=69);

        color("red")
        translate([135/2,-1,-50])
        cube([137,75,100], center=true);

    }



    }



//Einsatz(); 
//color("pink")
Kanal();

// color("gray")
// translate([2,0,5])
// rotate([0,90,0])
// cylinder(h=200, d=10);
