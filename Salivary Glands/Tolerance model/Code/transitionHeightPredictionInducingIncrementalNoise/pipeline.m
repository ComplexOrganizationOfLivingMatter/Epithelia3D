%%pipeline

rootPath='D:\Pedro\Epithelia3D\';

data2SavedPath=[rootPath 'Salivary Glands\Tolerance model\Data\localHeightTransitionPrediction\'];

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

%main(name2save,pathStructure,frame,cellsGroup,hTransition,hCell,curvature)
 
%WT
% main([data2SavedPath '\WT\WT_1a'],WTpaths{1},1,[15,18,13,21],72.9*micronsToPixels,103.28*micronsToPixels,0.204)
% main([data2SavedPath '\WT\WT_1b'],WTpaths{1},'end',[57,59,54,12],58*micronsToPixels,90.22*micronsToPixels,0.217)
% main([data2SavedPath '\WT\WT_1c'],WTpaths{1},'end',[60,62,61,69],59.02*micronsToPixels,103.28*micronsToPixels,0.204)
% main([data2SavedPath '\WT\WT_1d'],WTpaths{1},'end',[68,67,22,58],57.2*micronsToPixels,98.05*micronsToPixels,0.192)
% main([data2SavedPath '\WT\WT_2a'],WTpaths{2},1,[7,5,17,3],79.26*micronsToPixels,107.23*micronsToPixels,0.214)
% main([data2SavedPath '\WT\WT_2b'],WTpaths{2},'end',[49,43,53,31],65.66*micronsToPixels,83.17*micronsToPixels,0.240)
% main([data2SavedPath '\WT\WT_2c'],WTpaths{2},'end',[50,53,38,43],73.9*micronsToPixels,83.17*micronsToPixels,0.240)
% main([data2SavedPath '\WT\WT_2d'],WTpaths{2},'end',[51,49,3,42],94.61*micronsToPixels,107.23*micronsToPixels,0.214)
% main([data2SavedPath '\WT\WT_3a'],WTpaths{3},'end',[79,73,75,56],83.05*micronsToPixels,98.62*micronsToPixels,0.152)
  main([data2SavedPath '\WT\WT_3b'],WTpaths{3},'end',[64,69,68,42],103.5*micronsToPixels,111.46*micronsToPixels,0.151)
% main([data2SavedPath '\WT\WT_4a'],WTpaths{4},1,[21,29,18,37],37.97*micronsToPixels,71.72*micronsToPixels,0.261)
% main([data2SavedPath '\WT\WT_4b'],WTpaths{4},'end',[78,74,80,53],41.21*micronsToPixels,68.68*micronsToPixels,0.256)
% main([data2SavedPath '\WT\WT_4c'],WTpaths{4},'end',[71,69,70,56],34.9*micronsToPixels,73.68*micronsToPixels,0.213)
% main([data2SavedPath '\WT\WT_5a'],WTpaths{5},1,[11,16,12,17],50.6*micronsToPixels,65.06*micronsToPixels,0.243)
% main([data2SavedPath '\WT\WT_5b'],WTpaths{5},1,[16,20,15,24],40.85*micronsToPixels,73.53*micronsToPixels,0.197)
  main([data2SavedPath '\WT\WT_5c'],WTpaths{5},1,[25,31,28,29],52.93*micronsToPixels,57*micronsToPixels,0.373)
% main([data2SavedPath '\WT\WT_5d'],WTpaths{5},'end',[79,77,73,52],48.01*micronsToPixels,65.47*micronsToPixels,0.235)
% main([data2SavedPath '\WT\WT_5e'],WTpaths{5},'end',[84,87,83,64],45.41*micronsToPixels,63.57*micronsToPixels,0.254)
% main([data2SavedPath '\WT\WT_6a'],WTpaths{6},1,[23,16,17,21],38.14*micronsToPixels,68.65*micronsToPixels,0.180)
  main([data2SavedPath '\WT\WT_6b'],WTpaths{6},'end',[69,65,46,64],53.53*micronsToPixels,66.91*micronsToPixels,0.203)
% main([data2SavedPath '\WT\WT_6c'],WTpaths{6},'end',[65,83,66,56],39.23*micronsToPixels,68.65*micronsToPixels,0.180)
% main([data2SavedPath '\WT\WT_6d'],WTpaths{6},'end',[73,75,78,74],49.49*micronsToPixels,65.98*micronsToPixels,0.284)
% main([data2SavedPath '\WT\WT_7a'],WTpaths{7},1,[08,11,03,15],20.26*micronsToPixels,40.51*micronsToPixels,0.153)
 main([data2SavedPath '\WT\WT_7b'],WTpaths{7},1,[34,32,22,40],35.94*micronsToPixels,62.9*micronsToPixels,0.109)
% 
% 
% %Ecadhi
% main([data2SavedPath '\Ecadhi\Ecadhi_1a'],Ecadhipaths{1},1,[11,7,9,10],12.05*micronsToPixels,27.11*micronsToPixels,0.218)
% main([data2SavedPath '\Ecadhi\Ecadhi_1b'],Ecadhipaths{1},1,[24,27,25,29],25.44*micronsToPixels,36.34*micronsToPixels,0.19)
% main([data2SavedPath '\Ecadhi\Ecadhi_1c'],Ecadhipaths{1},'end',[85,75,83,43],30.3*micronsToPixels,30.30*micronsToPixels,0.236)
% main([data2SavedPath '\Ecadhi\Ecadhi_1d'],Ecadhipaths{1},'end',[89,88,47,45],72.9*micronsToPixels,44.59*micronsToPixels,0.246)
% main([data2SavedPath '\Ecadhi\Ecadhi_2a'],Ecadhipaths{2},1,[21,17,16,23],41.09*micronsToPixels,46.23*micronsToPixels,0.157)
% main([data2SavedPath '\Ecadhi\Ecadhi_2b'],Ecadhipaths{2},1,[25,20,22,24],5.14*micronsToPixels,41.14*micronsToPixels,0.092)
% main([data2SavedPath '\Ecadhi\Ecadhi_3a'],Ecadhipaths{3},'end',[97,86,71,78],33.7*micronsToPixels,33.7*micronsToPixels,0.156)
% 
% 
% %CultE
% main([data2SavedPath '\CultE\CultE_1a'],CultEpaths{1},1,[5,13,8,11],6.22*micronsToPixels,10.74*micronsToPixels,0.358)
% main([data2SavedPath '\CultE\CultE_2a'],CultEpaths{2},1,[6,8,4,9],3.54*micronsToPixels,9.92*micronsToPixels,0.242)
% 
% % No Transitions
% 
% % WT
% main([data2SavedPath '\WT\WT_NoT_5a'],WTpaths{5},'end',[82,81,74,84],0*micronsToPixels,57*micronsToPixels,0.373)
% main([data2SavedPath '\WT\WT_NoT_6a'],WTpaths{6},1,[26,22,23,27],0*micronsToPixels,65.98*micronsToPixels,0.284)
% main([data2SavedPath '\WT\WT_NoT_7a'],WTpaths{7},'end',[78,79,62,63],0*micronsToPixels,62.9*micronsToPixels,0.109)
% main([data2SavedPath '\WT\WT_NoT_7b'],WTpaths{7},'end',[78,63,79,64],0*micronsToPixels,62.9*micronsToPixels,0.109)
% main([data2SavedPath '\WT\WT_NoT_7c'],WTpaths{7},'end',[78,64,63,65],0*micronsToPixels,62.9*micronsToPixels,0.109)
% 
% %Ecadhi
% main([data2SavedPath '\Ecadhi\Ecadhi_NoT_3a'],Ecadhipaths{3},1,[12,14,15,16],0*micronsToPixels,27.47*micronsToPixels,0.299)
% main([data2SavedPath '\Ecadhi\Ecadhi_NoT_4a'],Ecadhipaths{4},1,[12,13,2,24],0*micronsToPixels,32.89*micronsToPixels,0.181)
% main([data2SavedPath '\Ecadhi\Ecadhi_NoT_4b'],Ecadhipaths{4},1,[12,18,5,24],0*micronsToPixels,32.89*micronsToPixels,0.181)
% main([data2SavedPath '\Ecadhi\Ecadhi_NoT_4c'],Ecadhipaths{4},1,[28,18,5,24],0*micronsToPixels,35.47*micronsToPixels,0.152)
% main([data2SavedPath '\Ecadhi\Ecadhi_NoT_4d'],Ecadhipaths{4},1,[28,22,6,31],0*micronsToPixels,35.47*micronsToPixels,0.152)
% 
% %CultE
% main([data2SavedPath '\CultE\CultE_NoT_1a'],CultEpaths{1},42,[28,31,30,29],0*micronsToPixels,10.74*micronsToPixels,0.358)
% main([data2SavedPath '\CultE\CultE_NoT_2a'],CultEpaths{2},'end',[32,31,30,29],0*micronsToPixels,9.92*micronsToPixels,0.242)
% main([data2SavedPath '\CultE\CultE_NoT_2b'],CultEpaths{2},'end',[32,20,23,33],0*micronsToPixels,9.92*micronsToPixels,0.242)
% main([data2SavedPath '\CultE\CultE_NoT_2c'],CultEpaths{2},'end',[32,23,30,29],0*micronsToPixels,9.92*micronsToPixels,0.242)
% main([data2SavedPath '\CultE\CultE_NoT_2b'],CultEpaths{2},'end',[32,20,31,33],0*micronsToPixels,9.92*micronsToPixels,0.242)
% main([data2SavedPath '\CultE\CultE_NoT_3a'],CultEpaths{3},22,[14,15,17,16],0*micronsToPixels,6.79*micronsToPixels,0.332)  