function mainTubularControlModelProjectionSurface(numSeeds,basalExpansions,apicalReductions,numRandoms,H,W)

    %main
    %we analyse the energy measurements from the expanded cylindrical voronoi
    %images


    

    typeProjections={'expansion','reduction'};
    for typProj=1:length(typeProjections)

        typeProjection=typeProjections{typProj};
        relativePath= ['data\tubularVoronoiModelSurfaceProjection\' typeProjection '\' num2str(W) 'x' num2str(H) '_'];

        if ~isempty(strfind(typeProjection,'expansion'))
            numSurfaces=length(basalExpansions);
        else
            numSurfaces=length(apicalReductions);
        end




        for nSeeds=numSeeds

            colours = colorcube(nSeeds);
            colours = colours(randperm(nSeeds), :);

             for nRand=1:numRandoms

                 for i=1:numSurfaces

                    if ~isempty(strfind(typeProjection,'expansion'))
                        load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')            
                        L_img=listLOriginalProjection.L_originalProjection{1};
                        surfaceRatio=basalExpansions(i);
                        W_projection=round(size(L_img,2)*surfaceRatio);


                        ['surface ratio - expansion: ' num2str(surfaceRatio) ]  
                    else
                        load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalApical')            
                        indexImage=10-10*apicalReductions(i);
                        surfaceRatio=1/(1-apicalReductions(i));
                        L_img=listLOriginalApical.L_originalApical{end};
                        ['surface ratio - reduction: ' num2str(surfaceRatio) ]

                        W_projection=round(size(L_img,2)*(1-apicalReductions(i)));


                    end    

                        ['number of randomization: ' num2str(nRand)]


                    %calculate neighbourings in apical layers
                    [neighs,~]=calculateNeighbours(L_img);

                    %get vertices apical
                    [vertices]=calculateVerticesAllFrusta(L_img,neighs);
                    notEmptyCells=cellfun(@(x) ~isempty(x),vertices.verticesPerCell,'UniformOutput',true);
                    vertices.verticesPerCell=vertices.verticesPerCell(notEmptyCells,:);
                    vertices.verticesConnectCells=vertices.verticesConnectCells(notEmptyCells,:);


                    [verticesNoValidCells]=getVerticesBorderNoValidCells(L_img);


                    %get vertices in new basal
                    if ~isempty(strfind(typeProjection,'expansion'))
                        verticesProjection.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*surfaceRatio)],vertices.verticesPerCell,'UniformOutput',false);
                        verticesProjection.verticesConnectCells=vertices.verticesConnectCells;
                        verticesProjectionNoValidCells.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*surfaceRatio)],verticesNoValidCells.verticesPerCell,'UniformOutput',false);
                        verticesProjectionNoValidCells.verticesConnectCells=verticesNoValidCells.verticesConnectCells;
                    else
                        verticesProjection.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*(1-apicalReductions(i)))],vertices.verticesPerCell,'UniformOutput',false);
                        verticesProjection.verticesConnectCells=vertices.verticesConnectCells;
                        verticesProjectionNoValidCells.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*(1-apicalReductions(i)))],verticesNoValidCells.verticesPerCell,'UniformOutput',false);
                        verticesProjectionNoValidCells.verticesConnectCells=verticesNoValidCells.verticesConnectCells;

                    end       

                    %get empty vertices to delete them
                    arrayProjectionCellVertices=verticesProjection(:).verticesConnectCells;
                    arrayProjectionNoValidCellVertices=cell2mat(verticesProjectionNoValidCells(:).verticesConnectCells')';



                    figure('visible','off');    
                    borderCells=unique(L_img(:,[1 end]));
                    borderCells=borderCells(borderCells~=0);
                    for j=1:max(max(L_img))

                            [indexes,~]=find(arrayProjectionCellVertices==j);
                            [indexesNoValidCells,~]=find(arrayProjectionNoValidCellVertices==j);
                            if isempty(indexesNoValidCells)
                                V=vertcat(verticesProjection.verticesPerCell{indexes,1});
                            else
                                V=[vertcat(verticesProjection.verticesPerCell{indexes,1});vertcat(verticesProjectionNoValidCells.verticesPerCell{indexesNoValidCells,1})];
                            end

                            V=unique(V,'rows');
                            if sum(j==borderCells)>0 && sum(V(:,2)>W_projection/2)~=0 && sum(V(:,2)<= W_projection/2)~=0
                                V1=V;
                                V2=V;
                                V1(V(:,2) > (W_projection/2),2) = V1(V(:,2) > (W_projection/2),2)-W_projection;
                                V2(V(:,2) <= (W_projection/2),2) = V2(V2(:,2) <= (W_projection/2),2)+W_projection;

                                orderVerticesV1=convhull(V1(:,1),V1(:,2));
                                sortedVerticesV1=V1(orderVerticesV1,:);
                                plot(sortedVerticesV1(:,1),sortedVerticesV1(:,2));
                                hold on;
                                orderVerticesV2=convhull(V2(:,1),V2(:,2));
                                sortedVerticesV2=V2(orderVerticesV2,:);
                                plot(sortedVerticesV2(:,1),sortedVerticesV2(:,2));


                                cellFigure = alphaShape(sortedVerticesV1(:,1), sortedVerticesV1(:,2), H);
                                plot(cellFigure, 'FaceColor', colours(j, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
                                cellFigure = alphaShape(sortedVerticesV2(:,1), sortedVerticesV2(:,2), 2000);
                                plot(cellFigure, 'FaceColor', colours(j, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);

                            else
                                orderVertices=convhull(V(:,1),V(:,2));
                                sortedVertices=V(orderVertices,:);
                                plot(sortedVertices(:,1),sortedVertices(:,2));
                                cellFigure = alphaShape(sortedVertices(:,1), sortedVertices(:,2), H);
                                plot(cellFigure, 'FaceColor', colours(j, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);

                                hold on;
                            end





                    end

                    directory2save=['data\tubularControlModelSurfaceProjection\images\' typeProjection '\' num2str(nSeeds) 'seeds\randomization' num2str(nRand) '\'];

                    axis([0 size(L_img,1) 0 W_projection])
                    camroll(-90)
                    set(gca,'Visible','off')

                    mkdir(directory2save);

                    print('-dtiff','-r300',[directory2save 'surfaceRatio' num2str(surfaceRatio) '.tiff'])
                    close all

                end

            end
        end

    end
end