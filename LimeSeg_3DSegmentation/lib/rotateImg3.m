function [rotatedImg3d, originalRotation] = rotateImg3(img3d, resizeImg, definedRotation)

    img3d_reduced=imresize3(img3d,resizeImg,'nearest');
    orientationObj = regionprops3(img3d_reduced>0, 'Orientation');
    originalRotation(1) = orientationObj.Orientation(1);
    if exist('predefinedRotation', 'var') == 0
        img3d_rot1 = imrotate(img3d, - orientationObj.Orientation(1));
    else
        img3d_rot1 = imrotate(img3d, - definedRotation(1));
    end
    

    xzyImg = permute(img3d_rot1,[1 3 2]);
    orientationObj = regionprops3(imresize3(xzyImg,resizeImg,'nearest')>0, 'Orientation');
    originalRotation(2) = orientationObj.Orientation(1);
    if exist('predefinedRotation', 'var') == 0
        xzyImg3d_rot = imrotate(xzyImg, - orientationObj.Orientation(1));
    else
        xzyImg3d_rot = imrotate(xzyImg, - definedRotation(2));
    end

    yzxImg3d_rot = permute(xzyImg3d_rot,[3 2 1]);
    orientationObj = regionprops3(imresize3(yzxImg3d_rot,resizeImg,'nearest')>0, 'Orientation');
    originalRotation(3) = orientationObj.Orientation(1);

    
    if exist('predefinedRotation', 'var') == 0
        img3d_rotFinal = imrotate(yzxImg3d_rot, - orientationObj.Orientation(1));
    else
        img3d_rotFinal = imrotate(yzxImg3d_rot, - definedRotation(3));
    end
    img3d_rot = permute(img3d_rotFinal,[3 2 1]);
    
    [xCol, yRow, z] = ind2sub(size(img3d_rot),find(img3d_rot>0));
    if min(xCol) <= 0 || min(yRow) <= 0 || min(z) <= 0

        if min(xCol) <= 0 
            xCol = xCol + abs(min(xCol)) + 1;
        end

        if min(yRow) <= 0
            yRow = yRow + abs(min(yRow)) + 1;
        end

        if min(z) <= 0
            z = z + abs(min(z)) +1;
        end
        rotatedImg3d = zeros(max(xCol),max(yRow),max(z));
        rotatedImg3d( sub2ind(size(rotatedImg3d),xCol,yRow,z) ) = img3d_rot( img3d_rot > 0 );
    else
        rotatedImg3d = img3d_rot;
    end
    
end