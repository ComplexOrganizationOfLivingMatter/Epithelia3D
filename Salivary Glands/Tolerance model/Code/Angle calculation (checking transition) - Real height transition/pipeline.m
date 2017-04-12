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

% angleScaledWT=[];
% angleScaled2WT=[];
% angleWithoutScaledWT=[];
% angleWithoutScaled2WT=[];
% 
% %main(name2save,pathStructure,frame,cellsGroup,hTransition,hCell,curvature)
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{1},1,[15,18,13,21],72.9*micronsToPixels,0.204);
 [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{1},'end',[57,59,54,12],58*micronsToPixels,0.217);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{1},'end',[60,62,61,69],59.02*micronsToPixels,0.204);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{1},'end',[68,67,22,58],57.2*micronsToPixels,0.192);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{2},1,[7,5,17,3],79.26*micronsToPixels,0.214);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{2},'end',[49,43,53,31],65.66*micronsToPixels,0.240);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{2},'end',[50,53,38,43],73.9*micronsToPixels,0.240);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{2},'end',[51,49,3,42],94.61*micronsToPixels,0.214);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{3},'end',[79,73,75,56],83.05*micronsToPixels,0.152);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{3},'end',[64,69,68,42],103.5*micronsToPixels,0.151);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{4},1,[21,29,18,37],37.97*micronsToPixels,0.261);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{4},'end',[78,74,80,53],41.21*micronsToPixels,0.256);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{4},'end',[71,69,70,56],34.9*micronsToPixels,0.213);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{5},1,[11,16,12,17],50.6*micronsToPixels,0.243);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{5},1,[16,20,15,24],40.85*micronsToPixels,0.197);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{5},1,[25,31,28,29],52.93*micronsToPixels,0.373);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{5},'end',[79,77,3,78],48.01*micronsToPixels,0.235); %rareeee motif
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{5},'end',[84,87,83,64],45.41*micronsToPixels,0.254);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{6},3,[23,16,17,21],38.14*micronsToPixels,0.180);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{6},'end',[69,65,46,64],53.53*micronsToPixels,0.203);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{6},'end',[65,83,66,56],39.23*micronsToPixels,0.180);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{6},'end',[73,75,78,74],49.49*micronsToPixels,0.284);
% [angleScaledWT(end+1,1),angleScaled2WT(end+1,1),angleWithoutScaledWT(end+1,1),angleWithoutScaled2WT(end+1,1)]=mainLocalAngleFromRealHeightTransition(WTpaths{7},1,[34,32,22,40],35.94*micronsToPixels,0.109);
% 
% 
% %Ecadhi
% angleScaledEcadhi=[];
% angleScaled2Ecadhi=[];
% angleWithoutScaledEcadhi=[];
% angleWithoutScaled2Ecadhi=[];
% 
% [angleScaledEcadhi(end+1,1),angleScaled2Ecadhi(end+1,1),angleWithoutScaledEcadhi(end+1,1),angleWithoutScaled2Ecadhi(end+1,1)]=mainLocalAngleFromRealHeightTransition(Ecadhipaths{1},1,[11,7,9,10],12.05*micronsToPixels,0.218);
% [angleScaledEcadhi(end+1,1),angleScaled2Ecadhi(end+1,1),angleWithoutScaledEcadhi(end+1,1),angleWithoutScaled2Ecadhi(end+1,1)]=mainLocalAngleFromRealHeightTransition(Ecadhipaths{1},1,[24,27,25,29],25.44*micronsToPixels,0.19);
% [angleScaledEcadhi(end+1,1),angleScaled2Ecadhi(end+1,1),angleWithoutScaledEcadhi(end+1,1),angleWithoutScaled2Ecadhi(end+1,1)]=mainLocalAngleFromRealHeightTransition(Ecadhipaths{1},'end',[85,75,83,43],30.3*micronsToPixels,0.236);
% [angleScaledEcadhi(end+1,1),angleScaled2Ecadhi(end+1,1),angleWithoutScaledEcadhi(end+1,1),angleWithoutScaled2Ecadhi(end+1,1)]=mainLocalAngleFromRealHeightTransition(Ecadhipaths{1},'end',[89,88,47,45],72.9*micronsToPixels,0.246);
% [angleScaledEcadhi(end+1,1),angleScaled2Ecadhi(end+1,1),angleWithoutScaledEcadhi(end+1,1),angleWithoutScaled2Ecadhi(end+1,1)]=mainLocalAngleFromRealHeightTransition(Ecadhipaths{2},1,[21,17,16,23],41.09*micronsToPixels,0.157);
% [angleScaledEcadhi(end+1,1),angleScaled2Ecadhi(end+1,1),angleWithoutScaledEcadhi(end+1,1),angleWithoutScaled2Ecadhi(end+1,1)]=mainLocalAngleFromRealHeightTransition(Ecadhipaths{2},1,[25,20,22,24],5.14*micronsToPixels,0.092);
% [angleScaledEcadhi(end+1,1),angleScaled2Ecadhi(end+1,1),angleWithoutScaledEcadhi(end+1,1),angleWithoutScaled2Ecadhi(end+1,1)]=mainLocalAngleFromRealHeightTransition(Ecadhipaths{4},'end',[97,86,71,78],33.7*micronsToPixels,0.156);
% 
% 
% %CultE
% angleScaledCultEp=[];
% angleScaled2CultEp=[];
% angleWithoutScaledCultEp=[];
% angleWithoutScaled2CultEp=[];
% %Now we don't apply curvature. We only apply proportion of ratios
% [angleScaledCultEp(end+1,1),angleScaled2CultEp(end+1,1),angleWithoutScaledCultEp(end+1,1),angleWithoutScaled2CultEp(end+1,1)]=mainLocalAngleFromRealHeightTransition(CultEpaths{1},1,[5,13,8,11],6.22*micronsToPixels,sqrt(0.358));
% [angleScaledCultEp(end+1,1),angleScaled2CultEp(end+1,1),angleWithoutScaledCultEp(end+1,1),angleWithoutScaled2CultEp(end+1,1)]=mainLocalAngleFromRealHeightTransition(CultEpaths{2},1,[6,8,4,9],3.54*micronsToPixels,sqrt(0.242));
% 
% 
% 
% %mean, median and max
% meanAngleScaledWT=mean(angleScaledWT);
% meanAngleScaled2WT=mean(angleScaled2WT);
% meanAngleWithoutScaledWT=mean(angleWithoutScaledWT);
% meanAngleWithoutScaled2WT=mean(angleWithoutScaled2WT);
% meanAngleScaledCultEp=mean(angleScaledCultEp);
% meanAngleScaled2CultEp=mean(angleScaled2CultEp);
% meanAngleWithoutScaledCultEp=mean(angleWithoutScaledCultEp);
% meanAngleWithoutScaled2CultEp=mean(angleWithoutScaled2CultEp);
% meanAngleScaledEcadhi=mean(angleScaledEcadhi);
% meanAngleScaled2Ecadhi=mean(angleScaled2Ecadhi);
% meanAngleWithoutScaledEcadhi=mean(angleWithoutScaledEcadhi);
% meanAngleWithoutScaled2Ecadhi=mean(angleWithoutScaled2Ecadhi);
% 
% 
% stdAngleScaledWT=std(angleScaledWT);
% stdAngleScaled2WT=std(angleScaled2WT);
% stdAngleWithoutScaledWT=std(angleWithoutScaledWT);
% stdAngleWithoutScaled2WT=std(angleWithoutScaled2WT);
% stdAngleScaledCultEp=std(angleScaledCultEp);
% stdAngleScaled2CultEp=std(angleScaled2CultEp);
% stdAngleWithoutScaledCultEp=std(angleWithoutScaledCultEp);
% stdAngleWithoutScaled2CultEp=std(angleWithoutScaled2CultEp);
% stdAngleScaledEcadhi=std(angleScaledEcadhi);
% stdAngleScaled2Ecadhi=std(angleScaled2Ecadhi);
% stdAngleWithoutScaledEcadhi=std(angleWithoutScaledEcadhi);
% stdAngleWithoutScaled2Ecadhi=std(angleWithoutScaled2Ecadhi);
% 
% 
% maxAngleScaledWT=max(angleScaledWT);
% maxAngleScaled2WT=max(angleScaled2WT);
% maxAngleWithoutScaledWT=max(angleWithoutScaledWT);
% maxAngleWithoutScaled2WT=max(angleWithoutScaled2WT);
% maxAngleScaledCultEp=max(angleScaledCultEp);
% maxAngleScaled2CultEp=max(angleScaled2CultEp);
% maxAngleWithoutScaledCultEp=max(angleWithoutScaledCultEp);
% maxAngleWithoutScaled2CultEp=max(angleWithoutScaled2CultEp);
% maxAngleScaledEcadhi=max(angleScaledEcadhi);
% maxAngleScaled2Ecadhi=max(angleScaled2Ecadhi);
% maxAngleWithoutScaledEcadhi=max(angleWithoutScaledEcadhi);
% maxAngleWithoutScaled2Ecadhi=max(angleWithoutScaled2Ecadhi);
% 
% medianAngleScaledWT=median(angleScaledWT);
% medianAngleScaled2WT=median(angleScaled2WT);
% medianAngleWithoutScaledWT=median(angleWithoutScaledWT);
% medianAngleWithoutScaled2WT=median(angleWithoutScaled2WT);
% medianAngleScaledCultEp=median(angleScaledCultEp);
% medianAngleScaled2CultEp=median(angleScaled2CultEp);
% medianAngleWithoutScaledCultEp=median(angleWithoutScaledCultEp);
% medianAngleWithoutScaled2CultEp=median(angleWithoutScaled2CultEp);
% medianAngleScaledEcadhi=median(angleScaledEcadhi);
% medianAngleScaled2Ecadhi=median(angleScaled2Ecadhi);
% medianAngleWithoutScaledEcadhi=median(angleWithoutScaledEcadhi);
% medianAngleWithoutScaled2Ecadhi=median(angleWithoutScaled2Ecadhi);

