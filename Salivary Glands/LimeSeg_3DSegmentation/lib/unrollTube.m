function [] = unrollTube(img3d)
%UNROLLTUBE Summary of this function goes here
%   Detailed explanation goes here

    %% Rotate the gland
    
    
    %% Unroll
    imgFinalCoordinates=cell(size(img3d,3),1);
    centroids=centers{nImg};

    %         centroidX=mean(cellfun(@(x) x(3),centroids));
    %         centroidY=mean(cellfun(@(x) x(1),centroids));

    for coordZ = 1 : size(img3d,3)
        centroidCoordZ = centroids{rangeY(1)-1+coordZ};
        centroidX = centroidCoordZ(3);
        centroidY = centroidCoordZ(1);

        %% Create perimeter mask
        mask=false(size(img3d(:,:,1)));
        mask(img3d(:,:,coordZ)>0)=1;
        [x,y]=find(mask);

        zPerimMask = imread(['data\' name '\maskLayers\' setLayerNames{nImg} '\' num2str(rangeY(1)-1+coordZ) '.bmp']);
        zPerimMask=bwperim(zPerimMask);
        [xPerim,yPerim]=find(zPerimMask);

        %angles coord perim regarding centroid
        anglePerimCoord = atan2(yPerim - centroidY, xPerim - centroidX);
        %find the sorted order
        [anglePerimCoordSort,~] = sort(anglePerimCoord);

        %% labelled mask
        maskLabel=img3d(:,:,coordZ);
        %angles label coord regarding centroid
        angleLabelCoord = atan2(y - centroidY, x - centroidX);

        %% Assing label to pixels of perimeters
        %If a perimeter coordinate have no label pixels in a range of pi/45 radians, it label is 0
        orderedLabels = zeros(1,length(anglePerimCoordSort));
        for nCoord = 1:length(anglePerimCoordSort)
            [M,ind]=min(abs(angleLabelCoord - anglePerimCoordSort(nCoord)));
            if M < pi/135
                orderedLabels(nCoord)=maskLabel(x(ind(1)),y(ind(1)));
            else
                orderedLabels(nCoord)=0;
            end
        end

        imgFinalCoordinates{coordZ} = orderedLabels;

    end

    %% Reconstruct deployed img
    ySize=max(cellfun(@length, imgFinalCoordinates));
    deployedImg = zeros(size(img3d,3),ySize);

    for coordZ = 1 : size(img3d,3)
        rowOfCoord = imgFinalCoordinates{coordZ};
        deployedImg(coordZ,1:length(rowOfCoord)) = rowOfCoord;
    end

    %        figure;imshow(deployedImg,c(orderRand,:))
    totalImages{nImg} = deployedImg;
end

