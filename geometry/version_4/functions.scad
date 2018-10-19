
// well-tempered chaos sequencer board version 3.0
// modulas and functions
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]



////////////////////////////////////////////
// include fan function and spiral functions
////////////////////////////////////////////

include <fan_functions.scad>
include <spiral_functions.scad>

////////////////////////////////////////////
// create generic random shaped pins
////////////////////////////////////////////

module  randum_pillar(x=1, y=1, r=2, z=10, resulation=3) { 
    translate([x,y,0]) 
        cylinder($fn = resulation, $fa = 12, $fs = 2, h = z, r1 = r, r2 = r, center = false);
    }

/////////////////////////////////////////////////////////////
//     CREATE BINS
/////////////////////////////////////////////////////////////

module Cascades (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis){
    
    // Cascades
    for (y = [wall_thinkness:wall_thinkness+channel_size:size_y-wall_thinkness] )
    {   
        union(){
            
            // BINS 
            translate([230/350*size_x,y*spacing_factor,wall_thinkness]) 
                scale([cascades_lengths*break_factor,channel_size,size_z]) 
                    cube(1);

            // break Cascades TO AN AGNEL
            translate([230/350*size_x+cascades_lengths*break_factor,y*spacing_factor,wall_thinkness]) rotate(a = break_angel, v = [0, 0, 1])
                scale([cascades_lengths*(1-break_factor)+wall_thinkness*2,Ball_raduis*2,size_z]) 
                    cube(1);

          
        }
    }   
}


/////////////////////////////////////////////////////////////
//     CREATE HOLES FOR JUMPER CABLE PIN HEADS
/////////////////////////////////////////////////////////////

module pin_heads (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis, size = 2.7, scale_x=2){
    
    // iterations
    for (y = [wall_thinkness:wall_thinkness+channel_size:size_y-wall_thinkness] ){
        
        union(){       
         // pin heads
        translate([230/350*size_x+cascades_lengths*break_factor/2,y*spacing_factor+channel_size/2,0])
        scale([scale_x,1,wall_thinkness*3]) 
            cube(size, center = true);
        }
    }
}