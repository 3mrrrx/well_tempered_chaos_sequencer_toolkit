// well-tempered chaos sequencer board version 2.0 
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]

////////////////////////////////////////////
// Global varaibes
////////////////////////////////////////////



tol = 0.24;

Ball_raduis = 2.25 + tol;

wall_thinkness = 2 ;


size_x = 240;
//size_y = 105.7;
size_y = 22.9;
//size_y = 46.9;

size_z = Ball_raduis*3;

// cascades parameters
cascades_lengths = 120 * size_x/350;
spacing_factor = 1;

// funnel parameters
funnel_size = 50 ;
funnel_resulition = 50;
inlet_factor = 2;

$fn = 10;



// fan dimensions

fan_x = 20 + 2;
fan_y = 40;
fan_z = 40;
factor_fan = 0.8;





// return channel parameters
channel_width = (Ball_raduis+wall_thinkness)*2;
channel_mid = wall_thinkness;


// debug

shift_factor = 0.1;

debug_eliv = 0;


////////////////////////////////////////////
// modulas and functions
////////////////////////////////////////////


// function to create generic pins
module  randum_pillar(x=1, y=1,z = 10 , resulation = 3 ) { 
    translate([x,y,0]) 
        cylinder($fn = resulation, $fa = 12, $fs = 2, h = z, r1 = 2, r2 = 2, center = false);
    }


module create_wind_tubeing(Ball_raduis,wall_thinkness,size_x,size_y,size_z,channel_width,debug_eliv){
                // wind channel tubing 
//            color([1,0,0]) // red
            union(){
                
                // top
                shift_top_r = Ball_raduis*2*shift_factor;
                translate([0,shift_top_r,0]) 
                translate([wall_thinkness,size_y/2,wall_thinkness+debug_eliv*2]) 
                    scale([Ball_raduis*2,size_y/2+channel_width/2-shift_top_r,size_z]) 
                        cube(1);
                
                // side
                shift_side_r = wall_thinkness+Ball_raduis;
                translate([shift_side_r,0,0]) 
                translate([0,size_y+wall_thinkness,wall_thinkness+debug_eliv*2]) 
                    scale([size_x+Ball_raduis*2-shift_side_r,Ball_raduis*2,size_z]) 
                        cube(1);
                
                // bottom
                translate([0,0,0])
                translate([size_x+wall_thinkness,0,wall_thinkness+debug_eliv*2]) 
                    scale([Ball_raduis*2,size_y+Ball_raduis*2,size_z]) 
                        cube(1);
                               
                // top
                translate([channel_width/2,size_y+channel_width/2,wall_thinkness+debug_eliv*2]) 
                    cylinder(r=Ball_raduis, h=size_z);
                                               
                // bottom
                translate([size_x+channel_width/2,size_y+channel_width/2,wall_thinkness+debug_eliv*2]) 
                    cylinder(r=Ball_raduis, h=size_z);   
                
            }
            
            
}

module side_wind_box(Ball_raduis,channel_width,size_x,size_y,size_z,debug_eliv){
            // top   
            shift = Ball_raduis*2*shift_factor;
            translate([0,shift,0]) // shift 
            translate([0,size_y/2,debug_eliv]) 
                scale([channel_width,size_y/2+channel_width-shift,size_z]) 
                    cube(1);   

            // side   ??? +5??
            translate([0+5,size_y,debug_eliv]) 
                scale([size_x,channel_width,size_z]) 
                    cube(1);

            // bottom
            translate([size_x,0,debug_eliv]) 
                scale([channel_width,size_y+channel_width,size_z]) 
                    cube(1);

            }    
            
        
module  side_wind_box_fan(Ball_raduis,channel_width,size_x,size_y,size_z,fan_x, fan_y, fan_z, factor_fan, debug_eliv){


// fan dimensions

//fan_x = 20+fan_x;
//fan_y = 40;
//fan_z = 40;
//factor_fan = 0.8;

            // Flange
            
    difference(){
    
            //Flange upwind
            translate([size_x*factor_fan-wall_thinkness,-fan_y,debug_eliv]) 
                scale([wall_thinkness,fan_y,fan_z]) 
                    cube(1);
      
               //Flange hole
            translate([size_x*factor_fan+fan_x+wall_thinkness,-fan_z/2,fan_z/2+debug_eliv])
                     rotate(a = -90, v = [0, 1, 0])
 
                    cylinder( h = fan_x+wall_thinkness*2, r = fan_z/2-wall_thinkness, center = false, $fn= 50 );


           }
           
