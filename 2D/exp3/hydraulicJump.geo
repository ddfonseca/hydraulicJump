// Inputs
x = 3;
y1 = 0.025;
yt = 0.185 - y1;
y3 = 0.35 - y1 - yt;
z = 0.1;
cellsize = 0.025/5; // deltaX

// Points
Point(0) = {0, 0, 0};
Point(1) = {x, 0, 0};
Point(2) = {x, y1, 0};
Point(3) = {0, y1, 0};

// Points Block 2
Point(4) = {x, yt + y1, 0};
Point(5) = {0, yt + y1, 0};
Point(6) = {x, y3 + yt + y1, 0};
Point(7) = {0, y3 + yt + y1, 0};

// Block 1
Line(10) = {0,1};
Line(11) = {1,2};
Line(12) = {2,3};
Line(13) = {3,0};

// Block 2
// Line -12
Line(14) = {2,4};
Line(15) = {4,5};
Line(16) = {5,3};

// Block 3
// Line -15
Line(17) = {4,6};
Line(18) = {6,7};
Line(19) = {7,5};

// Surface Block 1
Line Loop(20) = {10, 11, 12, 13};
Plane Surface(21) = 20; surfaceOne = 21;

// Surface Block 2
Line Loop(22) = {-12, 14,15,16};
Plane Surface(23) = 22; surfaceTwo = 23;

// Surface Block 3
Line Loop(24) = {-15, 17, 18, 19};
Plane Surface(25) = 24; surfaceThree = 25;

// Structured Mesh Block 1
// Divide the lines based on cellsize definition
divx = x/cellsize + 1;
divy = y1/cellsize + 1;
Transfinite Line{10,12} = divx;
Transfinite Line{11,13} = divy;
Transfinite Surface(surfaceOne);
Recombine Surface(surfaceOne);

// Structured Mesh Block 2
// Divide the lines based on cellsize definition
divx = x/cellsize + 1;
divy = yt/cellsize + 1;
Transfinite Line{-12,15} = divx;
Transfinite Line{14,16} = divy;
Transfinite Surface(surfaceTwo);
Recombine Surface(surfaceTwo);

// Structured Mesh Block 3
// Divide the lines based on cellsize definition
divx = x/cellsize + 1;
divy = y3/cellsize + 1;
Transfinite Line{-15,18} = divx;
Transfinite Line{17,19} = divy;
Transfinite Surface(surfaceThree);
Recombine Surface(surfaceThree);

surfaceOneE[] =
Extrude {0, 0, z}
{
    Surface{surfaceOne};
    Layers{1};
    Recombine;
};

surfaceTwoE[] =
Extrude {0, 0, z}
{
    Surface{surfaceTwo};
    Layers{1};
    Recombine;
};

surfaceThreeE[] =
Extrude {0, 0, z}
{
    Surface{surfaceThree};
    Layers{1};
    Recombine;
};

Physical Surface("walls") = {surfaceOneE[2], surfaceTwoE[5], surfaceThreeE[5]};
Physical Surface("inlet_water") = {surfaceOneE[5]};
Physical Surface("outlet_air") = {surfaceThreeE[3]};
Physical Surface("outlet_water") = {surfaceOneE[3], surfaceTwoE[3]};
Physical Surface("atmosphere") = {surfaceThreeE[4]};
Physical Volume("internal") = {surfaceOneE[1], surfaceTwoE[1], surfaceThreeE[1]};
