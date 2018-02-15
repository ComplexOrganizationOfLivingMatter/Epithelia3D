function [ output_args ] = layerVoronoi( infoCentroids, numLayer, maxFrame )
%LAYERVORONOI Summary of this function goes here
%   Detailed explanation goes here


    pxWidth = 0.6165279; % Pixel converter
    
    %Creating an output directory
    outputDir = strcat('..\..\results\LayerAnalysis\Layer_', numLayer, '\'); 
    mkdir(outputDir);

    
    seeds = []; %Create a variable for the seeds empty
    cellIds = vertcat(infoCentroids{:, 1}); %Variable with only the tracking ID of all the cells
    seedsInitial = vertcat(infoCentroids{:, 2}); %Variable with the tracking coordinates of all the cells
    
    seeds(:, 1) = seedsInitial(:, 1) * pxWidth; %Fill the first column of the seed variable with the X components of the coordinates multiplied by the pixel conversion factor
    seeds(:, 2) = seedsInitial(:, 2) * pxWidth; %The same as before but for the Y coordinate
    widthMax=max(max(seeds(:, 1:2))); %We look at the maximum number of coordinates changed to pixels
    seeds(:, 3) = seedsInitial(:, 3) * ((widthMax/maxFrame)/2); %With this, we modify the height correspondingly

    %The minimum is calculated for the 3 coordinates and subtracted from everything and added 1, which means that the minimums are squared to 1. It is seen in the results that all values 1 are from frame 6.
    seeds(:, 1) = seeds(:, 1) - min(seeds(:, 1)) + 1;
    seeds(:, 2) = seeds(:, 2) - min(seeds(:, 2)) + 1;
    seeds(:, 3) = seeds(:, 3) - min(seeds(:, 3)) + 1;

    seeds = round(seeds); %The numbers are rounded up as pixels are what we are going to try

    %We put the intial seeds on the voronoi 3D image
    imgWithSegmentSeeds3D = zeros(max(seeds) + 1); %Matrix of zeros with the dimension of the seeds (coordinates) plus one
    for numCell = 1:max(cellIds) %The maximum of the variable with the tracking of IDs is the total number of cells that there is 
        seedsOfCell = seeds(cellIds == numCell, :);% Look for all the coordinates associated with an ID and store it in a new variable. What you get is the traking of each cell.
        
        %Create three empty variables that will accumulate the coordinates                                              
        xnAcum=[];
        ynAcum=[];
        znAcum=[];
        for nSeed=1:size(seedsOfCell)-1 %Less one for the structure of the Drawline3D function that needs the current and the next
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
    
    % Loop to know which cells overlap
    num=1;
    for numAcum=1:size(acum,1)
        numAcum
           for numAcum2=(numAcum+1):size(acum,1) 
                if any(ismember(acum{numAcum,1} ,acum{numAcum2,1}, 'rows'))==1
                    idCellsRepeat{num,1}=[numAcum, numAcum2];
                    num=num+1;
                end
           end
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
    colours = colorcube(max(cellIds));
    figure;

    for numCell=1:max(cellIds)
        
            numCell
            seedsOfCell = seeds(cellIds == numCell, :);
            labelToBeRelabelled=water3DImage(seedsOfCell(1,1),seedsOfCell(1,2),seedsOfCell(1,3));
            regionActual = water3DImage == labelToBeRelabelled;
            
            img3DLabelled(regionActual) = numCell;
            [x, y, z] = findND(bwperim(img3DLabelled == numCell));
            cellFigure = alphaShape(x, y, z, 10);
            plot(cellFigure, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
            hold on;
        
    end
    
    save(strcat('layerAnalysisVoronoi_', date, '.mat'), 'img3DLabelled');
    save(strcat(outputDir, 'layerAnalysisVoronoi_', date, '.mat'), 'img3DLabelled');
    savefig(strcat(outputDir, 'layerAnalysisVoronoi_', date, '.fig'));
    colorR = repmat(colorcube(255), 10, 1);
    close all
    
    for numZ = 1:size(img3DLabelled, 3)
        
        img = double(img3DLabelled(:, :, numZ));
        se=strel('disk',3);
        mask=imdilate(img, se);
        mask=imerode(mask,se);
        imgTreatment= watershed(1-img, 8);
        imgTreatment(mask==0)=0;
        cent=regionprops(imgTreatment, 'Centroid');
        centroids=vertcat(cent.Centroid);
        maskImg=zeros(size(imgTreatment));
        
        for numCent=1:size(centroids)
            if isnan(centroids(numCent,1)) == 0
                maskImg(imgTreatment == imgTreatment(round(centroids(numCent,2)), round(centroids(numCent,1)))) = img(round(centroids(numCent,2)), round(centroids(numCent,1)));      
            end
        end
       
        Img{numZ} = maskImg;
        
        fig=figure('Visible','off');
        imshow(Img{numZ},colorR)
        print('-f1','-dbmp',[outputDir, 'img_z_' num2str(numZ)  '.bmp']);
        close all
    %     imwrite(img, colorR(1:255, :), strcat('img_z_', num2str(numZ) , '.tiff'));
    end
    save(strcat('imgVoronoi2D_', date, '.mat'), 'Img');
end

