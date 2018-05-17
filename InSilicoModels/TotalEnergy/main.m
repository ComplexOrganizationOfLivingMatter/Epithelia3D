
addpath('src/');
addpath('lib/');

%% With matching apico-basal


% fileCombinations = {'SalivaryGland', 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\FinalEnergyMeasurements\SalivaryGland\Unfiltered\energyMeasurements_TotalEnergy_Transitions_SalivaryGland_20x_40x_60x_19_02_2018.xls', '';
%     'TubVoronoiModel_SR167' , 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\200Seeds_Energy\voronoiModelEnergy_200seeds_surfaceRatio1.6667_Transitions_05-Apr-2018.xls', ...
%     'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\energy_AllFrusta_200seeds\allFrustaEnergy_200seeds_surfaceRatio_1.6667_30-Mar-2018.xls';
%     'EggChamber_Stage4', 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\FinalEnergyMeasurements\EggChamber\Unfiltered\energyMeasurements_eggChamber_Stage4_Transitions_19_02_2018.xls', '';
%     
%     'EggChamber_Stage8', 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\FinalEnergyMeasurements\EggChamber\Unfiltered\energyMeasurements_eggChamber_Stage8_Transitions_19_02_2018.xls', '';
%     
% };
% 
% outputTable = table();
% for numExperiment = 1:length(fileCombinations(:, 1))
%     
%     experimentName = fileCombinations{numExperiment, 1};
%     transFile = fileCombinations{numExperiment, 2};
%     frustaFile = fileCombinations{numExperiment, 3};
%     
%     outputTable = horzcat(outputTable, computeTotalEnergy(transFile, experimentName, isempty(frustaFile) == 0));
%     
%     if isempty(frustaFile) == 0
%         
%         positions = strfind(frustaFile, '_');
%         apicalFrustaFile = strcat(frustaFile(1:positions(end-2)), 'surfaceRatio_1', frustaFile(positions(end):end));
%         allFrustaExcel = unifyApicalAndBasal(readtable(apicalFrustaFile), readtable(frustaFile));
%         
%         noTransitionsFile = strrep(transFile, '_Transitions_', '_NoTransitions_');
%         noTransitionsFile = strrep(noTransitionsFile, 'Fake', '');
%         voronoiTransitionsExcel = readtable(transFile);
%         voronoiNoTransitionsExcel = readtable(noTransitionsFile);
%         
%         [ allFrustaFakeTrans, allFrustaNoTrans, ~, ~] = correspondanceFrustaAndVoronoi( readtable(noTransitionsFile), readtable(transFile), allFrustaExcel);
%         positions = strfind(frustaFile, '_');
%         
%         frustaTransFile = strcat(frustaFile(1:positions(end)), 'FakeTransitions_', frustaFile(positions(end)+1:length(frustaFile)));
%         if exist(frustaTransFile, 'file') ~= 2
%             writetable(allFrustaNoTrans, strcat(frustaFile(1:positions(end)), 'NoTransitions_', frustaFile(positions(end)+1:length(frustaFile))));
%             writetable(allFrustaFakeTrans, frustaTransFile);
%         end
%         
%         outputTable = horzcat(outputTable, computeTotalEnergy(frustaTransFile, strrep(experimentName, 'Voronoi', 'Frusta'), isempty(frustaFile) == 0));
%     end
% end

%% With no matching (all the motifs of the layer

inputDirectoriesFrusta = 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\AllFrusta_energy_200seeds\';
inputDirectoriesVoronoi = 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\Voronoi_energy_200seeds\';
surfaceRatios = {'1', '1.25', '1.6667', '2', '5'};

finalTable = table();

for numSR = 1:length(surfaceRatios)
    
    voronoiFile = dir(strcat(inputDirectoriesVoronoi, 'allMotifsEnergy_200seeds_surfaceRatio', surfaceRatios{numSR}, '_*'));
    frustaFile = dir(strcat(inputDirectoriesFrusta, 'allFrustaEnergy_200seeds_surfaceRatio_', surfaceRatios{numSR}, '_*'));
    [uniqueValidCells, modelFrusta, modelVoronoi, frustaPolDist, voronoiPolDist ] = getValidOfValidCells( readtable(strcat(inputDirectoriesFrusta, frustaFile(1).name)), readtable(strcat(inputDirectoriesVoronoi, voronoiFile(1).name)), str2double(surfaceRatios{numSR}));
    
    [frustaTissueEnergy, ~] = getEnergyInfo(modelFrusta);
    [voronoiTissueEnergy, ~] = getEnergyInfo(modelVoronoi);
    outputTable = table(frustaTissueEnergy, voronoiTissueEnergy);
    outputTable.Properties.VariableNames = cellfun(@(x) strcat('SR', strrep(surfaceRatios{numSR}, '.', ''), '_', x), outputTable.Properties.VariableNames, 'UniformOutput', false);
    
    finalTable = horzcat(finalTable, outputTable);
end
