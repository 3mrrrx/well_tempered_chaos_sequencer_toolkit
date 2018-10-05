// well-tempered chaos sequencer board version 1.0
// 5/8/2018   By: 3mrrrx
// GNU GPLv3


//////// modules
module  randum_pillar(x=1, y=1, resulation = 6 ) { translate([x,y,0]) cylinder($fn = resulation, $fa = 12, $fs = 2, h = 20, r1 = 2, r2 = 2, center = false);}
    
//////// model
//// Board
difference(){

// bounding_box
scale([350,300,20]) cube(1);

// triangle
$fn =3; 
translate([25,150,19.5]) scale([50,150,20]) sphere(radius = 1);

// bottem box
translate([59,5,5]) scale([285,290,20]) cube(1);

}

//// create pins
color_vec = ["black","red","blue","green","pink","purple"];


// random vector for $fn circular segment resolution
// $fn = 3 ->  traingel 
// $fn = 5 ->  pentagon 

randum_vec = rands(3,6,50000,1);

i = 0;
 for (y = [10:10:290] )
    for (x = [68:10:223] )
        {   i = x*y;
         randum_pillar(x,y,floor(randum_vec[i]));
        }

//// create bins
 for (y = [5:6.:295] )
 {
translate([230,y,0]) scale([120,2,20]) cube();
 }