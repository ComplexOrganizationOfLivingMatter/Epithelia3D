%main
%we analyse the energy measurements from the expanded cylindrical voronoi
%images

addpath lib
addpath libEnergy

surfaceRatios= [1/0.9 1/0.8 1/0.7 1/0.6 1/0.5 1/0.4 1/0.3 1/0.2 1/0.1];

numSeeds=200;%[50,100,200,400];
numRandoms=20;


relativePath= '..\..\data\expansion\512x1024_';
numSurfaces=length(surfaceRatios);

colours = colorcube(numSeeds);
colours = colours(randperm(numSeeds), :);


for nSeeds=numSeeds
        
    for i=1:numSurfaces
        tableTransitionEnergy=table();
        tableNoTransitionEnergy=table();
        tableTransitionEnergyFiltering200data=table();
        tableNoTransitionEnergyFiltering200data=table();
    
        for nRand=1:numRandoms
            
                load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')            
                L_apical=listLOriginalProjection.L_originalProjection{1};
                surfaceRatio=surfaceRatios(i);
                
                
            ['surface ratio - expansion: ' num2str(surfaceRatio) ]            
            ['number of randomization: ' num2str(nRand)]
            
            
            %calculate neighbourings in apical layers
            [neighs_apical,~]=calculateNeighbours(L_apical);
            %no valid cells. No valid in apical or basal
            noValidCells=unique([L_apical(1,:),L_apical(size(L_apical,1),:)]);
            
            %get vertices apical
            [verticesApical]=calculateVertices(L_apical,neighs_apical,noValidCells);
            [verticesApicalNoValidCells]=getVerticesBorderNoValidCells(L_apical);
            
            %get vertices in new basal
            verticesBasal.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*surfaceRatio)],verticesApical.verticesPerCell,'UniformOutput',false);
            verticesBasal.verticesConnectCells=verticesApical.verticesConnectCells;
            
            verticesBasalNoValidCells.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*surfaceRatio)],verticesApicalNoValidCells.verticesPerCell,'UniformOutput',false);
            verticesBasalNoValidCells.verticesConnectCells=verticesApicalNoValidCells.verticesConnectCells;

            
            %get empty vertices to delete them
            arrayBasalCellVertices=verticesBasal(:).verticesConnectCells;
            arrayBasalNoValidCellVertices=cell2mat(verticesBasalNoValidCells(:).verticesConnectCells')';
            
            
            W_basal=round(size(L_apical,2)*surfaceRatio);
            
            figure('visible','off');    
            for j=1:max(max(L_apical))

                    [indexes,~]=find(arrayBasalCellVertices==j);
                    [indexesNoValidCells,~]=find(arrayBasalNoValidCellVertices==j);
                    if isempty(indexesNoValidCells)
                        V=vertcat(verticesBasal.verticesPerCell{indexes,1});
                    else
                        V=[vertcat(verticesBasal.verticesPerCell{indexes,1});vertcat(verticesBasalNoValidCells.verticesPerCell{indexesNoValidCells,1})];
                    end
                    
                    V=unique(V,'rows');
                    if sum(V(:,2)>W_basal/1.333)~=0 && sum(V(:,2)< W_basal/4)~=0
                        V1=V;
                        V2=V;
                        V1(V(:,2) > (W_basal/1.333),2) = V1(V(:,2) > (W_basal/1.333),2)-W_basal;
                        V2(V(:,2) < (W_basal/4),2) = V2(V2(:,2) < (W_basal/4),2)+W_basal;
                        
                        orderVerticesV1=convhull(V1(:,1),V1(:,2));
                        sortedVerticesV1=V1(orderVerticesV1,:);
%                         plot(sortedVerticesV1(:,1),sortedVerticesV1(:,2));
                        hold on;
                        orderVerticesV2=convhull(V2(:,1),V2(:,2));
                        sortedVerticesV2=V2(orderVerticesV2,:);
%                         plot(sortedVerticesV2(:,1),sortedVerticesV2(:,2));
                        

                        cellFigure = alphaShape(sortedVerticesV1(:,1), sortedVerticesV1(:,2), 2000);
                        plot(cellFigure, 'FaceColor', colours(j, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
                        cellFigure = alphaShape(sortedVerticesV2(:,1), sortedVerticesV2(:,2), 2000);
                        plot(cellFigure, 'FaceColor', colours(j, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
                        
                    else
                        orderVertices=convhull(V(:,1),V(:,2));
                        sortedVertices=V(orderVertices,:);
%                         plot(sortedVertices(:,1),sortedVertices(:,2));
                        cellFigure = alphaShape(sortedVertices(:,1), sortedVertices(:,2), 2000);
                        plot(cellFigure, 'FaceColor', colours(j, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
                        
                        hold on;
                    end
                        
                        
                                        
                    
                   
            end
            
                        directory2save=['..\..\data\vertexModel\images\expansion\' num2str(nSeeds) 'seeds\randomization' num2str(nRand) '\'];

            
            axis([0 size(L_apical,1) 0 W_basal])
            camroll(-90)
            set(gca,'Visible','off')
            
            mkdir(directory2save);
            
            print('-dtiff','-r300',[directory2save 'surfaceRatio' num2str(surfaceRatio) '.tiff'])
            close all
            
            
            
                                            
        end
        
    end
end