    difference(){
    

            //Flange downwind
            translate([size_x*factor_fan+fan_x,-fan_y,debug_eliv]) 
                scale([wall_thinkness,fan_y,fan_z]) 
                    cube(1);

        
               //Flange hole
            translate([size_x*factor_fan+fan_x+wall_thinkness,-fan_z/2,fan_z/2+debug_eliv])
                     rotate(a = -90, v = [0, 1, 0])
 
                    cylinder( h = fan_x+wall_thinkness*2, r = fan_z/2-wall_thinkness, center = false, $fn= 50 );


           }
           
           
           
////////////////////////////////////////////

            // side


    /////////////   funnels
    length_side  = (size_x*(1-factor_fan)-fan_x-wall_thinkness);

    scale_fan_z = channel_width/fan_y;
    scale_fan_y = size_z/fan_z;
    
    raduis_funnel = fan_y/2;

    translate([size_x*factor_fan+length_side/2+fan_x+wall_thinkness,0,debug_eliv*3])   
rotate(a = 90, v = [0, 1, 0])

    // funnel down wind

difference(){
       
 linear_extrude(height = length_side,
                center = true,
                convexity = 10,
                scale=[scale_fan_y,scale_fan_z], 
//                slices = 70, 
                $fn=100)
                    translate([-raduis_funnel,-raduis_funnel, 0])
                        circle(r = raduis_funnel, center = true);


 linear_extrude(height = length_side,
                center = true,
                convexity = 10,
                scale=[scale_fan_y,scale_fan_z], 
//                slices = 70, 
                $fn=100)
                    translate([-raduis_funnel,-raduis_funnel, 0])
                        circle(r = raduis_funnel-wall_thinkness*1.5, center = true);
            
            }



///////////////////// funnel upwind
//translate([size_x*factor_fan+length_side/2+fan_x+wall_thinkness,0,20+debug_eliv*3])   
            
translate([size_x*factor_fan-length_side/2-wall_thinkness,0,debug_eliv*3])   
rotate(a = -90, v = [0, 1, 0])
difference(){
       
    linear_extrude(height = length_side,
                center = true,
                convexity = 10,
                scale=[scale_fan_y,scale_fan_z], 
//                slices = 70, 
                $fn=100)
                    translate([raduis_funnel,- raduis_funnel, 0])
                        circle(r = raduis_funnel, center = true);


    linear_extrude(height = length_side,
                center = true,
                convexity = 10,
                scale=[scale_fan_y,scale_fan_z], 
//                slices = 70, 
                $fn=100)
                    translate([raduis_funnel,- raduis_funnel, 0])
                        circle(r = raduis_funnel-wall_thinkness*1.5, center = true);
            
            }


                    
//            // Fan 
//            translate([size_x*factor_fan,-fan_y,debug_eliv]) 
//                scale([fan_x,fan_y,fan_z]) 
//                    cube(1);

//            // side   
//            translate([0,-channel_width,debug_eliv]) 
//                scale([size_x,channel_width,size_z]) 
//                    cube(1);
//            



//  down wind tube

difference(){

            // side  bottom 
            translate([size_x,-channel_width,debug_eliv]) 
                scale([channel_width,channel_width,size_z+wall_thinkness]) 
                    cube(1);
                    
            // bottom sphere junction
            color([0,1,1]) 
        //    translate([0,0,Ball_raduis*2+1]) 
                translate([size_x+channel_width/2,-channel_width/2,size_z/2+debug_eliv*3]) 
                    scale([channel_width/2-wall_thinkness/2,1,size_z/2-wall_thinkness])
                        sphere(1, center = false);   
            
            // horizontal tube
            shift_bottom_c = 0;
            length_bottom  = channel_width/2;
            color([0,0,1]) // blue
        //    translate([shift_side_c,0,0]) 
            translate([size_x+channel_width/2,0,size_z/2+debug_eliv*3]) 
//                    scale([channel_width/2-wall_thinkness,1,size_z/2-wall_thinkness*2])
                    
                    scale([channel_width/2-wall_thinkness*1.3,1,size_z/2-wall_thinkness])

                    rotate(a = 90, v = [1, 0, 0]){
                        cylinder( h = length_bottom, r = 1, center = false, $fn= 50);};           

            // vertical tube
            translate([size_x+channel_width/2,-channel_width/2,size_z/2+debug_eliv*3]) 
                rotate(a = -90, v = [0, 0, 1])
                    scale([channel_width/2-wall_thinkness/4,1,size_z/2-wall_thinkness])
                        rotate(a = 90, v = [1, 0, 0]){
                            cylinder( h = length_bottom, r = 1, center = false, $fn= 50);};           
            
                                   
                        
                        }          
                        
                        
            
// up wind tube

difference(){

            //
            upwind_length = size_x*factor_fan-length_side-wall_thinkness;

            // side   
            translate([0,-channel_width,debug_eliv]) 
                scale([upwind_length,channel_width,size_z+wall_thinkness]) 
                    cube(1);
                    
            
            // top sphere junction
            color([0,1,1]) 
        //    translate([0,0,Ball_raduis*2+1]) 
                translate([0+channel_width/2,-channel_width/2,size_z/2+debug_eliv*3]) 
                    scale([channel_width/2-wall_thinkness/2,Ball_raduis,size_z/2-wall_thinkness]) 
                        sphere(1, center = false);   
            
            // horizontal tube
            shift_bottom_c = 0;
            length_bottom  = channel_width/2;
            color([0,0,1]) // blue
            translate([0+channel_width/2,size_y/2,size_z/2+debug_eliv*3]) 
                    scale([channel_width/2-wall_thinkness/2,1,size_z/2-wall_thinkness])
                    rotate(a = 90, v = [1, 0, 0]){
                        cylinder( h = size_y/2+channel_width/2, r = 1, center = false, $fn=25);};           
            
            // vertical tube         
            translate([upwind_length,-channel_width/2,size_z/2+debug_eliv*3]) 
                    rotate(a = -90, v = [0, 0, 1])
                    scale([channel_width/2-wall_thinkness/4,1,size_z/2-wall_thinkness/2])
                        rotate(a = 90, v = [1, 0, 0]){
                            cylinder( h = upwind_length-channel_width/2, r = 1, center = false, $fn = 25);};           
            
                        }                                  
            }         

            
