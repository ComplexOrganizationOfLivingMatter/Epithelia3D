%%pipeline

rootPath='D:\Pedro\Epithelia3D\';


salivaryGlandFolder='Salivary Glands\Confocal stacks\Segmented images data\';

WTpaths={[rootPath salivaryGlandFolder 'Wild type\13-06-16\gland 1 (sqhgfp ecadh gfp ed 1a 20x)\Label_sequence.mat'];...
[rootPath salivaryGlandFolder 'Wild type\13-06-16\gland 2 (sqhgfp ecadh gfp ed 2a 20x)\Label_sequence.mat'];...
[rootPath salivaryGlandFolder 'Wild type\13-06-16\gland 3 (sqhgfp ecadh gfp ed 3a 20x)\Label_sequence.mat'];...
[rootPath salivaryGlandFolder 'Wild type\13-06-16\gland 4 (sqhgfp ecadh gfp ed 4a 20x)\Label_sequence.mat'];...
[rootPath salivaryGlandFolder 'Wild type\13-06-16\gland 5 (sqhgfp ecadh gfp ed 5a 20x)\Label_sequence.mat'];...
[rootPath salivaryGlandFolder 'Wild type\21-03-16\gland 6 (sqhgfp ecadh gfp ed 2a 20x)\Label_sequence.mat'];...
[rootPath salivaryGlandFolder 'Wild type\10-11-16\gland 7 (sqhgfp pha sqhgfp dapi 20X 1a)\Label_sequence.mat'];...
[rootPath salivaryGlandFolder 'Wild type\10-11-16\gland 8 (sqhgfp pha sqhgfp dapi 20X 2a)\Label_sequence.mat']};

Ecadhipaths={[rootPath salivaryGlandFolder 'E-cadh inhibited\15-09-16\Gland_1 (Ab-1-Gal4 U-Ecadhi Fal Ecadh 2a 20X)\Label_sequence.mat'];
[rootPath salivaryGlandFolder 'E-cadh inhibited\15-09-16\Gland_2 (Ab-1-Gal4 U-Ecadhi Fal Ecadh 3a 20X)\Label_sequence.mat'];
[rootPath salivaryGlandFolder 'E-cadh inhibited\15-09-16\Gland_3 (Ab-1-Gal4 U-Ecadhi Fal Ecadh 5a 20X)\Label_sequence.mat'];
[rootPath salivaryGlandFolder 'E-cadh inhibited\15-09-16\Gland_4 (Ab-1-Gal4 U-Ecadhi Fal Ecadh 6a 20X)\Label_sequence.mat']};

CultEpaths={[rootPath 'culture epithelia\Segmented images data\24-11-16\n0\Label_sequence.mat'];
[rootPath 'culture epithelia\Segmented images data\24-11-16\n1\Label_sequence.mat'];
[rootPath 'culture epithelia\Segmented images data\24-11-16\n2\Label_sequence.mat']};


micronsToPixels=1024/631.02; %microns*(pixels/microns)= pixels;


hTranWT={};
hTranEc={};
%[hTranWTsition,hTranWTsitionPredict]=recalculateCentroids(pathStructure, frame, cellsGroup, hTranWTsition, curvature, D , alpha,hCell)

%% Transition