path2Load=[rootPath 'Salivary Glands\Tolerance model\Data\checkingHeightOfTransitionFixing2Points\anglesMeasurements.mat'];
%save(path2Load,'maxAngleScaledWT','maxAngleScaled2WT','maxAngleWithoutScaledWT','maxAngleWithoutScaled2WT','maxAngleScaledCultEp','maxAngleScaled2CultEp','maxAngleWithoutScaledCultEp','maxAngleWithoutScaled2CultEp','maxAngleScaledEcadhi','maxAngleScaled2Ecadhi','maxAngleWithoutScaledEcadhi','maxAngleWithoutScaled2Ecadhi','stdAngleScaledWT','stdAngleScaled2WT','stdAngleWithoutScaledWT','stdAngleWithoutScaled2WT','stdAngleScaledCultEp','stdAngleScaled2CultEp','stdAngleWithoutScaledCultEp','stdAngleWithoutScaled2CultEp','stdAngleScaledEcadhi','stdAngleScaled2Ecadhi','stdAngleWithoutScaledEcadhi','stdAngleWithoutScaled2Ecadhi','meanAngleScaledWT','meanAngleScaled2WT','meanAngleWithoutScaledWT','meanAngleWithoutScaled2WT','meanAngleScaledCultEp','meanAngleScaled2CultEp','meanAngleWithoutScaledCultEp','meanAngleWithoutScaled2CultEp','meanAngleScaledEcadhi','meanAngleScaled2Ecadhi','meanAngleWithoutScaledEcadhi','meanAngleWithoutScaled2Ecadhi','medianAngleScaledWT','medianAngleScaled2WT','medianAngleWithoutScaledWT','medianAngleWithoutScaled2WT','medianAngleScaledCultEp','medianAngleScaled2CultEp','medianAngleWithoutScaledCultEp','medianAngleWithoutScaled2CultEp','medianAngleScaledEcadhi','medianAngleScaled2Ecadhi','medianAngleWithoutScaledEcadhi','medianAngleWithoutScaled2Ecadhi')
load(path2Load)
% % No Transitions
%[hTransitionScaledMean,hTransitionScaledMean2,hTransitionWithoutScaledMean,hTransitionWithoutScaledMean2,hTransitionScaledMax,hTransitionScaledMax2,hTransitionWithoutScaledMax,hTransitionWithoutScaledMax2,hTransitionScaledMedian,hTransitionScaledMedian2,hTransitionWithoutScaledMedian,hTransitionWithoutScaledMedian2,resultOfComparisonMean,resultOfComparisonMax,resultOfComparisonMedian] = mainCheckPredictedHeight(pathStructure,frame,cellsGroup,hCell,curvature,meanAngleScaled,meanAngleScaled2,meanAngleWithoutScaled,meanAngleWithoutScaled2,maxAngleScaled,maxAngleScaled2,maxAngleWithoutScaled,maxAngleWithoutScaled2,medianAngleScaled,medianAngleScaled2,medianAngleWithoutScaled,medianAngleWithoutScaled2)

