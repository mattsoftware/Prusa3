$fn = 30;
bolt_hole = 8;
length = 12;
top_width = 14;
bottom_width = 20;
bottom_gap_depth =1;

difference() {
    cylinder(d2 = top_width, d1 = bottom_width, h = length);
    translate([0,0,-0.01]) cylinder(d = bolt_hole, h = length + 0.02);
    #translate([0,0,-0.01]) cylinder(d = top_width, h = bottom_gap_depth + 0.01);
}

