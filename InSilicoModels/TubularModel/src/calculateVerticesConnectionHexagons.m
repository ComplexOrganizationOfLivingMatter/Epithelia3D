%%calculateVerticesConnectionHexagons
addpath(genpath('lib'))
 
H_initial=512;
W_initial=1024;
n_seeds=132;
rootPath='..\beforePaperCode\dataBeforePaperCode\voronoiModel\reduction\cylinderOfHexagons\';
dir2save=[num2str(H_initial) 'x' num2str(W_initial) '_' num2str(n_seeds) 'seeds\'];

initialSurfaceRatio = 0.3;
intermediateSurfaceRatio=0.5;
basalSurfaceRatio=0.9;
surfaceRatios=[initialSurfaceRatio,intermediateSurfaceRatio,basalSurfaceRatio];
nRand=1;
cellWithVertices={};
dataVertID={};
pairOfVerticesTotal={};

load([rootPath dir2save 'Image_1_Diagram_5.mat'],'listSeedsProjected','listLOriginalProjection')

%Voronoi or Frusta output
VoronoiOutput = 0;
if VoronoiOutput
    disp('---------------Voronoi results--------------');
    outputKind = 'Voronoi';
else
    disp('---------------Frusta results --------------');
    outputKind = 'Frusta';
end
        
maxSurfaceRatio=max(surfaceRatios);
L_imgMax=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==maxSurfaceRatio};
Wmax=size(L_imgMax,2);
RadiusMax=Wmax/(2*pi);

for nSurfR=surfaceRatios

    %1- vertices located in Cylinder 3D position over the surface
    %2- vertices in contact over the surface
    L_img = listLOriginalProjection.L_originalProjection{round(listLOriginalProjection.surfaceRatio,3)==round(nSurfR,3)};
    
    L_img=[L_img(:,end-5:end),L_img(:,1:end-5)];
    if initialSurfaceRatio == nSurfR || VoronoiOutput
        initialL_img = L_img;

        [dataVertID,pairOfVerticesTotal,verticesInfo,verticesNoValidCellsInfo]=extract3dCoordInCylinderSurface(L_img,dataVertID,pairOfVerticesTotal,nRand,RadiusMax);
    else
        %We get the L_img from earlier steps
        [dataVertID,pairOfVerticesTotal,verticesInfo,verticesNoValidCellsInfo]=extract3dCoordInCylinderSurface(initialL_img,dataVertID,pairOfVerticesTotal,nRand,RadiusMax, nSurfR/initialSurfaceRatio);
    end
    
    %%3- cells composed by N-vertices
    cellWithVertices = groupingVerticesPerCellSurface(L_img,verticesInfo,verticesNoValidCellsInfo,cellWithVertices,nRand);
end


pairVertices3D=joiningVerticesIn3d(dataVertID);
radiusCyl=vertcat(dataVertID{:,2});
radiusCylUniq=unique(radiusCyl);
 
pairTotalVertices = [[vertcat(pairOfVerticesTotal{:,1}),vertcat(pairOfVerticesTotal{:,2})];pairVertices3D];

cellsVerts=cell(max(L_img(:)),2);
for nCell=1:max(L_img(:))
    
    idVertsPerCell=cellfun(@(x) ismember(nCell,x), dataVertID(:,end));
    
    cellsVerts(nCell,1)={nCell};
    cellsVerts(nCell,2)={find(idVertsPerCell)'};
    
end

dataVertID = dataVertID(:,2:end);  

%deleting junction intermediate layer
[radCyl,idx,c]=unique(vertcat(dataVertID{:,1}));
vertInter=vertcat(dataVertID{c==2,2});
join2Del=arrayfun(@(x,y) sum(ismember(vertInter,[x,y]))==2,pairTotalVertices(:,1),pairTotalVertices(:,2));
pairTotalVertices(join2Del,:)=[];

%% Removing the vertices that are irrelevant
% We created a line between each pair of vertices and see if any other
% vertex overlap with this line.
thresholdDistance = 1;
vertexToDelete = [];
for numCell = 96%1:size(cellVerticesTable, 1)
    verticesOfACellIds = cellVerticesTable.verticesIDs{numCell};   
    
    %Possible pair of vertices we could remove
    actualPairOfVertices = pairTotalVertices(all(ismember(pairTotalVertices, verticesOfACellIds), 2), :);
    
    for initialNumVertex = verticesOfACellIds
        pairOfVerticesToAnalyse = actualPairOfVertices(any(ismember(actualPairOfVertices, initialNumVertex), 2), :);
        vertexNeighbours = unique(pairOfVerticesToAnalyse)';
        vertexNeighbours(vertexNeighbours == initialNumVertex) = [];
        
        for numVertexNeigh = vertexNeighbours
            pairOfVerticesNeighs = actualPairOfVertices(any(ismember(actualPairOfVertices, numVertexNeigh), 2), :);
            endVertices = unique(pairOfVerticesNeighs)';
            endVertices(ismember(endVertices, [initialNumVertex numVertexNeigh])) = [];
            for endNumVertex = endVertices
                initialVertex = cell2mat(dataVertID(initialNumVertex, 3:5));
                intermediateVertex = cell2mat(dataVertID(numVertexNeigh, 3:5)); 
                endVertex = cell2mat(dataVertID(endNumVertex, 3:5));
                [linePoints] = line3D(initialVertex, endVertex);
                if min(pdist2(intermediateVertex, linePoints)) < thresholdDistance
                    %plot3(intermediateVertex(:, 1), intermediateVertex(:, 2), intermediateVertex(:, 3), '*')
                    vertexToDelete(end+1) = numVertexNeigh;
                end
            end
        end
    end
end


%storing data
cellVerticesTable=cell2table(cellsVerts,'VariableNames',{'cellIDs','verticesIDs'});
pairOfVerticesTable=array2table(pairTotalVertices,'VariableNames',{'verticeID1','verticeID2'});
vertices3dTable=cell2table(dataVertID,'VariableNames',{'radius','verticeID','coordX','coordY','coordZ','cellIDs'});


%Representing a cell
%verticesToShowIDs = cellVerticesTable.verticesIDs{96};

%representing joined vertices
figure;
hold on
for nPair=size(pairOfVerticesTable,1):-1:1
    %if ismember(pairOfVerticesTable.verticeID1(nPair), verticesToShowIDs) && ismember(pairOfVerticesTable.verticeID2(nPair), verticesToShowIDs)
        x1=vertices3dTable.coordX(pairOfVerticesTable.verticeID1(nPair));
        y1=vertices3dTable.coordY(pairOfVerticesTable.verticeID1(nPair));
        z1=vertices3dTable.coordZ(pairOfVerticesTable.verticeID1(nPair));
        x2=vertices3dTable.coordX(pairOfVerticesTable.verticeID2(nPair));
        y2=vertices3dTable.coordY(pairOfVerticesTable.verticeID2(nPair));
        z2=vertices3dTable.coordZ(pairOfVerticesTable.verticeID2(nPair));

        plot3([x1,x2],[y1,y2],[z1,z2])
    %end
    
end

writetable(cellVerticesTable,[rootPath dir2save 'cellsWithVerticesIDs_' outputKind '_' date '.xls'])
writetable(vertices3dTable,[rootPath dir2save 'tableVerticesCoordinates3D_' outputKind '_' date '.xls'])
writetable(pairOfVerticesTable,[rootPath dir2save 'tableConnectionsOfVertices3D_' outputKind '_' date '.xls'])


