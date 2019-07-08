
// well-tempered chaos sequencer board version 3.0
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]


////////////////////////////////////////////
// include functions
////////////////////////////////////////////

include <functions.scad>

////////////////////////////////////////////
// global variables
////////////////////////////////////////////

// tolerance plus ball raduis 
tol = 0.4; //0.24
Ball_raduis = 2.25 + tol;

//thinkness of each of the wall
wall_thinkness = 2 ;

// bottom floor thinknes goes in -z
floor_thinkess = 9.5 + 5;

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

// motor Size
motor_r = 20+1  +tol;
motor_l = 110;


// debug
shift_factor = 0.1;
debug_eliv = 0;


////////////////////////////////////////////
// geomerty
////////////////////////////////////////////

// board
difference(){

    ////////////////////////////////
    //  summ to peripheres
    ////////////////////////////////
    union(){
            
    ////////////////////////////////
    //  mian board
    ////////////////////////////////
    difference(){

    // bounding box
    scale([size_x,size_y,size_z]) 
    cube(1);
    
    // horizontal tube
    shift_bottom_c = 0;
    length_bottom  = channel_width/2;
    color([0,0,1]) // blue
    translate([0+channel_width/2,size_y/2,size_z/2+debug_eliv*3]) 
    scale([channel_width/2-wall_thinkness*1.3,1,size_z/2-wall_thinkness])
    rotate(a = 90, v = [1, 0, 0]){
        cylinder( h = size_y/2+channel_width/2, r = 1, center = false, $fn=25);};   
    
    ////////////////////////////////
    //  create funnels
    ////////////////////////////////
    funnel(funnel_size,wall_thinkness,size_x,size_y,size_z,funnel_resulition);
    
    ////////////////////////////////
    // bottom box
    ////////////////////////////////
    translate([funnel_size+wall_thinkness*2,wall_thinkness,wall_thinkness])
    scale([size_x-funnel_size-wall_thinkness*2 - cascades_lengths,size_y-wall_thinkness*2,size_z])
        cube(1);
        
    ////////////////////////////////
    // wind tunnel tubing       
    ////////////////////////////////
    
    create_spiral_tubeing(Ball_raduis,wall_thinkness,size_x,size_y,size_z,channel_width,debug_eliv);
        
    ////////////////////////////////
    // create bins
    ////////////////////////////////
    
    Cascades (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis);

    ////////////////////////////////
    // sensor holes
    ////////////////////////////////
        
    // CNY70 heads                
    pin_heads (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis, size = 2.7, scale_x=1);

//    // doubleholes jumper cable bin heads
//    translate([0,1.1,0])
//        pin_heads (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis, size = 1.4, scale_x=1);
//    
//    translate([0,-1.1,0])
//        pin_heads (wall_thinkness,channel_size,        cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis, size = 1.4, scale_x=1);                  


    ////////////////////////////////
    // plexy glass holder
    ////////////////////////////////
    
    // scaling fixed
    translate([40*size_x/235.55,0,0])
        pin_heads (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,1,Ball_raduis, size = [7.7,7.7,1.7], scale_x=1);   
                                 
    }

    ////////////////////////////////
    // plexy glass holder
    ////////////////////////////////

//    // bottom    
//    translate([size_x+channel_width-wall_thinkness,-channel_width,0]) 
//    scale([wall_thinkness,wall_thinkness*4+Ball_raduis*8 + size_y,size_z+wall_thinkness+Ball_raduis*2]) 
//        cube(1);
//
//    // top
//    translate([-wall_thinkness*3,-channel_width,-floor_thinkess]) 
//    scale([wall_thinkness*3,wall_thinkness*4+Ball_raduis*8 + size_y,size_z+wall_thinkness+Ball_raduis*2+floor_thinkess])
//        cube(1);
    
    
    // bottom    
    translate([size_x+channel_width-wall_thinkness,0,0]) 
    scale([wall_thinkness,wall_thinkness*4+Ball_raduis*8 + size_y-channel_width,size_z+wall_thinkness+Ball_raduis*2]) 
        cube(1);

    // top
    translate([-wall_thinkness*3,0,-floor_thinkess]) 
    scale([wall_thinkness*3,wall_thinkness*4+Ball_raduis*8 + size_y-channel_width,size_z+wall_thinkness+Ball_raduis*2+floor_thinkess])
        cube(1);
    
    ////////////////////////////////
    // create pins
    ////////////////////////////////    
    
    factor_pins = 1.0;
    // random vector for pin shape resolution 
    random_vec = rands(1,5,50000,9);
    i = 0;
    
    for (x = [62.5+5:Ball_raduis*4+2:223/350*size_x] )
    for (y = [wall_thinkness+Ball_raduis*4-2:Ball_raduis*4*factor_pins+2:size_y-wall_thinkness-Ball_raduis*2]){
        
        i = x*y; // generate index for random vector
        randum_pillar(x,y,random_vec[i] ,size_z,floor(random_vec[i]+2));
    
    }
    

    ////////////////////////////////
    // create channels
    ////////////////////////////////    
    
    channel_size = Ball_raduis*2*spacing_factor;

    // return tube
    difference(){
        
        // create wind channel box
        difference(){

        // side spiral box 
        color([1,1,1]) // green        
            side_spiral_box(Ball_raduis,channel_width,size_x,size_y,size_z,debug_eliv);
        
        // wind channel tubing 
//        color([1,0,0]) // red
//            create_spiral_tubeing(Ball_raduis,wall_thinkness,size_x,size_y,size_z,channel_width,debug_eliv);
            
//       color([1,0,0]) // red
//            
                    rotate(12, [1,0,0])
        translate([0,-1.7,-Ball_raduis*3.5])

            create_spiral_tubeing(Ball_raduis,wall_thinkness,size_x,size_y+3,size_z,channel_width,debug_eliv);
            
            
            
                  color([1,0,0]) // red
            
//                    rotate(12, [1,0,0])
        translate([0,wall_thinkness,-Ball_raduis*3.5])

            create_spiral_tubeing(Ball_raduis,wall_thinkness,size_x,size_y-wall_thinkness,size_z+10,channel_width,debug_eliv); 
            
            
        }
        
        // CUTE THE BIN CHANNELS FORM THE BAORDES OF THE
        color([1,0,0]) // red
            Cascades (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis);
    }

        // side wind box 
       // color([1,0,1]) // green
      //      side_wind_box_fan(Ball_raduis,channel_width,size_x,size_y,size_z,fan_x, fan_y, fan_z, factor_fan, debug_eliv);

    ////////////////////////////////
    // floor
    //////////////////////////////// 
    difference() {
        
        //////////////////////////////// 
        // FLOOR BOX
        //////////////////////////////// 
        
        union(){
            
            // UNDER THE BOARD
//            translate([0,-channel_width,-floor_thinkess]) 
//            scale([size_x+channel_width,size_y+   channel_width*2+Ball_raduis*3+2.5,floor_thinkess]) 
//                cube(1);   
            
            translate([0,0,-floor_thinkess]) 
            scale([size_x+channel_width,size_y+   channel_width*1+Ball_raduis*3+2.5,floor_thinkess]) 
                cube(1);   

            // under the fan
         //   translate([size_x*factor_fan-fan_x*0.5,-fan_y,-floor_thinkess]) 
        //    scale([fan_x*2,fan_y,floor_thinkess]) 
        //        cube(1);   
        }

        //////////////////////////////// 
        // FLOOR CUTS
        //////////////////////////////// 


        // FALL TO PIT CUT
        translate([0,0,-32]) 
            pin_heads(wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,floor_thinkess,Ball_raduis, size = [8,8,floor_thinkess], scale_x=1);
    
        
         // JUMPER CABLE PATHS VERTICAL
        translate([-32,0,-floor_thinkess/2]) 
            pin_heads(wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,floor_thinkess,Ball_raduis, size = [3.4,3.4,3.4], scale_x=size_x/6);

        
         // JUMPER CABLE PATHS horizontal
//        translate([size_x*factor_fan*1.1,0,-floor_thinkess])
//        scale([3.4,size_y*2,floor_thinkess]) 
//            cube([1]);
//
//        translate([size_x*factor_fan*1.2,0,-floor_thinkess])
//        scale([3.4,size_y*2,floor_thinkess]) 
//            cube([1]);
    
    }
    
    } // END OF peripheres SUMM


        //////////////////////////////// 
        // Motor Box
        ////////////////////////////////
        
        translate([0,0,0]) 
        translate([-wall_thinkness*3,size_y*0.85,-floor_thinkess+3]) 
//        scale([motor_l,motor_r,motor_r-10]) 
//            cube(1);
        rotate(a = 90, v = [0, 1, 0])
        cylinder(h=motor_l,r=motor_r/2,$fn=30);

    //////////////////////////////// 
    // peripher AND BAORD CUTS
    //////////////////////////////// 

    // bearing ball holder -> change to module
    
    translate([0,0,Ball_raduis*3-Ball_raduis*1.5+wall_thinkness])

    union(){
        
        
        //////////////////////////////// 
        // SPRIAL BEARING CUTS
        ////////////////////////////////

        // axises FOR BOTTOM NIDEL BEARING
        translate([0,0,Ball_raduis*1.8+11-5.5])
        rotate(4.7+2.6, [0,1,0])
        translate([240+8.15-1+5-10,size_y+Ball_raduis*3+wall_thinkness+0.25+0.3,size_z/2+5/2])
        rotate(a = -90, v = [0, 1, 0])
            cylinder(h=240+6+10,r=Ball_raduis+0.3,$fn=30);
     
        // bearing ring
        translate([0,0,Ball_raduis*1.8+11-5.5])
        rotate(4.7+2.6, [0,1,0])        
        translate([240+8.15-1+5,size_y+Ball_raduis*3+wall_thinkness+0.25,size_z/2+5/2])
        rotate(a = -90, v = [0, 1, 0])
            cylinder(h=240+6+10+200,r=0.75,$fn=30);        
            
        // cube INSERATION CUT
        translate([0,0,Ball_raduis*1.8+11-5.5-2.5])
        rotate(4.7+2.6, [0,1,0])
        translate([0-10,size_y+Ball_raduis*3+wall_thinkness+0.25-Ball_raduis,size_z/2+5])
        translate([0,0,0])
            cube([240+10,(Ball_raduis+0.3)*2,size_z/2+2+7]);

        //////////////////////////////// 
        // SPIRAL BOX 
        ////////////////////////////////
        
        translate([0,3,7])
        rotate(-8, [1,0,0])
        translate([size_x-wall_thinkness*1.5,0,-floor_thinkess*1.5+5 ])
        scale([Ball_raduis*4,size_y+wall_thinkness+Ball_raduis,Ball_raduis*3.5+3]) 
            cube([1]);
    
        //////////////////////////////// 
        // BOTTOM BALL COLLECTOR 
        ////////////////////////////////

        tole =1;
        shift_side_r = wall_thinkness+Ball_raduis;
        
        // SPIRAL BOX
        color([1,0.5,1])
        translate([-5,0,Ball_raduis*1.8])
        rotate(4.7+2.6, [0,1,0])
        translate([shift_side_r,0,0]) 
        translate([0,size_y+wall_thinkness,wall_thinkness+5+debug_eliv*2]) 
        scale([size_x+Ball_raduis*2-shift_side_r+2+5,Ball_raduis*2+Ball_raduis*3+wall_thinkness+tole,size_z+wall_thinkness*2+30]) 
            cube(1);

        // TRIMER OF EXTRA HIGHT
        color([1,0.5,1])
        translate([-4.5,-wall_thinkness*2,Ball_raduis*1.8+21])
        rotate(4.7, [0,1,0])
        translate([shift_side_r,0,0]) 
        translate([0,size_y+wall_thinkness,wall_thinkness+debug_eliv*2]) 
        scale([size_x+Ball_raduis*2-shift_side_r+2+5,Ball_raduis*2+Ball_raduis*3+wall_thinkness*4+tole,size_z/2+wall_thinkness*20]) 
            cube(1);



    } // END OF FLOOR
    
} // end of BAORD shape
 



