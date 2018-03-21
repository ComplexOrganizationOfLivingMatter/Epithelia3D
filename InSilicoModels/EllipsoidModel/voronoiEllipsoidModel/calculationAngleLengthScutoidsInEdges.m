

addpath(genpath('src'))
addpath(genpath('lib'))

filePathVoronoiStage8='results\Stage 8\';
filePathVoronoiStage4='results\Stage 4\';
filePathGlobe='results\Globe\';
filePathRugby='results\Rugby\';

filePaths={filePathVoronoiStage8,filePathVoronoiStage4,filePathGlobe,filePathRugby};
nCellHeight=1;
for nPath=1:length(filePaths)
    
    switch nPath
        case 1
            numRandoms=30;
            nCellHeight=1;
        case 2
            numRandoms=180;
            nCellHeight=1;
        otherwise
            numRandoms=10;
            nCellHeight=3;
    end
    
    for cellHeight=1:nCellHeight
        for nRand=1:numRandoms           
            ellipsoidPath=dir([filePaths{nPath} 'random_' num2str(nRand) '\*llipsoid*' ]);
            splittedPath=strsplit(ellipsoidPath(cellHeight).name,'_');
            splittedCellHeight=splittedPath{end};
            if nCellHeight>1
                load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater')
            else
                load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
            end
            %loading mask central cells in projection
            maskRoiInner=1-im2bw(imread([filePaths{nPath} 'maskInner.tif']));
            for i=1:length(projectionsInnerWater)                
                
                [innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,~,~]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsOuterWater{i});

                
                
            end
        end
    end
    
end