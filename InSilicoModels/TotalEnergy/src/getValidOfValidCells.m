function [ uniqueValidCells, modelFrusta, modelVoronoi, frustaPolDist, voronoiPolDist ] = getValidOfValidCells( modelFrusta, modelVoronoi, surfaceRatio )
%GETVALIDOFVALIDCELLS Summary of this function goes here
%   Detailed explanation goes here
    
    maxRandoms = 20;
    uniqueValidCells = cell(maxRandoms, 1);
    frustaPolDist = zeros(maxRandoms, 5);
    voronoiPolDist = zeros(maxRandoms, 5);
    for nRandom = 1:maxRandoms
        load(strcat('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\voronoiModel\expansion\512x4096_200seeds\Image_', num2str(nRandom), '_Diagram_5\Image_', num2str(nRandom),'_Diagram_5.mat'));
        
        %Neighbours in frusta are the same as in apical
        frustaLayer = listLOriginalProjection(listLOriginalProjection.surfaceRatio == 1, :).L_originalProjection{1};
        [neighbours_cellsFrusta, sides_cellsFrusta] = calculateNeighbours(frustaLayer);

        voronoiLayer = listLOriginalProjection(round(listLOriginalProjection.surfaceRatio, 2) == round(surfaceRatio, 2), :).L_originalProjection{1};
        [neighbours_cellsVoronoi, sides_cellsVoronoi] = calculateNeighbours(voronoiLayer);

        motifsFrusta = table2array(modelFrusta(modelFrusta.nRand == nRandom, 1:4));
        uniqueCellsModelFrusta = unique(motifsFrusta(:));
        
        motifsVoronoi = table2array(modelVoronoi(modelVoronoi.nRand == nRandom, 1:4));
        uniqueCellsModelVoronoi = unique(motifsVoronoi(:));
        
        %allNeighboursCell = cellfun(@(x, y) unique([x; y]), neighs_realFrusta, neighs_realFVoronoi, 'UniformOutput', false);
        
        oldValidCells = intersect(uniqueCellsModelVoronoi, uniqueCellsModelFrusta);
        
        
        voronoiNoValidCells = union(unique(voronoiLayer(1:5, :)), unique(voronoiLayer(end-5:end, :)));
        frustaNoValidCells = union(unique(frustaLayer(1:5, :)), unique(frustaLayer(end-5:end, :)));
        
        noValidCells = union(unique(vertcat(neighbours_cellsVoronoi{voronoiNoValidCells(2:end)})), unique(vertcat(neighbours_cellsFrusta{frustaNoValidCells(2:end)})));
        
        validCells = ismember(1:200, noValidCells) == 0;
%         validCells = zeros(size(oldValidCells, 1), 1);
%         for numCell = 1:length(oldValidCells)
%             oldValidCell = oldValidCells(numCell);
%             %Is a valid cell if it has 5 motifs touching its sides of cells
%             %and another 5 starting at its vertices
%             validCellFrusta = isequal(sum(any(ismember(motifsFrusta, oldValidCell), 2)), sides_cellsFrusta(oldValidCell)*2);
%             
%             validCellVoronoi = isequal(sum(any(ismember(motifsVoronoi, oldValidCell), 2)), sides_cellsVoronoi(oldValidCell)*2);
%             
%             if validCellFrusta && validCellVoronoi
%                 validCells(numCell) = 1;
%             end
%         end
        
        uniqueValidCells{nRandom} = setdiff(1:200, noValidCells);
        
        sides_cellsFrusta = sides_cellsFrusta(logical(validCells));
        sides_cellsVoronoi = sides_cellsVoronoi(logical(validCells));
        
        frustaPolDist(nRandom, :) = vertcat(sum(sides_cellsFrusta == 4), sum(sides_cellsFrusta == 5), sum(sides_cellsFrusta == 6), sum(sides_cellsFrusta == 7), sum(sides_cellsFrusta == 8)) / length(sides_cellsFrusta);
        voronoiPolDist(nRandom, :) = vertcat(sum(sides_cellsVoronoi == 4), sum(sides_cellsVoronoi == 5), sum(sides_cellsVoronoi == 6), sum(sides_cellsVoronoi == 7), sum(sides_cellsVoronoi == 8)) / length(sides_cellsVoronoi);
        
        motifsVoronoiIndices = find(modelVoronoi.nRand == nRandom);
        removingMotifs = any(ismember(motifsVoronoi, uniqueValidCells{nRandom}), 2) == 0;
%         %
%         l_original = listLOriginalProjection(listLOriginalProjection.surfaceRatio == surfaceRatio, :).L_originalProjection{1};
%         figure;
%         imshow(ismember(l_original, unique(motifsVoronoi(removingMotifs, :))))
%         figure;
%         imshow(ismember(l_original, uniqueValidCells{nRandom}))
%         %
        modelVoronoi(motifsVoronoiIndices(removingMotifs), :) = [];
        motifsFrustaIndices = find(modelFrusta.nRand == nRandom);
        removingMotifs = any(ismember(motifsFrusta, uniqueValidCells{nRandom}), 2) == 0;
%         %
%         l_original = listLOriginalProjection(listLOriginalProjection.surfaceRatio == 1, :).L_originalProjection{1};
%         figure;
%         imshow(ismember(l_original, unique(motifsFrusta(removingMotifs, :))))
%         figure;
%         imshow(ismember(l_original, uniqueValidCells{nRandom}))
%         %
        modelFrusta(motifsFrustaIndices(removingMotifs), :) = [];
        
    end
    

end

