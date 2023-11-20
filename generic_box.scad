use <common.scad>;

di_box_width = 96;
di_box_height = 117;
di_box_depth = 42; // including rubber feet

module dual_mount_box() {
    difference() {
        scale([1.1, 1.1, 1.0]) bbox() children();
        translate([0, 0, 2])  children();
    }
}

$fn = 50;

module di_box_bb() {
    translate([0, -di_box_depth + 30, di_box_height/3 + 0.1]) cube([di_box_width*1.2, di_box_depth+5, di_box_height/3], center=true); 
}

module hex_stub(total_height=25, shank_height=15, fillet_angle=65) {
    fillet_height = total_height-shank_height;
    s = trapezoid_overhang_size(13, fillet_height, fillet_angle)/13;
    translate([0, 0, fillet_height])rotate([180, 0, 0]) linear_extrude(height=fillet_height, scale=s) circle(r=15/2, $fn=6);
    translate([0, 0, fillet_height]) cylinder(r=15/2, h=shank_height, $fn=6);

}
centerpoint = hsw_cell_offset(1, 0);
translate([-centerpoint.y, 23, 0]) rotate([90, 90, 0]) {
    translate(hsw_cell_offset(0, 0)) rotate([180, 0, 360/12]) hex_stub();
    translate(hsw_cell_offset(2, 0)) rotate([180, 0, 360/12]) hex_stub();
    translate(hsw_cell_offset(1, 1)) rotate([180, 0, 360/12]) hex_stub();
}
difference() {
    dual_mount_box() {
        cube([di_box_width, di_box_depth, di_box_height], center=true); 
    }
    di_box_bb();
}
