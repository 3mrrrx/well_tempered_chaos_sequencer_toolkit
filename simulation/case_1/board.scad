// well-tempered chaos sequencer board version 1.0 reworked
// 5/8/2018   By: 3mrrrx
// GNU GPLv3


//////// modules
module  random_pillar(x=1, y=1,height=20, raduis = 2, resulation = 6, b=0) { 
    
    translate([x,y,height/2]) 
    
            rotate(b,[0,0,1])

    cylinder($fn = resulation, $fa = 12, $fs = 2, h = height, r1 = raduis, r2 = raduis, center = true);
    
    }

//////// variables
// size
size_x = 275;
size_y = 225;
size_z = 15;

// wall thikness    
wall = 5;

// bearing ball raduis
r_ball = 2.25;
    
// toleranz
tol = 0.2;    
    
//////// model
//// Board
//difference(){

//// bounding_box
//scale([size_x,size_y,size_z]) cube(1);
//
////  funnel for holding the balls hold
//$fn =3; 
//translate([wall*5,size_y/2,size_z+wall-1.5]) scale([size_x/6,size_y/1.5,size_z]) sphere(radius = 1);
    

//// return tube
//translate([wall+5,size_y-wall*5,size_z/2]) scale([size_x*0.2,wall*4,size_z/2]) cube(1);
//    
//translate([wall+5,size_y-wall-size_y/2,size_z/2]) scale([wall*2,size_y/2,size_z/2]) cube(1);    

// bottem box
//translate([size_x*0.2,wall,size_z/2]) scale([size_x*0.775,size_y-wall*2,size_z]) cube(1);

    
//}


//// create pins
// random seed

wid=58; 
logox = 514; 
logoy = 226; 

translate([size_x*0.7,0,0]) 

rotate(90,[0,0,1])

scale([1.6,1.6,size_z])

difference(){ 
    
    translate([wid/4,wid/4,1]) 
        scale([wid/logox*2,wid/logoy,1/255]) 
             surface("C:/Users/hasan/Desktop/dont_apnic.png",invert=true); 
    cube([wid*2.5,wid*1.5,1]); 


} 


//// create bins
//wall_bin = 2;
//bin_step = wall_bin*2+r_ball*2+tol;
//        
// for (y = [wall+bin_step-wall_bin:bin_step:size_y-wall] )
// {
//translate([size_x*0.7,y,0]) scale([size_x*0.3,wall_bin,size_z]) cube();
// }
 