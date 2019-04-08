function matrixSeeds = lloydWithDelaunayCylinder(matrixSeeds,xImg,yImg,numSeeds,idCentralRegion,nLloydIt)


    for nIt = 1:nLloydIt      
        %get vertices per cell
        %%delaunay triangulation
        DT = delaunayTriangulation(matrixSeeds(:,1),matrixSeeds(:,2));
        %triplets of neighbours cells
        triOfInterest = DT.ConnectivityList;
        %get vertices position using the triangle circumcenter
        verticesTRI = DT.circumcenter; 

        %delete vertices out of the image region 2 avoid repeatition in
        %border cells
        indVertOut = verticesTRI(:,1)>2*xImg | verticesTRI(:,1)<-xImg;
        verticesTRI(indVertOut,:) = [];
        triOfInterest(indVertOut,:) = [];   
        
        %delete triangulations and vertices out of limits
        vertIn = [verticesTRI(:,2) <= 2*yImg] & [verticesTRI(:,2) > -yImg];
        noValidCells = unique(triOfInterest(~vertIn,:));
        triOfInterest = triOfInterest(vertIn,:);
        verticesTRI = verticesTRI(vertIn,:);
        indNoValCel = ismember(triOfInterest, noValidCells);
        pairNoValidCells = triOfInterest(sum(indNoValCel,2)==2,:);
        tripletNoValidCells = triOfInterest(sum(indNoValCel,2)==3,:);
        pairNoValidCells(~ismember(pairNoValidCells,noValidCells)) = 0;
        
        %subdivide triplet of no valid cells in pairs and delete extra
        %connections
        for nTri =1 : size(tripletNoValidCells,1)
            a = sum(ismember(pairNoValidCells(:),tripletNoValidCells(nTri,1)));
            b = sum(ismember(pairNoValidCells(:),tripletNoValidCells(nTri,2)));
            c = sum(ismember(pairNoValidCells(:),tripletNoValidCells(nTri,3)));
            [~,indMin] = sort([a,b,c]);
            
            pairNoValidCells(sum(ismember(pairNoValidCells,[tripletNoValidCells(nTri,indMin(2)),tripletNoValidCells(nTri,indMin(3))]),2)==2,:)=[];
            
            pairNoValidCells = [pairNoValidCells;[tripletNoValidCells(nTri,indMin(1)),tripletNoValidCells(nTri,indMin(2)),0]];
            pairNoValidCells = [pairNoValidCells;[tripletNoValidCells(nTri,indMin(1)),tripletNoValidCells(nTri,indMin(3)),0]];
        end
        
        %storing bulk vertices
        verticesInfo.verticesPerCell = verticesTRI;
        verticesInfo.verticesConnectCells = triOfInterest;
        
        %calculate no valid cells vertices
        verticesNoValidCellsInfo = getVerticesNoValidCellsDelaunay(pairNoValidCells,fliplr(matrixSeeds),[],-yImg,2*yImg,0);
        
        Cx = zeros(numSeeds*9,1);
        Cy = zeros(numSeeds*9,1);
        close all
        figure;
        for nCell = idCentralRegion
            idValidVert = sum(ismember(vertcat(verticesInfo.verticesConnectCells),nCell),2)>0;
            idNoValidVert = sum(ismember(vertcat(verticesNoValidCellsInfo.verticesConnectCells{:}),nCell),2)>0;    
            vertValid = vertcat(verticesInfo.verticesPerCell(idValidVert,:));
            if sum(idNoValidVert)>0
                vertNoValid = vertcat(verticesNoValidCellsInfo.verticesPerCell{idNoValidVert});
            else
                vertNoValid = [];
            end
            vertTotal = unique([vertValid;fliplr(vertNoValid)],'rows');

            try        
                k = convhull(vertTotal(:,1),vertTotal(:,2));
                if length(k) > size(vertTotal,1)
                    newVertOrder = vertTotal(k,:);
                    newVertOrder = [newVertOrder;newVertOrder(1,:)];
                else
                    newVertOrder = boundaryOfCell(vertTotal, matrixSeeds(nCell,:));
                end
                % Should be connected clockwise
                % I.e. from bigger numbers to smaller ones
                % Or the second vertex should in the left hand of the first

                [newOrderX, newOrderY] = poly2cw(newVertOrder((1:end-1), 1), newVertOrder((1:end-1), 2));
                pgon = polyshape(newOrderX,newOrderY);
                plot(pgon)
                hold on
                [Cx(nCell), Cy(nCell)] = centroid(pgon);
            catch
                if size(vertTotal,1)>1
                    cent = mean(vertTotal);
                else
                    cent = vertTotal;
                end
                Cx(nCell) = cent(1);
                Cy(nCell) = cent(2);
                
                'cell with low vertices'
            end

        end
        axis equal
        xlim([-xImg 2*xImg])
        ylim([0 yImg/2])
        Cx(1:3*numSeeds) = Cx(3*numSeeds+1:6*numSeeds) - xImg;
        Cx(6*numSeeds+1:9*numSeeds) = Cx(3*numSeeds+1:6*numSeeds) + xImg;
        Cy(1:3*numSeeds) = Cy(3*numSeeds+1:6*numSeeds);
        Cy(6*numSeeds+1:9*numSeeds) = Cy(3*numSeeds+1:6*numSeeds);
        matrixSeeds = [Cx,Cy];
    end

end

