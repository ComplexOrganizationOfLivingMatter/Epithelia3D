%% Unroll tube

addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', 'InSilicoModels', 'TubularModel', 'src')));

files = dir('**/Salivary gland/**/Results/3d_layers_info.mat');

%parpool(3)
for numFile = 1:length(files)
    if contains(lower(files(numFile).folder), 'discarded') == 0
        files(numFile).folder
        selpath = files(numFile).folder;
        %if exist(fullfile(selpath, 'apical_img.mat'), 'file') == 0 || exist(fullfile(selpath, 'basal_img.mat'), 'file') == 0
            unrollTube_parallel(selpath);
        %end
        
%         load(fullfile(selpath, 'apical_img.mat'), 'cylindre2DImage', 'validCellsFinal');
%         [neighs_apical, side_cells_apical] = calculateNeighbours(cylindre2DImage);
%         
%         load(fullfile(selpath, 'basal_img.mat'), 'cylindre2DImage');
%         [neighs_basal, side_cells_basal] = calculateNeighbours(cylindre2DImage);
%         
%         missingCellsUnroll = find(side_cells_basal<3 | side_cells_apical<3);
%         if isempty(missingCellsUnroll) == 0
%             %msgbox(strcat('CARE!! Missing (or ill formed) cells at unrolltube: ', strjoin(arrayfun(@num2str, missingCellsUnroll, 'UniformOutput', false), ', ')))
%             load(fullfile(selpath, '3d_layers_info.mat'), 'colours');
%             strjoin(arrayfun(@num2str, missingCellsUnroll, 'UniformOutput', false), ', ')
%         end
% 
%         [polygon_distribution_UnrollTubeApical] = calculate_polygon_distribution(side_cells_apical, validCellsFinal);
%         [polygon_distribution_UnrollTubeBasal] = calculate_polygon_distribution(side_cells_basal, validCellsFinal);
%         neighbours_UnrollTube = table(neighs_apical, neighs_basal);
%         polygon_distribution_UnrollTube = table(polygon_distribution_UnrollTubeApical,polygon_distribution_UnrollTubeBasal);
%         neighbours_UnrollTube.Properties.VariableNames = {'Apical', 'Basal'};
%         polygon_distribution_UnrollTube.Properties.VariableNames = {'Apical','Basal'};
%         infoUnroll{numFile} = polygon_distribution_UnrollTube;
%         directorySplitted = strsplit(selpath, '\');
%         %createSamiraFormatExcel_NaturalTissues(fullfile(selpath, 'apical_img.mat'), strjoin(directorySplitted(end-3:end-1), '_'));
%         %createSamiraFormatExcel_NaturalTissues(fullfile(selpath, 'basal_img.mat'), strjoin(directorySplitted(end-3:end-1), '_'));
    end
end