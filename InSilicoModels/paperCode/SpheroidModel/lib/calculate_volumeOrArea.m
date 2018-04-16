function [ volumeOfCells ] = calculate_volumeOrArea( img3D )
%CALCULATE_VOLUMEORAREA If 3D returns volumen, otherwise returns area
%   Detailed explanation goes here
%

    cellIds = unique(img3D);
    cellIds(cellIds==0) = [];
    
    volumeOfCells = zeros(size(cellIds));
    for numCell = 1:size(cellIds, 1)
        actualId = cellIds(numCell);
        volumeOfCells(numCell) = sum(sum(sum(img3D == actualId)));
    end
end

