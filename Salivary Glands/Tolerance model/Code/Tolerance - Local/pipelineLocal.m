
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


transition=1;
NoTransition=0;
micronsToPixels=1024/631.02; %microns*(pixels/microns)= pixels;
%%[angle,angleCurv,tolerance]=mainLocalAngleTolerance(pathStructure,frame,cell1,cell2,cell3,cell4,hTransition,transition,curvature)

%WT
[angleWT1a,angleCurvWT1a,toleranceWT1a] = mainLocalAngleTolerance(WTpaths{1},1,15,18,13,21,72.9*micronsToPixels,transition,0.204);
[angleWT1b,angleCurvWT1b,toleranceWT1b] = mainLocalAngleTolerance(WTpaths{1},'end',57,59,54,12,58*micronsToPixels,transition,0.217);
[angleWT1c,angleCurvWT1c,toleranceWT1c] = mainLocalAngleTolerance(WTpaths{1},'end',60,62,61,69,59.02*micronsToPixels,transition,0.204);
[angleWT1d,angleCurvWT1d,toleranceWT1d] = mainLocalAngleTolerance(WTpaths{1},'end',68,67,22,58,57.2*micronsToPixels,transition,0.192);
[angleWT2a,angleCurvWT2a,toleranceWT2a] = mainLocalAngleTolerance(WTpaths{2},1,7,5,17,3,79.26*micronsToPixels,transition,0.214);
[angleWT2b,angleCurvWT2b,toleranceWT2b] = mainLocalAngleTolerance(WTpaths{2},'end',49,43,53,31,65.66*micronsToPixels,transition,0.240);
[angleWT2c,angleCurvWT2c,toleranceWT2c] = mainLocalAngleTolerance(WTpaths{2},'end',50,53,38,43,73.93*micronsToPixels,transition,0.240);
[angleWT2d,angleCurvWT2d,toleranceWT2d] = mainLocalAngleTolerance(WTpaths{2},'end',51,49,3,42,94.61*micronsToPixels,transition,0.214);
[angleWT3a,angleCurvWT3a,toleranceWT3a] = mainLocalAngleTolerance(WTpaths{3},'end',79,73,75,56,83.05*micronsToPixels,transition,0.152);
[angleWT3b,angleCurvWT3b,toleranceWT3b] = mainLocalAngleTolerance(WTpaths{3},'end',64,69,68,42,103.5*micronsToPixels,transition,0.151);

%Ecadhi
[angleEc1a,angleCurvEc1a,toleranceEc1a] = mainLocalAngleTolerance(Ecadhipaths{1},1,7,9,10,11,12.05*micronsToPixels,transition,0.218);
[angleEc1b,angleCurvEc1b,toleranceEc1b] = mainLocalAngleTolerance(Ecadhipaths{1},1,24,27,25,29,25.44*micronsToPixels,transition,0.19);
[angleEc1c,angleCurvEc1c,toleranceEc1c] = mainLocalAngleTolerance(Ecadhipaths{1},'end',85,75,83,43,30.3*micronsToPixels,transition,0.236);
[angleEc1d,angleCurvEc1d,toleranceEc1d] = mainLocalAngleTolerance(Ecadhipaths{1},'end',89,88,47,45,33.44*micronsToPixels,transition,0.246);
% %Ecadhi no tran
% [angleEc3a,angleCurvEc3a,toleranceEc3a] = mainLocalAngleToleranceNoTran(Ecadhipaths{3},1,[5,8,11,16,15,14,10],27.47*micronsToPixels,transition,0.299);
% [angleEc4a,angleCurvEc4a,toleranceEc4a] = mainLocalAngleToleranceNoTran(Ecadhipaths{4},1,[2,4,5,18,24,13],32.89*micronsToPixels,transition,0.181);
% [angleEc4b,angleCurvEc4b,toleranceEc4b] = mainLocalAngleToleranceNoTran(Ecadhipaths{4},1,[6,11,30,31,22,36],35.47*micronsToPixels,transition,0.152);
