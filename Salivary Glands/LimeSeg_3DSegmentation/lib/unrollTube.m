function [] = unrollTube(img3d)
%UNROLLTUBE Summary of this function goes here
%   Detailed explanation goes here

    %% Rotate the gland
    
    [Y, X, Z] = ndgrid(1:size(img3d,1), 1:size(img3d,2), 1:size(img3d,3));
    XYZ0 = [X(:), Y(:), Z(:), zeros(numel(X),1)];
    
    imgProperties = regionprops3(img3d>0, {'Orientation', 'PrincipalAxisLength'});
    angleRotation = deg2rad(-cat(2,imgProperties.Orientation));

    M = makehgtform('zrotate', angleRotation(1)); %X axis
    
    newXYZ0 = XYZ0 * M;
    nX = round(reshape(newXYZ0(:,1), size(X)));
    nY = round(reshape(newXYZ0(:,2), size(Y)));
    nZ = round(reshape(newXYZ0(:,3), size(Z)));

    %paint3D(img3dRotated)
%     figure; pcshow([X(img3d(:)>0), Y(img3d(:)>0), Z(img3d(:)>0)])
    figure; pcshow([nX(img3d(:)>0), nY(img3d(:)>0), nZ(img3d(:)>0)])
    
    img3DRotated = zeros(max(nX(:)), max(nY(:)), max(nZ(:)));
    
    labelIndices = sub2ind(size(img3DRotated), nX(img3d(:)>0), nY(img3d(:)>0), nZ(img3d(:)>0));
    
    img3DRotated(labelIndices) = img3d(img3d(:)>0);
    

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

