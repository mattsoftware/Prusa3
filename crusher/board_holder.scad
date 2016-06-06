include <../box_frame/inc/functions.scad>;
include <../box_frame/inc/metric.scad>;

bolt_size = 3;
bolt_length = 10;
board_length = 123;
board_width = 53;
board_depth = 2;
board_under_clearance = 3;
pad_size = 10;
base_height = bolt_length - board_depth + 2;

holes = [
    [5,5],
    [48,5],
    [5,118],
    [48,118]
];

support_size = 7;
screw_holes_from_side = 7;

module orange_knob() {
    difference() {
        cube([board_length, board_width, board_depth]);
        for (i = [0:3]) {
            translate([holes[i][1],holes[i][0],-0.01]) cylinder(d=3, h=board_depth+0.02, $fn=30);
        }
    }
}

module bolts(extra=0, extra_length=0) {
    $fn = 30;
    length = bolt_length + extra_length;
    diam = bolt_size + extra;
    for (i = [0:1]) {
        translate([holes[i][1],holes[i][0],-length]) {
            translate([0,0,length]) cylinder(d=5, h=2.5);
            cylinder(d=diam, h=length);
        }
    }
}
module bolt_pads() {
   for (i = [0:3]) {
        translate([holes[i][1],holes[i][0],base_height/2]) {
            difference() {
                cube([pad_size,pad_size,base_height], center=true);
                translate([0,0,-1]) {
                    cylinder(d=m3_nut_diameter_horizontal, h=m3_nut_height, $fn=6);
                    translate([0, -(m3_nut_diameter_horizontal-1)/2, 0]) cube([20, m3_nut_diameter_horizontal-1, m3_nut_height]);
                }
            }
        }
    }
}
module bottom_hook(no_side_wall = false) {
    wall_width = 3;
    hook_height = base_height + 5;
    side_wall = no_side_wall ? 0 : wall_width;
    translate([board_length-pad_size,-side_wall,0]) {
        difference() {
            cube([pad_size+wall_width,pad_size+side_wall,hook_height]);
            translate([pad_size-0.01,pad_size+side_wall+0.01,base_height]) {
                rotate([0,0,180]) {
                    difference() {
                        hull() {
                            cube([pad_size+0.01,pad_size+0.02,board_depth]);
                            rotate([0,-5,0]) cube([pad_size+1,pad_size+0.02,board_depth]);
                        }
                        translate([-1,-0.01,0]) cube([1,pad_size+0.04,board_depth+1]);
                    }
                }
            }
        }
    }
}

module base_cutout(height) {
    // cutout
    cutout_offset = [pad_size, pad_size];
    translate([cutout_offset[1],cutout_offset[0],-0.01]) {
        cube([
            board_length-cutout_offset[1]*2,
            board_width-cutout_offset[0]*2,
            height+0.02
        ]);
    }
}
module x_support(height) {
    linear_extrude(height) {
        polygon(points = [
            [0,support_size],
            [board_length-support_size,board_width],
            [board_length,board_width-support_size],
            [support_size,0],
        ]);
        polygon(points = [
            [0,board_width-support_size],
            [board_length-support_size,0],
            [board_length,support_size],
            [support_size,board_width]
        ]);
    }
}
module screw_holes() {
    rotate([180,0,0]) {
        translate([0,0,-16]) {
            translate([15,0,0]) {
                translate([0,-screw_holes_from_side,0]) plate_screw();
                translate([0,-board_width+screw_holes_from_side,0]) plate_screw();
            }
            translate([board_length-15,0,0]) {
                translate([0,-screw_holes_from_side,0]) plate_screw();
                translate([0,-board_width+screw_holes_from_side,0]) plate_screw();
            }
        }
    }
}
module base() {
    height = (base_height - board_under_clearance)/2;
    difference() {
        union() {
            difference() {
                union() {
                    cube([board_length, board_width, height]);
                    bolt_pads();
                    bottom_hook();
                    translate([0,board_width-pad_size,0]) bottom_hook(true);
                }
                translate([0,0,base_height+board_depth]) bolts(0.5,board_depth+0.01);
                base_cutout(height);

            }
            x_support(height);
        }
        screw_holes();
    }
}


%orange_knob();
%translate([0,0,board_depth]) bolts();
translate([0,0,-base_height]) base();

