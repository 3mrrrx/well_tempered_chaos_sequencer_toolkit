
// well-tempered chaos sequencer board version 1.0 reworked
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]



////////////////////////////////////////////
// global variables
////////////////////////////////////////////

// include <version4.scad>

////////////////////////////////////////////
// global variables
////////////////////////////////////////////

// tolerance plus ball raduis 
tol = 0.4; //0.24
Ball_raduis = 2.25 + tol;

//thinkness of each of the wall
wall_thinkness = 2 ;

// bottom floor thinknes goes in -z
floor_thinkess = 9.5;

// board dimenstion 
size_x = 235.55; //240-3.7-1+0.25;
size_y = 60.4;
size_z = Ball_raduis*3.5;

// bin size parameters
cascades_lengths = 115 * size_x/350;
spacing_factor = 1; // factor to multiply to bin width  

// bin end break paramter 
break_factor = 1;  // fraction of bin length 
break_angel  = 20; // angel of bread degs


// fann funnel parameters
funnel_size = 50 ; // lentgh of funnel
funnel_resulition = 50; // funnel cirular resolution
inlet_factor = 2;   // 
$fn = 10;

// fan dimensions
fan_x = 72;
fan_y = 40;
fan_z = 40;
factor_fan = 0.5; // position of fan as a fraction of 


// return channel parameters
channel_width = (Ball_raduis+wall_thinkness)*2;
channel_mid = wall_thinkness;


// debug
shift_factor = 0.1;
debug_eliv = 0;



////////////////////////////////////////////
// spiral
////////////////////////////////////////////
 
translate([247.15,size_y+Ball_raduis*3+wall_thinkness+0.25,wall_thinkness+Ball_raduis*3+size_z/2])
rotate(a = -90, v = [0, 1, 0])

union(){
    difference(){

        // spiral
        steps_factor = 16;
        translate([0,0,-7]) 

        for ( z = [1:240*steps_factor]){
            rotate(z*2) translate([0,0,z/steps_factor])
            rotate([90,0,0])
                cube(size = [Ball_raduis*3,5,1], center = false);
        }
        
        // PUSH BACK SIRAPL TO MAKE FOR BEARING HEAD
        translate([-20,-20,-7]) 
            cube([60,60,5]);

        //center hole FOR BOTTOM PIN BEARING HOLE
        translate([0,0,0])
            cylinder(h=250,r=1.2,$fn=50);
    
            
    }
    

    //center cylinder
    translate([0,0,0])cylinder(h=240+6,r=Ball_raduis,$fn=50);
    
    //rounded top
    translate([0,0,240+11-5])
        sphere(r=Ball_raduis,$fn=50);
    


}

