// PRUSA iteration3
// Complete printer visualisation
// GNU GPL v3
// Greg Frost
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/josefprusa/Prusa3

include <../../configuration.scad>
use <../../x-end.scad>
use <../../x-carriage.scad>

board_sides=50;
board_w=bed_x_size+10+2*board_sides;

// X ends
translate([-board_w/2+4,-26,200])
rotate([0,0,90])
rotate([0,180,0])
x_end_motor();

translate([board_w/2-4,-26,200])
rotate(90)
rotate([0,180,0])
x_end_idler();

// X rods
for(i=[0:1])
color("MediumBlue")
translate([0,-12,149+i*45])rotate([0,90,0])cylinder(h=300,r=4,center=true);

// X carriage
translate([0,-12,149])
rotate([0,90,0])
x_carriage();

