// ========================================================
// DripLogic NODE_WATERING - Simple Slide-In Mount Version
// ========================================================

// --- PARAMETERS ---
box_length = 75;
box_width = 55;
box_height = 30;
wall_thickness = 2.5;
corner_radius = 4.0;

// Bottle & Vacuum-Break Parameters
bottle_neck_dia = 28.0; 
bottle_collar_dia = 38.0;
bottle_collar_height = 16.0;

// Simple Slide Mount Parameters
rail_width = 24.0;
rail_depth = 3.0;

// --- HELPER MODULES ---
module rounded_box(l, w, h, r) {
    hull() {
        for (x = [r, l - r]) {
            for (y = [r, w - r]) {
                translate([x, y, 0])
                    cylinder(r=r, h=h, $fn=60);
            }
        }
    }
}

// --- INTERNAL PCB STANDOFFS (2mm holes) ---
module standoffs() {
    post_offset = 6;
    post_radius = 3.5;
    post_height = wall_thickness + 3;
    
    positions = [
        [post_offset, post_offset],
        [box_length - post_offset, post_offset],
        [post_offset, box_width - post_offset],
        [box_length - post_offset, box_width - post_offset]
    ];
    
    for (pos = positions) {
        translate([pos[0], pos[1], wall_thickness])
            difference() {
                cylinder(r=post_radius, h=post_height, $fn=30);
                translate([0, 0, -1]) 
                    cylinder(r=1.0, h=post_height + 2, $fn=30); // 2mm PCB hole
            }
    }
}

// --- SIMPLE WALL MOUNTING BRACKET (Screwed to wall, box slides onto this) ---
module wall_mounting_bracket() {
    color("DarkGray")
    translate([box_length / 2 - rail_width / 2, -rail_depth, box_height / 4])
    difference() {
        // Simple rectangular slide tongue block
        cube([rail_width, rail_depth, box_height / 2]);
        
        // Countersunk M4 wall screw hole in the center
        translate([rail_width / 2, -1, box_height / 4])
            rotate([-90, 0, 0])
                cylinder(r=2.0, h=10, $fn=30);
    }
}

// --- ENCLOSURE BASE + SIMPLE SLIDE SLOT ---
module enclosure_base() {
    union() {
        difference() {
            rounded_box(box_length, box_width, box_height, corner_radius);

            // Internal cavity
            translate([wall_thickness, wall_thickness, wall_thickness])
                rounded_box(
                    box_length - (2 * wall_thickness), 
                    box_width - (2 * wall_thickness), 
                    box_height, 
                    corner_radius - wall_thickness
                );
                
            // J1 sensor connector port (Left)
            translate([-1, 15, wall_thickness + 2])
                cube([wall_thickness + 2, 12, 10]);
                
            // J2 power port (Right)
            translate([box_length - wall_thickness - 1, 15, wall_thickness + 2])
                cube([wall_thickness + 2, 12, 10]);
                
            // Rear thermal/wire slot
            translate([box_length / 2 - 10, box_width - wall_thickness - 1, wall_thickness + 8])
                cube([20, wall_thickness + 2, 15]);
                
            // Simple rectangular slot cut into the back wall for the slide mount
            translate([box_length / 2 - rail_width / 2, -1, box_height / 4])
                cube([rail_width, wall_thickness + 2, box_height / 2]);
        }
        
        standoffs();
    }
}

// --- ENCLOSURE LID + OPTIMIZED VACUUM-BREAK BOTTLE ADAPTER ---
module enclosure_lid() {
    color("LightGray")
    translate([0, box_width + 15, 0])
    union() {
        // Lid Base Plate
        difference() {
            rounded_box(box_length, box_width, wall_thickness, corner_radius);

            // Central water outflow port
            translate([box_length / 2, box_width / 2, -1])
                cylinder(r=8, h=wall_thickness + 2, $fn=30);

            // Ventilation louvers
            for (i = [15 : 12 : box_length - 25]) {
                translate([i, 8, -1])
                    cube([4, 12, wall_thickness + 2]);
            }
        }
        
        // Internal mating lip for snap/friction fit
        translate([wall_thickness + 0.4, wall_thickness + 0.4, -3])
            rounded_box(
                box_length - (2 * wall_thickness) - 0.8, 
                box_width - (2 * wall_thickness) - 0.8, 
                3, 
                corner_radius - wall_thickness
            );

        // 1.5L Bottle Collar with Optimized Vacuum-Break Air Channel
        translate([box_length / 2, box_width / 2, wall_thickness])
            difference() {
                cylinder(r=bottle_collar_dia / 2, h=bottle_collar_height, $fn=120);
                
                // Bottle neck inner clearance
                translate([0, 0, -1])
                    cylinder(r=bottle_neck_dia / 2, h=bottle_collar_height + 2, $fn=120);
                
                // Vacuum-break air intake channel slot
                translate([-1.5, 0, -1])
                    cube([3, bottle_collar_dia / 2, bottle_collar_height + 3]);
            }
    }
}

// --- RENDER ASSEMBLY ---
enclosure_base();
enclosure_lid();
wall_mounting_bracket();