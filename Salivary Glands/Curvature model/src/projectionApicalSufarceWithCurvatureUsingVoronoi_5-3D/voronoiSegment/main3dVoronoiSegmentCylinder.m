
H_apical=1024;
W_apical=512;
numSeeds=100;
numTotalImages=20;
%That is a factor of conversion to reduce the coordinates of the original
%cylinder
reductionFactor=4;
%surface ratio
rBasal=1;
rApical=0.6;
surfaceRatio=rBasal/rApical;


globalAccumulativeMatrix=zeros(numSeeds*numTotalImages,3);

for numImage=1:numTotalImages
    numImage
    %load seeds in apical and the voronoi image in apical
    load(['..\..\..\data\expansion\512x1024_' num2str(numSeeds) 'seeds\Image_' num2str(numImage) '_Diagram_5\Image_' num2str(numImage) '_Diagram_5.mat'],'listSeedsProjected','listLOriginalProjection')
    imgApical= listLOriginalProjection.L_originalProjection{1};
    imgBasal= listLOriginalProjection.L_originalProjection{9};
    initialSeeds=listSeedsProjected.seedsApical{1};
    initialSeeds=initialSeeds(:,2:end);
    
    areaApical=regionprops(imgApical,'area');
    areaApical=cat(1,areaApical.Area);
    areaBasal=regionprops(imgBasal,'area');
    areaBasal=cat(1,areaBasal.Area);
    
    name2save= ['Image_' num2str(numImage) '_' num2str(numSeeds) 'seeds'];
    seedsInfo=rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, H_apical, W_apical, surfaceRatio,imgApical,reductionFactor,name2save);
    
    volume3DCells=[seedsInfo(:).volume];
    
    indexA=numSeeds*(numImage-1)+1;
    indexB=numSeeds*numImage;
    globalAccumulativeMatrix(indexA:indexB,1:3)=[volume3DCells',areaBasal,areaApical]; 
end

T=array2table(globalAccumulativeMatrix,'VariableNames',{'volume','areaBasal','areaApical'});
