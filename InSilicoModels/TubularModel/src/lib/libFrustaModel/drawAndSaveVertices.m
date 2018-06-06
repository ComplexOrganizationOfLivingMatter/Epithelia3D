function drawAndSaveVertices(relativePath,nSeeds,nRand,numSurfaces,typeProjection,basalExpansions,apicalReductions,colours,H)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
     frustaTable=cell(numSurfaces,3);
     indexesBorderVerticesLeftPerCell={};
     load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')            
     relativePathControl=strrep(relativePath,'Voronoi','Control');
     
     for nSurf=1:numSurfaces

        
        if contains(typeProjection,'expansion')
            surfaceRatio=basalExpansions(nSurf);
            disp(['Drawing vertices: surface ratio - expansion: ' num2str(surfaceRatio) ' number of seeds ' num2str(nSeeds) ' _ number of randomization: ' num2str(nRand) ])  
        else
            surfaceRatio=apicalReductions(nSurf);
            disp(['Drawing vertices: surface ratio - reduction: ' num2str(surfaceRatio) ' number of seeds ' num2str(nSeeds) ' _ number of randomization: ' num2str(nRand) ])
        end    


        if nSurf==1         
            L_img=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==1};

            %calculate neighbourings in apical layers
            [neighs,~]=calculateNeighbours(L_img);

            %get vertices apical
            [vertices]=calculateVertices(L_img,neighs);
            [verticesNoValidCells]=getVerticesBorderNoValidCells(L_img);

            %defining valid vertices in valid left border cell
            arrayValidVerticesBorderLeft=zeros(size(vertices.verticesPerCell,1),1);
            arrayValidVerticesBorderRight=zeros(size(vertices.verticesPerCell,1),1);
        end
        
        W_projection=round(size(L_img,2)*surfaceRatio);

        %get vertices in new basal
        verticesProjection.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*surfaceRatio)],vertices.verticesPerCell,'UniformOutput',false);
        verticesProjection.verticesConnectCells=vertices.verticesConnectCells;
        verticesProjectionNoValidCells.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*surfaceRatio)],verticesNoValidCells.verticesPerCell,'UniformOutput',false);
        verticesProjectionNoValidCells.verticesConnectCells=verticesNoValidCells.verticesConnectCells;


        %get empty vertices to delete them
        arrayProjectionCellVertices=verticesProjection(:).verticesConnectCells;
        try 
            arrayProjectionNoValidCellVertices=cell2mat(verticesProjectionNoValidCells(:).verticesConnectCells')';
        catch
           disp('n of cells = 1'  )
           validIndexes=cellfun(@(x) length(x)==2, verticesProjectionNoValidCells.verticesConnectCells);
           verticesProjectionNoValidCells.verticesConnectCells=verticesProjectionNoValidCells.verticesConnectCells(validIndexes,:);
           arrayProjectionNoValidCellVertices=cell2mat(verticesProjectionNoValidCells(:).verticesConnectCells')';
           verticesProjectionNoValidCells.verticesPerCell=verticesProjectionNoValidCells.verticesPerCell(validIndexes,:);
        end
        borderCells=unique(L_img(:,[1 end]));
        borderCells=borderCells(borderCells~=0);
        verticesBorderCells=cellfun(@(x) (x(1,2) == W_projection | x(1,2) == 1),vertices.verticesPerCell);
        newBorderCells=unique(vertices.verticesConnectCells(verticesBorderCells,:));
        borderCells=unique(vertcat(borderCells,[newBorderCells(:)]));

        figure('visible','off');    

        for nCell=1:max(max(L_img))
             try
                [indexes,~]=find(arrayProjectionCellVertices==nCell);
                indexes=sort(indexes);
                [indexesNoValidCells,~]=find(arrayProjectionNoValidCellVertices==nCell);
                if isempty(indexesNoValidCells)
                    V=vertcat(verticesProjection.verticesPerCell{indexes,1});
                else
                    V=[vertcat(verticesProjection.verticesPerCell{indexes,1});vertcat(verticesProjectionNoValidCells.verticesPerCell{indexesNoValidCells,1})];
                end

                V=unique(V,'rows','stable');
                V=round(V);
                if ismember(nCell,borderCells) || max(V(:,2))-min(V(:,2))>W_projection/2
                    if nSurf==1
                        [V1,V2,V1index,~]=checkVerticesBorder(nCell,L_img,V,W_projection);
                        indexesBorderVerticesLeftPerCell{nCell}=V1index;
                        arrayValidVerticesBorderLeft(indexes(V1index(1:(end-(length(indexesNoValidCells))))))=1;
                        arrayValidVerticesBorderRight(indexes(~V1index(1:(end-(length(indexesNoValidCells))))))=1;   
                    else
                        V1index=indexesBorderVerticesLeftPerCell{nCell};
                        V1=V;
                        V2=V;
                        V1(V1index,2)=V(V1index,2)+W_projection; 
                        V2(~V1index,2)=V(~V1index,2)-W_projection; 
                    end

                    orderVerticesV1=convhull(V1(:,1),V1(:,2));
                    sortedVerticesV1=V1(orderVerticesV1,:);
                    plot(sortedVerticesV1(:,1),sortedVerticesV1(:,2),'black');
                    hold on;
                    orderVerticesV2=convhull(V2(:,1),V2(:,2));
                    sortedVerticesV2=V2(orderVerticesV2,:);
                    plot(sortedVerticesV2(:,1),sortedVerticesV2(:,2),'black');


                    cellFigure = alphaShape(sortedVerticesV1(:,1), sortedVerticesV1(:,2), H*2);
                    plot(cellFigure, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
                    cellFigure = alphaShape(sortedVerticesV2(:,1), sortedVerticesV2(:,2), H*2);
                    plot(cellFigure, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);

                else
                    orderVertices=convhull(V(:,1),V(:,2));
                    sortedVertices=V(orderVertices,:);
                    plot(sortedVertices(:,1),sortedVertices(:,2),'black');
                    cellFigure = alphaShape(sortedVertices(:,1), sortedVertices(:,2), H*2);
                    plot(cellFigure, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);

                    hold on;

                    indexesBorderVerticesLeftPerCell{nCell}=nan;

                end
            catch
                disp(['error in cell ' num2str(nCell)] )
            end

        end


        directory2save=[relativePathControl num2str(nSeeds) 'seeds\randomization' num2str(nRand) '\'];
        directoryData=strrep(directory2save,'images','data');


        axis([0 size(L_img,1) 0 W_projection])
        camroll(-90)
        set(gca,'Visible','off')

        mkdir(directory2save);
        mkdir(directoryData);


        print('-dtiff','-r300',[directory2save 'surfaceRatio' num2str(surfaceRatio) '.tiff'])
        close all

        frustaTable{nSurf,1}=surfaceRatio;
        frustaTable{nSurf,2}=verticesProjection;
        frustaTable{nSurf,3}=verticesProjectionNoValidCells;
     end
        
     frustaTable=cell2table(frustaTable,'VariableNames',{'surfaceRatio','vertices','noValidCellsVertices'});
     save([directoryData 'totalVerticesData.mat'],'frustaTable','indexesBorderVerticesLeftPerCell','L_img','arrayValidVerticesBorderLeft','arrayValidVerticesBorderRight')

     
     
end

