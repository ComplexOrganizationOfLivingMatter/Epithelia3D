
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
% salivaryGlandModel = vertcat(salivaryGlandTrans, salivaryGlandNoTrans);
% 
% [~, salivaryGlandTotalEnergy] = getEnergyInfo(salivaryGlandModel);
% salivaryGlandTotalEnergyApical = salivaryGlandTotalEnergy(:, [2,4]);
% %Removing outliers
% salivaryGlandTotalEnergyApical(478, :) = [];
% salivaryGlandModel(478, :) = [];
% salivaryGlandTotalEnergyBasal = salivaryGlandTotalEnergy(:, [1,3]);
% 
% %% Basal filter
% maxLim = 0.15;
% numBins = 100;
% h = figure('visible', 'off');
% subplot(1,2,1);
% histogram(salivaryGlandTotalEnergyApical(salivaryGlandModel.basalEdgeAngle < 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% hold on;
% histogram(salivaryGlandTotalEnergyBasal(salivaryGlandModel.basalEdgeAngle < 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% legend('SalivaryGlandApical', 'SalivaryGlandBasal');
% title('EdgeAngle<45');
% ylim([0 maxLim]);
% 
% subplot(1,2,2);
% histogram(salivaryGlandTotalEnergyApical(salivaryGlandModel.basalEdgeAngle >= 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% hold on;
% histogram(salivaryGlandTotalEnergyBasal(salivaryGlandModel.basalEdgeAngle >= 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% legend('SalivaryGlandApical', 'SalivaryGlandBasal');
% title('EdgeAngle>=45');
% ylim([0 maxLim]);
% suptitle('Salivary gland (basal angle)');
% 
% print(h, strcat('results/histogramEnergy_SalivaryGland_basalFilter_', date, '.tif'), '-dtiff', '-r300')
% close(h);
% 
% %% Apical filter
% maxLim = 0.15;
% numBins = 100;
% h = figure('visible', 'off');
% subplot(1,2,1);
% histogram(salivaryGlandTotalEnergyApical(salivaryGlandModel.apicalEdgeAngle < 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% hold on;
% histogram(salivaryGlandTotalEnergyBasal(salivaryGlandModel.apicalEdgeAngle < 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% legend('SalivaryGlandApical', 'SalivaryGlandBasal');
% title('EdgeAngle<45');
% ylim([0 maxLim]);
% 
% subplot(1,2,2);
% histogram(salivaryGlandTotalEnergyApical(salivaryGlandModel.apicalEdgeAngle >= 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% hold on;
% histogram(salivaryGlandTotalEnergyBasal(salivaryGlandModel.apicalEdgeAngle >= 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% legend('SalivaryGlandApical', 'SalivaryGlandBasal');
% title('EdgeAngle>=45');
% ylim([0 maxLim]);
% suptitle('Salivary gland (apical angle)');
% 
% print(h, strcat('results/histogramEnergy_SalivaryGland_apicalFilter_', date, '.tif'), '-dtiff', '-r300')
% close(h);


%% General
% histogram(salivaryGlandTotalEnergyApical(:, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% hold on;
% histogram(salivaryGlandTotalEnergyBasal(:, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
% legend('SalivaryGlandApical', 'SalivaryGlandBasal');
% title('Salivary gland');


inputDirectories = 'D:\Pablo\Epithelia3D\InSilicoModels\TotalEnergy\data\';
% surfaceRatiosExpansion = {'1', '1.25', '1.6667', '2', '5', '10'};
% surfaceRatiosReduction = {'1', '0.8', '0.6', '0.5', '0.2', '0.1'};
surfaceRatiosExpansion = {'1', '1.1111', '1.25', '1.4286', '1.6667', '2', '2.5', '3.3333', '5', '10'};
surfaceRatiosReduction = {'1', '0.9', '0.8', '0.7', '0.6', '0.5', '0.4', '0.3', '0.2', '0.1'};

expansionOrReduction = 'expansion';
mkdir(strcat('results/', expansionOrReduction, '/'));

maxLim = 0.15;
numBins = 100;

inputDirectories = strcat(inputDirectories, expansionOrReduction, '\');
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


%cellsToAnalyze =  [108];
cellsToAnalyze = [];
cellsAnalysed = [];

if isempty(cellsToAnalyze) == 0
    cellsAnalysed = mat2str(cellsToAnalyze);
    cellsAnalysed = strcat('cellsWithId_', strrep(cellsAnalysed(2:end-1), ' ', '-'));
    expansionOrReduction = strcat(expansionOrReduction, '/', cellsAnalysed);
end
mkdir(strcat('results/', expansionOrReduction, '/'));


definedAngles = 0:15:90;

parfor numSR = 1:length(surfaceRatios)
    
    voronoiFile = dir(strcat(inputDirectories, 'allMotifsEnergy_200seeds_surfaceRatio', surfaceRatios{numSR}, '_*'));
    frustaFile = dir(strcat(inputDirectories, 'allFrustaEnergy_200seeds_surfaceRatio_', surfaceRatios{numSR}, '_*'));
    
    [uniqueValidCells, modelFrusta, modelVoronoi, frustaPolDist, voronoiPolDist ] = getValidOfValidCells( readtable(strcat(inputDirectories, frustaFile(1).name)), readtable(strcat(inputDirectories, voronoiFile(1).name)), str2double(surfaceRatios{numSR}), inputDirectories);
    
    if isempty(cellsToAnalyze) == 0
        modelFrusta(any(ismember(modelFrusta{:, 1:4}, cellsToAnalyze), 2) == 0, :) = [];
        modelVoronoi(any(ismember(modelVoronoi{:, 1:4}, cellsToAnalyze), 2) == 0, :) = [];
    end
    
    [frustaTissueEnergy, frustaTotalEnergy] = getEnergyInfo(modelFrusta);
	[voronoiTissueEnergy, voronoiTotalEnergy] = getEnergyInfo(modelVoronoi);
    
    h = figure('visible', 'off');
    %h = figure;
    subplot(1,2,1);
    histogram(frustaTotalEnergy(modelFrusta.EdgeAngle < 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
    hold on;
    histogram(voronoiTotalEnergy(modelVoronoi.EdgeAngle < 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
    ylim([0 maxLim]);
    title('EdgeAngle<45');
    legend(strcat('Frusta (', num2str(sum(modelFrusta.EdgeAngle < 45)) ,' motifs)'), strcat('Voronoi (', num2str(sum(modelVoronoi.EdgeAngle < 45)) ,' motifs)'));
    hold off;
    
    subplot(1,2,2);
    histogram(frustaTotalEnergy(modelFrusta.EdgeAngle >= 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
    hold on;
    histogram(voronoiTotalEnergy(modelVoronoi.EdgeAngle >= 45, 1), 'NumBins', numBins, 'normalization', 'probability', 'binLimits', [0.5, 1.5]);
    ylim([0 maxLim]);
    title('EdgeAngle>=45');
    legend(strcat('Frusta (', num2str(sum(modelFrusta.EdgeAngle >= 45)) ,' motifs)'), strcat('Voronoi (', num2str(sum(modelVoronoi.EdgeAngle >= 45)) ,' motifs)'));
    hold off;
    
    suptitle(strcat('Surface ratio: ', surfaceRatios{numSR}));
    %legend('Frusta', 'Voronoi');%, 'SalivaryGlandApical', 'SalivaryGlandBasal')
    
    print(h, strcat('results/', expansionOrReduction, '/histogramEnergy_FrustaVsVoronoi_SurfaceRatio', surfaceRatios{numSR}, '_', date, '.tif'), '-dtiff', '-r300')
    close(h);
    
    paintLineTensionEdges( modelFrusta, str2double(surfaceRatios{numSR}), frustaTotalEnergy, 'Frusta', inputDirectories, cellsAnalysed);
    paintLineTensionEdges( modelVoronoi, str2double(surfaceRatios{numSR}), voronoiTotalEnergy, 'Voronoi', inputDirectories, cellsAnalysed);
    
    
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
