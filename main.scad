

// Render selection: "both", "bottom", "top", or "assembly"
part = "both"; // [both, bottom, top, assembly]

// --- Parameters ---
wall = 2.0;               // Uniform wall thickness (mm)[cite: 5]
clearance = 0.5;          // Internal fit clearance (mm)
tolerance = 0.25;         // Clamshell lip tolerance (mm)

// PCB Dimensions & Placement
pcb_w = 35.0;             // PCB X width
pcb_l = 42.0;             // PCB Y length
pcb_t = 1.595;            
standoff_h = 3.0;          
pcb_z = standoff_h;       

// Enclosure Inner Dimensions
in_w = pcb_w + 2 * clearance;
in_h = pcb_l + 2 * clearance;
bottom_depth = standoff_h + pcb_t + 5.0; 
top_depth = 20.0;         

boss_d = 6.5;             
m3_hole_d = 3.2;          
insert_hole_d = 4.2;      
insert_depth = 5.7;


origin_x = 155.0;
origin_y = -115.0;

function local_x(x) = x - origin_x;
function local_y(y) = y - origin_y;

j1_pos = [local_x(157.5), local_y(-82.5)];
sw1_pos = [local_x(157.75), local_y(-108.75)];
sw2_pos = [local_x(177.0), local_y(-111.5)];
sw3_pos = [local_x(170.5), local_y(-111.5)];

$fn = 60;


if (part == "bottom" || part == "both" || part == "assembly") {
    translate([0, 0, 0])
        bottom_shell();
}

if (part == "top" || part == "both" || part == "assembly") {
    translate([0, 0, (part == "both") ? (bottom_depth + 15) : 0])
        top_shell();
}

if (part == "assembly") {
    %pcb_assembly();
}




module bottom_shell() {
    outer_w = in_w + 2 * wall;
    outer_l = in_h + 2 * wall;
    
    difference() {
        union() {
            // Main Body Shell
            translate([-wall, -wall, 0])
                cube([outer_w, outer_l, bottom_depth]);
            
            // Corner Bosses for M3 Inserts
            corner_bosses(bottom_depth);
            
            // Internal Standoffs for PCB
            pcb_standoffs();
        }
        
        // Hollow interior
        translate([0, 0, wall])
            cube([in_w, in_h, bottom_depth]);
            
        // Clamshell mating lip
        translate([-wall + tolerance, -wall + tolerance, bottom_depth - 1.5])
            cube([outer_w - 2 * tolerance, outer_l - 2 * tolerance, 1.6]);
            
        // --- Interface & Component Cutouts ---
        
        // Pin Header J1 Cutout[cite: 5]
        translate([j1_pos[0] - 1.0, in_h - wall - 0.5, pcb_z])
            cube([12.0, wall + 2.0, 10.0]);
            
        // Buttons Access / Clearance[cite: 5]
        translate([sw1_pos[0] - 3.0, sw1_pos[1] - 3.0, -1])
            cylinder(h = wall + 2, d = 6.5);
        translate([sw2_pos[0] - 3.0, sw2_pos[1] - 3.0, -1])
            cylinder(h = wall + 2, d = 6.5);
        translate([sw3_pos[0] - 3.0, sw3_pos[1] - 3.0, -1])
            cylinder(h = wall + 2, d = 6.5);
            
        // Cable entry
        translate([in_w / 2 - 5.0, -wall - 1.0, pcb_z])
            cube([10.0, wall + 2.0, 8.0]);
    }
}

module top_shell() {
    outer_w = in_w + 2 * wall;
    outer_l = in_h + 2 * wall;
    
    difference() {
        union() {
            // Main Top Shell
            translate([-wall, -wall, 0])
                cube([outer_w, outer_l, top_depth]);
            
            
            top_corner_bosses(top_depth);
        }
        
        // Hollow interior
        translate([0, 0, 0])
            cube([in_w, in_h, top_depth - wall]);
            
        // Clamshell mating lip (protrusion on top shell bottom rim)
        translate([-wall + tolerance + 0.2, -wall + tolerance + 0.2, -0.1])
            cube([outer_w - 2 * tolerance - 0.4, outer_l - 2 * tolerance - 0.4, 1.5]);
            
        // Countersunk holes for M3 screw heads on top[cite: 5]
        top_countersunk_holes(top_depth);
        
        // Ventilation slots
        for (i = [10 : 8 : in_w - 10]) {
            translate([i, in_h / 2 - 10, top_depth - wall - 1])
                cube([3.0, 20.0, wall + 2.0]);
        }
    }
}

module corner_bosses(h) {
    positions = [
        [0, 0],
        [in_w, 0],
        [0, in_h],
        [in_w, in_h]
    ];
    
    for (p = positions) {
        translate([p[0], p[1], 0])
            difference() {
                cylinder(h = h, d = boss_d);
                // M3 Heat-set insert hole[cite: 5]
                translate([0, 0, h - insert_depth])
                    cylinder(h = insert_depth + 1, d = insert_hole_d);
            }
    }
}

module top_corner_bosses(h) {
    positions = [
        [0, 0],
        [in_w, 0],
        [0, in_h],
        [in_w, in_h]
    ];
    
    for (p = positions) {
        translate([p[0], p[1], 0])
            cylinder(h = h - wall, d = boss_d);
    }
}

module top_countersunk_holes(h) {
    positions = [
        [0, 0],
        [in_w, 0],
        [0, in_h],
        [in_w, in_h]
    ];
    
    for (p = positions) {
        translate([p[0], p[1], 0]) {
            // Through hole for M3 screw[cite: 5]
            translate([0, 0, -1])
                cylinder(h = h + 2, d = m3_hole_d);
            // Countersink head recess[cite: 5]
            translate([0, 0, h - 3.0])
                cylinder(h = 4.0, d1 = m3_hole_d, d2 = 6.0);
        }
    }
}

module pcb_standoffs() {
    margin = 3.0;
    standoff_w = 4.5;
    
    positions = [
        [margin, margin],
        [pcb_w - margin - standoff_w, margin],
        [margin, pcb_l - margin - standoff_w],
        [pcb_w - margin - standoff_w, pcb_l - margin - standoff_w]
    ];
    
    for (p = positions) {
        translate([p[0], p[1], 0])
            difference() {
                cube([standoff_w, standoff_w, standoff_h]);
                translate([standoff_w/2, standoff_w/2, -1])
                    cylinder(h = standoff_h + 2, d = 2.2);
            }
    }
}

module pcb_assembly() {
    
    color("green", 0.8)
    translate([clearance, clearance, pcb_z])
        cube([pcb_w, pcb_l, pcb_t]);
        
    // Pin Header J1[cite: 5]
    color("black")
    translate([j1_pos[0], j1_pos[1], pcb_z + pcb_t])
        cube([10.16, 2.54, 8.5]);
        
    // Buttons[cite: 5]
    color("silver") {
        translate([sw1_pos[0] - 3, sw1_pos[1] - 3, pcb_z + pcb_t])
            cube([6, 6, 4.3]);
        translate([sw2_pos[0] - 3, sw2_pos[1] - 3, pcb_z + pcb_t])
            cube([6, 6, 4.3]);
        translate([sw3_pos[0] - 3, sw3_pos[1] - 3, pcb_z + pcb_t])
            cube([6, 6, 4.3]);
    }
}
