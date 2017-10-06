function [ output_args ] = layerVoronoi( infoCentroids, numLayer, maxFrame )
%LAYERVORONOI Summary of this function goes here
%   Detailed explanation goes here
    pxWidth = 0.6165279;
    %pxDepth = 1.2098982;
    
%     outputDir = strcat('..\..\results\LayerAnalysis\Layer_', numLayer, '\');
%     mkdir(outputDir);

    seeds = [];
    cellIds = vertcat(infoCentroids{:, 1});
    seedsInitial = vertcat(infoCentroids{:, 2});
    seeds(:, 1) = seedsInitial(:, 1) * pxWidth;
    seeds(:, 2) = seedsInitial(:, 2) * pxWidth;
    
    widthMax=max(max(seeds(:, 1:2)));
    seeds(:, 3) = seedsInitial(:, 3) * (widthMax/maxFrame);

    seeds(:, 1) = seeds(:, 1) - min(seeds(:, 1)) + 1;
    seeds(:, 2) = seeds(:, 2) - min(seeds(:, 2)) + 1;
    seeds(:, 3) = seeds(:, 3) - min(seeds(:, 3)) + 1;

    seeds = round(seeds);

    %We put the intial seeds on the voronoi 3D image
    imgWithSegmentSeeds3D = zeros(max(seeds) + 1);
    for numCell = 1:max(cellIds)
        seedsOfCell = seeds(cellIds == numCell, :);
        xnAcum=[];
        ynAcum=[];
        znAcum=[];
        for nSeed=1:size(seedsOfCell)-1
            %get pixel coordinates of lines joining centroids
            [xn,yn,zn] = Drawline3D(seedsOfCell(nSeed,1), seedsOfCell(nSeed,2), seedsOfCell(nSeed,3),seedsOfCell(nSeed+1,1), seedsOfCell(nSeed+1,2), seedsOfCell(nSeed+1,3));
            xnAcum=[xnAcum;xn];
            ynAcum=[ynAcum;yn];
            znAcum=[znAcum;zn];
        end
        acum{numCell,1}=[xnAcum,ynAcum,znAcum];
        %conversion x, y, z to index
        indexesMatrix=cell2mat(arrayfun(@(x,y,z) sub2ind(size(imgWithSegmentSeeds3D),x,y,z),xnAcum,ynAcum,znAcum,'UniformOutput',false));
        imgWithSegmentSeeds3D(indexesMatrix) = numCell;
    
    end
    imgDist = bwdist(imgWithSegmentSeeds3D);
    
    %We create the shape in which the voronoi will be embedded
    shapeOfSeeds = alphaShape(seeds(:, 1), seeds(:, 2), seeds(:, 3), 500);
    

    img3DActual = zeros(max(seeds) + 1);
    %Remove pixels outside the cells area
    [xPx, yPx, zPx] = findND(img3DActual==0);
    validPxs = shapeOfSeeds.inShape(xPx, yPx, zPx);

    
    water3DImage=watershed(imgDist,26);
    water3DImage(validPxs==0)=0;
    


    %Create voronoi 3D region and paint it
    img3DLabelled = zeros(max(seeds) + 1);
%     colours = colorcube(max(cellIds));
%     figure;

    for numCell = 1:max(cellIds)
        numCell
        seedsOfCell = seeds(cellIds == numCell, :);
        labelToBeRelabelled=water3DImage(seedsOfCell(1,1),seedsOfCell(1,2),seedsOfCell(1,3))
        regionActual = water3DImage == labelToBeRelabelled;
        
        img3DLabelled(regionActual) = numCell;
%         [x, y, z] = findND(bwperim(img3DLabelled == numCell));
%         cellFigure = alphaShape(x, y, z, 10);
%         plot(cellFigure, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
%         hold on;

    end
save(strcat('layerAnalysisVoronoi_', date, '.mat'), 'img3DLabelled');
%     save(strcat(outputDir, 'layerAnalysisVoronoi_', date, '.mat'), 'img3DLabelled');
%     savefig(strcat(outputDir, 'layerAnalysisVoronoi_', date, '.fig'));
%     colorR = repmat(colorcube(255), 10, 1);
%     close all
%     for numZ = 1:size(img3DLabelled, 3)
%         img = double(img3DLabelled(:, :, numZ));
%         fig=figure('Visible','off');
%         imshow(img,colorR)
%         print('-f1','-dbmp',[outputDir, 'img_z_' num2str(numZ)  '.bmp']);
%         close all
%     %     imwrite(img, colorR(1:255, :), strcat('img_z_', num2str(numZ) , '.tiff'));
%     end

end

