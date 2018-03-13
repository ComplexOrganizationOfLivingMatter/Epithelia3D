function [ uniqueValidCells, modelFrusta, modelVoronoi ] = getValidOfValidCells( modelFrusta, modelVoronoi, surfaceRatio )
%GETVALIDOFVALIDCELLS Summary of this function goes here
%   Detailed explanation goes here
    
    maxRandoms = 20;
    uniqueValidCells = cell(maxRandoms);
    for nRandom = 1:maxRandoms
        load(strcat('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\voronoiModel\expansion\512x1024_200seeds\Image_', num2str(nRandom), '_Diagram_5\Image_', num2str(nRandom),'_Diagram_5.mat'));
        
        %Neighbours in frusta are the same as in apical
        [~, sides_cellsFrusta] = calculateNeighbours(listLOriginalProjection(listLOriginalProjection.surfaceRatio == 1, :).L_originalProjection{1});

        [~, sides_cellsVoronoi] = calculateNeighbours(listLOriginalProjection(listLOriginalProjection.surfaceRatio == surfaceRatio, :).L_originalProjection{1});

        motifsFrusta = table2array(modelFrusta(modelFrusta.nRand == nRandom, 1:4));
        uniqueCellsModelFrusta = unique(motifsFrusta(:));
        
        motifsVoronoi = table2array(modelVoronoi(modelVoronoi.nRand == nRandom, 1:4));
        uniqueCellsModelVoronoi = unique(motifsVoronoi(:));
        
        %allNeighboursCell = cellfun(@(x, y) unique([x; y]), neighs_realFrusta, neighs_realFVoronoi, 'UniformOutput', false);
        
        oldValidCells = intersect(uniqueCellsModelVoronoi, uniqueCellsModelFrusta);
        
        validCells = zeros(size(oldValidCells, 1), 1);
        
        for numCell = 1:length(oldValidCells)
            oldValidCell = oldValidCells(numCell);
            %Is a valid cell if it has 5 motifs touching its sides of cells
            %and another 5 starting at its vertices
            validCellFrusta = isequal(sum(any(ismember(motifsFrusta, oldValidCell), 2)), sides_cellsFrusta(oldValidCell)*2);
            
            validCellVoronoi = isequal(sum(any(ismember(motifsVoronoi, oldValidCell), 2)), sides_cellsVoronoi(oldValidCell)*2);
            
            if validCellFrusta && validCellVoronoi
                validCells(numCell) = 1;
            end
        end
        
        uniqueValidCells{nRandom} = oldValidCells(logical(validCells));
        motifsVoronoiIndices = find(modelVoronoi.nRand == nRandom);
        modelVoronoi(motifsVoronoiIndices(all(ismember(motifsVoronoi, uniqueValidCells{nRandom}), 2) == 0), :) = [];
        motifsFrustaIndices = find(modelFrusta.nRand == nRandom);
        modelFrusta(motifsFrustaIndices(all(ismember(motifsFrusta, uniqueValidCells{nRandom}), 2) == 0), :) = [];
        
    end
    

end

