function [outerSurfaceDataTransition,outerSurfaceDataNoTransition] = getAnglesLengthAndTranstionFromTheEdges( innerEllipsoidInfo, outerEllipsoidInfo )

    
    pairOfNeighsOuterSurface=(cellfun(@(x, y) [y*ones(length(x),1),x],outerEllipsoidInfo.neighbourhood,num2cell(1:size(outerEllipsoidInfo.neighbourhood,1))','UniformOutput',false));
    uniquePairOfNeighsOuterSurface=unique(vertcat(pairOfNeighsOuterSurface{:}),'rows');
    uniquePairOfNeighsOuterSurface=unique([min(uniquePairOfNeighsOuterSurface,[],2),max(uniquePairOfNeighsOuterSurface,[],2)],'rows');
    %number of cells per region
    numberOfTotalCell=size(unique(uniquePairOfNeighsOuterSurface),1);

    numOfEdges=size(uniquePairOfNeighsOuterSurface,1);
    outerSurfaceTotalData=struct('edgeLength',zeros(numOfEdges,1),'edgeAngle',zeros(numOfEdges,1),'edgeVertices',zeros(numOfEdges,1));
    
    %define the vertices in the ellipsoid grid
    [xVerGrid,yVerGrid,zVerGrid]=ellipsoid((outerEllipsoidInfo.xCenter+outerEllipsoidInfo.xOffset)*outerEllipsoidInfo.resolutionFactor, (outerEllipsoidInfo.yCenter+outerEllipsoidInfo.yOffset)*outerEllipsoidInfo.resolutionFactor, (outerEllipsoidInfo.zCenter+outerEllipsoidInfo.zOffset)*outerEllipsoidInfo.resolutionFactor, (outerEllipsoidInfo.xRadius+outerEllipsoidInfo.cellHeight)*outerEllipsoidInfo.resolutionFactor, (outerEllipsoidInfo.yRadius+outerEllipsoidInfo.cellHeight)*outerEllipsoidInfo.resolutionFactor, (outerEllipsoidInfo.zRadius+outerEllipsoidInfo.cellHeight)*outerEllipsoidInfo.resolutionFactor, outerEllipsoidInfo.resolutionEllipse);
    [~,verGrid,~] = surf2patch(xVerGrid,yVerGrid,zVerGrid);
    
    %surf(xVerGrid,yVerGrid,zVerGrid)

%     uiopen('D:\Pedro\Epithelia3D\InSilicoModels\VoronoiEllipsoid\results\random_1\Stage 4\voronoi_04-Oct-2017.fig',1)
%     set(get(0,'children'),'visible','on')
    %capture the length and the angle from the pair of neighbours    
    for i=1:numOfEdges
        
        mask=outerEllipsoidInfo.cellDilated{uniquePairOfNeighsOuterSurface(i,1),1}.*outerEllipsoidInfo.cellDilated{uniquePairOfNeighsOuterSurface(i,2),1};
        mask(outerEllipsoidInfo.img3DLayer~=0)=0;
        %%%incluir la condicion de que la dilatación no contenga pixels en
        %%%invalidZone. Que venga ya la imagen limpia o limpiarla aquí
        [x,y,z]=findND(mask);
        edgeCoordinates=[x,y,z];
        [rowIndex,colIndex]=find(squareform(pdist([x,y,z]))==max(max(squareform(pdist([x,y,z])))));
        vertsEdge=[edgeCoordinates(rowIndex(1),:);edgeCoordinates(colIndex(1),:)];
        [edgeLength, edgeAngle] = comparisonEdgeOrietationWithMeridianOfEllipsoidGrid( verGrid, vertsEdge,outerEllipsoidInfo);
        outerSurfaceTotalData(i).edgeLength=edgeLength;
        outerSurfaceTotalData(i).edgeAngle=edgeAngle;
        outerSurfaceTotalData(i).edgeVertices=vertsEdge;
        
        %plot3(x,y,z,'*')
        plot3(vertsEdge(:,1),vertsEdge(:,2),vertsEdge(:,3))
        hold on

        
    end
    
    for i=1:numberOfTotalCell
        [a,b,c]=findND(outerEllipsoidInfo.cellDilated{i});
        plot3(a,b,c,'*')
        hold on
    end
    
    %get edges of transitions
    Lossing=cellfun(@(x,y) setdiff(x,y),outerEllipsoidInfo.neighbourhood,innerEllipsoidInfo.neighbourhood,'UniformOutput',false);
    
    pairOfLostNeigh=cellfun(@(x, y) [y*ones(length(x),1),x],Lossing,num2cell(1:size(outerEllipsoidInfo.neighbourhood,1))','UniformOutput',false);
    pairOfLostNeigh=unique(vertcat(pairOfLostNeigh{:}),'rows');
    pairOfLostNeigh=unique([min(pairOfLostNeigh,[],2),max(pairOfLostNeigh,[],2)],'rows');
    indexesEdgesTransition=ismember(uniquePairOfNeighsOuterSurface,pairOfLostNeigh,'rows');
    
    %classify data per zone
    endLimitRight=((outerEllipsoidInfo.xOffset+(outerEllipsoidInfo.xRadius+outerEllipsoidInfo.cellHeight)*outerEllipsoidInfo.bordersSituatedAt)*outerEllipsoidInfo.resolutionFactor);   
    endLimitLeft=((outerEllipsoidInfo.xOffset-(outerEllipsoidInfo.xRadius+outerEllipsoidInfo.cellHeight)*outerEllipsoidInfo.bordersSituatedAt)*outerEllipsoidInfo.resolutionFactor);
    
    outerDataVertices=struct2cell(outerSurfaceTotalData);
    outerDataVertices=outerDataVertices(3,:);
    meanEdgeVertices=cell2mat(cellfun(@(x) mean(x),outerDataVertices,'UniformOutput',false)');
    
    isRightEdgeTransition=zeros(numOfEdges,length(endLimitRight));
    isLeftEdgeTransition=zeros(numOfEdges,length(endLimitRight));
    isCentralEdgeTransition=zeros(numOfEdges,length(endLimitRight));
    isRightEdgeNoTransition=zeros(numOfEdges,length(endLimitRight));
    isLeftEdgeNoTransition=zeros(numOfEdges,length(endLimitRight));
    isCentralEdgeNoTransition=zeros(numOfEdges,length(endLimitRight));
    numCellsAtXBorderRight=zeros(length(endLimitRight),1);
    numCellsAtXBorderLeft=zeros(length(endLimitRight),1);
    numCellsAtXCentral=zeros(length(endLimitRight),1);
    for i=1:length(endLimitRight)
        isRightEdgeTransition(:,i) = (meanEdgeVertices(:,1) > endLimitRight(i)).*logical(indexesEdgesTransition);
        isLeftEdgeTransition(:,i)= (meanEdgeVertices(:,1) < endLimitLeft(i)).*logical(indexesEdgesTransition);
        isCentralEdgeTransition(:,i) = (meanEdgeVertices(:,1) >= endLimitLeft(i) & meanEdgeVertices(:,1) <= endLimitRight(i)).*logical(indexesEdgesTransition);
        isRightEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) > endLimitRight(i)).*logical(1-indexesEdgesTransition);
        isLeftEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) < endLimitLeft(i)).*logical(1-indexesEdgesTransition);
        isCentralEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) >= endLimitLeft(i) & meanEdgeVertices(:,1) <= endLimitRight(i)).*logical(1-indexesEdgesTransition);
        
        numCellsAtXBorderRight(i) = sum(outerEllipsoidInfo.centroids(:, 1) > endLimitRight(i));
        numCellsAtXBorderLeft(i) = sum(outerEllipsoidInfo.centroids(:, 1) < endLimitLeft(i));
        numCellsAtXCentral(i) = numberOfTotalCell - numCellsAtXBorderRight(i) - numCellsAtXBorderLeft(i);
    
    end
    
    %organize transitions per region
    [outerSurfaceDataTransition.TotalRegion,outerSurfaceDataNoTransition.TotalRegion]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,logical(indexesEdgesTransition),logical(1-indexesEdgesTransition),numberOfTotalCell);
    [outerSurfaceDataTransition.RightRegion,outerSurfaceDataNoTransition.RightRegion]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,logical(isRightEdgeTransition),logical(isRightEdgeNoTransition),numCellsAtXBorderRight);
    [outerSurfaceDataTransition.LeftRegion,outerSurfaceDataNoTransition.LeftRegion]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,logical(isLeftEdgeTransition),logical(isLeftEdgeNoTransition),numCellsAtXBorderLeft);
    [outerSurfaceDataTransition.CentralRegion,outerSurfaceDataNoTransition.CentralRegion]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,logical(isCentralEdgeTransition),logical(isCentralEdgeNoTransition),numCellsAtXCentral);               
        
end
