


part = "print_plate"; // [assembly, exploded, section, base, lid, bracket, side_caddy, solenoid_holder, straight_fitting, curve_fitting, elbow90_fitting, female_fitting, female_tube_long, solenoid_adapter, solenoid_inline_valve, sprinkler_fitting, print_plate]
$fn = 64;

/* [Enclosure body] */
box_l    = 75;
box_w    = 55;
box_h    = 30;
corner_r = 4.0;
wall     = 2.5;

/* [Lid joint] */
lip_h      = 3.0;
lip_t      = 1.1;
fit_clear  = 0.20;
rib_interf = 0.10;

/* [PCB mounting] */
pcb_hole_dx     = 60;
pcb_hole_dy     = 40;
standoff_h      = 6.0;
standoff_r      = 3.5;
standoff_hole_r = 1.0;

/* [Connector and vent] */
cut_r = 1.0;
j1_w = 18; j1_h = 8; j1_y = 0; j1_z = 14;
j2_w = 12; j2_h = 9; j2_y = 0; j2_z = 14;
rs_w = 10; rs_h = 6; rs_x = 28; rs_z = 19;

/* [Dovetail slide-lock] */
dt_neck_w  = 12;
dt_h       = 5;
dt_angle   = 30;
dt_clear   = 0.25;
pad_w      = 36;
pad_t      = 8;
rail_len   = 45;
ledge_h    = 5;
br_w       = 46;
br_t       = 4;
screw_d    = 4.5;
csk_d      = 8.4;
screw_edge = 7;

/* [Bottle collar & Snorkel tube - Xixo 1.5L] */
outflow_r     = 8;
collar_od     = 40;
neck_d        = 28.5; 
collar_h      = 16;
collar_fillet = 2;
thread_on     = true;
thr_pitch     = 2.7;
thr_h         = 0.7;
thr_crest_w   = 0.6;
tube_hole_dia = 4.3;

/* [Solenoid Valve Parameters (WSV-12V 1/2")] */
valve_body_dia  = 36.0; 
valve_bracket_w = 50.0;
valve_bracket_h = 42.0;

/* [Modular Water Fittings] */
water_bore_d    = 10.0; 


eps         = 0.01;
lid_t       = wall;
floor_t     = wall;
base_h      = box_h - lid_t;
skirt_t     = wall - lip_t - fit_clear;
groove_d    = lip_h + 0.30;
pad_y0      = -box_w/2 - pad_t;
dt_head_w   = dt_neck_w + 2*dt_h*tan(dt_angle);
br_h        = ledge_h + rail_len;
thr_z0      = 0.8;
thr_top     = 1.0;
thr_up      = 0.1;


module rrect2d(l, w, r) {
    rr = max(r, 0.05);
    offset(r = rr) square([max(l - 2*rr, 0.01), max(w - 2*rr, 0.01)], center = true);
}

module outline(inset = 0) {
    rrect2d(box_l - 2*inset, box_w - 2*inset, corner_r - inset);
}

module rail_profile() {
    polygon([[-dt_neck_w/2, 0], [dt_neck_w/2, 0], [dt_head_w/2, dt_h], [-dt_head_w/2, dt_h]]);
    translate([-dt_neck_w/2, -0.5]) square([dt_neck_w, 0.5 + eps]);
}

module slot_profile(extra = 0) {
    ext = 1;
    t = tan(dt_angle);
    offset(delta = dt_clear + extra)
        polygon([[-(dt_neck_w/2 - ext*t), -ext], [dt_neck_w/2 - ext*t, -ext],
                 [dt_head_w/2, dt_h], [-dt_head_w/2, dt_h]]);
}

module dovetail_slot(len) {
    translate([0, 0, -eps]) linear_extrude(height = len + 2*eps, convexity = 4) slot_profile();
}


module standoffs() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*pcb_hole_dx/2, sy*pcb_hole_dy/2, 0])
            difference() {
                translate([0, 0, floor_t - 0.2]) cylinder(r = standoff_r, h = standoff_h + 0.2);
                translate([0, 0, floor_t]) cylinder(r = standoff_hole_r, h = standoff_h + 1);
            }
}

module mount_pad() {
    pad_r = 2;
    difference() {
        linear_extrude(height = base_h)
            hull() {
                for (sx = [-1, 1]) translate([sx*(pad_w/2 - pad_r), pad_y0 + pad_r]) circle(r = pad_r);
                translate([-pad_w/2, -box_w/2 - eps]) square([pad_w, 1 + eps]);
            }
        translate([0, pad_y0, 0]) dovetail_slot(base_h);
    }
}