%WT
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{1},1,[15,18,13,21],72.9*micronsToPixels,0.204,222.09*micronsToPixels,((29.5*pi)/180),103.28*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{1},'end',[57,59,54,12],58*micronsToPixels,0.217,231.03*micronsToPixels,((0.5*pi)/180),90.22*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{1},'end',[60,62,61,69],66.39*micronsToPixels,0.204,222.09*micronsToPixels,((12.5*pi)/180),103.28*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{1},'end',[68,67,22,58],57.2*micronsToPixels,0.192,237.09*micronsToPixels,((20*pi)/180),98.05*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{2},1,[7,5,17,3],79.26*micronsToPixels,0.214,232.7*micronsToPixels,((21.1*pi)/180),107.23*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{2},'end',[50,53,38,43],73.9*micronsToPixels,0.240,216.66*micronsToPixels,((26*pi)/180),83.17*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{2},'end',[51,49,3,42],94.61*micronsToPixels,0.214,232.7*micronsToPixels,((4*pi)/180),107.23*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{3},'end',[79,73,75,56],91.58*micronsToPixels,0.152,232.05*micronsToPixels,((12.2*pi)/180),98.62*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{3},'end',[64,69,68,42],93.86*micronsToPixels,0.151,269.09*micronsToPixels,((2.1*pi)/180),111.46*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{4},1,[21,29,18,37],37.97*micronsToPixels,0.261,191.41*micronsToPixels,((29.5*pi)/180),71.72*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{4},'end',[78,74,80,53],41.21*micronsToPixels,0.256,195.97*micronsToPixels,((21*pi)/180),73.68*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{4},'end',[71,69,70,56],34.9*micronsToPixels,0.213,183.45*micronsToPixels,((23*pi)/180),68.68*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{5},1,[11,16,12,17],50.6*micronsToPixels,0.243,162.65*micronsToPixels,((1*pi)/180),65.06*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{5},1,[16,20,15,24],40.85*micronsToPixels,0.197,162.48*micronsToPixels,((18*pi)/180),73.53*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{5},1,[25,31,28,29],52.93*micronsToPixels,0.373,178.76*micronsToPixels,((30*pi)/180),57*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{5},'end',[79,77,3,78],52.38*micronsToPixels,0.235,170.87*micronsToPixels,((16*pi)/180),65.47*micronsToPixels); %rareeee motif
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{5},'end',[84,87,83,64],45.41*micronsToPixels,0.254,165.63*micronsToPixels,((26.5*pi)/180),63.57*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{6},3,[23,16,17,21],38.14*micronsToPixels,0.180,167.85*micronsToPixels,((1*pi)/180),68.65*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{6},'end',[69,65,46,64],53.53*micronsToPixels,0.203,168.46*micronsToPixels,((8*pi)/180),66.91*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{6},'end',[65,83,66,56],39.23*micronsToPixels,0.180,167.85*micronsToPixels,((29*pi)/180),68.65*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{6},'end',[73,75,78,74],49.49*micronsToPixels,0.284,176.30*micronsToPixels,((49*pi)/180),65.98*micronsToPixels);
[hTranWT{end+1,1},hTranWT{end+1,2},hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{7},1,[34,32,22,40],35.94*micronsToPixels,0.109,140.62*micronsToPixels,((3.5*pi)/180),62.9*micronsToPixels);


% %Ecadhi

[hTranEc{end+1,1},hTranEc{end+1,2},hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{1},1,[11,7,9,10],12.05*micronsToPixels,0.218,68.53*micronsToPixels,((11.3*pi)/180),27.11*micronsToPixels); %rareeee motif
[hTranEc{end+1,1},hTranEc{end+1,2},hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{1},1,[24,27,25,29],25.44*micronsToPixels,0.19,81.13*micronsToPixels,((21*pi)/180),36.34*micronsToPixels);
[hTranEc{end+1,1},hTranEc{end+1,2},hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{1},'end',[85,75,83,43],30.3*micronsToPixels,0.236,79.9*micronsToPixels,((15*pi)/180),30.3*micronsToPixels);
[hTranEc{end+1,1},hTranEc{end+1,2},hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{1},'end',[89,88,47,45],72.9*micronsToPixels,0.246,90.21*micronsToPixels,((16.5*pi)/180),44.59*micronsToPixels);
[hTranEc{end+1,1},hTranEc{end+1,2},hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{2},1,[21,17,16,23],41.09*micronsToPixels,0.157,111.72*micronsToPixels,((6*pi)/180),46.23*micronsToPixels);
[hTranEc{end+1,1},hTranEc{end+1,2},hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{2},1,[25,20,22,24],5.14*micronsToPixels,0.092,99.59*micronsToPixels,((1*pi)/180),41.14*micronsToPixels);
[hTranEc{end+1,1},hTranEc{end+1,2},hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{4},'end',[97,86,71,78],33.7*micronsToPixels,0.156,80.1*micronsToPixels,((11*pi)/180),33.7*micronsToPixels);




%% No transition

%WT
[hTranWT{end+1,1},~,hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{5},'end',[82,81,74,84],[],0.373,178.76*micronsToPixels,((84.5*pi)/180),57*micronsToPixels);
[hTranWT{end+1,1},~,hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{6},1,[26,22,23,27],[],0.284,176.30*micronsToPixels,((86.5*pi)/180),65.98*micronsToPixels);
[hTranWT{end+1,1},~,hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{7},'end',[78,79,62,63],[],0.109,140.62*micronsToPixels,((7.3*pi)/180),62.9*micronsToPixels);
[hTranWT{end+1,1},~,hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{7},'end',[78,63,79,64],[],0.109,140.62*micronsToPixels,((63.2*pi)/180),62.9*micronsToPixels);
[hTranWT{end+1,1},~,hTranWT{end+1,3},hTranWT{end+1,4},hTranWT{end+1,5},hTranWT{end+1,6},hTranWT{end+1,7},hTranWT{end+1,8},hTranWT{end+1,9},hTranWT{end+1,10},hTranWT{end+1,11},hTranWT{end+1,12},hTranWT{end+1,13},hTranWT{end+1,14},hTranWT{end+1,15},hTranWT{end+1,16},hTranWT{end+1,17}]=recalculateCentroids(WTpaths{7},'end',[78,64,63,65],[],0.109,140.62*micronsToPixels,((64.3*pi)/180),62.9*micronsToPixels);

