// Gmsh project created on Tue Jan  3 12:24:59 2023

Lateral = 400;
xFactor = 0.4;

//+ Upper Boundaries:

LowerRes = 400;
MidRes = LowerRes + 250;
UpperRes = MidRes + 400;

//+ 

MeshRefine = 15.0;
MeshRefine2 = 60.0;

//+

//+Bottom Boundary
Point(1) = {0, 0, 0, MeshRefine};
Point(2) = {Lateral*xFactor, 0, 0, MeshRefine};
Point(3) = {Lateral, 0, 0, MeshRefine}; 

//+Top Boundary
Point(4) = {0, UpperRes, 0, MeshRefine};
Point(5) = {Lateral, UpperRes, 0, MeshRefine};
Point(6) = {Lateral*xFactor, UpperRes, 0, MeshRefine};



//+ Production Point

Point(7) = {0, MidRes-125, 0, MeshRefine};

//+ Injection Point

Point(8) = {Lateral, MidRes-125, 0, MeshRefine};

//+ UpperBoundary Middle Reservoir

Point(9) = {0, MidRes, 0, MeshRefine};
Point(10) = {Lateral*xFactor, MidRes, 0, MeshRefine};
Point(11) = {Lateral, MidRes, 0, MeshRefine};

//+Upper Boundary of LowerReservoir
Point(12) = {0, LowerRes, 0, MeshRefine};
Point(13) = {Lateral*xFactor, LowerRes, 0, MeshRefine};
Point(14) = {Lateral, LowerRes, 0, MeshRefine};


//+
Physical Point("InjectionPoint", 1) = {8};
Physical Point("ProductionPoint", 2) = {7};





//+//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 14};
//+
Line(4) = {14, 8};
//+
Line(5) = {8, 11};
//+
Line(6) = {11, 5};
//+
Line(7) = {5, 6};
//+
Line(8) = {6, 4};
//+
Line(9) = {4, 9};
//+
Line(10) = {9, 7};
//+
Line(11) = {7, 12};
//+
Line(12) = {12, 1};
//+
Line(13) = {1, 1};
//+
Line(14) = {2, 13};
//+
Line(15) = {13, 10};
//+
Line(16) = {10, 6};
//+
Line(17) = {10, 9};
//+
Line(18) = {10, 11};
//+
Line(19) = {14, 13};
//+
Line(20) = {13, 12};
//+
Curve Loop(1) = {8, 9, -17, 16};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {7, -16, 18, 6};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {17, 10, 11, -20, 15};
//+
Plane Surface(3) = {3};
//+
Curve Loop(4) = {18, -5, -4, 19, 15};
//+
Plane Surface(4) = {4};
//+
Curve Loop(5) = {19, -14, 2, 3};
//+
Plane Surface(5) = {5};
//+
Curve Loop(6) = {20, 12, 1, 14};
//+
Plane Surface(6) = {6};



Physical Curve("TopBC", 21) = {8, 7};
//+
Physical Curve("RightBC", 22) = {6, 5, 4, 3};
//+
Physical Curve("BottomBC", 23) = {2, 1};
//+
Physical Curve("LeftBC", 24) = {9, 10, 11, 12};
//+
Physical Surface("reservoir", 25) = {1, 2, 4, 3, 6, 5};