module base() {
    difference() {
        union() {
            linear_extrude(height = base_h) outline(0);
            mount_pad();
        }
        translate([0, 0, floor_t]) linear_extrude(height = base_h) outline(wall);
        translate([0, 0, base_h - groove_d]) linear_extrude(height = groove_d + eps) outline(skirt_t);

        translate([-box_l/2 - eps, j1_y, j1_z]) rotate([90, 0, 90])
            linear_extrude(height = wall + 2*eps, center = false) rrect2d(j1_w, j1_h, cut_r);

        translate([ box_l/2 - wall - eps, j2_y, j2_z]) rotate([90, 0, 90])
            linear_extrude(height = wall + 2*eps, center = false) rrect2d(j2_w, j2_h, cut_r);

        translate([rs_x, -box_w/2 - eps, rs_z]) rotate([90, 0, 0])
            linear_extrude(height = wall + 2*eps, center = false) rrect2d(rs_w, rs_h, cut_r);
    }
    standoffs();
}


function ang(v) = 360 * v / thr_pitch;

module thread_section() {
    r_c = neck_d/2 - thr_h;
    r_r = neck_d/2;
    r_o = neck_d/2 + 0.5;
    n   = 14;
    c_h = ang(thr_crest_w/2);
    r_u = ang(thr_crest_w/2 + thr_up);
    r_l = ang(thr_crest_w/2 + thr_h);
    crest = [for (i = [0:n]) let(a = -c_h + 2*c_h*i/n) r_c * [cos(a), sin(a)]];
    outer = [for (i = [0:n]) let(a = r_l - (r_u + r_l)*i/n) r_o * [cos(a), sin(a)]];
    polygon(concat(crest, [r_r * [cos(r_l), sin(r_l)]], outer, [r_r * [cos(-r_u), sin(-r_u)]]));
}

module neck_thread() {
    t_len = collar_h - thr_z0 - thr_top;
    translate([0, 0, thr_z0])
        linear_extrude(height = t_len, twist = -360*t_len/thr_pitch,
                       slices = ceil(24*t_len/thr_pitch), convexity = 10)
            thread_section();
}

module bottle_collar() {
    R = collar_od/2;
    union() {
        difference() {
            union() {
                translate([0, 0, -eps]) cylinder(r = R, h = collar_h + eps);
                translate([0, 0, -eps]) cylinder(r1 = R + collar_fillet, r2 = R, h = collar_fillet + eps);
            }
            translate([0, 0, -2*eps]) cylinder(r = neck_d/2, h = collar_h + 4*eps);
        }
        if (thread_on) neck_thread();
    }
}


module crush_rib() {
    r = 0.5;
    c = fit_clear + rib_interf - r;
    hull() {
        translate([c, 0, base_h - 0.3])    cylinder(r = r,    h = eps);
        translate([c, 0, base_h - lip_h]) cylinder(r = 0.05, h = eps);
    }
}

module lid_crush_ribs() {
    if (rib_interf > 0) {
        fx = box_l/2 - skirt_t - fit_clear;
        fy = box_w/2 - skirt_t - fit_clear;
        for (s = [-1, 1]) {
            translate([s*fx, 0, 0]) rotate([0, 0, s > 0 ? 0 : 180]) crush_rib();
            for (px = [-18, 18])
                translate([px, s*fy, 0]) rotate([0, 0, s > 0 ? 90 : -90]) crush_rib();
        }
    }
}

module lid() {
    union() {
        translate([0, 0, base_h]) linear_extrude(height = lid_t) outline(0);
        translate([0, 0, base_h - lip_h]) linear_extrude(height = lip_h + eps)
            difference() { outline(skirt_t + fit_clear); outline(wall); }
        lid_crush_ribs();
    }
}


module side_bottle_caddy() {
    caddy_base_w = 56;
    caddy_base_l = 56;
    
    main_x = 0;
    main_y = -2.5;
    
    snork_x = 0;
    snork_y = 10.5; 
    
    narrow_len = 12;
    wide_len = 15;
    total_boss_len = narrow_len + wide_len;
    