/////////////////////////////////////////////////////////////
//
//      funnel module
//            
/////////////////////////////////////////////////////////////
            
module funnel(funnel_size,wall_thinkness,size_x,size_y,size_z,funnel_resulition){
    
        //// funnel
        union(){

        //
        ////translate([25,150,wall_thinkness]) scale([funnel_size,size_y/2,size_z]) sphere(radius = 1);
        // 

        translate([funnel_size/2+wall_thinkness,size_y/2,wall_thinkness])  scale([funnel_size,size_y-wall_thinkness*2,size_z])  cylinder(r=0.5, h=1,$fn = funnel_resulition );

        // opening
        opening_size = Ball_raduis*inlet_factor*2;
        translate([(funnel_size+wall_thinkness/2),size_y/2-opening_size/2,wall_thinkness]) scale([wall_thinkness*5,opening_size,size_z])  cube( center = false);

        }
}


module Cascades (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis){
    
        // Cascades
        for (y = [wall_thinkness:wall_thinkness+channel_size:size_y-wall_thinkness] )
        {   
            union(){
                
                // Cascades 
                translate([230/350*size_x,y*spacing_factor,wall_thinkness]) 
                    scale([cascades_lengths*break_factor,channel_size,size_z]) 
                        cube(1);

                // break Cascades
                translate([230/350*size_x+cascades_lengths*break_factor,y*spacing_factor,wall_thinkness]) rotate(a = break_angel, v = [0, 0, 1])
                    scale([cascades_lengths*(1-break_factor)+wall_thinkness*2,Ball_raduis*2,size_z]) 
                        cube(1);
                
//               // pin heads
//                translate([230/350*size_x+cascades_lengths*break_factor/2,y*spacing_factor+channel_size/2,-wall_thinkness])
//                    scale([2,1,5]) 
//                        cube(2.54, center = true);
              
                }
        }
        
    }


module pin_heads (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis, size = 2.7, scale_x=2){
    
        // iterations
        for (y = [wall_thinkness:wall_thinkness+channel_size:size_y-wall_thinkness] )
        {   
            union(){
                
         // pin heads
        translate([230/350*size_x+cascades_lengths*break_factor/2,y*spacing_factor+channel_size/2,0])
                scale([scale_x,1,wall_thinkness*3]) 
                    cube(size, center = true);
                }
        }
        
    }

////////////////////////////////////////////
// geomerty
////////////////////////////////////////////