%WT

% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(WTpaths{5},'end',[82,81,74,84],57*micronsToPixels,0.373,meanAngleScaledWT,meanAngleScaled2WT,meanAngleWithoutScaledWT,meanAngleWithoutScaled2WT,maxAngleScaledWT,maxAngleScaled2WT,maxAngleWithoutScaledWT,maxAngleWithoutScaled2WT,medianAngleScaledWT,medianAngleScaled2WT,medianAngleWithoutScaledWT,medianAngleWithoutScaled2WT);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(WTpaths{6},1,[26,22,23,27],65.98*micronsToPixels,0.284,meanAngleScaledWT,meanAngleScaled2WT,meanAngleWithoutScaledWT,meanAngleWithoutScaled2WT,maxAngleScaledWT,maxAngleScaled2WT,maxAngleWithoutScaledWT,maxAngleWithoutScaled2WT,medianAngleScaledWT,medianAngleScaled2WT,medianAngleWithoutScaledWT,medianAngleWithoutScaled2WT);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(WTpaths{7},'end',[78,79,62,63],62.9*micronsToPixels,0.109,meanAngleScaledWT,meanAngleScaled2WT,meanAngleWithoutScaledWT,meanAngleWithoutScaled2WT,maxAngleScaledWT,maxAngleScaled2WT,maxAngleWithoutScaledWT,maxAngleWithoutScaled2WT,medianAngleScaledWT,medianAngleScaled2WT,medianAngleWithoutScaledWT,medianAngleWithoutScaled2WT);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(WTpaths{7},'end',[78,63,79,64],62.9*micronsToPixels,0.109,meanAngleScaledWT,meanAngleScaled2WT,meanAngleWithoutScaledWT,meanAngleWithoutScaled2WT,maxAngleScaledWT,maxAngleScaled2WT,maxAngleWithoutScaledWT,maxAngleWithoutScaled2WT,medianAngleScaledWT,medianAngleScaled2WT,medianAngleWithoutScaledWT,medianAngleWithoutScaled2WT);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(WTpaths{7},'end',[78,64,63,65],62.9*micronsToPixels,0.109,meanAngleScaledWT,meanAngleScaled2WT,meanAngleWithoutScaledWT,meanAngleWithoutScaled2WT,maxAngleScaledWT,maxAngleScaled2WT,maxAngleWithoutScaledWT,maxAngleWithoutScaled2WT,medianAngleScaledWT,medianAngleScaled2WT,medianAngleWithoutScaledWT,medianAngleWithoutScaled2WT);
% 
% 
% 
% 
% %Ecadhi
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(Ecadhipaths{3},1,[12,14,15,16],27.47*micronsToPixels,0.299,meanAngleScaledEcadhi,meanAngleScaled2Ecadhi,meanAngleWithoutScaledEcadhi,meanAngleWithoutScaled2Ecadhi,maxAngleScaledEcadhi,maxAngleScaled2Ecadhi,maxAngleWithoutScaledEcadhi,maxAngleWithoutScaled2Ecadhi,medianAngleScaledEcadhi,medianAngleScaled2Ecadhi,medianAngleWithoutScaledEcadhi,medianAngleWithoutScaled2Ecadhi);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(Ecadhipaths{4},1,[12,13,2,24],32.89*micronsToPixels,0.181,meanAngleScaledEcadhi,meanAngleScaled2Ecadhi,meanAngleWithoutScaledEcadhi,meanAngleWithoutScaled2Ecadhi,maxAngleScaledEcadhi,maxAngleScaled2Ecadhi,maxAngleWithoutScaledEcadhi,maxAngleWithoutScaled2Ecadhi,medianAngleScaledEcadhi,medianAngleScaled2Ecadhi,medianAngleWithoutScaledEcadhi,medianAngleWithoutScaled2Ecadhi);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(Ecadhipaths{4},1,[12,18,5,24],32.89*micronsToPixels,0.181,meanAngleScaledEcadhi,meanAngleScaled2Ecadhi,meanAngleWithoutScaledEcadhi,meanAngleWithoutScaled2Ecadhi,maxAngleScaledEcadhi,maxAngleScaled2Ecadhi,maxAngleWithoutScaledEcadhi,maxAngleWithoutScaled2Ecadhi,medianAngleScaledEcadhi,medianAngleScaled2Ecadhi,medianAngleWithoutScaledEcadhi,medianAngleWithoutScaled2Ecadhi);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(Ecadhipaths{4},1,[28,18,5,24],35.47*micronsToPixels,0.152,meanAngleScaledEcadhi,meanAngleScaled2Ecadhi,meanAngleWithoutScaledEcadhi,meanAngleWithoutScaled2Ecadhi,maxAngleScaledEcadhi,maxAngleScaled2Ecadhi,maxAngleWithoutScaledEcadhi,maxAngleWithoutScaled2Ecadhi,medianAngleScaledEcadhi,medianAngleScaled2Ecadhi,medianAngleWithoutScaledEcadhi,medianAngleWithoutScaled2Ecadhi);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(Ecadhipaths{4},1,[28,22,6,31],35.47*micronsToPixels,0.152,meanAngleScaledEcadhi,meanAngleScaled2Ecadhi,meanAngleWithoutScaledEcadhi,meanAngleWithoutScaled2Ecadhi,maxAngleScaledEcadhi,maxAngleScaled2Ecadhi,maxAngleWithoutScaledEcadhi,maxAngleWithoutScaled2Ecadhi,medianAngleScaledEcadhi,medianAngleScaled2Ecadhi,medianAngleWithoutScaledEcadhi,medianAngleWithoutScaled2Ecadhi);
% 
% 
% 
% %CultE
%[resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(CultEpaths{1},42,[28,31,30,29],10.74*micronsToPixels,sqrt(0.358),meanAngleScaledCultEp,meanAngleScaled2CultEp,meanAngleWithoutScaledCultEp,meanAngleWithoutScaled2CultEp,maxAngleScaledCultEp,maxAngleScaled2CultEp,maxAngleWithoutScaledCultEp,maxAngleWithoutScaled2CultEp,medianAngleScaledCultEp,medianAngleScaled2CultEp,medianAngleWithoutScaledCultEp,medianAngleWithoutScaled2CultEp);
%[resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(CultEpaths{2},'end',[32,31,30,29],9.92*micronsToPixels,sqrt(0.242),meanAngleScaledCultEp,meanAngleScaled2CultEp,meanAngleWithoutScaledCultEp,meanAngleWithoutScaled2CultEp,maxAngleScaledCultEp,maxAngleScaled2CultEp,maxAngleWithoutScaledCultEp,maxAngleWithoutScaled2CultEp,medianAngleScaledCultEp,medianAngleScaled2CultEp,medianAngleWithoutScaledCultEp,medianAngleWithoutScaled2CultEp);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(CultEpaths{2},'end',[32,20,23,33],9.92*micronsToPixels,sqrt(0.242),meanAngleScaledCultEp,meanAngleScaled2CultEp,meanAngleWithoutScaledCultEp,meanAngleWithoutScaled2CultEp,maxAngleScaledCultEp,maxAngleScaled2CultEp,maxAngleWithoutScaledCultEp,maxAngleWithoutScaled2CultEp,medianAngleScaledCultEp,medianAngleScaled2CultEp,medianAngleWithoutScaledCultEp,medianAngleWithoutScaled2CultEp);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(CultEpaths{2},'end',[32,23,30,29],9.92*micronsToPixels,sqrt(0.242),meanAngleScaledCultEp,meanAngleScaled2CultEp,meanAngleWithoutScaledCultEp,meanAngleWithoutScaled2CultEp,maxAngleScaledCultEp,maxAngleScaled2CultEp,maxAngleWithoutScaledCultEp,maxAngleWithoutScaled2CultEp,medianAngleScaledCultEp,medianAngleScaled2CultEp,medianAngleWithoutScaledCultEp,medianAngleWithoutScaled2CultEp);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(CultEpaths{2},'end',[32,20,31,33],9.92*micronsToPixels,sqrt(0.242),meanAngleScaledCultEp,meanAngleScaled2CultEp,meanAngleWithoutScaledCultEp,meanAngleWithoutScaled2CultEp,maxAngleScaledCultEp,maxAngleScaled2CultEp,maxAngleWithoutScaledCultEp,maxAngleWithoutScaled2CultEp,medianAngleScaledCultEp,medianAngleScaled2CultEp,medianAngleWithoutScaledCultEp,medianAngleWithoutScaled2CultEp);
% [resultOfCompMean,resultOfCompMax,resultOfCompMedian]=mainCheckPredictedHeight(CultEpaths{3},22,[14,15,17,16],6.79*micronsToPixels,sqrt(0.332),meanAngleScaledCultEp,meanAngleScaled2CultEp,meanAngleWithoutScaledCultEp,meanAngleWithoutScaled2CultEp,maxAngleScaledCultEp,maxAngleScaled2CultEp,maxAngleWithoutScaledCultEp,maxAngleWithoutScaled2CultEp,medianAngleScaledCultEp,medianAngleScaled2CultEp,medianAngleWithoutScaledCultEp,medianAngleWithoutScaled2CultEp);
%  

clearvars -except resultOfCompMax resultOfCompMean resultOfCompMedian