    difference() {
        union() {
            linear_extrude(height = wall)
                rrect2d(caddy_base_l, caddy_base_w, corner_r);
            translate([0, 0, wall])
                bottle_collar();
                
           
            translate([main_x, main_y, -narrow_len])
                cylinder(r = 8, h = narrow_len, $fn = 40);
                
            
            translate([main_x, main_y, -total_boss_len])
                cylinder(r = 14, h = wide_len, $fn = 60);
                
           
            translate([main_x, main_y, -narrow_len - 2])
                cylinder(r1 = 14, r2 = 8, h = 2, $fn = 60);
        }
        
        translate([main_x, main_y, -total_boss_len - eps]) {
            // Main inner water bore
            cylinder(r = water_bore_d/2, h = total_boss_len + wall + 2*eps, $fn=40);
            
            // Female threading cavity only in the widened lower section
            cylinder(r = 10.4, h = wide_len + eps, $fn=40);
            for(z = [2 : 3 : wide_len - 2]) {
                translate([0, 0, z])
                    rotate_extrude($fn=40)
                        translate([10.4, 0, 0]) circle(r=1.0, $fn=16);
            }
        }
            
        // Breather snorkel hole - now easily clearing the 8mm neck
        translate([snork_x, snork_y, -eps])
            cylinder(r = tube_hole_dia / 2, h = wall + 2*eps, $fn=30);
            
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * 21, sy * 21, -eps])
                cylinder(r = 2.2, h = wall + 2*eps, $fn=30);
        }
    }
}


module solenoid_holder() {
    bracket_thk = 4.0;
    cradle_h = 25.0;
    
    difference() {
        union() {
            translate([-valve_bracket_w/2, 0, 0])
                cube([valve_bracket_w, bracket_thk, valve_bracket_h]);
                
            translate([0, bracket_thk, cradle_h / 2 + 4])
                rotate([-90, 0, 0])
                    cylinder(r = valve_body_dia / 2 + 3.0, h = 22, $fn=60);
        }
        
        translate([0, bracket_thk - eps, cradle_h / 2 + 4])
            rotate([-90, 0, 0])
                cylinder(r = valve_body_dia / 2, h = 24 + 2*eps, $fn=60);
                
        translate([-valve_body_dia/2, bracket_thk - eps, cradle_h / 2 + 4])
            cube([valve_body_dia, 24 + 2*eps, valve_body_dia]);

        for (sx = [-1, 1]) {
            translate([sx * 16, -eps, valve_bracket_h / 2])
                rotate([-90, 0, 0])
                    cylinder(r = 2.2, h = bracket_thk + 2*eps, $fn=30);
        }
    }
}



module threaded_connector_body(length) {
    cylinder(r=10, h=length, $fn=40);
    for(z = [2 : 3 : length-3]) {
        translate([0, 0, z])
            rotate_extrude($fn=40)
                translate([10, 0, 0]) circle(r=0.8, $fn=16);
    }
}

module threaded_connector_hole(length) {
    translate([0, 0, -eps])
        cylinder(r=water_bore_d/2, h=length + 2*eps, $fn=40);
}

module straight_fitting() {
    difference() {
        threaded_connector_body(25);
        threaded_connector_hole(25);
    }
}

module curve_fitting() {
    difference() {
        union() {
            threaded_connector_body(15);
            translate([0, 0, 15]) rotate([0, 30, 0]) threaded_connector_body(15);
            translate([0, 0, 15]) sphere(r=10, $fn=40); 
        }
        union() {
            threaded_connector_hole(15);
            translate([0, 0, 15]) rotate([0, 30, 0]) threaded_connector_hole(15);
            translate([0, 0, 15]) sphere(r=water_bore_d/2, $fn=40);
        }
    }
}

module elbow90_fitting() {
    difference() {
        union() {
            threaded_connector_body(18);
            translate([0, 0, 18]) rotate([0, 90, 0]) threaded_connector_body(18);
            translate([0, 0, 18]) sphere(r=10, $fn=40);
        }
        union() {
            threaded_connector_hole(18);
            translate([0, 0, 18]) rotate([0, 90, 0]) threaded_connector_hole(18);
            translate([0, 0, 18]) sphere(r=water_bore_d/2, $fn=40);
        }
    }
}

module female_fitting() {
    length = 25;
    difference() {
        cylinder(r=14, h=length, $fn=60);
        translate([0,0,-eps]) cylinder(r=water_bore_d/2, h=length+2*eps, $fn=40);
        for (z_offset = [-eps, length/2 + eps]) {
            translate([0, 0, z_offset]) {
                cylinder(r=10.4, h=length/2, $fn=40);
                for(z = [2 : 3 : (length/2)-2]) {
                    translate([0, 0, z])
                        rotate_extrude($fn=40)
                            translate([10.4, 0, 0]) circle(r=1.0, $fn=16);
                }
            }
        }
    }
}

