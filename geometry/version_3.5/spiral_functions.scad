
// well-tempered chaos sequencer board version 3.0
// SPIRAL functions
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]


////////////////////////////////////////////
// cut spiral tubings out of spiral box
////////////////////////////////////////////
module create_spiral_tubeing(Ball_raduis,wall_thinkness,size_x,size_y,size_z,channel_width,debug_eliv){
    
    tole = 1; // added tol shift for spiral tolerance

    union(){
        
        // top
        shift_top_r = Ball_raduis*2*shift_factor;
        translate([0,shift_top_r,0]) 
        translate([wall_thinkness,size_y/2,wall_thinkness+debug_eliv*2]) 
        scale([Ball_raduis*2,size_y/2+channel_width/2-shift_top_r+Ball_raduis*3+wall_thinkness*2+tole*1.5,size_z+wall_thinkness*2+20]) 
            cube(1);
        
//                // side
//                shift_side_r = wall_thinkness+Ball_raduis;
//                translate([shift_side_r,0,0]) 
//                translate([0,size_y+wall_thinkness,wall_thinkness+debug_eliv*2]) 
//                    scale([size_x+Ball_raduis*2-shift_side_r,Ball_raduis*2+Ball_raduis*3+wall_thinkness+tole,size_z+wall_thinkness*2]) 
//                        cube(1);
        
        // bottom
        translate([0,0,0])
        translate([size_x+wall_thinkness,0,wall_thinkness+debug_eliv*2]) 
        scale([Ball_raduis*2,size_y+Ball_raduis*2+Ball_raduis*3+wall_thinkness+tole+wall_thinkness,size_z+wall_thinkness*2]) 
            cube(1);
                       
        // top
        translate([wall_thinkness,size_y+channel_width/2+Ball_raduis*3+wall_thinkness+tole,wall_thinkness+debug_eliv*2]) 
            cube([Ball_raduis,Ball_raduis,size_z]);
            //cylinder(r=Ball_raduis, h=size_z);
                                       
        // bottom
        translate([size_x+channel_width/2,size_y+channel_width/2+Ball_raduis*3+wall_thinkness+tole,wall_thinkness+debug_eliv*2]) 
            cube([Ball_raduis,Ball_raduis,size_z] );
            //cylinder(r=Ball_raduis, h=size_z);   
        
    }  
}

////////////////////////////////////////////
// holding box for spiral geometries  
////////////////////////////////////////////
module side_spiral_box(Ball_raduis,channel_width,size_x,size_y,size_z,debug_eliv){
           
    // top   
    shift = Ball_raduis*2*shift_factor;
    translate([0,shift,0]) // shift 
    translate([0,size_y/2,debug_eliv]) 
    scale([channel_width,size_y/2+Ball_raduis*6-shift+wall_thinkness*2,size_z]) 
        cube(1);   

    // side   ??? +5??
    translate([0-wall_thinkness,size_y,debug_eliv]) 
    scale([size_x+wall_thinkness*4+1,Ball_raduis*6+wall_thinkness*2,size_z*2.5+wall_thinkness*2]) 
        cube(1);

    // bottom
    translate([size_x,0,debug_eliv]) 
    scale([channel_width,size_y+Ball_raduis*6+wall_thinkness*2,size_z]) 
        cube(1);

}   

/////////////////////////////////////////////////////////////
//    CREATE BEARING FOR SPIRAL 
/////////////////////////////////////////////////////////////
module bearing (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis){

    union(){
    
        translate([240+8.15-1+5,size_y+Ball_raduis*3+wall_thinkness+0.25,size_z/2])
        rotate(a = -90, v = [0, 1, 0])
            cylinder(h=240+6+10,r=Ball_raduis,$fn=50);
    
        translate([0,size_y+Ball_raduis*3+wall_thinkness+0.25-Ball_raduis,size_z/2])
            cube([240+10,Ball_raduis*2,size_z]);
    }
}