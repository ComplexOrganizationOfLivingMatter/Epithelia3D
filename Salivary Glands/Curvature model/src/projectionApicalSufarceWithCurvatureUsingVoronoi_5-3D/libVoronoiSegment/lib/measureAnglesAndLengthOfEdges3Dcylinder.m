function [ outerDataTransition,outerDataNoTransition ] = measureAnglesAndLengthOfEdges3Dcylinder( outerSurface,innerSurface)

    %% -- THIS CODE NEED TO BE REFACTOR WHEN MATLAB R2017B IS AVAILABLE -- %%


    %calculate neighbourings in apical and basal layers
    [neighs_outer,~]=calculate_neighbours3D(outerSurface);
    [neighs_inner,~]=calculate_neighbours3D(innerSurface);

    %classify neighbourings of basal
    pairOfNeighsOuter=(cellfun(@(x, y) [y*ones(length(x),1),x],neighs_outer',num2cell(1:size(neighs_outer,2))','UniformOutput',false));
    uniquePairOfNeighOuter=unique(vertcat(pairOfNeighsOuter{:}),'rows');
    uniquePairOfNeighOuter=unique([min(uniquePairOfNeighOuter,[],2),max(uniquePairOfNeighOuter,[],2)],'rows');

    outerData=struct('edgeLength',zeros(size(uniquePairOfNeighOuter,1),1),'edgeAngle',zeros(size(uniquePairOfNeighOuter,1),1));
    
    %calculate vertices of cells
    [ verticesInfo] = getVertices3D( outerSurface, neighs_outer);
    
    % capture the length and the angle from the pair of neighbours
    acum=1;
    indToDelete=zeros(size(uniquePairOfNeighOuter,1),1);    
    for i=1:size(uniquePairOfNeighOuter,1)
                
        %get vertices of neigh cells edge 
        indexVert=sum(ismember(verticesInfo.verticesConnectCells,uniquePairOfNeighOuter(i,:)),2);
        indexVert=find(indexVert==2);
        vertsEdge=vertcat(verticesInfo.verticesPerCell{indexVert(:)});
       	vertsEdge=unique(vertsEdge,'rows');
        
        if size(vertsEdge,1)>1
            
            if size(vertsEdge,1)>2
                   [rowIndex,colIndex]=find(squareform(pdist(vertsEdge))==max(max(squareform(pdist(vertsEdge)))));
                    vertsEdge=vertsEdge([rowIndex(1),colIndex(1)],:);
            end
            %angle calculation
            [edgeLength, edgeAngle] = comparisonEdgeOrientationWithTrasverseCylinderPlane( vertsEdge);
            outerData(acum).edgeLength=edgeLength;
            outerData(acum).edgeAngle=edgeAngle;
            outerData(acum).edgeVertices=vertsEdge;
            
            hold on
            plot3(vertsEdge(:,1),vertsEdge(:,2),vertsEdge(:,3))
            
            
            acum=acum+1;
        else
            indToDelete(i)=1;
            
        end     
    end
    
    %deleting pair of neighbours with no vertices
    uniquePairOfNeighOuter=uniquePairOfNeighOuter(logical(1-indToDelete),:);

    
    
    %get edges of transitions
    newInOuter=cellfun(@(x,y) setdiff(x,y),neighs_outer,neighs_inner,'UniformOutput',false);
   
    pairOfNewNeighsInOuter=cellfun(@(x, y) [y*ones(length(x),1),x],newInOuter',num2cell(1:size(neighs_outer,2))','UniformOutput',false);
    pairOfNewNeighsInOuter=unique(vertcat(pairOfNewNeighsInOuter{:}),'rows');
    pairOfNewNeighsInOuter=unique([min(pairOfNewNeighsInOuter,[],2),max(pairOfNewNeighsInOuter,[],2)],'rows');
    indexesOuterEdgesTransition=ismember(uniquePairOfNeighOuter,pairOfNewNeighsInOuter,'rows');
    
    
    %define transition edge length and angle
    outerDataTransition=struct('edgeLength',zeros(sum(indexesOuterEdgesTransition),1),'edgeAngle',zeros(sum(indexesOuterEdgesTransition),1));
    outerDataTransition.edgeLength=cat(1,outerData(indexesOuterEdgesTransition).edgeLength);
    outerDataTransition.edgeAngle=abs(cat(1,outerData(indexesOuterEdgesTransition).edgeAngle));
    outerDataTransition.edgeVertices=cat(1,{outerData(indexesOuterEdgesTransition).edgeVertices});

    
    %define no transition transition edge length and angle
    outerDataNoTransition.edgeLength=cat(1,outerData(logical(1-indexesOuterEdgesTransition)).edgeLength);
    outerDataNoTransition.edgeAngle=abs(cat(1,outerData(logical(1-indexesOuterEdgesTransition)).edgeAngle));
    outerDataNoTransition.edgeVertices=cat(1,{outerData(logical(1-indexesOuterEdgesTransition)).edgeVertices});

    %basalDataTransition
    anglesTransition=cat(1,outerDataTransition(:).edgeAngle);
    outerDataTransition.cellularMotifs=uniquePairOfNeighOuter(indexesOuterEdgesTransition,:);
    outerDataTransition.angles=anglesTransition;
    outerDataTransition.numOfEdges=length(anglesTransition);
    outerDataTransition.proportionAnglesLess15deg=sum(anglesTransition<=15)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween15_30deg=sum(anglesTransition>15 & anglesTransition <= 30)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween30_45deg=sum(anglesTransition>30 & anglesTransition <= 45)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween45_60deg=sum(anglesTransition>45 & anglesTransition <= 60)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween60_75deg=sum(anglesTransition>60 & anglesTransition <= 75)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween75_90deg=sum(anglesTransition>75 & anglesTransition <= 90)/length(anglesTransition);
    
    %basalDataNoTransition
    anglesNoTransition=cat(1,outerDataNoTransition(:).edgeAngle);
    outerDataNoTransition.cellularMotifs=uniquePairOfNeighOuter(logical(1-indexesOuterEdgesTransition),:);
    outerDataNoTransition.angles=anglesNoTransition;
    outerDataNoTransition.numOfEdges=length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesLess15deg=sum(anglesNoTransition<=15)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween15_30deg=sum(anglesNoTransition>15 & anglesNoTransition <= 30)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween30_45deg=sum(anglesNoTransition>30 & anglesNoTransition <= 45)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween45_60deg=sum(anglesNoTransition>45 & anglesNoTransition <= 60)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween60_75deg=sum(anglesNoTransition>60 & anglesNoTransition <= 75)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween75_90deg=sum(anglesNoTransition>75 & anglesNoTransition <= 90)/length(anglesNoTransition);
    
    

end

