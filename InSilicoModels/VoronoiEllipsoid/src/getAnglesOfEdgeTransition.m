function [outerSurfaceDataTransition,outerSurfaceDataNoTransition, outerEllipsoidInfo] = getAnglesOfEdgeTransition( innerEllipsoidInfo, outerEllipsoidInfo, outputDir )

    
    pairOfNeighsOuterSurface=(cellfun(@(x, y) [y*ones(length(x),1),x],outerEllipsoidInfo.neighbourhood,num2cell(1:size(outerEllipsoidInfo.neighbourhood,1))','UniformOutput',false));
    outerEllipsoidInfo.neighbourhood=unique(vertcat(pairOfNeighsOuterSurface{:}),'rows');
    outerEllipsoidInfo.neighbourhood=unique([min(outerEllipsoidInfo.neighbourhood,[],2),max(outerEllipsoidInfo.neighbourhood,[],2)],'rows');

    outerSurfaceTotalData=struct('edgeLength',zeros(size(outerEllipsoidInfo.neighbourhood,1),1),'edgeAngle',zeros(size(outerEllipsoidInfo.neighbourhood,1),1),'edgeVertices',zeros(size(outerEllipsoidInfo.neighbourhood,1),1));
    
    %define the morphological shape to calculate the intercellular edge
    ratio=4;
    [xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
    ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio);
    %define the vertices in the ellipsoid grid
    [xVerGrid,yVerGrid,zVerGrid]=ellipsoid(outerEllipsoidInfo.xCenter, outerEllipsoidInfo.yCenter, outerEllipsoidInfo.zCenter, outerEllipsoidInfo.xRadius, outerEllipsoidInfo.yRadius, outerEllipsoidInfo.zRadius, outerEllipsoidInfo.resolutionEllipse);
    [~,verGrid,~] = surf2patch(xVerGrid,yVerGrid,zVerGrid);
    
    
    %save dilated perimeters of cells
    dilatedCell=cell(outerEllipsoidInfo.maxNumberOfCellsInVoronoi,1);
    for numCell=1:outerEllipsoidInfo.maxNumberOfCellsInVoronoi
        mask=zeros(size(outerEllipsoidInfo.img3DLayer));
        mask(outerEllipsoidInfo.img3DLayer==numCell)=1;
        mask=imdilate(bwperim(mask),ball);
        dilatedCell{numCell}=mask;
    end
    
%     outerEllipsoidInfo.cellDilated{i}
    %capture the length and the angle from the pair of neighbours    
    for i=1:size(outerEllipsoidInfo.neighbourhood,1)
        
        mask=dilatedCell{outerEllipsoidInfo.neighbourhood(i,1)}.*dilatedCell{outerEllipsoidInfo.neighbourhood(i,2)};
        [x,y,z]=findND(mask);
        edgeCoordinates=[x,y,z];
        [rowIndex,colIndex]=find(squareform(pdist([x,y,z]))==max(max(squareform(pdist([x,y,z])))));
        vertsEdge=[edgeCoordinates(rowIndex(1),:);edgeCoordinates(colIndex(1),:)];
        [edgeLength, edgeAngle] = comparisonEdgeOrietationWithMeridianOfEllipsoidGrid( verGrid, vertsEdge,outerEllipsoidInfo);
        outerSurfaceTotalData(i).edgeLength=edgeLength;
        outerSurfaceTotalData(i).edgeAngle=edgeAngle;
        outerSurfaceTotalData(i).edgeVertices=vertsEdge;
        
    end
    
    %get edges of transitions
    Lossing=cellfun(@(x,y) setdiff(x,y),outerEllipsoidInfo.neighbourhood,innerEllipsoidInfo.neighbourhood,'UniformOutput',false);
    
    pairOfLostNeigh=cellfun(@(x, y) [y*ones(length(x),1),x],Lossing,num2cell(1:size(outerEllipsoidInfo.neighbourhood,1))','UniformOutput',false);
    pairOfLostNeigh=unique(vertcat(pairOfLostNeigh{:}),'rows');
    pairOfLostNeigh=unique([min(pairOfLostNeigh,[],2),max(pairOfLostNeigh,[],2)],'rows');
    indexesEdgesTransition=ismember(outerEllipsoidInfo.neighbourhood,pairOfLostNeigh,'rows');
    
    %classify data per zone
    endLimitRight=((outerEllipsoidInfo.xOffset+outerEllipsoidInfo.xRadius*outerEllipsoidInfo.bordersSituatedAt)*outerEllipsoidInfo.resolutionFactor);   
    endLimitLeft=((outerEllipsoidInfo.xOffset-outerEllipsoidInfo.xRadius*outerEllipsoidInfo.bordersSituatedAt)*outerEllipsoidInfo.resolutionFactor);
    
    outerDataVertices=struct2cell(outerSurfaceTotalData);
    outerDataVertices=outerDataVertices(3,:);
    meanEdgeVertices=cell2mat(cellfun(@(x) mean(x),outerDataVertices,'UniformOutput',false)');
    for i=1:length(endLimitRight)
        isRightEdgeTransition(:,i) = (meanEdgeVertices(:,1) > endLimitRight(i)).*logical(indexesEdgesTransition);
        isLeftEdgeTransition(:,i)= (meanEdgeVertices(:,1) < endLimitLeft(i)).*logical(indexesEdgesTransition);
        isCentralEdgeTransition(:,i) = (meanEdgeVertices(:,1) >= endLimitLeft(i) & meanEdgeVertices(:,1) <= endLimitRight(i)).*logical(indexesEdgesTransition);
        isRightEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) > endLimitRight(i)).*logical(1-indexesEdgesTransition);
        isLeftEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) < endLimitLeft(i)).*logical(1-indexesEdgesTransition);
        isCentralEdgeNoTransition(:,i) = (meanEdgeVertices(:,1) >= endLimitLeft(i) & meanEdgeVertices(:,1) <= endLimitRight(i)).*logical(1-indexesEdgesTransition);
    end
    
    %organize transitions per region
    [outerSurfaceDataTransition.TotalRegion,outerSurfaceDataNoTransition.TotalRegion]=classifyEdgeDataPerZone(outerEllipsoidInfo,outerSurfaceTotalData,indexesEdgesTransition,indexesEdgesNoTransition);
    [outerSurfaceDataTransition.RightRegion,outerSurfaceDataNoTransition.RightRegion]=classifyEdgeDataPerZone(outerEllipsoidInfo,outerSurfaceTotalData,isRightEdgeTransition,isRightEdgeNoTransition);
    [outerSurfaceDataTransition.LeftRegion,outerSurfaceDataNoTransition.LeftRegion]=classifyEdgeDataPerZone(outerEllipsoidInfo,outerSurfaceTotalData,isLeftEdgeTransition,isLeftEdgeNoTransition);
    [outerSurfaceDataTransition.CentralRegion,outerSurfaceDataNoTransition.CentralRegion]=classifyEdgeDataPerZone(outerEllipsoidInfo,outerSurfaceTotalData,isCentralEdgeTransition,isCentralEdgeNoTransition);

    
    numCellsAtXBorderRight = sum(outerEllipsoidInfo.finalCentroids(:, 1) < -(outerEllipsoidInfo.bordersSituatedAt(numBorder) * outerEllipsoidInfo.xRadius));
    numCellsAtXBorderLeft = sum(outerEllipsoidInfo.finalCentroids(:, 1) > (outerEllipsoidInfo.bordersSituatedAt(numBorder) * outerEllipsoidInfo.xRadius));
    numCellsAtXCentral = size(outerEllipsoidInfo.finalCentroids(:, 1), 1) - numCellsAtXBorderRight - numCellsAtXBorderLeft;

               
        
end
