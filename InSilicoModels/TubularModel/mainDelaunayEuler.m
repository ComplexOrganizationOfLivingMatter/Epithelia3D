
addpath(genpath('src'));

wInit = 512;
hInit = 4096;
numSeeds = 200;
numRand = 20;
sr = 1:0.25:5;

%initial Voronoi diagrams
setVoronoi = 1 : 10;
setNLloydIt = setVoronoi -1;

%get random seeds or load from files
isRandom = false;

%Calculate the delaunay diagrams, some data and Graphics.

delaunayEuler3DPredefinedSeeds(wInit,hInit,numSeeds,numRand,setVoronoi,sr)

%delaunayEuler3D(wInit,hInit,numSeeds,numRand,setVoronoi-1,isRandom)
