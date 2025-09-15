// Gartenschild mit Stecker und Schriftzug "Tomate"
$fn = 100;
// Parameter
width = 100;        // Breite des Schildes in mm
height = 40;        // Höhe des Schildes in mm
thickness = 2;      // Dicke des Schildes in mm
corner_radius = 4;  // Radius der abgerundeten Ecken in mm
plug_length = 80;   // Länge des Steckers in mm
plug_width = 20;    // Breite des Steckers in mm
text_size = ###GardensignFontsize###;     // Schriftgröße in mm
text_on_sign = ###GardensignText###;

// Modul für abgerundetes Rechteck
module rounded_rect(width, height, radius, thickness) {
    hull() {
        // Vier Kreise für die abgerundeten Ecken
        translate([radius, radius, 0])
            cylinder(h=thickness, r=radius, $fn=50);
        translate([width-radius, radius, 0])
            cylinder(h=thickness, r=radius, $fn=50);
        translate([radius, height-radius, 0])
            cylinder(h=thickness, r=radius, $fn=50);
        translate([width-radius, height-radius, 0])
            cylinder(h=thickness, r=radius, $fn=50);
    }
}

// Hauptmodul für das Schild
module garden_sign() {
    // Schildfläche
    rounded_rect(width, height, corner_radius, thickness);
    
    // Schriftzug "Tomate"
    translate([width/2, height/2, thickness])
    linear_extrude(height=1) // 1 mm Extrusion für 3D-Schrift
    text(text_on_sign, size=text_size, font="Arial:style=Bold", halign="center", valign="center");

    // Umrandung
    color("blue")
    translate([0, 0, thickness])
    difference() {
        rounded_rect(width, height, corner_radius, 2);
        translate([2, 2, -1])
        rounded_rect(width - 4, height - 4, corner_radius, 4);
    }

    // Stecker
    union() {
        translate([width/2 - plug_width/2, 0, 0])
        hull() {
            // Rechteckiger Teil des Steckers
            cube([plug_width, 1, thickness]);
            // Spitze des Steckers
            translate([plug_width/2, -plug_length-1, 0])
                cylinder(h=thickness, r=1, $fn=50);
        }

        color("pink")
        translate([width/2 - 1, -plug_length + 10, 2])
        cube([2, plug_length - 10, thickness]);

        color("red")
        translate([width/2 - 1, -plug_length + 10, thickness])
        rotate([0, 90, 0])
        cylinder(h=2, d=4);

    }
}

// Schild rendern
garden_sign();