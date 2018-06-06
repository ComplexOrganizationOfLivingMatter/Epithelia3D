
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

%% With no matching (all the motifs of the layer)

% salivaryGlandNoTrans = readtable('D:\Pablo\Epithelia3D\docs\Tables\FinalEnergyMeasurements\SalivaryGland\Unfiltered\energyMeasurements_TotalEnergy_NoTransitions_SalivaryGland_20x_40x_60x_19_02_2018.xls');
% salivaryGlandTrans = readtable('D:\Pablo\Epithelia3D\docs\Tables\FinalEnergyMeasurements\SalivaryGland\Unfiltered\energyMeasurements_TotalEnergy_Transitions_SalivaryGland_20x_40x_60x_19_02_2018.xls');
% 
% [~, salivaryGlandTotalEnergy] = getEnergyInfo(vertcat(salivaryGlandTrans, salivaryGlandNoTrans));
% salivaryGlandTotalEnergyApical = salivaryGlandTotalEnergy(:, [2,4]);
% %Removing outliers
% salivaryGlandTotalEnergyApical(478, :) = [];
% salivaryGlandTotalEnergyBasal = salivaryGlandTotalEnergy(:, [1,3]);
% 
% 
% numBins = 100;
% h = figure('visible', 'off');
% histogram(salivaryGlandTotalEnergyApical(:, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% hold on;
% histogram(salivaryGlandTotalEnergyBasal(:, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% legend('SalivaryGlandApical', 'SalivaryGlandBasal');
% title('Salivary gland');
% print(h, strcat('results/histogramEnergy_SalivaryGland.tif'), '-dtiff', '-r300')
% close(h);

inputDirectories = 'D:\Pablo\Epithelia3D\InSilicoModels\TotalEnergy\data\';
surfaceRatiosExpansion = {'1', '1.25', '1.6667', '2', '5', '10'};
surfaceRatiosReduction = {'1', '0.8', '0.6', '0.5', '0.2', '0.1'};

expansionOrReduction = 'reduction\';

numBins = 100;

inputDirectories = strcat(inputDirectories, expansionOrReduction);
if isequal(expansionOrReduction, 'reduction\')
    surfaceRatios = surfaceRatiosReduction;
else
    surfaceRatios = surfaceRatiosExpansion;
end

finalTable = cell(length(surfaceRatios), 1);

totalfrustaPolDist = [];
totalVoronoiPolDist = [];

frustaEnergyPerAngle = cell(length(surfaceRatios), 1);
voronoiEnergyPerAngle = cell(length(surfaceRatios), 1);

definedAngles = 0:15:90;

for numSR = 1:length(surfaceRatios)
    
    voronoiFile = dir(strcat(inputDirectories, 'allMotifsEnergy_200seeds_surfaceRatio', surfaceRatios{numSR}, '_*'));
    frustaFile = dir(strcat(inputDirectories, 'allFrustaEnergy_200seeds_surfaceRatio_', surfaceRatios{numSR}, '_*'));
    
    [uniqueValidCells, modelFrusta, modelVoronoi, frustaPolDist, voronoiPolDist ] = getValidOfValidCells( readtable(strcat(inputDirectories, frustaFile(1).name)), readtable(strcat(inputDirectories, voronoiFile(1).name)), str2double(surfaceRatios{numSR}), inputDirectories);
    
    [frustaTissueEnergy, frustaTotalEnergy] = getEnergyInfo(modelFrusta);
	[voronoiTissueEnergy, voronoiTotalEnergy] = getEnergyInfo(modelVoronoi);
    
    h = figure('visible', 'off');
    histogram(frustaTotalEnergy(:, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
    hold on;
    histogram(voronoiTotalEnergy(:, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
    %histogram(salivaryGlandTotalEnergyApical(:, 1), 'NumBins', numBins, 'normalization', 'probability');
    %histogram(salivaryGlandTotalEnergyBasal(:, 1), 'NumBins', numBins, 'normalization', 'probability');
    legend('Frusta', 'Voronoi');%, 'SalivaryGlandApical', 'SalivaryGlandBasal')
    title(strcat('Surface ratio: ', surfaceRatios{numSR}));
    print(h, strcat('results/', expansionOrReduction, 'histogramEnergy_FrustaVsVoronoi_SurfaceRatio', surfaceRatios{numSR}, '_', date, '.tif'), '-dtiff', '-r300')
    close(h);
    
    %paintLineTensionEdges( modelFrusta, str2double(surfaceRatios{numSR}), frustaTotalEnergy, 'Frusta', inputDirectories );
    %paintLineTensionEdges( modelVoronoi, str2double(surfaceRatios{numSR}), voronoiTotalEnergy, 'Voronoi', inputDirectories );
    
    
    % It was not necessary to perform the Edge length cutoff because we do
    % not distinguish between transition and no transition.
    
    
%     totalfrustaPolDist = vertcat(totalfrustaPolDist, mean(frustaPolDist));
%     totalVoronoiPolDist = vertcat(totalVoronoiPolDist, mean(voronoiPolDist));
%     
%     frustaTissueEnergyPerAngle = [];
%     voronoiTissueEnergyPerAngle = [];
%     
%     for numAngle = 2:length(definedAngles)
%         actualAngle = definedAngles(numAngle);
%         prevAngle = definedAngles(numAngle-1);
%         
%         indexingPerAngleVoronoi = modelVoronoi.EdgeAngle >= prevAngle & modelVoronoi.EdgeAngle < actualAngle;
%         indexingPerAngleFrusta = modelFrusta.EdgeAngle >= prevAngle & modelFrusta.EdgeAngle < actualAngle;
%         
%         [frustaTissueEnergy, ~] = getEnergyInfo(modelFrusta(indexingPerAngleFrusta, :));
%         [voronoiTissueEnergy, ~] = getEnergyInfo(modelVoronoi(indexingPerAngleVoronoi, :));
%         
%         %Adding num motifs
%         frustaTissueEnergyPerAngle(:, end+1) = vertcat(frustaTissueEnergy, sum(indexingPerAngleFrusta));
%         voronoiTissueEnergyPerAngle(:, end+1) = vertcat(voronoiTissueEnergy, sum(indexingPerAngleVoronoi));
%     end
%     
%     
%     [frustaTissueEnergy, frustaTotalEnergy] = getEnergyInfo(modelFrusta);
% 	[voronoiTissueEnergy, voronoiTotalEnergy] = getEnergyInfo(modelVoronoi);
%     
%     outputTable = table(frustaTissueEnergy, voronoiTissueEnergy);
%     outputTable(end+1, :) = table(size(modelFrusta, 1), size(modelVoronoi, 1));
%     outputTable(end+1, :) = table(length(horzcat(uniqueValidCells{:})), length(horzcat(uniqueValidCells{:})));
%     outputTable.Properties.VariableNames = cellfun(@(x) strcat('SR', strrep(surfaceRatios{numSR}, '.', ''), '_', x), outputTable.Properties.VariableNames, 'UniformOutput', false);
% 
%     
%     finalTable{numSR} = outputTable;
%     frustaEnergyPerAngle{numSR} = frustaTissueEnergyPerAngle;
%     voronoiEnergyPerAngle{numSR} = voronoiTissueEnergyPerAngle;
end
finalTable = horzcat(finalTable{:});
