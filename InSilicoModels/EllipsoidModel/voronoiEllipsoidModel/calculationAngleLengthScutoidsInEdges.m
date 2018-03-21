

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
        totalProportionScutoids=zeros(numRandoms,1);
        totalProportionWinNeigh=zeros(numRandoms,1);
        totalProportionLossNeigh=zeros(numRandoms,1);
        totalProportionOfCellsInNoTransitions=zeros(numRandoms,1);
        TableWinningNeigh=table();
        TableLossingNeigh=table();
        TableTransitionsPerCell=table();
        
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
            neighsInner=cell(length(projectionsInnerWater),1);
            noValidCells=cell(length(projectionsInnerWater),1);
            neighsOuter=cell(length(projectionsInnerWater),1);
            validCells=cell(length(projectionsInnerWater),1);
            nCells=zeros(length(projectionsInnerWater),1);
            for i=1:length(projectionsInnerWater)                
                [projectionInner,neighsOuter{i},neighsInner{i},noValidCells{i},validCells{i},~,~]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsOuterWater{i});
                nCells(i)=size(neighsOuter{i},2);               
            end
            cellNeighsOuter=cell(4,max(nCells));
            cellNeighsInner=cell(4,max(nCells));
            for i=1:length(projectionsInnerWater)  
                cellNeighsOuter(i,1:size(neighsOuter{i},2))=neighsOuter{i};
                cellNeighsInner(i,1:size(neighsInner{i},2))=neighsInner{i};
            end
            globalValidCells=unique(horzcat(validCells{:}));
            globalNeighsOuter=cellfun(@(a,b,c,d) unique([a;b;c;d]),cellNeighsOuter(1,:),cellNeighsOuter(2,:),cellNeighsOuter(3,:),cellNeighsOuter(4,:),'UniformOutput',false);
            globalNeighsInner=cellfun(@(a,b,c,d) unique([a;b;c;d]),cellNeighsInner(1,:),cellNeighsInner(2,:),cellNeighsInner(3,:),cellNeighsInner(4,:),'UniformOutput',false);
            
            [totalProportionScutoids(nRand),totalProportionWinNeigh(nRand),totalProportionLossNeigh(nRand),totalProportionOfCellsInNoTransitions(nRand),...
                distributionWinningNeigh,distributionLossingNeigh,distributionTransitionsPerCell]...
                =calculateNumberOfInvolvedCellsInTransitions(globalNeighsInner,globalNeighsOuter,globalValidCells);
            
            TableTransitionsPerCell=[TableTransitionsPerCell;distributionTransitionsPerCell];
            TableWinningNeigh=[TableWinningNeigh;distributionWinningNeigh];
            TableLossingNeigh=[TableLossingNeigh;distributionLossingNeigh];
        end
    end
    
end