// ========================================================
// DripLogic NODE_WATERING - Complete Enclosure, Mount & 1.5L Bottle Adapter
// ========================================================

// Fő paraméterek
box_length = 75;
box_width = 55;
box_height = 30;
wall_thickness = 2.5;
corner_radius = 4.0;
lid_height = 5.0;

// Fali rögzítő fül paraméterek
tab_width = 12;
tab_length = 22;
tab_thickness = 3.0;
hole_radius = 2.0; // M4 csavarhoz

// 1.5L Palack tartó paraméterek (Vákuum-kompenzált légbevezetővel)
bottle_neck_dia = 28.0; 
bottle_collar_dia = 38.0;
bottle_collar_height = 16.0;

// Segédmodul: lekerekített doboz
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

// Belső NYÁK rögzítő oszlopok (4 sarok) - Updated for 2mm PCB holes
module standoffs() {
    post_offset = 6;
    post_radius = 3.5;
    post_height = wall_thickness + 3;
    
    translate([post_offset, post_offset, wall_thickness])
        difference() {
            cylinder(r=post_radius, h=post_height, $fn=30);
            translate([0, 0, -1]) cylinder(r=1.0, h=post_height + 2, $fn=30); // 2mm PCB hole
        }
        
    translate([box_length - post_offset, post_offset, wall_thickness])
        difference() {
            cylinder(r=post_radius, h=post_height, $fn=30);
            translate([0, 0, -1]) cylinder(r=1.0, h=post_height + 2, $fn=30);
        }
        
    translate([post_offset, box_width - post_offset, wall_thickness])
        difference() {
            cylinder(r=post_radius, h=post_height, $fn=30);
            translate([0, 0, -1]) cylinder(r=1.0, h=post_height + 2, $fn=30);
        }        
        
    translate([box_length - post_offset, box_width - post_offset, wall_thickness])
        difference() {
            cylinder(r=post_radius, h=post_height, $fn=30);
            translate([0, 0, -1]) cylinder(r=1.0, h=post_height + 2, $fn=30);
        }
}

// Beépített fali tartó fülek
module mounting_tabs() {
    // Bal oldali fül
    translate([-tab_width, box_width/2 - tab_length/2, 0])
        difference() {
            cube([tab_width, tab_length, tab_thickness]);
            translate([tab_width/2, tab_length/2, -1])
                cylinder(r=hole_radius, h=tab_thickness + 2, $fn=30);
        }
        
    // Jobb oldali fül
    translate([box_length, box_width/2 - tab_length/2, 0])
        difference() {
            cube([tab_width, tab_length, tab_thickness]);
            translate([tab_width/2, tab_length/2, -1])
                cylinder(r=hole_radius, h=tab_thickness + 2, $fn=30);
        }
}

// Doboz alsó rész + Fali tartó fülek
module enclosure_base() {
    union() {
        // Fő doboz test
        difference() {
            rounded_box(box_length, box_width, box_height, corner_radius);

            // Belső üreg
            translate([wall_thickness, wall_thickness, wall_thickness])
                rounded_box(
                    box_length - (2 * wall_thickness), 
                    box_width - (2 * wall_thickness), 
                    box_height, 
                    corner_radius - wall_thickness
                );
                
            // J1 csatlakozó kivágás (Bal oldalt)
            translate([-1, 15, wall_thickness + 2])
                cube([wall_thickness + 2, 12, 10]);
                
            // J2 csatlakozó kivágás (Jobb oldalt)
            translate([box_length - wall_thickness - 1, 15, wall_thickness + 2])
                cube([wall_thickness + 2, 12, 10]);
                
            // Q1 tranzisztor / D1 dióda hőleadási / szerelési nyílás hátul
            translate([box_length / 2 - 10, box_width - wall_thickness - 1, wall_thickness + 8])
                cube([20, wall_thickness + 2, 15]);
        }
        
        standoffs();
        mounting_tabs();
    }
}

// Doboz tető illesztőperemmel, szellőzéssel és 1.5L palack tartóval + légbevezető vákuum-csatornával
module enclosure_lid() {
    color("LightGray")
    translate([0, box_width + 20, 0])
    union() {
        // Tető alaplemez
        difference() {
            rounded_box(box_length, box_width, wall_thickness, corner_radius);

            // Központi vízkifolyó nyílás
            translate([box_length / 2, box_width / 2, -1])
                cylinder(r=8, h=wall_thickness + 2, $fn=30);

            // Szellőzőnyílások a tetőn
            for (i = [15 : 12 : box_length - 25]) {
                translate([i, 8, -1])
                    cube([4, 12, wall_thickness + 2]);
            }
        }
        
        // Belső illesztő perem
        translate([wall_thickness + 0.4, wall_thickness + 0.4, -3])
            rounded_box(
                box_length - (2 * wall_thickness) - 0.8, 
                box_width - (2 * wall_thickness) - 0.8, 
                3, 
                corner_radius - wall_thickness
            );

        // Külső 1.5L palack tartó csonk a tető tetején (légbevezető horonnyal a vákuum elkerülésére)
        translate([box_length / 2, box_width / 2, wall_thickness])
            difference() {
                union() {
                    cylinder(r=bottle_collar_dia / 2, h=bottle_collar_height, $fn=500);
                }
                // Palack nyak helye
                translate([0, 0, -1])
                    cylinder(r=bottle_neck_dia / 2, h=bottle_collar_height + 2, $fn=500);
                
                // Légbevezető / vákuumtörő csatorna (biztosítja, hogy a víz ki tudjon folyni)
                translate([-1.5, 0, 0])
                    cube([3, bottle_collar_dia / 2, bottle_collar_height + 2]);
            }
    }
}

// Teljes modell renderelése
enclosure_base();
enclosure_lid();
