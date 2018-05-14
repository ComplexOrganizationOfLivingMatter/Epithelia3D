function deleteFrame( pathArchMat, frameToDelete, folderNumber )

%DELETEFRAME Eliminates centroids that have as frame the same one that is taken as input parameter.
%
% Input/output specs
% ------------------
% pathArchMat:  'E:\Tina\Epithelia3D\Zebrafish\Code\LayersCentroids5.mat';
% frameToDelete: 75;
% folderNumber: 5;

load(pathArchMat);

LayerCentroid=cellfun(@(x) x(x(:,1)~=frameToDelete,:),LayerCentroid,'UniformOutput', false);
%LayerPixel=cellfun(@(x) x(x(:,1)~=frameToDelete,:),LayerPixel,'UniformOutput', false);

centroids{frameToDelete,1}={};
pixel{frameToDelete,1}={};

finalFileName=['LayersCentroids' sprintf('%d',folderNumber) '.mat'];
save(finalFileName, 'LayerCentroid', 'centroids', 'pixel', 'newLayer');

end

