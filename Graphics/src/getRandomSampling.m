function [ ] = getRandomSampling(nameFile, sizeSampling)
%GETRANDOMSAMPLING Summary of this function goes here
%   Detailed explanation goes here
    originalTable = readtable(nameFile);
    
    filterdByEdgeTable = originalTable(originalTable{:, 5} > 4 & originalTable{:, 12} > 4, :);
    
    foundPositions = strfind(nameFile, '_');
    writetable(filterdByEdgeTable, strcat(nameFile(1:foundPositions(end)), 'EdgeThreshold4_', nameFile(foundPositions(end)+1:end)));
    
    idsFilter = randperm(size(filterdByEdgeTable, 1), sizeSampling);
    
    foundPositions = strfind(nameFile, '_');
    writetable(filterdByEdgeTable(idsFilter, :), strcat(nameFile(1:foundPositions(end)), 'EdgeThreshold4_100Sampling_', nameFile(foundPositions(end)+1:end)));

end

