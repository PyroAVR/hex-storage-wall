use "common.scad";

module shure_sm58_ring(rad_top=16, depth=20, slope_angle=92, thickness=5, adapter_depth = 4, bolt_diam = 2) {


    // model parameters for the outer ring
    rad_bot = rad_top - depth*tan(90-slope_angle);
    s = (rad_top/rad_bot);
    outer_rad_top = rad_top + thickness;

    // adapter
    adapter_width = 8;
    adapter_height = 4;
    adapter_cyl_pos = [adapter_width/2, 0, 0];
    adapter_pos = [rad_top + thickness + adapter_depth/2, 0, 0];
    bolt_hole_pos = adapter_pos + adapter_cyl_pos + [-adapter_depth, 0, 0];


    // adapter
    difference() {
        translate(adapter_pos) rotate([0, -90, 0]) {
            translate([-adapter_cyl_pos.x, 0, 0]) difference() {
                hull() {
                    translate(adapter_cyl_pos) cylinder(r=adapter_width/2, h=adapter_height);
                    translate([-adapter_width/2, -adapter_width/2, adapter_height/2]) cube([adapter_width, adapter_width, adapter_height/2]);
                }
            }
        }
        translate(bolt_hole_pos) rotate([0, -90, 0]) cylinder(r=bolt_diam, h=adapter_height + 1);
    }
    // ring holder
    difference() {
        // outer shell
        rotate([180, 0, 0])
        linear_extrude(height=depth, scale=s, center=true) {
            circle(r = outer_rad_top);
        }
        // inner cavity
        rotate([180, 0, 0])
        linear_extrude(height=depth + 1, scale=s, center=true) {
            circle(r = rad_top);
        }
        translate(bolt_hole_pos) rotate([0, -90, 0]) cylinder(r=bolt_diam, h=adapter_height + thickness + 1);
        // counter-sink for bolt head
        translate(bolt_hole_pos) rotate([0, -90, 0]) cylinder(r=bolt_diam + 1, h=adapter_height + thickness + 1);
    }

}

//hex_wall_adapter();
$fn = 50;
/*rounded_inner()*/ {
    shure_sm58_ring();
}
