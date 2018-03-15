function [ ] = countUniqueCellsInMotif( modelMotifs )
%COUNTUNIQUECELLSINMOTIF Summary of this function goes here
%   Detailed explanation goes here
size(modelMotifs, 1)
maxRandoms = 20;

for nRandom = 1:maxRandoms
    motifs = table2array(modelMotifs(modelMotifs.nRand == nRandom, 1:4));
    uniqueCellsModel{nRandom} = unique(motifs(:));
end
length(vertcat(uniqueCellsModel{:}))

end

