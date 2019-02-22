function [samiraTableVoronoi] = createSamiraFormatExcel_delaunaySimulations(pathFile,surfaceRatios,hInit,wInit)

        
    addpath(genpath('lib'))
    pathSplitted = strsplit(pathFile, '\');
    nameOfSimulation = pathSplitted{end-1};

    %% Simulations
    load(strcat(pathFile, nameOfSimulation,'.mat'), 'listSeedsProjected');
    
    initialSeeds = listSeedsProjected{vertcat(listSeedsProjected{:,1})==1,2};
    initialSeeds = initialSeeds(:,2:3);
    
    
    nameSplitted = strsplit(nameOfSimulation, '_');
    samiraTableVoronoi = {};
    dir2save = strcat(strjoin(pathSplitted(1:end-2), '\'),'\verticesSamira\');
    if ~exist(dir2save,'dir')
        mkdir(dir2save)
    end
    for nSurfR = surfaceRatios
               
        %change seeds and dimensions using the surface ratio
        srSeeds = initialSeeds;
        srSeeds(:,2) = srSeeds(:,2)*nSurfR;
        wSR = wInit*nSurfR;

        nSeeds = size(srSeeds,1);
        
        %Triplet the number of seeds
        tripletSeeds = [srSeeds;srSeeds(:,1), srSeeds(:,2)+wSR;srSeeds(:,1), srSeeds(:,2)+2*wSR];

        %% delaunay triangulation
        DT = delaunayTriangulation(tripletSeeds);
        %triplets of neighbours cells
        triOfInterest = DT.ConnectivityList;
        %get vertices position using the triangle circumcenter
        verticesTRI = DT.circumcenter; 
        
        %delete vertices out of the image region 2 avoid repeatition in
        %border cells
        indVertOut = verticesTRI(:,2)>2*wSR | verticesTRI(:,2)<=wSR;
        verticesTRI(indVertOut,:) = [];
        triOfInterest(indVertOut,:) = [];   
        
        %delete triangulations and vertices out of limits
        vertIn = [verticesTRI(:,1) <= hInit] & [verticesTRI(:,1) > 0];
       
        noValidCells = unique(triOfInterest(~vertIn,:));
        noValidCells(noValidCells>nSeeds) = noValidCells(noValidCells>nSeeds) -nSeeds;
        noValidCells(noValidCells>nSeeds) = noValidCells(noValidCells>nSeeds) -nSeeds;
        noValidCells = unique([noValidCells;noValidCells+nSeeds;noValidCells+2*nSeeds]);
       
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
        
        %relocate seeds close to the origin
        verticesTRI(:,2) = verticesTRI(:,2) - wSR;
        
        %relabel triangulations (border cells)
        triOfInterestRelabel = triOfInterest;
        triOfInterestRelabel(triOfInterestRelabel>nSeeds) = triOfInterestRelabel(triOfInterestRelabel>nSeeds) - nSeeds;
        triOfInterestRelabel(triOfInterestRelabel>nSeeds) = triOfInterestRelabel(triOfInterestRelabel>nSeeds) - nSeeds;
        
        %storing bulk vertices
        verticesInfo.verticesPerCell = verticesTRI;
        verticesInfo.verticesConnectCells = triOfInterestRelabel;
        
        %calculate no valid cells vertices
        verticesNoValidCellsInfo = getVerticesNoValidCellsDelaunay(pairNoValidCells,tripletSeeds,nSeeds,0,hInit,wSR);
        
        %Grouping cells
        cellWithVertices = groupingVerticesPerCellSurface(verticesInfo, verticesNoValidCellsInfo, [], 1, [],nSeeds,wSR);
        missingVertices = [];
        
        [samiraTableVoronoiActualSR, cellsVoronoi] = tableWithSamiraFormat(cellWithVertices, srSeeds, missingVertices, nSurfR, pathSplitted, nameOfSimulation);
        samiraTableVoronoi = [samiraTableVoronoi; samiraTableVoronoiActualSR];

        
        %save vertices simulations
        %Create frusta table 
        if nSurfR == 1
            samiraTableFrusta = samiraTableVoronoi(:,1:4);
            verticesSR1=samiraTableVoronoi(:,5);
            samiraTableFrustaSR = samiraTableVoronoi;
            samiraTableFrusta_SRColumn = cellfun(@(x) x*nSurfR,samiraTableFrusta(:,1),'UniformOutput',false);

        else
            samiraTableFrusta_SRColumn = cellfun(@(x) x*nSurfR,samiraTableFrusta(:,1),'UniformOutput',false);
            verticesSR_frusta = cellfun(@(x) [x(1:2:length(x)-1);x(2:2:length(x))*nSurfR],verticesSR1,'UniformOutput',false);
            verticesSR_frusta = cellfun(@(x) x(:)',verticesSR_frusta,'UniformOutput',false);
            cellsFrusta = [samiraTableFrusta_SRColumn,samiraTableFrusta(:,2:4),verticesSR_frusta];
            samiraTableFrustaSR =  [samiraTableFrustaSR;cellsFrusta];
            
            %Plot frusta
            plotVerticesPerSurfaceRatio(cellsFrusta,[],dir2save,nameSplitted,'Frusta',nSurfR)

        end

    end
    
    samiraTableVoronoiT = cell2table(samiraTableVoronoi, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});
    samiraTableFrustaT = cell2table(samiraTableFrustaSR, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});

    writetable(samiraTableVoronoiT, strcat(dir2save, '\Voronoi_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));
    writetable(samiraTableFrustaT, strcat(dir2save, '\Frusta_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));


    
end

