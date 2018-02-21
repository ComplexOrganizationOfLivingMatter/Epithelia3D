%The variables that are going to be used are loaded
load('..\..\data\trackingLayer2.mat')
maxFrame=48;

%Add the path to use the 'findND' function
addpath(genpath('findND'));

%the function 'layerVoronoi' is called, setting the following parameters as input parameters:
%the tracking of the cells, the layers that the voronoi will make in 3D and the number of the last frame.
layerVoronoi( finalCentroid, 'all', maxFrame)
close all


%The layers of the centroids are broken down.
% layers = vertcat(finalCentroid{:, 3});

% 3D voronoi is made by layers
% for numLayer = 1:max(layers)
%     if any((cellfun(@(x) x == numLayer, finalCentroid(:, 3))))
%         seedsInfo = finalCentroid((cellfun(@(x) x == numLayer, finalCentroid(:, 3))), :);
%         layerVoronoi( seedsInfo, num2str(numLayer), maxFrame);
%     end
%     close all
% end


% The voronoi 3D is done every two layers, that is, 1 with 2, 2 with 3 and so on.
% for numLayer = 2:max(layers)
%     if any(cellfun(@(x) x == numLayer | x == (numLayer - 1), finalCentroid(:, 3)))
%         seedsInfo = finalCentroid(cellfun(@(x) x == numLayer | x == (numLayer - 1), finalCentroid(:, 3)), :);
%         layerVoronoi( seedsInfo, strcat(num2str(numLayer), '_', num2str(numLayer - 1)), maxFrame);
%     end
%     close all
% end

