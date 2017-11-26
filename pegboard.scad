// beam params
beam_w = 7.1;
beam_d = 3;
beam_h = 76;
// distance between edge of beam and center of bolt
bolt1_x = 1.39;
bolt2_x = beam_w - bolt1_x;

// distance between bolts in vertical direction
bolt_z = 3.2;

// diameter of bolts/holes in desk beam
bolt_diam = 0.675;

connector_w = 1;
conn_hull_r = 1;

// board params
// radius of board bolts
bbolt_r = 0.3;
// distance between bolt centers in x direction
bbolt_x = 38.735;
// distance between bolt centers in z direction
bbolt_z = 39.37;
// distance along x between board edge and bolt center
bbolt_offset_x = 0.79375;
// distance along z between board edge and bolt center
bbolt_offset_z = 1.27;
// width of board
board_d = 1.905;
// gap between edges of board and beam
gap = 0.5;

module bolt (row1, height) {
	if (row1) {
		translate([bolt1_x,1.5*beam_d,height])
		rotate([90,0,0])
		cylinder(2*beam_d, r=bolt_diam/2, $fn=50);
	} else {
		translate([bolt2_x, 1.5*beam_d, height])
		rotate([90,0,0])
		cylinder(2*beam_d, r=bolt_diam/2, $fn=50);
	}
}

module bolt_pair (height) {
	bolt(true, height);
	bolt(false, height);
}

module bolt_array (bolts) {
	for (i = [1:bolts]) {
		bolt(true, i*bolt_z);
		bolt(false, i*bolt_z);
	}
}

module board_bolts (y) {
	translate([0,1.5*beam_d,0])
	rotate([90,0,0])
	translate([-(bbolt_offset_x+gap), y]) {
		translate([0,0]) cylinder(2*beam_d, r=bbolt_r, $fn=50);
		translate([-bbolt_x,0]) cylinder(2*beam_d, r=bbolt_r, $fn=50);
		translate([-bbolt_x,bbolt_z]) cylinder(2*beam_d, r=bbolt_r, $fn=50);
		translate([0,bbolt_z]) cylinder(2*beam_d, r=bbolt_r, $fn=50);
		translate([-bbolt_x,2*bbolt_z]) cylinder(2*beam_d, r=bbolt_r, $fn=50);
		translate([0,2*bbolt_z]) cylinder(2*beam_d, r=bbolt_r, $fn=50);
	}
}

module board (y) {
	color("gray")
	difference() {
		translate([-(bbolt_x + 2*bbolt_offset_x + gap), beam_d - board_d,y - bbolt_offset_z])
		cube([bbolt_x + 2*bbolt_offset_x, board_d, 2*bbolt_z + 2*bbolt_offset_z]);
		board_bolts(y);
	}
}

// draw the desk beam
module beam() {
color("silver")
difference() {
	cube([beam_w,beam_d,beam_h]);
	bolt_array(22);
}
}

// draw the connection piece
module connector1 (bolts, cantilever_length, bottom_bolt) {
	color([0.7,0.4,0.2])
	difference() {
		translate([0,beam_d+connector_w,(bottom_bolt-0.5)*bolt_z])
		rotate([90,0,0])
		linear_extrude(connector_w)
		polygon([[beam_w,0],[0,0],[-cantilever_length,bolts*bolt_z],[beam_w,bolts*bolt_z]]);
		// beam bolt holes
		bolt(true, bottom_bolt*bolt_z);
		bolt(true, (bottom_bolt+bolts-1)*bolt_z);
		bolt(false, bottom_bolt*bolt_z);
		bolt(false, (bottom_bolt+bolts-1)*bolt_z);
		// board mounting holes
		board_bolts(1.5*bolt_z);
	}
}

module connector2 (board_y) {
	color([0.7,0.4,0.2])
	difference() {
	hull() {
		translate([0,beam_d+connector_w,0])
		rotate([90,0,0])
		translate([-(bbolt_offset_x+gap), board_y]) {
			translate([0,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate([-bbolt_x,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
		}
	
		translate([0,beam_d+connector_w,2*bolt_z])
		rotate([90,0,0]) {
			translate ([bolt1_x,0,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt2_x,0,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt1_x,3*bolt_z,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt2_x,3*bolt_z,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
		}
	}
	
	board_bolts(board_y);
	bolt_pair(2*bolt_z);
	bolt_pair((2+4-1)*bolt_z);
	}
}

module connector_mid (board_y) {
	color([0.7,0.4,0.2])
	difference() {
	hull() {
		translate([0,beam_d+connector_w,0])
		rotate([90,0,0])
		translate([-(bbolt_offset_x+gap), board_y]) {
			translate([0,bbolt_z]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate([-bbolt_x,bbolt_z]) cylinder(connector_w, r=conn_hull_r, $fn=50);
		}

		translate([0,beam_d+connector_w,12*bolt_z])
		rotate([90,0,0]) {
			translate ([bolt1_x,0,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt2_x,0,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt1_x,3*bolt_z,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt2_x,3*bolt_z,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
		}
	}

	board_bolts(board_y);
	bolt_pair(12*bolt_z);
	bolt_pair(15*bolt_z);
	}
}

module connector_high (board_y) {
	color([0.7,0.4,0.2])
	difference() {
	hull() {
		translate([0,beam_d+connector_w,0])
		rotate([90,0,0])
		translate([-(bbolt_offset_x+gap), board_y]) {
			translate([0,2*bbolt_z]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate([-bbolt_x,2*bbolt_z]) cylinder(connector_w, r=conn_hull_r, $fn=50);
		}

		translate([0,beam_d+connector_w,21*bolt_z])
		rotate([90,0,0]) {
			translate ([bolt1_x,0,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt2_x,0,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt1_x,bolt_z,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
			translate ([bolt2_x,bolt_z,0]) cylinder(connector_w, r=conn_hull_r, $fn=50);
		}
	}

	board_bolts(board_y);
	bolt_pair(21*bolt_z);
	bolt_pair(22*bolt_z);
	}
}

beam();
//color([.19,.15,.15]) translate([-59,-120,1.35]) cube([90.17,120,2]);
//connector1(4, 60, 2);
//connector1(4, 60, 11);
//connector1(2, 60, 22);
board(1.5*bolt_z);

connector2(1.5*bolt_z);
connector_mid(1.5*bolt_z);
connector_high(1.5*bolt_z);

