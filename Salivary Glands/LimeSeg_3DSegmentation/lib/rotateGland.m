function [img3DRotated] = rotateGland(img3d, angleRotation, predefinedSize)
%ROTATEGLAND Summary of this function goes here
%   Detailed explanation goes here
    [Y, X, Z] = ndgrid(1:size(img3d,1), 1:size(img3d,2), 1:size(img3d,3));
    XYZ0 = [X(:), Y(:), Z(:), zeros(numel(X),1)];
    
    M = makehgtform('zrotate', angleRotation); %X axis
    
    newXYZ0 = XYZ0 * M;
    nX = round(reshape(newXYZ0(:,1), size(X)));
    nY = round(reshape(newXYZ0(:,2), size(Y)));
    nZ = round(reshape(newXYZ0(:,3), size(Z)));

%     figure; pcshow([X(img3d(:)>0), Y(img3d(:)>0), Z(img3d(:)>0)])
%     figure; pcshow([nX(img3d(:)>0), nY(img3d(:)>0), nZ(img3d(:)>0)])
    if ~isempty ( nY < 0) 
       nY = abs(min(nY(:))) + 1 + nY; 
    end
    
    if ~isempty ( nX < 0) 
       nX = abs(min(nX(:))) + 1 + nX; 
    end
    
    if exist('predefinedSize', 'var') == 0
        img3DRotated = zeros(max(nX(:)), max(nY(:)), max(nZ(:)));
    else
        img3DRotated = zeros(predefinedSize);
    end
    
    labelIndices = sub2ind(size(img3DRotated), nX(img3d(:)>0), nY(img3d(:)>0), nZ(img3d(:)>0));
    
    img3DRotated(labelIndices) = img3d(img3d(:)>0);
end