//
//          translate([0,20,5.5])
//
//  
//    rotate(5, [1,0,0])
//
//    // size
//        translate([wall_thinkness*1,20,-floor_thinkess*1.5 ])
//
//    scale([Ball_raduis*2,size_y/2+channel_width,Ball_raduis*3.5]) cube([1]);
    

      // size


//        translate([wall_thinkness+channel_width,size_y+channel_width,size_z*1.5
//    ])
//
//    scale([size_x,channel_width,size_z]) cube([1]);
//    

// bearing ball holder -> change to module
//    translate([0,0,Ball_raduis*3+wall_thinkness])
//
//        union(){
//    
//    translate([240+8.15-1+5,size_y+Ball_raduis*3+wall_thinkness+0.25,size_z/2])
//
//    rotate(a = -90, v = [0, 1, 0])
//
//cylinder(h=240+6+10,r=Ball_raduis,$fn=50);
//    
//    translate([0,size_y+Ball_raduis*3+wall_thinkness+0.25-Ball_raduis,size_z/2])
//
//    translate([0,0,0])
//
//cube([240+10,Ball_raduis*2,size_z/2]);
//}
///////////////////////////////////////////////////////////////////////////7

// ball

// translate([size_x-Ball_raduis*5,0,50+Ball_raduis*2])
//
//sphere(r=Ball_raduis,$fn=20);

