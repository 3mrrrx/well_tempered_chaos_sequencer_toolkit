// well-tempered chaos sequencer board version 1.0 reworked
// 5/8/2018   By: 3mrrrx
// GNU GPLv3


//////// modules
module  random_pillar(x=1, y=1,height=20, raduis = 2, resulation = 6 ) { translate([x,y,0]) cylinder($fn = resulation, $fa = 12, $fs = 2, h = height, r1 = raduis, r2 = raduis, center = false);
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
difference(){

// bounding_box
scale([size_x,size_y,size_z]) cube(1);

//  funnel for holding the balls hold
$fn =3; 
translate([wall*5,size_y/2,size_z+wall-1.5]) scale([size_x/6,size_y/1.5,size_z]) sphere(radius = 1);
    

// return tube
translate([wall,size_y-wall*5,size_z/2]) scale([size_x*0.2,wall*4,size_z/2]) cube(1);
    
translate([wall,size_y-wall-size_y/2,size_z/2]) scale([wall*4,size_y/2,size_z/2]) cube(1);    

// bottem box
translate([size_x*0.2,wall,size_z/2]) scale([size_x*0.775,size_y-wall*2,size_z]) cube(1);

    
}


//// create pins
// random seed
seed = 1;

// random vector for $fn circular segment resolution
// $fn = 3 ->  traingel 
// $fn = 5 ->  pentagon 
random_res = rands(3,6,50000,seed);

// random vector for pin two variations
random_r = rands(r_ball*0.8,r_ball*0.8,50000,seed);
// random_r = rands(0,r_ball*1.5,50000,seed);

// steps between bins
x_step = r_ball*4+tol;
y_step = r_ball*4+tol;

i = 0;
 for (y = [wall*2:y_step:size_y-wall*2] )
    for (x = [size_x*0.25:x_step:size_x*0.68] )
        {   i = x*y;
         random_pillar(x,y,size_z,random_r[i],floor(random_res[i]));
        }

//// create bins
wall_bin = 2;
bin_step = wall_bin*2+r_ball*2+tol;
        
 for (y = [wall+bin_step-wall_bin:bin_step:size_y-wall] )
 {
translate([size_x*0.7,y,0]) scale([size_x*0.3,wall_bin,size_z]) cube();
 }
 