// create box
union()    {
difference(){

    // bounding box
    scale([size_x,size_y,size_z]) cube(1);
    
        // horizontal tube
        shift_bottom_c = 0;
        length_bottom  = channel_width/2;
        color([0,0,1]) // blue
        translate([0+channel_width/2,size_y/2,size_z/2+debug_eliv*3]) 
                scale([channel_width/2-wall_thinkness*1.3,1,size_z/2-wall_thinkness])
                rotate(a = 90, v = [1, 0, 0]){
                    cylinder( h = size_y/2+channel_width/2, r = 1, center = false, $fn=25);};   

    // funnel
    funnel(funnel_size,wall_thinkness,size_x,size_y,size_z,funnel_resulition);

    // bottom box
    translate([funnel_size+wall_thinkness*2,wall_thinkness,wall_thinkness]) scale([size_x-funnel_size-wall_thinkness*2 - cascades_lengths,size_y-wall_thinkness*2,size_z]) cube(1);

    // wind tunnel tubing       
    create_wind_tubeing(Ball_raduis,wall_thinkness,size_x,size_y,size_z,channel_width,debug_eliv);

    // Cascades
    Cascades (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis);
                    
//    // holes bannan headss                
//    pin_heads (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis, size = 2.7, scale_x=1);
//    
    // holes bannan headss
    translate([0,0.9,0])                pin_heads (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis, size = 1.3, scale_x=1);
    
        translate([0,-0.9,0])                pin_heads (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis, size = 1.3, scale_x=1);                  
    
}

// plexy glass holder


translate([size_x+channel_width,-channel_width,0]) 
    scale([wall_thinkness,channel_width*2 + size_y,size_z+wall_thinkness]) cube(1);

//  pins
factor_pins = 1.;
randum_vec = rands(1,5,50000,1);
i = 0;
//for (y = [10:10:290] )
    for (y = [wall_thinkness+Ball_raduis*4-2:Ball_raduis*4*factor_pins:size_y-wall_thinkness-Ball_raduis*2])

    for (x = [62.5:Ball_raduis*4:223/350*size_x-10] )
        {   i = x*y;
            randum_pillar(x,y,size_z,floor(randum_vec[i]));
//            echo(x*y);
        }
        
// create channels
channel_size = Ball_raduis*2*spacing_factor;
break_factor = 0.9;
break_angel  = 10; // degs
        
// return tube
if (debug_eliv == 0){
difference(){
    // create wind channel box
    difference(){

        // side wind box 
        color([1,1,1]) // green
        side_wind_box(Ball_raduis,channel_width,size_x,size_y,size_z,debug_eliv);
            
        // wind channel tubing 
        color([1,0,0]) // red
        create_wind_tubeing(Ball_raduis,wall_thinkness,size_x,size_y,size_z,channel_width,debug_eliv);
        }
        
        // casacads
        echo((wall_thinkness-size_y-wall_thinkness)/(wall_thinkness+channel_size));
        Cascades (wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,size_z,Ball_raduis);
    }
}

    // side wind box 
    color([1,0,1]) // green
    side_wind_box_fan(Ball_raduis,channel_width,size_x,size_y,size_z,fan_x, fan_y, fan_z, factor_fan, debug_eliv);

    // floor
    floor_thinkess = 3.5;
    difference() {
    union(){
    translate([0,-channel_width,-floor_thinkess]) scale([size_x+channel_width+wall_thinkness,size_y+   channel_width*2,floor_thinkess]) cube(1);   

    translate([size_x*factor_fan-fan_x*1.5,-fan_y,-floor_thinkess]) 
        scale([fan_x*4,fan_y,floor_thinkess]) cube(1);   
    }
    translate([0,0,-floor_thinkess/2]) 
    pin_heads(wall_thinkness,channel_size,cascades_lengths,break_factor,break_angel,size_x,size_y,floor_thinkess,Ball_raduis, size = 3.4, scale_x=12);
    }
    
}



//////////////////////////////////////////////////////
// debug or not used
//////////////////////////////////////////////////////

//// bottom box
//translate([funnel_size+wall_thinkness*2+size_x-funnel_size-wall_thinkness*2 - cascades_lengths,wall_thinkness,debug_eliv]) scale([cascades_lengths+wall_thinkness*2,size_y-wall_thinkness*2+channel_width,size_z]) cube(1);
    
