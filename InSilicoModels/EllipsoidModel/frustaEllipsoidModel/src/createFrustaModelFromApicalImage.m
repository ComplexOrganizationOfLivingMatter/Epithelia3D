function [ ] = createFrustaModelFromApicalImage(inputFile )
%CREATEFRUSTAMODELFROMAPICALIMAGE Summary of this function goes here
%   Detailed explanation goes here
    
    outputFile = strrep(inputFile, '..\voronoiEllipsoidModel\', '');
    outputFileSplitted = strsplit(outputFile, '\');
    outputFileDirectory = strjoin(outputFileSplitted(1:end-1), '\');
    mkdir(outputFileDirectory)
    
    outputNameFile=dir([outputFileDirectory '\frusta*']);
        
    load(inputFile);

    disp('Getting vertices 3D');
    %Get vertices info on the apical layer
    
    if isfield(initialEllipsoid, 'neighbourhood')
        [initialEllipsoid] = calculate_neighbours3D(initialEllipsoid.img3DLayer, initialEllipsoid);
    end
    
    initialEllipsoid = getVertices3D( initialEllipsoid.img3DLayer, initialEllipsoid.neighbourhood, initialEllipsoid );

    
    initialEllipsoid.resolutionFactor = ellipsoidInfo.resolutionFactor;
    initialEllipsoid.resolutionEllipse = 500;

    disp('Getting outter layer vertices');
    %New vertices on basal
    [ finalVerticesAugmented ] = getAugmentedCentroids( initialEllipsoid, vertcat(initialEllipsoid.verticesPerCell{:}), ellipsoidInfo.cellHeight);

       
    if isempty(outputNameFile.name)
        
        allFrustaImage = initialEllipsoid.img3DLayer;
        
        %     colours = colorcube(size(initialEllipsoid.centroids, 1));
        %     outputFigure = figure;
        
        % Now we have to get the actual pixels from the faces of the cells
        for numCell = 1:size(initialEllipsoid.centroids, 1)
            %disp(['NumCell: ' num2str(numCell)]);
            indicesVerticesOfActualCell = any(ismember(initialEllipsoid.verticesConnectCells, numCell), 2);
            
            verticesOfActualCell = round(finalVerticesAugmented(indicesVerticesOfActualCell, :));
            
            %Get the faces of the cell
            KVert = convhulln(verticesOfActualCell);
            
            %Create the appropiate structure for voselise function
            cellStructure.faces = KVert;
            cellStructure.vertices = verticesOfActualCell;
            
            %Get the pixels of the cell
            [outputGrid, gridCOx, gridCOy, gridCOz] = VOXELISE(max(verticesOfActualCell(:, 1)), max(verticesOfActualCell(:, 2)), max(verticesOfActualCell(:, 3)), cellStructure);
            
            gridCOx = round(gridCOx);
            gridCOy = round(gridCOy);
            gridCOz = round(gridCOz);
            
            [x, y, z] = findND(outputGrid == 1);
            realPixels = round(vertcat(gridCOx(x), gridCOy(y), gridCOz(z)))';
            for numPixel = 1:size(realPixels, 1)
                allFrustaImage(realPixels(numPixel, 1), realPixels(numPixel, 2), realPixels(numPixel, 3)) = numCell;
            end
            
            %Paint the cell to check if everything fits
            %         cellFigure = alphaShape(realPixels(:, 1), realPixels(:, 2), realPixels(:, 3), 500);
            %         plot(cellFigure, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
            %         hold on;
        end
        
        %Save necessary info
        
        %savefig(strcat(outputFileDirectory, '\frustaEllipsoidModel_OutterLayer_', date, '.fig'));
        
        save(strcat(outputFileDirectory, '\frustaEllipsoidModel_', date, '.mat'), 'allFrustaImage', '-v7.3');
        
        %close outputFigure
        
        
    end
    
    verticesPerCellInitial=initialEllipsoid.verticesPerCell;
    verticesConnectCellsInitial=initialEllipsoid.verticesConnectCells;
    neighsInitial=initialEllipsoid.neighbourhood;
    
    save(strcat(outputFileDirectory, '\', outputNameFile(1).name),'neighsInitial','verticesPerCellInitial','verticesConnectCellsInitial','finalVerticesAugmented', '-append');
     

end

