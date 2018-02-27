function [outerSurfaceDataTransition,outerSurfaceDataNoTransition] = getAnglesLengthAndTranstionFromTheEdges( innerEllipsoidInfo, outerEllipsoidInfo )

    
    pairOfNeighsOuterSurface=(cellfun(@(x, y) [y*ones(length(x),1),x],outerEllipsoidInfo.neighbourhood,num2cell(1:size(outerEllipsoidInfo.neighbourhood,1))','UniformOutput',false));
    uniquePairOfNeighsOuterSurface=unique(vertcat(pairOfNeighsOuterSurface{:}),'rows');
    uniquePairOfNeighsOuterSurface=unique([min(uniquePairOfNeighsOuterSurface,[],2),max(uniquePairOfNeighsOuterSurface,[],2)],'rows');
    %number of cells per region
    numberOfTotalCell=size(unique(uniquePairOfNeighsOuterSurface),1);

    numOfPairs=size(uniquePairOfNeighsOuterSurface,1);
    outerSurfaceTotalData=struct('edgeLength',zeros(numOfPairs,1),'edgeAngle',zeros(numOfPairs,1),'edgeVertices',zeros(numOfPairs,1));
    
    
    if outerEllipsoidInfo.cellHeight==0
        resolutionFactor=innerEllipsoidInfo.resolutionFactor;
        centroidsRefactor=resolutionFactor;
    else
        resolutionFactor=outerEllipsoidInfo.resolutionFactor;
        centroidsRefactor=1;
    end
    
    %define the vertices in the ellipsoid grid
    [xVerGrid,yVerGrid,zVerGrid]=ellipsoid((outerEllipsoidInfo.xCenter)*resolutionFactor, (outerEllipsoidInfo.yCenter)*resolutionFactor, (outerEllipsoidInfo.zCenter)*resolutionFactor, (outerEllipsoidInfo.xRadius)*resolutionFactor, (outerEllipsoidInfo.yRadius)*resolutionFactor, (outerEllipsoidInfo.zRadius)*resolutionFactor, outerEllipsoidInfo.resolutionEllipse);
    [~,verGrid,~] = surf2patch(xVerGrid,yVerGrid,zVerGrid);


    %%GET VERTICES
    [ outerEllipsoidInfo] = getVertices3D( outerEllipsoidInfo.img3DLayer, outerEllipsoidInfo.neighbourhood, outerEllipsoidInfo );
    %capture the length and the angle from the pair of neighbours
    acum=1;
    indToDelete=zeros(numOfPairs,1);
    for i=1:numOfPairs  
         
        %get vertices of neigh cells edge 
        indexVert=sum(ismember(outerEllipsoidInfo.verticesConnectCells,uniquePairOfNeighsOuterSurface(i,:)),2);
        indexVert=find(indexVert==2);
        vertsEdge=vertcat(outerEllipsoidInfo.verticesPerCell{indexVert(:)});
       	vertsEdge=unique(vertsEdge,'rows');
        
        if size(vertsEdge,1)>1
            
            if size(vertsEdge,1)>2
                   [rowIndex,colIndex]=find(squareform(pdist(vertsEdge))==max(max(squareform(pdist(vertsEdge)))));
                    vertsEdge=vertsEdge([rowIndex(1),colIndex(1)],:);
            end
            %angle calculation
            [edgeLength, edgeAngle] = comparisonEdgeOrietationWithMeridianOfEllipsoidGrid( verGrid, vertsEdge,outerEllipsoidInfo);
            outerSurfaceTotalData(acum).edgeLength=edgeLength;
            outerSurfaceTotalData(acum).edgeAngle=edgeAngle;
            outerSurfaceTotalData(acum).edgeVertices=vertsEdge;
            
            plot3(vertsEdge(:,1),vertsEdge(:,2),vertsEdge(:,3))
            hold on
            
            acum=acum+1;
        else
            indToDelete(i)=1;
            
        end     
       
    end
    
    %deleting pair of neighbours with no vertices
    uniquePairOfNeighsOuterSurface=uniquePairOfNeighsOuterSurface(logical(1-indToDelete),:);

    
    %get edges of transitions
    
    Lossing=cellfun(@(x,y) setdiff(x,y),outerEllipsoidInfo.neighbourhood,innerEllipsoidInfo.neighbourhood,'UniformOutput',false);
    noValidPair=cellfun(@(x,y) size(setdiff(y,x), 1) ~= size(setdiff(x,y), 1),outerEllipsoidInfo.neighbourhood,innerEllipsoidInfo.neighbourhood);
    
    Lossing(noValidPair) = {[]};
    
    pairOfLostNeigh=cellfun(@(x, y) [y*ones(length(x),1),x],Lossing,num2cell(1:size(outerEllipsoidInfo.neighbourhood,1))','UniformOutput',false);
    pairOfLostNeigh=unique(vertcat(pairOfLostNeigh{:}),'rows');
    pairOfLostNeigh=unique([min(pairOfLostNeigh,[],2),max(pairOfLostNeigh,[],2)],'rows');
    indexesPairCellsTransition=ismember(uniquePairOfNeighsOuterSurface,pairOfLostNeigh,'rows');
    
    scutoidCells = cell(size(pairOfLostNeigh, 1), 1);
    for numEdge = 1:size(pairOfLostNeigh, 1)
        actualScutoidCells = horzcat(pairOfLostNeigh(numEdge, :), intersect(outerEllipsoidInfo.neighbourhood{pairOfLostNeigh(numEdge, 1)}, innerEllipsoidInfo.neighbourhood{pairOfLostNeigh(numEdge, 2)})');
        scutoidCells(numEdge) = {actualScutoidCells};
    end
    
    uniqueScutoidsCells = unique(horzcat(scutoidCells{:}));
    
    %classify data per zone
    endLimitRight=((outerEllipsoidInfo.xCenter+(outerEllipsoidInfo.xRadius)*outerEllipsoidInfo.bordersSituatedAt)*resolutionFactor);   
    endLimitLeft=((outerEllipsoidInfo.xCenter-(outerEllipsoidInfo.xRadius)*outerEllipsoidInfo.bordersSituatedAt)*resolutionFactor);
    
    outerDataVertices=struct2cell(outerSurfaceTotalData);
    outerDataVertices=outerDataVertices(3,:);
    
    meanEdgeVertices=cell2mat(cellfun(@(x) mean(x),outerDataVertices,'UniformOutput',false)');
    
    isRightEdgeTransition=zeros(numOfPairs-sum(indToDelete),length(endLimitRight));
    isLeftEdgeTransition=zeros(numOfPairs-sum(indToDelete),length(endLimitRight));
    isCentralEdgeTransition=zeros(numOfPairs-sum(indToDelete),length(endLimitRight));
    isRightEdgeNoTransition=zeros(numOfPairs-sum(indToDelete),length(endLimitRight));
    isLeftEdgeNoTransition=zeros(numOfPairs-sum(indToDelete),length(endLimitRight));
    isCentralEdgeNoTransition=zeros(numOfPairs-sum(indToDelete),length(endLimitRight));
    numCellsAtXBorderRight=zeros(length(endLimitRight),1);
    numCellsAtXBorderLeft=zeros(length(endLimitRight),1);
    numCellsAtXCentral=zeros(length(endLimitRight),1);
    scutoidsAtXBorderRight=zeros(length(endLimitRight),1);
    scutoidsAtXBorderLeft=zeros(length(endLimitRight),1);
    scutoidsAtXCentral=zeros(length(endLimitRight),1);
   
    
    for i=1:length(endLimitRight)
        isRightEdgeTransition(:,i) = (meanEdgeVertices(:,1) > endLimitRight(i)).*logical(indexesPairCellsTransition);
        isLeftEdgeTransition(:,i)= (meanEdgeVertices(:,1) < endLimitLeft(i)).*logical(indexesPairCellsTransition);
        isCentralEdgeTransition(:,i) = (meanEdgeVertices(:,1) >= endLimitLeft(i) & meanEdgeVertices(:,1) <= endLimitRight(i)).*logical(indexesPairCellsTransition);
        isRightEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) > endLimitRight(i)).*logical(1-indexesPairCellsTransition);
        isLeftEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) < endLimitLeft(i)).*logical(1-indexesPairCellsTransition);
        isCentralEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) >= endLimitLeft(i) & meanEdgeVertices(:,1) <= endLimitRight(i)).*logical(1-indexesPairCellsTransition);

        
        numCellsAtXBorderRight(i) = sum(outerEllipsoidInfo.centroids(:, 1)*centroidsRefactor > endLimitRight(i));
        numCellsAtXBorderLeft(i) = sum(outerEllipsoidInfo.centroids(:, 1)*centroidsRefactor < endLimitLeft(i));
        numCellsAtXCentral(i) = numberOfTotalCell - numCellsAtXBorderRight(i) - numCellsAtXBorderLeft(i);
        
        scutoidsAtXBorderRight(i) = sum(outerEllipsoidInfo.centroids(uniqueScutoidsCells, 1)*centroidsRefactor > endLimitRight(i));
        scutoidsAtXBorderLeft(i) = sum(outerEllipsoidInfo.centroids(uniqueScutoidsCells, 1)*centroidsRefactor < endLimitLeft(i));
        scutoidsAtXCentral(i) = (length(uniqueScutoidsCells) - scutoidsAtXBorderRight(i) - scutoidsAtXBorderLeft(i));

    end
    
    
    %organize transitions per region
    [outerSurfaceDataTransition.TotalRegion,outerSurfaceDataNoTransition.TotalRegion]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,logical(indexesPairCellsTransition),logical(1-indexesPairCellsTransition),numberOfTotalCell, length(uniqueScutoidsCells),'Total');
    [outerSurfaceDataTransition.RightRegion,outerSurfaceDataNoTransition.RightRegion]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,logical(isRightEdgeTransition),logical(isRightEdgeNoTransition),numCellsAtXBorderRight,scutoidsAtXBorderRight,'Right');
    [outerSurfaceDataTransition.LeftRegion,outerSurfaceDataNoTransition.LeftRegion]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,logical(isLeftEdgeTransition),logical(isLeftEdgeNoTransition),numCellsAtXBorderLeft, scutoidsAtXBorderLeft,'Left');
    [outerSurfaceDataTransition.CentralRegion,outerSurfaceDataNoTransition.CentralRegion]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,logical(isCentralEdgeTransition),logical(isCentralEdgeNoTransition),numCellsAtXCentral, scutoidsAtXCentral,'Central');               
        
end
