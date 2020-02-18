
addpath(genpath('src'));

%% INIT PARAMETERS TO CREATE VORONOI TUBULAR MODELS USING DELAUNAY TRIANGULATIONS
%width of initial deployed cylinder (apical)
wInit = 512;
%height of initial deployed cylinder (apical)
hInit = 4096;
%number of cells
numSeeds = 200;
%number of different randomizations
numRand = 20;

%surfaces ratios to expand the basal surface
sr = 1:0.25:10;
%surfaces ratios to plot in graphs
srOfInterest = 1:0.25:10;

%Kinds of initial Voronoi diagrams regarding the Lloyd algorithm.
setVoronoi = 1 : 10;
setNLloydIt = setVoronoi -1;

%hyde or show numbers of heatMaps plots
hydeNumberLabels = 1;

%% CALCULATE VORONOI DIAGRAMS SAVING SOME DATA AND GRAPHICS (FLINTSTONES LAW PAPER)
delaunayEuler3DPredefinedSeeds(wInit,hInit,numSeeds,numRand,setVoronoi,sr,srOfInterest,hydeNumberLabels)


% %get random seeds or load from files (true -> random; false -> load file) 
% isRandom = false;
% %delaunayEuler3D(wInit,hInit,numSeeds,numRand,setNLloydIt,isRandom)