module female_tube_long() {
    length = 50;
    thread_depth = 14; 
    difference() {
        cylinder(r=14, h=length, $fn=60);
        translate([0,0,-eps]) cylinder(r=water_bore_d/2, h=length+2*eps, $fn=40);
        for (z_offset = [-eps, length - thread_depth + eps]) {
            translate([0, 0, z_offset]) {
                cylinder(r=10.4, h=thread_depth, $fn=40);
                for(z = [2 : 3 : thread_depth - 2]) {
                    translate([0, 0, z])
                        rotate_extrude($fn=40)
                            translate([10.4, 0, 0]) circle(r=1.0, $fn=16);
                }
            }
        }
    }
}

module solenoid_adapter() {
    male_len = 15;
    fem_len = 16;
    difference() {
        union() {
            threaded_connector_body(male_len);
            translate([0, 0, male_len]) cylinder(r=16, h=fem_len, $fn=60);
        }
        translate([0, 0, -eps]) cylinder(r=water_bore_d/2, h=male_len+fem_len+2*eps, $fn=40);
        translate([0, 0, male_len - eps]) {
            cylinder(r=19.5/2, h=fem_len + 2*eps, $fn=60);
            for(z = [2 : 1.8 : fem_len-2]) { 
                translate([0, 0, z])
                    rotate_extrude($fn=60)
                        translate([19.5/2, 0, 0]) circle(r=0.7, $fn=16);
            }
        }
    }
}

module solenoid_inline_valve() {
    fem_len = 16;
    difference() {
        union() {
            // Main horizontal chamber block
            translate([-14, -14, -14]) cube([28, 28, 28]);
            
            // Left modular male thread
            translate([-14, 0, 0]) rotate([0, -90, 0]) threaded_connector_body(15);
            
            // Right modular male thread
            translate([14, 0, 0]) rotate([0, 90, 0]) threaded_connector_body(15);
            
            // Top vertical cylinder for solenoid mounting
            translate([0, 0, 14]) cylinder(r=16, h=fem_len, $fn=60);
        }
        
        // Horizontal water bore passing through the manifold
        translate([-30, 0, 0]) rotate([0, 90, 0]) cylinder(r=water_bore_d/2, h=60, $fn=40);
        
        // Vertical plunge bore for the solenoid to drop down and block the water path
        translate([0, 0, -10]) cylinder(r=5.5, h=25, $fn=40);
        
        // 1/2" Female threading cavity at the top for the WSV-12V
        translate([0, 0, 14 - eps]) {
            cylinder(r=19.5/2, h=fem_len + 2*eps, $fn=60);
            for(z = [2 : 1.8 : fem_len-2]) { 
                translate([0, 0, z])
                    rotate_extrude($fn=60)
                        translate([19.5/2, 0, 0]) circle(r=0.7, $fn=16);
            }
        }
    }
}

module sprinkler_fitting() {
    length = 20;
    thread_depth = 15;
    difference() {
        union() {
            cylinder(r=14, h=length - 5, $fn=60);
            translate([0, 0, length - 5]) cylinder(r1=14, r2=8, h=5, $fn=60);
        }
        
        translate([0, 0, -eps]) {
            cylinder(r=10.4, h=thread_depth, $fn=40);
            for(z = [2 : 3 : thread_depth - 2]) {
                translate([0, 0, z])
                    rotate_extrude($fn=40)
                        translate([10.4, 0, 0]) circle(r=1.0, $fn=16);
            }
        }
        
        translate([0, 0, thread_depth - eps])
            cylinder(r1=10.4, r2=6, h=length - thread_depth - 1, $fn=40);

        translate([0, 0, thread_depth]) {
            cylinder(r=1, h=10, $fn=16);
            for(a = [0:60:359]) {
                rotate([0, 0, a])
                    translate([4, 0, 0])
                        rotate([0, 15, 0])
                            cylinder(r=1, h=10, $fn=16);
            }
        }
    }
}


module csk_hole() {
    csk_depth = (csk_d - screw_d)/2;
    translate([0, 0, -eps]) cylinder(d1 = csk_d + 2*eps, d2 = screw_d, h = csk_depth + eps);
    translate([0, 0, -eps]) cylinder(d = screw_d, h = br_t + 2*eps);
}

