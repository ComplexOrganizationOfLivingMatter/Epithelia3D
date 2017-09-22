function [ indicesOfEdges ] = getEdgesOfCell(imgWithDistances, seedX, seedY, seedZ )
%getEdgesOfCell Summary of this function goes here
%   Detailed explanation goes here
    indicesOfEdges = [];
    
    for pxX = seedX-1:seedX+1
        for pxY = seedY-1:seedY+1
            for pxZ = seedZ-1:seedZ+1
                voxels(end+1, :) = [pxX, pxY, pxZ];
            end
        end
    end

end

