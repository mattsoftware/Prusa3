// PRUSA iteration3
// Y frame brackets
// GNU GPL v3
// Josef Průša <josefprusa@me.com>
// Václav 'ax' Hůla <axtheb@gmail.com>
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/josefprusa/Prusa3

// ThingDoc entry
/**
 * @id yFrameBracket
 * @name Y Axis Frame Bracket
 * @category Printed
 */
 
include <configuration.scad>

module bolt_track(width, length, height) {
    hwidth = width / 2;
    hdiff = hwidth - height;
    union() {
        difference() {
            rotate([90, 0, 0])
                translate([hwidth, height, -length])
                cylinder(h=length, r=hwidth, $fn=$fn);

            if (height < hwidth) {
                translate([0, -1, height - hwidth - 1])
                    cube([width, length + 2, hdiff + 1]);
            }
        }
        cube([width, length, height]);
    }
}

function bracket_width(screw_area) = screw_area * 2 + y_threaded_rod_long_r * 2;
function bracket_depth(lip_thickness, screw_area) = screw_area * 2 + lip_thickness;
function bracket_height(rod_size, lip_length=0) = rod_size + 6 * layer_height  + lip_length + 1;

module yrodbracket(screw_area, lip_thickness, lip_length, bevel_size=2.0, rod_size=threaded_rod_diameter) {
    inner_radius = rod_size / 2;
    screw_center = screw_area / 2;

    width = bracket_width(screw_area);
    depth = bracket_depth(lip_thickness, screw_area);
    height = bracket_height(rod_size, lip_length);

    difference() {
        translate([0, 0, -lip_length])
            cube_fillet([width, depth, height], bevel_size, top=[2, 2, 2, 2]);
        translate([width/2-rod_size/2, -1, -lip_length-1])
            bolt_track(rod_size, depth + 2, lip_length+1+rod_size/2);

        translate([-1, lip_thickness, -lip_length - 1])
            cube([width + 2, depth, lip_length + 1]);

        // screw holes
        for (x = [screw_center, width - screw_center]) {
            for (y = [lip_thickness + screw_center, screw_area + lip_thickness + screw_center]) {
                translate([x, y, bracket_height(rod_size) + 0.1])
                    rotate([180, 0, 0])
                    screw(head_drop=3, r_head=4.5);
            }
        }
    }
}

rotate([180, 0, 0]) {
    screw_area = 18;
    lip_thickness = 5;
    lip_length = 8;
    rod_size = 8;
    //%translate([bracket_width(screw_area)/2,50,rod_size/2]) rotate([90,0,0]) cylinder(d=rod_size, h=100);
    yrodbracket(screw_area, lip_thickness, lip_length, rod_size=rod_size);
    for (x = [0, bracket_width(screw_area) + 5]) {
        for (y = [0, bracket_depth(lip_thickness, screw_area) + 5]) {
            translate([x, y, 0])
                yrodbracket(screw_area, lip_thickness, lip_length, rod_size=rod_size);
        }
    }
}

