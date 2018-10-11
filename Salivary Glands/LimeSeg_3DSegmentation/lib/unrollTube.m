function [] = unrollTube(img3d)
%UNROLLTUBE Summary of this function goes here
%   Detailed explanation goes here

    %% Rotate the gland
    imgProperties = regionprops3(img3d>0, {'Orientation', 'BoundingBox'});
%     img3dCropped = imcrop(img3d, imgProperties.BoundingBox);

    
    
    
    imgProperties = regionprops3(img3dOrigin>0, {'Orientation', 'Centroid'});
    
    
    imgProperties = regionprops3(img3d>0, {'Orientation', 'PrincipalAxisLength'})
    
    
%     %img3dRotated = imrotate3(img3d, 90, [1 0 0],'nearest','loose','FillValues',0);
%     rotationMatrix = rotz(angleRotation(3))*roty(angleRotation(2))*rotx(angleRotation(1));
%     rotationMatrix(:, 4) = 0;
%     rotationMatrix(4, :) = 0;
%     rotationMatrix(4, 4) = 1;
        angleRotation = deg2rad(90-cat(2,imgProperties.Orientation));
%     bbox = round(imgProperties.BoundingBox);
%     M = makehgtform('xrotate', angleRotation(1));
%     M = makehgtform('yrotate', angleRotation(1));
    rotationMatrix = makehgtform('zrotate', angleRotation(1)); %X axis
    img3dRotated = imwarp(img3d, affine3d(rotationMatrix));
    
    imgProperties = regionprops3(img3dRotated>0, {'Orientation', 'PrincipalAxisLength'})
%     
    img3dRotated = img3d;
    
    
    for numCoord = 1:3
        angleRotation = regionprops3(img3dRotated>0, {'Orientation', 'PrincipalAxisLength'});
        
        angleRotation = cat(2,angleRotation.Orientation);
        img3dRotated = img3dRotated';
        angleRotation = regionprops3(img3dRotated>0, {'Orientation', 'PrincipalAxisLength'});

        angleSelected = [0 0 0];
        angleSelected(numCoord) = 1;
        img3dRotated = imrotate3(img3dRotated, angleRotation(numCoord), angleSelected,'nearest','loose','FillValues',0);
        imgProperties = regionprops3(img3dRotated>0, {'Orientation', 'PrincipalAxisLength'});

    end
    
    imgProperties = regionprops3(img3dRotated>0, {'Orientation', 'PrincipalAxisLength'});
    
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

