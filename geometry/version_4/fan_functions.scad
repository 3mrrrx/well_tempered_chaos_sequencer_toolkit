// well-tempered chaos sequencer board version 3.0
// fan functions
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]

////////////////////////////////////////////
// cut tubings from wind retrun tubing box
////////////////////////////////////////////
module create_wind_tubeing(Ball_raduis,wall_thinkness,size_x,size_y,size_z,channel_width,debug_eliv){
    
    // wind channel tubing 
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

////////////////////////////////////////////
//  create wind retrun tubing box 
////////////////////////////////////////////
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
    Sscale([channel_width,size_y+channel_width,size_z]) 
        cube(1);
    
}    
            
            
////////////////////////////////////////////
//  create wind pump tubing box
////////////////////////////////////////////        
module  side_wind_box_fan(Ball_raduis,channel_width,size_x,size_y,size_z,fan_x, fan_y, fan_z, factor_fan, debug_eliv){

    ////////////////////////////////////////////    
    // flange for holding the fan
    ////////////////////////////////////////////  
            
    //upwind flange geometry
    difference(){
    
        //Flange box
        translate([size_x*factor_fan-wall_thinkness,-fan_y,debug_eliv]) 
        scale([wall_thinkness,fan_y,fan_z]) 
            cube(1);

       //Flange hole
        translate([size_x*factor_fan+fan_x+wall_thinkness,-fan_z/2,fan_z/2+debug_eliv])
        rotate(a = -90, v = [0, 1, 0])
            cylinder( h = fan_x+wall_thinkness*2, r = fan_z/2-wall_thinkness, center = false, $fn= 50 );

        }
           
    //flange downwind flange
    difference(){
    
            //Flange box
            translate([size_x*factor_fan+fan_x,-fan_y,debug_eliv]) 
            scale([wall_thinkness,fan_y,fan_z]) 
                cube(1);
        
            //Flange hole
            translate([size_x*factor_fan+fan_x+wall_thinkness,-fan_z/2,fan_z/2+debug_eliv])
            rotate(a = -90, v = [0, 1, 0])
            cylinder( h = fan_x+wall_thinkness*2, r = fan_z/2-wall_thinkness, center = false, $fn= 50 );
           }
           
    ////////////////////////////////////////////    
    // fan funnel
    ////////////////////////////////////////////  
                       
           
    //fan funnel parameters
    length_side  = (size_x*(1-factor_fan)-fan_x-wall_thinkness);
    scale_fan_z = channel_width/fan_y;
    scale_fan_y = size_z/fan_z;
    
    raduis_funnel = fan_y/2;

    //  down wind funnel geometry
    translate([size_x*factor_fan+length_side/2+fan_x+wall_thinkness,0,debug_eliv*3])   
    rotate(a = 90, v = [0, 1, 0])
        difference(){
            
            linear_extrude(height = length_side,
                    center = true,
                    convexity = 10,
                    scale=[scale_fan_y,scale_fan_z], 
                    $fn=100)
                        translate([-raduis_funnel,-raduis_funnel, 0])
                            circle(r = raduis_funnel, center = true);
            
            linear_extrude(height = length_side,
                    center = true,
                    convexity = 10,
                    scale=[scale_fan_y,scale_fan_z], 
                    $fn=100)
                        translate([-raduis_funnel,-raduis_funnel, 0])
                            circle(r = raduis_funnel-wall_thinkness*1.5, center = true);
                
            }



    //  up wind funnel geometry
    translate([size_x*factor_fan-length_side/2-wall_thinkness,0,debug_eliv*3])   
    rotate(a = -90, v = [0, 1, 0])
    difference(){
        linear_extrude(height = length_side,
                    center = true,
                    convexity = 10,
                    scale=[scale_fan_y,scale_fan_z], 
                    $fn=100)
                        translate([raduis_funnel,- raduis_funnel, 0])
                            circle(r = raduis_funnel, center = true);

        linear_extrude(height = length_side,
                    center = true,
                    convexity = 10,
                    scale=[scale_fan_y,scale_fan_z], 
                    $fn=100)
                        translate([raduis_funnel,- raduis_funnel, 0])
                            circle(r = raduis_funnel-wall_thinkness*1.5, center = true);
                
    }


    ////////////////////////////////////////////    
    // air tubings  around funnel
    ////////////////////////////////////////////  

    // down wind tuebings
    difference(){

                // side  bottom 
                translate([size_x,-channel_width,debug_eliv]) 
                scale([channel_width,channel_width,size_z+wall_thinkness]) 
                    cube(1);
                        
                // bottom sphere junction
                color([0,1,1]) 
                translate([size_x+channel_width/2,-channel_width/2,size_z/2+debug_eliv*3]) 
                scale([channel_width/2-wall_thinkness/2,1,size_z/2-wall_thinkness])
                    sphere(1, center = false);   
                
                // horizontal tube
                shift_bottom_c = 0;
                length_bottom  = channel_width/2;
                color([0,0,1]) // blue
                translate([size_x+channel_width/2,0,size_z/2+debug_eliv*3])  
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
                translate([0+channel_width/2,-channel_width/2,size_z/2+debug_eliv*3]) 
                scale([channel_width/2-wall_thinkness/2,Ball_raduis,size_z/2-   wall_thinkness]) 
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
                    cylinder( h = upwind_length-channel_width/2, r = 1, center = false, $fn = 25);
    };     
                    
    }                                  
}         

            
/////////////////////////////////////////////////////////////
//      funnel module
/////////////////////////////////////////////////////////////
            
module funnel(funnel_size,wall_thinkness,size_x,size_y,size_z,funnel_resulition){
    
    // funnel
    union(){

        translate([funnel_size/2+wall_thinkness,size_y/2,wall_thinkness])  scale([funnel_size,size_y-wall_thinkness*2,size_z])
            cylinder(r=0.5, h=1,$fn = funnel_resulition );

        // opening
        opening_size = Ball_raduis*inlet_factor*2;
        translate([(funnel_size+wall_thinkness/2),size_y/2-opening_size/2,wall_thinkness]) scale([wall_thinkness*5,opening_size,size_z])  
            cube( center = false);

    }
}

