$fn = 30;
i_am_box = 1; // fixes compilation error with functions.scad
include <../box_frame/inc/functions.scad>;

// width, height, length
power_body = [14.26, 11.78, 11.03];

// width, height, length, 3.offset to main body, 4.gap above body, 5.cosmetic angle width, 6.gap between holes
power_terminal = [10.03, 10.12, 6.10, .3, 1.23, 1.35, 0.85];
power_terminal_holes = [5.5, 4.14, 1.11];

// diameter, lenth
power_end = [10, 8.13];

middle_length = 29.62 - power_body[2] - power_end[1];

bracket_size = 15;
bracket_length = middle_length + power_body[1] + power_terminal[2]/2;
bracket_width = 3;

module plug() {
    rotate([0,180,0]) {
        rotate([-90,0,0]) cylinder(d=power_end[0], h=power_end[1]);

        middle_offset = power_end[1];

        translate([-power_end[0]/2, middle_offset, -power_end[0]/2]) {
            intersection() {
                hull() {
                    cube_size = 0.1;
                    translate([0,0,0]) sphere(cube_size);
                    translate([power_end[0],0,0]) sphere(cube_size);
                    translate([power_end[0],0,power_end[0]]) sphere(cube_size);
                    translate([0,0,power_end[0]]) sphere(cube_size);
                    x_offset = (power_body[0]-power_end[0])/2;
                    y_offset = (power_body[2]-power_end[0])/2;
                    middle_size = middle_length-cube_size+0.01;
                    translate([-x_offset,middle_size,-y_offset]) cube([cube_size,cube_size,cube_size]);
                    translate([power_end[0]+x_offset-cube_size,middle_size,-y_offset]) cube([cube_size,cube_size,cube_size]);
                    translate([-x_offset,middle_size,power_end[0]+y_offset-cube_size]) cube([cube_size,cube_size,cube_size]);
                    translate([power_end[0]+x_offset-cube_size,middle_size,power_end[0]+y_offset-cube_size]) cube([cube_size,cube_size,cube_size]);
                }
                translate([power_end[0]/2,0,power_end[0]/2]) {
                    rotate([-90, 0, 0]) {
                        cylinder(d1=power_end[0], d2=sqrt(power_body[0]*power_body[0]+power_body[1]*power_body[1]), h=middle_length+0.01);
                    }
                }
            }
        }

        power_body_offset = middle_offset + middle_length;
        translate([-power_body[0]/2,power_body_offset,-power_body[2]/2]) cube(power_body);

        power_terminal_offset = power_body_offset + power_body[1] - power_terminal[3];
        translate([-power_terminal[0]/2,power_terminal_offset,-power_body[2]/2-power_terminal[4]]) {
            difference() {
                rotate([0,90,0]) {
                    linear_extrude(power_terminal[1]) {
                        polygon(points = [
                            [0,0],
                            [-power_terminal[1],0],
                            [-power_terminal[1],power_terminal[2]],
                            [-power_terminal[1]+power_terminal_holes[0]+power_terminal[6], power_terminal[2]],
                            [0, power_terminal[2]-power_terminal[5]]
                        ]);
                    }
                }
                translate(
                    [
                        (-power_terminal_holes[1]-power_terminal[6]/2)+power_terminal[0]/2,
                        power_terminal[2]-power_terminal_holes[2]+0.01,
                        power_terminal[0]-power_terminal_holes[0]-power_terminal[6] 
                    ]
                ) {
                    rotate([-90,-90,0]) {
                        cube(power_terminal_holes);
                        translate([0,power_terminal_holes[1]+power_terminal[6],0]) cube(power_terminal_holes);
                    }
                }
            }
        }
    }
}

module bracket(scale = 1) {
    cube([power_body[0]*scale-0.1,20,power_body[1]*scale-0.1]);
    rotate([-90,0,0]) {
        linear_extrude(bracket_length*scale) {
            b_y_mid = power_body[2]*scale*2;
            b_y_h = b_y_mid + bracket_size;
            b_x_mid = power_body[1]*scale*2;
            b_x_h = b_x_mid + bracket_size;
            polygon(points = [
                [0,-power_body[2]*scale],
                [0,-b_y_h],
                [bracket_width,-b_y_h],
                [bracket_width,-b_y_mid-1],
                [b_x_mid+1, -bracket_width],
                [b_x_h, -bracket_width],
                [b_x_h, 0],
                [power_body[0]*scale, 0],
            ]);
        }
    }
}

difference() {
    scale = 1.05;
    bracket(scale);
    translate([-0.01,0,-0.01]) {
        scale(scale) {
            translate([power_body[0]/2,-power_end[1],power_body[2]/2]) {
                #plug();
            }
        }
    }
    translate([0,bracket_length*scale/2,0]) {
        translate([15,0,power_body[2]*scale*2+bracket_size/2]) {
            #rotate ([0,-90,0]) plate_screw();
        }
        translate([power_body[1]*scale*2+bracket_size/2,0,15]) {
            #rotate ([0,180,0]) plate_screw();
        }
    }
}