module bracket() {
    difference() {
        union() {
            translate([0, 0, br_h/2]) rotate([90, 0, 0])
                linear_extrude(height = br_t) rrect2d(br_w, br_h, 3);
            translate([0, 0, ledge_h - eps])
                linear_extrude(height = rail_len + eps, convexity = 4) rail_profile();
            translate([-br_w/2, -eps, 0]) cube([br_w, pad_t + eps, ledge_h]);
        }
        for (sx = [-1, 1], z = [ledge_h + 9, br_h - 9])
            translate([sx*(br_w/2 - screw_edge), 0, z]) rotate([90, 0, 0]) csk_hole();
    }
}


module bracket_in_place() { translate([0, pad_y0, -ledge_h]) bracket(); }

module assembly() {
    color("SteelBlue")  base();
    color("Gainsboro")  lid();
    color("DimGray")    bracket_in_place();
    color("SlateGray")  translate([box_l/2 + 45, 0, 27]) side_bottle_caddy(); 
    color("DarkSlateGray") translate([0, box_w/2 + 40, 0]) solenoid_holder();
    
    color("Cyan")       translate([box_l/2 + 45, 45, 0]) straight_fitting();
    color("DarkTurquoise") translate([box_l/2 + 70, 45, 0]) curve_fitting();
    color("Teal")       translate([box_l/2 + 95, 45, 0]) elbow90_fitting();
    
    color("CadetBlue")  translate([box_l/2 + 45, -45, 0]) female_fitting();
    color("MediumAquaMarine") translate([box_l/2 + 75, -45, 0]) female_tube_long();
    color("LightSeaGreen") translate([box_l/2 + 110, -45, 0]) solenoid_adapter();
    color("DodgerBlue") translate([box_l/2 + 145, -45, 0]) sprinkler_fitting();
    color("Orange")     translate([box_l/2 + 100, -85, 0]) solenoid_inline_valve();
}

module exploded() {
    color("DimGray") bracket_in_place();
    translate([0, 0, 20]) {
        color("SteelBlue") base();
        color("Gainsboro") translate([0, 0, 25]) lid();
    }
    color("SlateGray") translate([box_l/2 + 45, 0, 40]) side_bottle_caddy();
    color("DarkSlateGray") translate([0, box_w/2 + 40, 20]) solenoid_holder();
}

module section_view() {
    difference() {
        assembly();
        translate([0, -200, -100]) cube([200, 400, 400]);
    }
}

module print_plate() {
    gap = 12;
    base();
    translate([box_l + gap, 0, 0]) lid();
    translate([-(box_l/2 + gap + br_w/2), br_h/2, br_t]) rotate([90, 0, 0]) bracket();
    
    translate([box_l + gap, box_w + gap, wall + 27]) rotate([180, 0, 0]) side_bottle_caddy();
    translate([-(box_l/2 + gap), box_w + gap, 0]) solenoid_holder();
    
    translate([box_l + gap, box_w + gap + 70, 0]) straight_fitting();
    translate([box_l + gap + 30, box_w + gap + 70, 0]) curve_fitting();
    translate([box_l + gap + 60, box_w + gap + 70, 0]) elbow90_fitting();
    
    translate([box_l + gap + 90, box_w + gap + 70, 0]) female_fitting();
    translate([box_l + gap + 130, box_w + gap + 70, 0]) female_tube_long();
    translate([box_l + gap + 170, box_w + gap + 70, 0]) solenoid_adapter();
    translate([box_l + gap + 210, box_w + gap + 70, 0]) sprinkler_fitting();
    translate([box_l + gap + 255, box_w + gap + 70, 14]) rotate([0, 0, 0]) solenoid_inline_valve();
}

if      (part == "assembly")              assembly();
else if (part == "exploded")              exploded();
else if (part == "section")               section_view();
else if (part == "base")                  base();
else if (part == "lid")                   lid();
else if (part == "bracket")               bracket();
else if (part == "side_caddy")            side_bottle_caddy();
else if (part == "solenoid_holder")       solenoid_holder();
else if (part == "straight_fitting")      straight_fitting();
else if (part == "curve_fitting")         curve_fitting();
else if (part == "elbow90_fitting")       elbow90_fitting();
else if (part == "female_fitting")        female_fitting();
else if (part == "female_tube_long")      female_tube_long();
else if (part == "solenoid_adapter")      solenoid_adapter();
else if (part == "solenoid_inline_valve") solenoid_inline_valve();
else if (part == "sprinkler_fitting")     sprinkler_fitting();
else if (part == "print_plate")           print_plate();
else echo(str("Unknown part: ", part));
