function [samiraTableVoronoi] = createSamiraFormatExcel(pathFile, surfaceRatios)
%CREATESAMIRAFORMATEXCEL Summary of this function goes here
%   Detailed explanation goes here
%
%   Example: createSamiraFormatExcel('..\data\tubularVoronoiModel\expansion\2048x4096_200seeds\Image_2_Diagram_5\', 1.6667)
    addpath(genpath('lib'))
    

    pathSplitted = strsplit(pathFile, '\');
    nameOfSimulation = pathSplitted{end-1};
    
    %% Simulations
    load(strcat(pathFile, nameOfSimulation,'.mat'), 'listLOriginalProjection');
    
    nameSplitted = strsplit(nameOfSimulation, '_');
    samiraTableVoronoi = {};
    dir2save = strcat(strjoin(pathSplitted(1:end-2), '\'),'\verticesSamira\');
    if ~exist(dir2save,'dir')
        mkdir(dir2save)
    end
    for nSurfR = [1 surfaceRatios]
        
        L_img = listLOriginalProjection{round([listLOriginalProjection{:,1}],3)==round(nSurfR,3),2};
        
        %We use L_img a little bit extended for get lateral border
        %vertices.
        extendedImage = [L_img(:,end-1:end),L_img,L_img(:,1:2)];
        [neighbours, ~] = calculateNeighbours(extendedImage);
        [ verticesInfo ] = calculateVertices(extendedImage, neighbours);
        [ verticesNoValidCellsInfo ] = getVerticesBorderNoValidCells( extendedImage);
        
        [samiraTableVoronoi, cellsVoronoi] = tableWithSamiraFormat(verticesInfo, verticesNoValidCellsInfo, extendedImage, L_img)
        
        %Plot and save vertices simulations
        plotVerticesPerSurfaceRatio(samiraTableVoronoi((end-numCell+1):end,:),missingVerticesCoord,dir2save,nameSplitted,'Voronoi',nSurfR)
        
        %Create frusta table 
        if nSurfR == 1
            samiraTableFrusta = samiraTableVoronoi(:,1:4);
            verticesSR1=samiraTableVoronoi(:,5);
            samiraTableFrustaSR = samiraTableVoronoi;
            samiraTableFrusta_SRColumn = cellfun(@(x) x*nSurfR,samiraTableFrusta(:,1),'UniformOutput',false);

        else
            samiraTableFrusta_SRColumn = cellfun(@(x) x*nSurfR,samiraTableFrusta(:,1),'UniformOutput',false);
            verticesSR_frusta = cellfun(@(x) round([x(1:2:length(x)-1);x(2:2:length(x))*nSurfR]),verticesSR1,'UniformOutput',false);
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
