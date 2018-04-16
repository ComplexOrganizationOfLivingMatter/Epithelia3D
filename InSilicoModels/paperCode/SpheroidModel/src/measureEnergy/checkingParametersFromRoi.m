function [innerRoiProjection,outerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,totalEdges,labelEdges]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater,projectionsOuterWater)
%CHECKINGPARAMETERSFROMROI It gets inner roi, edges, neighbours and valid cells
%
    % Calculation valid cells per roi
    se=strel('disk',4);
    innerRoiProjection=maskRoiInner(1:size(projectionsInnerWater,1),1:size(projectionsInnerWater,2)).*projectionsInnerWater;

    noValidCellsInner=unique(imdilate((1-maskRoiInner(1:size(projectionsInnerWater,1),1:size(projectionsInnerWater,2))),se).*innerRoiProjection);

    % Calculation neighbours
    [neighsOuter,~]=calculateNeighbours(projectionsOuterWater);
    [neighsInner,~]=calculateNeighbours(innerRoiProjection);

    if length(neighsOuter)< length(neighsInner)
        neighsInnerFilter=neighsInner(1:length(neighsOuter));
        neighsOuterFilter=neighsOuter;
    else
        neighsInnerFilter=neighsInner;
        neighsOuterFilter=neighsOuter(1:length(neighsInner));
    end

    %getting total valid and no valid cells
    notMatchingCellsROI=~cellfun(@(x,y) (~isempty(x) && ~isempty(y)) || (isempty(x) && isempty(y)),neighsInnerFilter,neighsOuterFilter);
    notPresentCellsInProjection=find(cellfun(@(x,y) (isempty(x) && isempty(y)),neighsInnerFilter,neighsOuterFilter)==1);
    noValidCells=unique([noValidCellsInner;find(notMatchingCellsROI==1)']);
    validCells=setdiff(1:length(notMatchingCellsROI),unique([notPresentCellsInProjection,noValidCells']));

    neighsInnerFilter(notMatchingCellsROI)={[]};
    neighsOuterFilter(notMatchingCellsROI)={[]};

    %get edges of transitions
    pairTransitions=cellfun(@(x,y) setdiff(x,y),neighsOuterFilter,neighsInnerFilter,'UniformOutput',false);
    pairNoTransitions=cellfun(@(x,y) intersect(x,y),neighsOuterFilter,neighsInnerFilter,'UniformOutput',false);

    cellsOuterRoiProjection=unique(innerRoiProjection);
    cellsOuterRoiProjection=cellsOuterRoiProjection(cellsOuterRoiProjection~=0);
    outerRoiProjection=zeros(size(projectionsOuterWater));
    logicalValidCellOuterRoi=zeros(size(projectionsOuterWater));

    for nCell=cellsOuterRoiProjection'
        if ismember(nCell,validCells)
            logicalValidCellOuterRoi(projectionsOuterWater==nCell)=1;
        end
        outerRoiProjection(projectionsOuterWater==nCell)=nCell;
    end

    se=strel('disk',3);
    outerRoiProjection=imdilate(logicalValidCellOuterRoi,se).*outerRoiProjection;

    totalEdges={pairTransitions,pairNoTransitions};
    labelEdges={'transition','noTransition'};
end