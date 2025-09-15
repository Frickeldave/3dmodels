$fn = 100;
// Import curved pipe library (https://www.thingiverse.com/thing:71464)
use <./../../../modules/scad/curved pipe/curvedPipe.scad>
// points - An array of 3D points, e.g. [[0,0,0], [100,0,0], [100,100,0]]  
// segments - the number of segments in the curve, e.g. 2 (one less than the number of points)  
// radii - an array of corner radii, e.g. [30,10]  
// od - outer diameter of the pipe  
// id - internal diameter of the pipe  

// _pipe_points = [[0,0,0],
// 				[100,0,0],
// 				[100,100,0],
// 				[50,100,100],
// 				[50,100,150],
// 				[0,100,50],
// 				[0,0,0],
// 				[50,0,50]
// 			   ];
// _pipe_radius = [70,30,30,6,50,30];

_pipe_points = [[0,0,0],
				[25,0,0],
                [40,17,0]
			   ];
_pipe_radius = [30];

curvedPipe(_pipe_points, 2, _pipe_radius, 53, 49);

translate([-43, 0, 0])
rotate([0, 90, 0])
cylinder(h = 33, r = 25);