//for (y = [0:channel_size:size_y-wall_thinkness] )
//{   
//    union(){
//        
//        translate([230,y*spacing_factor,debug_eliv]) scale([cascades_lengths*break_factor,wall_thinkness,size_z]) cube(1);
//
//        translate([230+cascades_lengths*break_factor,y*spacing_factor,debug_eliv]) rotate(a = break_angel, v = [0, 0, 1])scale([cascades_lengths*(1-break_factor)+wall_thinkness*2,wall_thinkness,size_z]) cube(1);
//    
//        }
//}


//
//if(debug_eliv != 0){
//
//// create wind channel box
//color([0,1,0]) // green
////difference(){
//union(){
//    
//     // top   
//     shift = Ball_raduis*2;
//     translate([0,shift,0]) // shift 
//     translate([0,size_y/2,debug_eliv]) 
//        scale([channel_width,size_y/2+channel_width-shift,size_z]) 
//            cube(1);
//    
//    // side   
//    translate([0+5,size_y,debug_eliv]) 
//        scale([350,channel_width,size_z]) 
//            cube(1);
//
//    // bottom
//    translate([size_x,0,debug_eliv]) 
//        scale([channel_width,size_y+channel_width,size_z]) 
//            cube(1);
//
//  
//    }
//
//
//// wind channel tubing 
//color([1,0,0]) // red
//union(){
//    
//    // top
//    shift_top_r = Ball_raduis*2;
//    translate([0,shift_top_r,0]) 
//    translate([wall_thinkness,size_y/2,debug_eliv*2]) 
//        scale([Ball_raduis*2,size_y/2+channel_width/2-shift_top_r,size_z]) 
//            cube(1);
//    
//    // side
//    shift_side_r = wall_thinkness+Ball_raduis;
//    translate([shift_side_r,0,0]) 
//    translate([0,size_y+wall_thinkness,debug_eliv*2]) 
//        scale([size_x+Ball_raduis*2-shift_side_r,Ball_raduis*2,size_z]) 
//            cube(1);
//    
//    // bottom
//    translate([0,0,0])
//    translate([size_x+wall_thinkness,0,debug_eliv*2]) 
//        scale([Ball_raduis*2,size_y+Ball_raduis*2,size_z]) 
//            cube(1);
//    
//    // top
//    translate([channel_width/2,size_y+channel_width/2,debug_eliv*2]) 
//        cylinder(r=Ball_raduis, h=size_z);
//    
//    // bottom
//    translate([size_x+channel_width/2,size_y+channel_width/2,debug_eliv*2]) 
//        cylinder(r=Ball_raduis, h=size_z);   
//    
//}
//
////}
//// ??? (+1) ???
//
//// wind channel tubing 
//union(){
//    
//    // top
//    shift_top_c = Ball_raduis*2 ;
//    length_top  = size_y/2+channel_width/2-shift_top_c;
//    color([0,0,1]) // blue
//    translate([0,shift_top_c,0]) 
//    translate([wall_thinkness+Ball_raduis,length_top+size_y/2,size_z/2+debug_eliv*3]) 
//        rotate(a = 90, v = [1, 0, 0]){
//            cylinder( h = length_top, r = Ball_raduis, center = false);};
//
//    // side
//    shift_side_c = wall_thinkness + Ball_raduis;
//    length_side  = size_x+Ball_raduis*2-shift_side_c;
//    color([0,0,1]) // blue
//    translate([shift_side_c,0,0]) 
//    translate([0,size_y+wall_thinkness+Ball_raduis,size_z/2+debug_eliv*3]) 
//        rotate(a = 90, v = [0, 1, 0]){
//            cylinder( h = length_side, r = Ball_raduis, center = false);};    
//    
//    // bottom
//    shift_bottom_c = wall_thinkness + Ball_raduis;
//    length_bottom  = size_y+Ball_raduis*2;
//    color([0,0,1]) // blue
////    translate([shift_side_c,0,0]) 
//    translate([size_x+channel_width/2,length_bottom,size_z/2+debug_eliv*3]) 
//        rotate(a = 90, v = [1, 0, 0]){
//            cylinder( h = length_bottom, r = Ball_raduis, center = false);};             
//    
//    // top
//    color([0,1,1]) 
////    translate([0,0,Ball_raduis*2+1]) 
//    translate([channel_width/2,size_y+channel_width/2,size_z/2+debug_eliv*3]) 
//        sphere(Ball_raduis, center = false);
//    // bottom
//    color([0,1,1]) 
////    translate([0,0,Ball_raduis*2+1]) 
//    translate([size_x+channel_width/2,size_y+channel_width/2,size_z/2+debug_eliv*3]) 
//        sphere(Ball_raduis, center = false);   
//    
//}
//
//
//}