
addpath(genpath('src'));

wInit = 512;
hInit = 4096;
numSeeds = 200;
numRand = 20;
sr = 1:0.25:10;
srOfInterest = 1:0.25:5;
%initial Voronoi diagrams
setVoronoi = 1 : 10;
setNLloydIt = setVoronoi -1;

%get random seeds or load from files
isRandom = false;

%hyde or show numbers of heatMaps
hydeNumberLabels = 1;

%Calculate the delaunay diagrams, some data and Graphics.

delaunayEuler3DPredefinedSeeds(wInit,hInit,numSeeds,numRand,setVoronoi,sr,srOfInterest,hydeNumberLabels)

%delaunayEuler3D(wInit,hInit,numSeeds,numRand,setVoronoi-1,isRandom)