// spiral

// translate([10 ,0,50])
//rotate(a = 90, v = [0, 1, 0])
//union(){
//difference(){
//        
//    cylinder(h=size_x+6,r=Ball_raduis*4,$fn=50);
//    cylinder(h=size_x+6,r=Ball_raduis*3.175,$fn=50);    
//    
//} 
//
//
//difference(){
//    translate([0,0,9])
//
//    scale([8*4,8*4,14*2])cube(1,center=true);
//    
//    
//    translate([0,0,-100])
//
//    cylinder(h=size_x*2,r=Ball_raduis*3.175,$fn=50);    
//} 
//}

//
// translate([size_x+11.85,size_y+Ball_raduis*3+wall_thinkness,50])



//bearing (wall_thinkness,cascades_lengths,size_x,size_y,size_z,Ball_raduis);



// // spiral starts here

//
//// translate([size_x+8.15,size_y+Ball_raduis*3+wall_thinkness,50])
//// translate([240+8.15,size_y+Ball_raduis*3+wall_thinkness+0.25,50])
// 
// 
// translate([240+8.15-1,size_y+Ball_raduis*3+wall_thinkness+0.25,wall_thinkness+Ball_raduis*3+size_z/2])
//
//
//
//rotate(a = -90, v = [0, 1, 0])
////Ball_raduis;
////channel_width;
//
//
//difference(){
//    union(){
//        union(){
////            difference(){
//
//union(){
//
//difference(){
//
//union(){
//
//difference(){
//
////spiral
//
//steps_factor = 16;
//
////for ( z = [1:size_x*steps_factor]) {
//for ( z = [1:240*steps_factor]) {
//
//rotate(z*2) translate([0,0,z/steps_factor])  rotate([90,0,0]) cube(size = [Ball_raduis*3,5,1], center = false);
//
//}
//
////translate([0,0,0])cylinder(h=size_x+6,r=Ball_raduis*3,$fn=50);
//
//
//}
//
//}
//
//translate([-20,-20,0]) cube([60,60,5]);
//
//}
//
// 
//}
//
//
//}
//
//union(){
//
////center cylinder
//
////translate([0,0,0])cylinder(h=size_x+6,r=Ball_raduis,$fn=50);
//translate([0,0,0])cylinder(h=240+6,r=Ball_raduis,$fn=50);
//
// 
//
////rounded top
//
////translate([0,0,size_x+11-5])sphere(r=Ball_raduis,$fn=50);
//translate([0,0,240+11-5])sphere(r=Ball_raduis,$fn=50);
//
//}
//
//}
//
////center hole
////translate([0,0,0])cylinder(h=size_x+11,r=1.2,$fn=50);
//translate([0,0,0])cylinder(h=240+11,r=1.2,$fn=50);
//
//}