%Ecadhi
[hTranEc{end+1,1},~,hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{3},1,[12,14,15,16],[],0.299,78.25*micronsToPixels,((58*pi)/180),27.47*micronsToPixels);
[hTranEc{end+1,1},~,hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{4},1,[12,13,2,24],[],0.181, 75.43*micronsToPixels,((24.5*pi)/180),32.89*micronsToPixels);
[hTranEc{end+1,1},~,hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{4},1,[12,18,5,24],[],0.181,75.43*micronsToPixels,((58*pi)/180),32.89*micronsToPixels);
%[hTranEc{end+1,1},~,hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{4},1,[28,18,5,24],[],0.152, 82.37*micronsToPixels,((83*pi)/180),35.47*micronsToPixels);
[hTranEc{end+1,1},~,hTranEc{end+1,3},hTranEc{end+1,4},hTranEc{end+1,5},hTranEc{end+1,6},hTranEc{end+1,7},hTranEc{end+1,8},hTranEc{end+1,9},hTranEc{end+1,10},hTranEc{end+1,11},hTranEc{end+1,12},hTranEc{end+1,13},hTranEc{end+1,14},hTranEc{end+1,15},hTranEc{end+1,16},hTranEc{end+1,17}]=recalculateCentroids(Ecadhipaths{4},1,[28,22,6,31],[],0.152, 82.37*micronsToPixels,((30*pi)/180),35.47*micronsToPixels);


clearvars -except hTranWT hTranEc

hTranWT=cell2table(hTranWT);
hTranWT.Properties.VariableNames{1} = 'motif';
hTranWT.Properties.VariableNames{2} = 'hMeasurements';
hTranWT.Properties.VariableNames{3} = 'hPredict';
hTranWT.Properties.VariableNames{4} = 'hCell';
hTranWT.Properties.VariableNames{5} = 'Degrees';
hTranWT.Properties.VariableNames{6} = 'Curvature';
hTranWT.Properties.VariableNames{7} = 'L12';
hTranWT.Properties.VariableNames{8} = 'L34';
hTranWT.Properties.VariableNames{9} = 'L12PostCurvature';
hTranWT.Properties.VariableNames{10} = 'L34PostCurvature';
hTranWT.Properties.VariableNames{11} = 'CoordA';
hTranWT.Properties.VariableNames{12} = 'CoordB';
hTranWT.Properties.VariableNames{13} = 'LEdgeTransition';
hTranWT.Properties.VariableNames{14} = 'Coord1';
hTranWT.Properties.VariableNames{15} = 'Coord2';
hTranWT.Properties.VariableNames{16} = 'Coord3';
hTranWT.Properties.VariableNames{17} = 'Coord4';


hTranEc=cell2table(hTranEc);
hTranEc.Properties.VariableNames{1} = 'motif';
hTranEc.Properties.VariableNames{2} = 'hMeasurements';
hTranEc.Properties.VariableNames{3} = 'hPredict';
hTranEc.Properties.VariableNames{4} = 'hCell';
hTranEc.Properties.VariableNames{5} = 'Degrees';
hTranEc.Properties.VariableNames{6} = 'Curvature';
hTranEc.Properties.VariableNames{7} = 'L12';
hTranEc.Properties.VariableNames{8} = 'L34';
hTranEc.Properties.VariableNames{9} = 'L12PostCurvature';
hTranEc.Properties.VariableNames{10} = 'L34PostCurvature';
hTranEc.Properties.VariableNames{11} = 'CoordA';
hTranEc.Properties.VariableNames{12} = 'CoordB';
hTranEc.Properties.VariableNames{13} = 'LEdgeTransition';
hTranEc.Properties.VariableNames{14} = 'Coord1';
hTranEc.Properties.VariableNames{15} = 'Coord2';
hTranEc.Properties.VariableNames{16} = 'Coord3';
hTranEc.Properties.VariableNames{17} = 'Coord4';

