
// well-tempered chaos sequencer board version 1.0 reworked
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]



////////////////////////////////////////////
// global variables
////////////////////////////////////////////


tol = 0.4; //0.24

Ball_raduis = 2.25 + tol;

wall_thinkness = 2 ;


size_x = 240-3.7-1+0.25;
//size_y = 105.7;
size_y = 57.8;
//size_y = 46.9;

size_z = Ball_raduis*3.5;

// cascades parameters
cascades_lengths = 120 * size_x/350;
spacing_factor = 1;

// funnel parameters
funnel_size = 50 ;
funnel_resulition = 50;
inlet_factor = 2;

$fn = 10;



// fan dimensions

fan_x = 70 + 2;
fan_y = 40;
fan_z = 40;
factor_fan = 0.5;


// return channel parameters
channel_width = (Ball_raduis+wall_thinkness)*2;
channel_mid = wall_thinkness;


// debug

shift_factor = 0.1;

debug_eliv = 0;





////////////////////////////////////////////
// spiral
////////////////////////////////////////////
 
translate([240+8.15-1,size_y+Ball_raduis*3+wall_thinkness+0.25,wall_thinkness+Ball_raduis*3+size_z/2])
rotate(a = -90, v = [0, 1, 0])

union(){
    difference(){

        // spiral
        steps_factor = 16;
        
        translate([0,0,-5]) 


        for ( z = [1:240*steps_factor]){
            rotate(z*2) translate([0,0,z/steps_factor])
            rotate([90,0,0])
                cube(size = [Ball_raduis*3,5,1], center = false);
        }
        
        // PUSH BACK SIRAPL TO MAKE FOR BEARING HEAD
        translate([-20,-20,-5]) 
            cube([60,60,5]);

        //center hole FOR BOTTOM PIN BEARING HOLE
        translate([0,0,0])
            cylinder(h=240+11,r=1.2,$fn=50);
            
    }
    

    //center cylinder
    translate([0,0,0])cylinder(h=240+6,r=Ball_raduis,$fn=50);
    
    //rounded top
    translate([0,0,240+11-5])
        sphere(r=Ball_raduis,$fn=50);
    

    
}


