module insert_empty() {
    translate([-56.25, -123.8, 0]) import("insert-empty.stl");
}

module insert_m4() {
    translate([-138.9, -118.225, 0]) import("insert-m4.stl");
}

module hsw_cell() {
    rotate([0, 0, 360/12]) difference() {
        // outer shell
        cylinder(r=14, h=8, center=true, $fn=6);
        // inner (thick) shell
        cylinder(r=12, h=9, center=true, $fn=6);
        // inner (thin) shell
        translate([0, 0, 2]) cylinder(r=13, h=3, $fn=6);
    }
}

function trapezoid_overhang_size(small_edge_size, height, angle) =  small_edge_size + height*tan(90-angle);

function hex_side_len(radius) = 2*radius*sin(30);

// half of the height of the largest square inscribed in a hexagon: offset from radius to edge (not vertex)
function hex_height(radius) = radius*sin(60);

function hsw_cell_offset(row, col, radius=14, gapx=0, gapy=0) = [
    ((row % 2 == 0) ? 0:hex_height(radius) + gapx/2) + (col * (2*hex_height(radius) + gapx)),
    row*((3/2)*radius + gapy),
    0
];

module hsw_tesselate(rows, cols) {
    for(i = [0:2*rows-1], j = [0:cols-1]) {
        // two radii
        translate(hsw_cell_offset(i, j)) hsw_cell();
    }
}

module rounded_inner(radius=0.25, $fn=25) {
    minkowski() {
        translate([radius, radius, radius]) sphere(r=radius);
        children();
    }
}
// from openscad tips and tricks
module bbox() { 

    // a 3D approx. of the children projection on X axis 
    module xProjection() 
        translate([0,1/2,-1/2]) 
            linear_extrude(1) 
                hull() 
                    projection() 
                        rotate([90,0,0]) 
                            linear_extrude(1) 
                                projection() children(); 
  
    // a bounding box with an offset of 1 in all axis
    module bbx()  
        minkowski() { 
            xProjection() children(); // x axis
            rotate(-90)               // y axis
                xProjection() rotate(90) children(); 
            rotate([0,-90,0])         // z axis
                xProjection() rotate([0,90,0]) children(); 
        } 
    
    // offset children() (a cube) by -1 in all axis
    module shrink()
      intersection() {
        translate([ 1, 1, 1]) children();
        translate([-1,-1,-1]) children();
      }

   shrink() bbx() children(); 
}

module test_tesselate() {
translate([-54.75, -73.2, 0]) import("/home/andy/Downloads/wall-honeycomb-224x190size(mk3s).stl");
radius = 13.5;
gapx = 0.2;
gapy = 0.2;
rows = 10;
cols = 9;
for(i = [0:rows-1], j = [0:cols-1]) {
    translate(hsw_cell_offset(i, j, radius=radius, gapx=gapx, gapy=gapy)) rotate([0, 0, 30]) {text(str(i*rows + j)); color("red") cylinder(r=radius, $fn=6);}
}
}
