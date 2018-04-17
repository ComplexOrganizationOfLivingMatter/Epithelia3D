function [totalCellsInRois,totalProportionScutoids,totalProportionWinNeigh,...
    totalProportionLossNeigh,totalProportionOfCellsInNoTransitions,...
    distributionWinningNeigh,distributionLossingNeigh,...
    distributionTransitionsPerCell,proportionAnglesTransition,...
    proportionAnglesNoTransition,totalAnglesTransition,...
    totalAnglesNoTransition,totalLengthTransition,totalLengthNoTransition] ...
    ...
    = calculationAngleLengthScutoidsInEdges(filePath,nRand,cellHeight,nCellHeight,resolutionTreshold)
%CALCULATIONANGLELENGTHSCUTOIDSINEDGES 
% 


    numberCellHeight = cellHeight;
    ellipsoidPath=dir([filePath 'randomizations\random_' num2str(nRand) '\*llipsoid*_cellHeight' numberCellHeight '*' ]);
    splittedPath=strsplit(ellipsoidPath(1).name,'_');
    splittedCellHeight=splittedPath{end};
    load([filePath 'randomizations\random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater')

    
    %loading mask central cells in projection
    maskRoiInner=imread([filePath 'maskInner.tif']);
    
    if sum(size(maskRoiInner) == size(projectionsInnerWater{1})) ~= 2
        maskRoiInner = imresize(maskRoiInner, size(projectionsInnerWater{1}));
    end
    
    maskRoiInner=1-im2bw(maskRoiInner(:,:,1));
    neighsInner=cell(length(projectionsInnerWater),1);
    noValidCells=cell(length(projectionsInnerWater),1);
    neighsOuter=cell(length(projectionsInnerWater),1);
    validCells=cell(length(projectionsInnerWater),1);
    projectionsOuter=cell(length(projectionsInnerWater),1);
    nCells=zeros(length(projectionsInnerWater),1);
    for i=1:length(projectionsInnerWater)
        [projectionsInner{i},projectionsOuter{i},neighsOuter{i},neighsInner{i},noValidCells{i},validCells{i},~,~]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsOuterWater{i});
        nCells(i)=size(neighsOuter{i},2);
    end
    cellNeighsOuter=cell(4,max(nCells));
    cellNeighsInner=cell(4,max(nCells));
    for i=1:length(projectionsInnerWater)
        cellNeighsOuter(i,1:size(neighsOuter{i},2))=neighsOuter{i};
        cellNeighsInner(i,1:size(neighsInner{i},2))=neighsInner{i};
    end
    globalValidCells=unique(horzcat(validCells{:}));
    totalCellsInRois=length(globalValidCells);
    globalNeighsOuter=cellfun(@(a,b,c,d) unique([a;b;c;d]),cellNeighsOuter(1,:),cellNeighsOuter(2,:),cellNeighsOuter(3,:),cellNeighsOuter(4,:),'UniformOutput',false);
    globalNeighsInner=cellfun(@(a,b,c,d) unique([a;b;c;d]),cellNeighsInner(1,:),cellNeighsInner(2,:),cellNeighsInner(3,:),cellNeighsInner(4,:),'UniformOutput',false);

    %get all the projections together
    outerOverlaped=horzcat([projectionsOuter{:}]);
    innerOverlaped=horzcat([projectionsInner{:}]);

    %measured angles and length discriminating between transition
    %and no transition
    [dataTransitionOuter,dataNoTransitionOuter]=measureAnglesAndLengthOfEdges(innerOverlaped,outerOverlaped,globalNeighsInner,globalNeighsOuter,globalValidCells,resolutionTreshold);
    [dataTransitionInner,~]=measureAnglesAndLengthOfEdges(outerOverlaped,innerOverlaped,globalNeighsOuter,globalNeighsInner,globalValidCells,resolutionTreshold);

    %calculate proportions of scutoids
    [totalProportionScutoids,totalProportionWinNeigh,totalProportionLossNeigh,totalProportionOfCellsInNoTransitions,...
        distributionWinningNeigh,distributionLossingNeigh,distributionTransitionsPerCell]...
        =calculateNumberOfCellsInvolvedInTransitions(dataTransitionOuter,dataTransitionInner,globalValidCells);



    proportionAnglesTransition=[dataTransitionOuter.proportionAnglesLess15deg,dataTransitionOuter.proportionAnglesBetween15_30deg,dataTransitionOuter.proportionAnglesBetween30_45deg,dataTransitionOuter.proportionAnglesBetween45_60deg,dataTransitionOuter.proportionAnglesBetween60_75deg,dataTransitionOuter.proportionAnglesBetween75_90deg];
    proportionAnglesNoTransition=[dataNoTransitionOuter.proportionAnglesLess15deg,dataNoTransitionOuter.proportionAnglesBetween15_30deg,dataNoTransitionOuter.proportionAnglesBetween30_45deg,dataNoTransitionOuter.proportionAnglesBetween45_60deg,dataNoTransitionOuter.proportionAnglesBetween60_75deg,dataNoTransitionOuter.proportionAnglesBetween75_90deg];
    totalAnglesTransition=dataTransitionOuter.edgeAngle;
    totalAnglesNoTransition=dataNoTransitionOuter.edgeAngle;
    totalLengthTransition=dataTransitionOuter.edgeLength;
    totalLengthNoTransition=dataNoTransitionOuter.edgeLength;

    disp([filePath ' cell height ' numberCellHeight '/' num2str(nCellHeight) ' random ' num2str(nRand)])
end