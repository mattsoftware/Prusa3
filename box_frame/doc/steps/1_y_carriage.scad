// PRUSA iteration3
// Complete printer visualisation
// GNU GPL v3
// Greg Frost
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/josefprusa/Prusa3

include <../../configuration.scad>
use <../../y-drivetrain.scad>
use <../../y-axis-corner.scad>

module nutwasher(){
	color("silver")
	difference(){
		union(){
			translate([0,0,2])cylinder(r=15/2,h=7,$fn=6);
			translate([0,0,0.5])cylinder(r=8.5,h=1);
		}
		translate([0,0,-1])cylinder(r=8/2,h=12);		
	}
}

// y motor mount
translate([56-yrodseparation/2,-y_smooth_rod_length/2+9,0]) 
{
	rotate([0,90,0]) rotate([0,0,90]) motorholder();
	translate([10,0,30])rotate([0,90,0])nutwasher();
	translate([0,0,30])rotate([0,90,180])nutwasher();
	translate([10,0,10])rotate([0,90,0])nutwasher();
	translate([0,0,10])rotate([0,90,180])nutwasher();
}

// y idler mount
translate([70-yrodseparation/2,y_smooth_rod_length/2-9,30]) 
{
	translate([0,0-33,-8]) 
	rotate([0,-90,0]) idlermount();
	translate([0,0,0])rotate([0,90,0])nutwasher();
	translate([-20,0,0])rotate([0,90,180])nutwasher();
}

yrodseparation=100;

module yfront()
{
	// corners
	leftfront();
	translate([yrodseparation,0,0]) mirror([1,0,0]) leftfront();

	// front bottom threaded rod
	color("Aqua")
	translate([-20,9,10]) rotate([0,90,0]) cylinder(h = 140, r=4);

	translate([yrodseparation+11,9,10])rotate([0,90,0])nutwasher();
	translate([yrodseparation-11,9,10])rotate([0,90,180])nutwasher();

	translate([-11,9,10])rotate([0,90,180])nutwasher();
	translate([11,9,10])rotate([0,90,0])nutwasher();
	
	// front top threaded rod
	color("Aqua")
	translate([-20,9,30]) rotate([0,90,0]) cylinder(h = 140, r=4);

%	translate([-11,9,30])rotate([0,90,180])nutwasher();
%	translate([11,9,30])rotate([0,90,0])nutwasher();

%	translate([yrodseparation-11,9,30])rotate([0,90,180])nutwasher();
%	translate([yrodseparation+11,9,30])rotate([0,90,0])nutwasher();
}

translate([-yrodseparation/2,-y_smooth_rod_length/2])
{
yfront();
translate([0,y_smooth_rod_length,0]) 
mirror([0,1,0])
yfront();
}

module yside()
{
	translate([-yrodseparation/2,0])
	{
	// left top rod
	color("MediumBlue")
	translate([0,0,45]) rotate([0,90,90]) cylinder(h = y_smooth_rod_length, r=4,center=true);
	//left bottom rod
	color("Aqua")
	translate([0,0,20]) rotate([0,90,90]) cylinder(h = 430, r=4,center=true);
	// middle nuts
	translate([0,0,20])rotate([0,-90,90])nutwasher();
	translate([0,board_thickness,20])rotate([0,90,90])nutwasher();

	// back nuts
	translate([0,y_smooth_rod_length/2+2,20])rotate([0,90,90])nutwasher();
	translate([0,y_smooth_rod_length/2+2-22,20])rotate([0,90,-90])nutwasher();
	// front nuts
	translate([0,-y_smooth_rod_length/2-2,20])rotate([0,90,-90])nutwasher();
	translate([0,-y_smooth_rod_length/2-2+22,20])rotate([0,90,90])nutwasher();
	}
}

yside();
translate([yrodseparation,0,0])yside();

