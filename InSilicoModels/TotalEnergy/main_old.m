%Developed by Pablo Vicente-Munuera
addpath('src');
% 
% disp('--------------------------------');
% 
% tableInfo = [mean(energyInfoVertexModel(:, 4)) mean(energyInfoTubMod(:, 4))
%     std(energyInfoVertexModel(:, 4)) std(energyInfoTubMod(:, 4))
%     mean(energyInfoVertexModel(:, 3)) mean(energyInfoTubMod(:, 3))
%     std(energyInfoVertexModel(:, 3)) std(energyInfoTubMod(:, 3))
%     sum(energyInfoVertexModel(:, 3) - energyInfoVertexModel(:, 4)) sum(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4))
%     mean(energyInfoVertexModel(:, 3) - energyInfoVertexModel(:, 4)) mean(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4))
%     std(energyInfoVertexModel(:, 3) - energyInfoVertexModel(:, 4)) std(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4))
%     sum(abs(energyInfoVertexModel(:, 3) - energyInfoVertexModel(:, 4))) sum(abs(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4)))
%     mean(abs(energyInfoVertexModel(:, 3) - energyInfoVertexModel(:, 4))) mean(abs(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4)))
%     std(abs(energyInfoVertexModel(:, 3) - energyInfoVertexModel(:, 4))) std(abs(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4)))
%     ];
% 
% % energyInfo = energyInfoTubMod_Trans;
% % energyInfoTubMod = energyInfoTubMod_NoTrans;
% % tableInfo = [mean(energyInfo(:, 4)) mean(energyInfoTubMod(:, 4))
% %     std(energyInfo(:, 4)) std(energyInfoTubMod(:, 4))
% %     mean(energyInfo(:, 3)) mean(energyInfoTubMod(:, 3))
% %     std(energyInfo(:, 3)) std(energyInfoTubMod(:, 3))
% %     sum(energyInfo(:, 3) - energyInfo(:, 4)) sum(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4))
% %     mean(energyInfo(:, 3) - energyInfo(:, 4)) mean(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4))
% %     std(energyInfo(:, 3) - energyInfo(:, 4)) std(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4))
% %     sum(abs(energyInfo(:, 3) - energyInfo(:, 4))) sum(abs(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4)))
% %     mean(abs(energyInfo(:, 3) - energyInfo(:, 4))) mean(abs(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4)))
% %     std(abs(energyInfo(:, 3) - energyInfo(:, 4))) std(abs(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4)))
% %     ];
%     
% disp('Vertex model mean energy apical:');
% mean(energyInfoVertexModel(:, 4))
% disp('Tubular model mean energy apical:');
% mean(energyInfoTubMod(:, 4))
% 
% disp('Vertex model mean energy basal:');
% mean(energyInfoVertexModel(:, 3))
% disp('Tubular model mean energy basal:');
% mean(energyInfoTubMod(:, 3))
% 
% disp('Vertex model total difference energy (basal - apical):');
% sum(energyInfoVertexModel(:, 3) - energyInfoVertexModel(:, 4))
% disp('Tubular model total difference energy (basal - apical):');
% sum(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4))
% 
% disp('Vertex model mean difference energy (basal - apical):');
% mean(energyInfoVertexModel(:, 3) - energyInfoVertexModel(:, 4))
% disp('Tubular model mean difference energy (basal - apical):');
% mean(energyInfoTubMod(:, 3) - energyInfoTubMod(:, 4))

% -------------------------------------------------------------------------------- %
% %% Salivary gland
% salivaryGlandTrans = readtable('D:\Pablo\Epithelia3D\Salivary Glands\docs\energyMeasurements_TotalEnergy_Transitions_SalivaryGland_20x_40x_60x_19_02_2018.xlsx');
% salivaryGlandNoTrans = readtable('D:\Pablo\Epithelia3D\Salivary Glands\docs\energyMeasurements_TotalEnergy_NoTransitions_SalivaryGland_20x_40x_60x_19_02_2018.xlsx');
% % 
% % randomIndicesTrans = randperm(size(salivaryGlandTrans, 1), 100);
% % randomIndicesNoTrans = randperm(size(salivaryGlandNoTrans, 1), 100);
% randomIndicesTrans = [6 65 110 97 28 54 47 82 73 62 12 101 91 36 61 85 24 126 102 31 35 69 41 42 45 19 8 70 9 80 123 66 105 33 100 39 15 71 37 53 23 11 46 16 5 106 68 1 113 27 14 92 83 49 25 115 127 60 86 81 109 58 89 104 55 57 124 51 90 3 125 122 95 107 21 29 64 43 10 119 52 108 18 128 7 96 72 44 98 74 117 17 20 13 4 34 26 75 50 2];
% randomIndicesNoTrans = [513 204 290 422 373 84 13 78 139 279 331 613 443 604 34 392 589 166 581 551 119 447 107 64 191 211 241 171 189 431 566 53 167 356 493 465 619 22 396 501 39 213 152 254 180 565 76 127 520 361 231 206 374 423 421 550 27 243 6 402 445 321 14 5 559 114 464 203 259 62 437 586 612 200 268 239 387 625 4 44 253 427 608 345 199 483 137 36 394 415 485 413 509 288 514 523 620 450 477 494];
% 
% 
% writetable(salivaryGlandNoTrans(randomIndicesNoTrans(1:100), :), 'energyMeasurements_NoTransitions_SalivaryGland_19_02_2018.xls');
% writetable(salivaryGlandTrans(randomIndicesTrans(1:100), :), 'energyMeasurements_Transitions_SalivaryGland_19_02_2018.xls');

% % [noTransDiffSummary, salivaryGlandNoTransEnergy] = getEnergyInfo(salivaryGlandNoTrans(randomIndicesNoTrans(1:100), :));
% % [transDiffSummary, salivaryGlandTransEnergy] = getEnergyInfo(salivaryGlandTrans(randomIndicesTrans(1:100), :));
% % [diffSummary, salivaryGlandEnergy] = getEnergyInfo(vertcat(salivaryGlandTrans(randomIndicesTrans(1:100), :), salivaryGlandNoTrans(randomIndicesNoTrans(1:100), :)));
% [noTransDiffSummary, salivaryGlandNoTransEnergy] = getEnergyInfo(salivaryGlandNoTrans(randomIndicesNoTrans(1:31), :));
% [transDiffSummary, salivaryGlandTransEnergy] = getEnergyInfo(salivaryGlandTrans(randomIndicesTrans(1:31), :));
% [diffSummary, salivaryGlandEnergy] = getEnergyInfo(vertcat(salivaryGlandTrans(randomIndicesTrans(1:31), :), salivaryGlandNoTrans(randomIndicesNoTrans(1:31), :)));


ttestDifferences = @(x, y) ttest2(x(:, 1) - x(:, 2), y(:, 1) - y(:, 2));
%ttestDifferencesReduction = @(x, y) ttest2(-x(:, 1) + x(:, 2), -y(:, 1) + y(:, 2));
% 
% %ttestDifferences(salivaryGlandEnergy, vertexModelGlandEnergy)
% 
%% Egg chamber Stage 4
% eggChamberStage4Trans = readtable('D:\Pablo\Epithelia3D\Egg chamber\docs\energyMeasurements_eggChamber_Stage4_transitions_19_02_2018.xlsx');
% eggChamberStage4NoTrans = readtable('D:\Pablo\Epithelia3D\Egg chamber\docs\energyMeasurements_eggChamber_Stage4_noTransitions_19_02_2018.xlsx');
% 
% maxSamples = size(eggChamberStage4Trans, 1);
% 
% %randomIndicesNoTrans = randperm(size(eggChamberStage4NoTrans, 1), maxSamples);
% randomIndicesNoTrans = [72,58,34,16,67,49,65,21,47,8,36,73,25,81,20,75,35,52,79,51,62,69,22,57,9,80,43,55,3,39,38,76,78,74,13,12,61,31,19,59,7,29,11,30,5,60,71,2,18,37,40];
% 
% % writetable(eggChamberStage4NoTrans(randomIndicesNoTrans(1:maxSamples), :), 'energyMeasurements_eggChamber_Stage4_noTransitions_filtered_19_03_2018.xls')
% % writetable(eggChamberStage4Trans, 'energyMeasurements_eggChamber_Stage4_transitions_filtered_19_03_2018.xls');
% 
% [stage4NoTransSummary, stage4NoTransEnergy] = getEnergyInfo(eggChamberStage4NoTrans(randomIndicesNoTrans(1:maxSamples), :));
% [stage4TransSummary, stage4TransEnergy] = getEnergyInfo(eggChamberStage4Trans);
% 
% [stage4Summary, stage4Energy] = getEnergyInfo(vertcat(eggChamberStage4Trans, eggChamberStage4NoTrans(randomIndicesNoTrans(1:maxSamples), :)));
% 
%% Ellipsoid Model Stage 4
% modelStage4NoTrans = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\EnergyMotifs\Voronoi\Matching_Motifs_Basal-Apical\Unfiltered\WithDuplicatedMotifs\spheroidVoronoiModelEnergy_Stage 4_NoTransition_AngleThreshold_03-Apr-2018.xls');
% modelStage4Trans = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\EnergyMotifs\Voronoi\Matching_Motifs_Basal-Apical\Unfiltered\WithDuplicatedMotifs\spheroidVoronoiModelEnergy_Stage 4_Transition_AngleThreshold_03-Apr-2018.xls');
% 
% modelStage4NoTrans.Properties.VariableNames = cellfun(@(x) strrep(x, 'inner', 'apical'), modelStage4NoTrans.Properties.VariableNames, 'UniformOutput', false);
% modelStage4NoTrans.Properties.VariableNames = cellfun(@(x) strrep(x, 'outer', 'basal'), modelStage4NoTrans.Properties.VariableNames, 'UniformOutput', false);
% 
% modelStage4Trans.Properties.VariableNames = cellfun(@(x) strrep(x, 'inner', 'apical'), modelStage4NoTrans.Properties.VariableNames, 'UniformOutput', false);
% modelStage4Trans.Properties.VariableNames = cellfun(@(x) strrep(x, 'outer', 'basal'), modelStage4NoTrans.Properties.VariableNames, 'UniformOutput', false);
% 
% [~, firstOcurrences] = unique(modelStage4Trans(:, [1:7]));
% modelStage4Trans = modelStage4Trans(firstOcurrences, :);
% 
% [~, firstOcurrences] = unique(modelStage4NoTrans(:, [1:7]));
% modelStage4NoTrans = modelStage4NoTrans(firstOcurrences, :);
% 
% 
% [~, firstOcurrences] = unique(modelStage4Trans(:, [1:4 19]));
% modelStage4Trans = modelStage4Trans(firstOcurrences, :);
% 
% [~, firstOcurrences] = unique(modelStage4NoTrans(:, [1:4 19]));
% modelStage4NoTrans = modelStage4NoTrans(firstOcurrences, :);
% 
% maxSamples = size(modelStage4Trans, 1);
% 
% %idsFilter = 1:2:200;
% %idsFilter = randperm(size(modelStage4NoTrans, 1), maxSamples);
% idsFilterNoTrans = [7833,8708,1221,8779,6077,938,2676,5254,9198,9268,1514,9321,9191,4661,7683,1362,4049,8789,7603,9207,6292,343,8145,8958,6510,7266,7126,3761,6284,1641,6767,306,2654,443,931,7888,6656,3037,9100,330,4201,3653,7328,7611,1789,4687,4264,6184,6786,7219,2640,6500,6265,1555,1138,4764,9174,3254,5593,2139,7178,2437,4833,6677,8509,9161,5225,1324,1426,2458,8024,2427,7770,2324,8866,3339,1876,2395,5875,4513,3353,7921,5579,5240,8741,2724,7215,7181,3625,5409,723,514,5055,7419,8892,1237,5415,4468,114,3208,1544,7557,2961,5027,1576,5725,2501,6219,6552,7112,4282,797,2176,8678,1448,7845,5114,9461,743,4204,1013,9132,44,7355,7757,8244,802,3793,2466,7589,4092,8636,1725,2502,1380,1290,8240,5494,5211,1374,8082,5893,3325,4861,3806,720,2272,1168,1741,9468,3950,470,8542,8939,4644,4628,3195,8512,3492,1052,7377,3685,2285,3818,912,1248,8901,9033,5434,565,2218,3335,7754,146,407,1596,6127,6906,6113,4255];
% idsFilterTrans = [11,65,154,115,6,124,57,122,164,92,13,140,127,53,22,29,157,75,141,131,112,48,179,9,142,60,156,113,10,88,61,178,71,99,23,30,16,76,74,73,4,46,33,31,166,25,94,14,77,5,105,172,104,26,161,143,116,121,158,138,120,66,149,36,111,126,153,85,133,100,167,170,69,83,95,35,103,148,160,18,81,1,32,123,119,45,3,135,110,56,49,40,168,130,175,106,80,97,150,72,24,114,84,78,128,129,91,17,136,52,7,51,2,82,139,174,145,177,21,144,41,173,176,62,86,107,90,20,55,109,134,98,96,117,132,47,34,27,102,12,59,28,50,93,101,125,44,42,137,68,163,38,155,8,162,19,70,147,79,169,43,108,58,146,37,152,54,89,171,63,15,64,165,118,151,67,39,159,87,180];
% 
% writetable(modelStage4NoTrans(idsFilterNoTrans(1:100), :), 'spheroidVoronoiModelEnergy_Stage4_NoTransitions_AngleThreshold_filtered_03_04_2018.xls');
% writetable(modelStage4Trans(idsFilterTrans(1:100), :), 'spheroidVoronoiModelEnergy_Stage4_Transitions_AngleThreshold_filtered_03_04_2018.xls');
% writetable(modelStage4NoTrans, 'spheroidVoronoiModelEnergy_Stage4_NoTransitions_AngleThreshold_03_04_2018.xls');
% writetable(modelStage4Trans, 'spheroidVoronoiModelEnergy_Stage4_Transitions_AngleThreshold_03_04_2018.xls');
% 

% [modelStage4NoTransSummary, 6modelStage4NoTransEnergy] = getEnergyInfo(modelStage4NoTrans(idsFilter, :));
% [modelStage4TransSummary, modelStage4TransEnergy] = getEnergyInfo(modelStage4Trans(idsFilter, :));
% 
% [modelStage4Summary, modelStage4Energy] = getEnergyInfo(vertcat(modelStage4NoTrans(idsFilter, :), modelStage4Trans(idsFilter, :)));

%% Frusta Model Stage 4
% frustaStage4 = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\energyMeasurements_spheroidAllFrustaModel_Stage4_NoTransition_28-Mar-2018.xls');
% voronoiTrans = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\ellipsoidVoronoiModel_Stage4_energyTransitionEdges_05-Mar-2018.xls');
% voronoiNoTrans = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\ellipsoidVoronoiModel_Stage4_energyNoTransitionEdges_05-Mar-2018.xls');
% 
% [ allFrustaFakeTrans, allFrustaNoTrans, allFrustaFakeTransFiltered, allFrustaNoTransFiltered   ] = correspondanceFrustaAndVoronoi( voronoiNoTrans, voronoiTrans, frustaStage4 );
% writetable(allFrustaNoTrans, 'energyMeasurements_spheroidAllFrustaModel_Stage4_NoTransitions_28_03_2018.xls');
% writetable(allFrustaFakeTrans, 'energyMeasurements_spheroidAllFrustaModel_Stage4_FakeTransitions_28_03_2018.xls');
% writetable(allFrustaNoTransFiltered, 'energyMeasurements_spheroidAllFrustaModel_Stage4_NoTransitions_filtered_28_03_2018.xls');
% writetable(allFrustaFakeTransFiltered, 'energyMeasurements_spheroidAllFrustaModel_Stage4_FakeTransitions_filtered_28_03_2018.xls');

%% Egg chamber Stage 8
% eggChamberStage8Trans = readtable('D:\Pablo\Epithelia3D\Egg chamber\docs\energyMeasurements_eggChamber_Stage8_transitions_19_02_2018.xlsx');
% eggChamberStage8NoTrans = readtable('D:\Pablo\Epithelia3D\Egg chamber\docs\energyMeasurements_eggChamber_Stage8_noTransitions_19_02_2018.xlsx');
% 
% maxSamples = size(eggChamberStage8Trans, 1);
% 
% randomIndicesNoTrans = [6,28,21,11,17,13,29,38,34,5,44,3,19,25,45,49,43,20,46,1,41,22,55,52,58,14,51,12,9,18,4,54,2,48,27,59,32,16,47,24,42,35];
% %randomIndicesNoTrans = randperm(size(eggChamberStage8NoTrans, 1), maxSamples);
% 
% writetable(eggChamberStage8NoTrans(randomIndicesNoTrans(1:maxSamples), :), 'energyMeasurements_eggChamber_Stage8_noTransitions_filtered_19_03_2018.xls');
% writetable(eggChamberStage8Trans, 'energyMeasurements_eggChamber_Stage8_transitions_filtered_19_03_2018.xls');

% [stage8NoTransSummary, stage8NoTransEnergy] = getEnergyInfo(eggChamberStage8NoTrans(randomIndicesNoTrans(1:maxSamples), :));
% [stage8TransSummary, stage8TransEnergy] = getEnergyInfo(eggChamberStage8Trans);
% 
% [stage8Summary, stage8Energy] = getEnergyInfo(vertcat(eggChamberStage8Trans, eggChamberStage8NoTrans(randomIndicesNoTrans(1:maxSamples), :)));
% 
%% Ellipsoid Modell Stage 8
modelStage8NoTrans = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\EnergyMotifs\Voronoi\Matching_Motifs_Basal-Apical\Unfiltered\spheroidVoronoiModelEnergy_Stage 8_NoTransition_AngleThreshold_03-Apr-2018.xls');
modelStage8Trans = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\EnergyMotifs\Voronoi\Matching_Motifs_Basal-Apical\Unfiltered\spheroidVoronoiModelEnergy_Stage 8_Transition_AngleThreshold_03-Apr-2018.xls');

[~, firstOcurrences] = unique(modelStage8Trans(:, [1:7]));
modelStage8Trans = modelStage8Trans(firstOcurrences, :);

[~, firstOcurrences] = unique(modelStage8NoTrans(:, [1:7]));
modelStage8NoTrans = modelStage8NoTrans(firstOcurrences, :);


[~, firstOcurrences] = unique(modelStage8Trans(:, [1:4 19]));
modelStage8Trans = modelStage8Trans(firstOcurrences, :);

[~, firstOcurrences] = unique(modelStage8NoTrans(:, [1:4 19]));
modelStage8NoTrans = modelStage8NoTrans(firstOcurrences, :);

maxSamples = size(modelStage8Trans, 1);

modelStage8NoTrans.Properties.VariableNames = cellfun(@(x) strrep(x, 'inner', 'apical'), modelStage8NoTrans.Properties.VariableNames, 'UniformOutput', false);
modelStage8NoTrans.Properties.VariableNames = cellfun(@(x) strrep(x, 'outer', 'basal'), modelStage8NoTrans.Properties.VariableNames, 'UniformOutput', false);

modelStage8Trans.Properties.VariableNames = cellfun(@(x) strrep(x, 'inner', 'apical'), modelStage8NoTrans.Properties.VariableNames, 'UniformOutput', false);
modelStage8Trans.Properties.VariableNames = cellfun(@(x) strrep(x, 'outer', 'basal'), modelStage8NoTrans.Properties.VariableNames, 'UniformOutput', false);

%idsFilter = 1:2:200;
%idsFilter = randperm(200, maxSamples);
idsFilterNoTrans = randperm(size(modelStage8NoTrans, 1), 100);
idsFilterTrans = randperm(size(modelStage8Trans, 1), 100);

writetable(modelStage8NoTrans(idsFilterNoTrans, :), 'spheroidVoronoiModelEnergy_Stage8_NoTransitions_AngleThreshold_filtered_03_04_2018.xls');
writetable(modelStage8Trans(idsFilterTrans, :), 'spheroidVoronoiModelEnergy_Stage8_Transitions_AngleThreshold_filtered_03_04_2018.xls');

writetable(modelStage8NoTrans, 'spheroidVoronoiModelEnergy_Stage8_NoTransitions_AngleThreshold_03_04_2018.xls');
writetable(modelStage8Trans, 'spheroidVoronoiModelEnergy_Stage8_Transitions_AngleThreshold_03_04_2018.xls');

% [modelStage8NoTransSummary, modelStage8NoTransEnergy] = getEnergyInfo(modelStage8NoTrans(idsFilter, :));
% [modelStage8TransSummary, modelStage8TransEnergy] = getEnergyInfo(modelStage8Trans(idsFilter, :));
% 
% [modelStage8Summary, modelStage8Energy] = getEnergyInfo(vertcat(modelStage8NoTrans(idsFilter, :), modelStage8Trans(idsFilter, :)));
% 
% 
%% Frusta Model Stage 8
frustaStage8 = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\energyMeasurements_spheroidAllFrustaModel_Stage8_NoTransition_28-Mar-2018.xls');
voronoiTrans = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\ellipsoidVoronoiModel_Stage8_energyTransitionEdges_05-Mar-2018.xls');
voronoiNoTrans = readtable('D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\docs\ellipsoidVoronoiModel_Stage8_energyNoTransitionEdges_05-Mar-2018.xls');

[ allFrustaFakeTrans, allFrustaNoTrans, allFrustaFakeTransFiltered, allFrustaNoTransFiltered  ] = correspondanceFrustaAndVoronoi( voronoiNoTrans, voronoiTrans, frustaStage8 );

%idsFilter = randperm(size(frustaStage8NoTrans, 1), maxSamples);
%idsFilter = [76,32,61,31,28,30,9,39,49,62,34,15,20,48,26,5,36,72,45,77,23,6,41,29,1,57,58,43,4,14,52,10,44,66,7,65,40,11,22,13,50,56,54,38,51,69,17];

writetable(allFrustaNoTrans, 'energyMeasurements_spheroidAllFrustaModel_Stage8_NoTransitions_28_03_2018.xls');
writetable(allFrustaFakeTrans, 'energyMeasurements_spheroidAllFrustaModel_Stage8_FakeTransitions_28_03_2018.xls');
writetable(allFrustaNoTransFiltered, 'energyMeasurements_spheroidAllFrustaModel_Stage8_NoTransitions_filtered_28_03_2018.xls');
writetable(allFrustaFakeTransFiltered, 'energyMeasurements_spheroidAllFrustaModel_Stage8_FakeTransitions_filtered_28_03_2018.xls');
% %% Voronoi Model & All frusta Model
% %Total cells
surfaceRatio = '1.25';
voronoiModelBasal = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\voronoiModel\allMotifsPerSurfaceRatio\allMotifsEnergy_200seeds_surfaceRatio_', surfaceRatio, '_16-Feb-2018.xls'));
voronoiModelApical = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\voronoiModel\allMotifsPerSurfaceRatio\allMotifsEnergy_200seeds_surfaceRatio_1_16-Feb-2018.xls'));
% allFrustaModel = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\allFrusta\allFrustaEnergy_200seeds_surfaceRatio_', surfaceRatio, '_13-Feb-2018.xls'));
% 
% % [ uniqueValidCells, allFrustaModel, voronoiModelBasal, frustaPolDist, voronoiPolDist ] = getValidOfValidCells( allFrustaModel, voronoiModelBasal, str2num(surfaceRatio) );
% % length(vertcat(uniqueValidCells{:}))
% % size(allFrustaModel, 1)
% % size(voronoiModelBasal, 1)
% % mean(frustaPolDist)
% % mean(voronoiPolDist)
% 
% %[voronoiModelApicalSummary, voronoiModelApicalEnergy] = getEnergyInfo(voronoiModelApical);
% 
% disp('------------Frusta-------------');
% 
% allFrustaModelNoFavorable = allFrustaModel(allFrustaModel.basalEdgeAngle >= 45, :);
% allFrustaModelFavorable = allFrustaModel(allFrustaModel.basalEdgeAngle <= 45, :);
% countUniqueCellsInMotif( allFrustaModelFavorable )
% countUniqueCellsInMotif( allFrustaModelNoFavorable )
% [allFrustaModelNoFavorableeSummary, allFrustaModelNoFavorableEnergy] = getEnergyInfo(allFrustaModelNoFavorable);
% [allFrustaModelFavorableSummary, allFrustaModelFavorableEnergy] = getEnergyInfo(allFrustaModelFavorable);
% [allFrustaModelSummary, allFrustaModelEnergy] = getEnergyInfo(allFrustaModel);
% 
% disp('------------Voronoi-------------');
% 
% voronoiModelBasalNoFavorable = voronoiModelBasal(voronoiModelBasal.EdgeAngle >= 45, :);
% voronoiModelBasalFavorable = voronoiModelBasal(voronoiModelBasal.EdgeAngle < 45, :);
% countUniqueCellsInMotif( voronoiModelBasalFavorable )
% countUniqueCellsInMotif( voronoiModelBasalNoFavorable )
% [voronoiModelNoFavorableSummary, voronoiModelNoFavorableEnergy] = getEnergyInfo(voronoiModelBasalNoFavorable);
% [voronoiModelFavorableSummary, voronoiModelFavorableEnergy] = getEnergyInfo(voronoiModelBasalFavorable);
% [voronoiModelSummary, voronoiModelEnergy] = getEnergyInfo(voronoiModelBasal);


% Same cells in apical in both models
% Matching cells
surfaceRatios = {'1.25', '1.6667', '2', '5'};
for numSurfaceRatio = 1:length(surfaceRatios)
    surfaceRatio = surfaceRatios{numSurfaceRatio};
    voronoiModelNoTrans = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\voronoiModel\matchingMotifsBasalApical\filtering200dataRandom\noTransitionEdges_200seeds_surfaceRatio_', surfaceRatio, '_filter200measurements_16-Feb-2018.xls'));
    voronoiModelTrans = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\voronoiModel\matchingMotifsBasalApical\filtering200dataRandom\transitionEdges_200seeds_surfaceRatio_', surfaceRatio, '_filter200measurements_16-Feb-2018.xls'));
    % allFrustaModelBasal = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\allFrusta\allFrustaEnergy_60seeds_surfaceRatio_', surfaceRatio, '_16-Mar-2018.xls'));
    % allFrustaModelApical = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\allFrusta\allFrustaEnergy_60seeds_surfaceRatio_', '1', '_16-Mar-2018.xls'));

    % % voronoiModelNoTrans = readtable('D:\Pablo\Epithelia3D\docs\Tables\noTransitionEdges_200seeds_surfaceRatio_1.6667_filter200measurements_14-Feb-2018.xls');
    % voronoiModelTrans = readtable('D:\Pablo\Epithelia3D\docs\Tables\transitionEdges_200seeds_surfaceRatio_1.6667_filter200measurements_14-Feb-2018.xls');
    % allFrustaModel = readtable('D:\Pablo\Epithelia3D\docs\Tables\tubularVertexModel_noTransitionEdges_200seeds_surfaceRatio_1.6667_13-Feb-2018.xls');

    % reduction
    % surfaceRatio = '5';
    % voronoiModelNoTrans = readtable(horzcat('D:\Pablo\Epithelia3D\docs\Tables\tubularModel_reduction_data_08_02_2018\noTransitionEdges_200seeds_surfaceRatio_', surfaceRatio, '_filter200measurements_20-Feb-2018.xls'));
    % voronoiModelTrans = readtable(horzcat('D:\Pablo\Epithelia3D\docs\Tables\tubularModel_reduction_data_08_02_2018\transitionEdges_200seeds_surfaceRatio_', surfaceRatio,'_filter200measurements_20-Feb-2018.xls'));
    % allFrustaModelApical = readtable(horzcat('D:\Pablo\Epithelia3D\docs\Tables\reductionAllMotifs\AllFrusta\allFrustaEnergy_200seeds_surfaceRatio_', surfaceRatio,'_20-Feb-2018.xls'));
    % allFrustaModelBasal = readtable(horzcat('D:\Pablo\Epithelia3D\docs\Tables\reductionAllMotifs\AllFrusta\allFrustaEnergy_200seeds_surfaceRatio_1_20-Feb-2018.xls'));

    idsFilter = 1:2:200;
    %idsFilter = 1:31;
    %idsFilter = 1:52;
    %idsFilter = 1:44;

    writetable(voronoiModelNoTrans(idsFilter, :), 'energyMeasurements_TubularVoronoiModel_SurfaceRatio_', surfaceRatio, '_NoTransitions_Filtered_21_03_2018.xls');
    writetable(voronoiModelTrans(idsFilter, :), 'energyMeasurements_TubularVoronoiModel_SurfaceRatio_', surfaceRatio, '_Transitions_Filtered_21_03_2018.xls');
end
surfaceRatio = '6.6667';
allFrustaModelBasal = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\allFrusta\allFrustaEnergy_60seeds_surfaceRatio_', surfaceRatio, '_16-Mar-2018.xls'));
allFrustaModelApical = readtable(horzcat('D:\TOTALenergyMeasurementsTubularModel\allFrusta\allFrustaEnergy_60seeds_surfaceRatio_', '1', '_16-Mar-2018.xls'));
allFrustaModelApical.Properties.VariableNames(5:end-3) = cellfun(@(x) strcat('apical', x), allFrustaModelApical.Properties.VariableNames(5:end-3), 'UniformOutput', false);
allFrustaModelBasal.Properties.VariableNames(5:end-3) = cellfun(@(x) strcat('basal', x), allFrustaModelBasal.Properties.VariableNames(5:end-3), 'UniformOutput', false);

apicalIds = table2array(allFrustaModelApical(:, [1:4 12]));
basalIds = table2array(allFrustaModelBasal(:, [1:4 12]));

[~, correspondanceIdBasalApical] = ismember(basalIds, apicalIds, 'rows');

allFrustaModel = horzcat(allFrustaModelApical(:, 1:end-3), allFrustaModelBasal(correspondanceIdBasalApical, 5:end));

noTransIds = table2array(voronoiModelNoTrans);
transIds = table2array(voronoiModelTrans);
vertexModel_noTransIds = table2array(allFrustaModel);

idsTubularModelTrans = transIds(:, [3:4 1:2 19]);
%idsTubularModelTrans = transIds(:, [1:4 19]);
idsTubularModelNoTrans = noTransIds(:, [1:4 19]);
idsVertexModel = vertexModel_noTransIds(:, [1:4 12]);

[~, correspondanceIdNoTrans] = ismember(idsTubularModelNoTrans, idsVertexModel, 'rows');
[~, correspondanceIdTrans] = ismember(idsTubularModelTrans, idsVertexModel, 'rows');

correspondanceIdNoTrans = correspondanceIdNoTrans(idsFilter, :);
correspondanceIdTrans = correspondanceIdTrans(idsFilter, :);

energyInfoVertexModelAllColTrans = allFrustaModel( correspondanceIdTrans, :);
energyInfoVertexModelAllColNoTrans = allFrustaModel(correspondanceIdNoTrans, :);



% allFrustaModelBasal = energyInfoVertexModelAllColTrans;
% allFrustaModelBasal.Properties.VariableNames(5:end-3) = cellfun(@(x) strcat('basal', x), allFrustaModelBasal.Properties.VariableNames(5:end-3), 'UniformOutput', false);
% 
% allFrustaModelMatching = horzcat(allFrustaModelBasal(:, 1:11), voronoiModelTrans(:, 5:11), voronoiModelTrans(:, end-2:end));
writetable(allFrustaModelMatching, 'frusta.xls');

[frustaEnergyTable, energyInfoVertexModel] = getEnergyInfo(allFrustaModel([correspondanceIdNoTrans correspondanceIdTrans], :));
[frustaNoTransEnergyTable, energyInfoVertexModelNoTran] = getEnergyInfo(allFrustaModel(correspondanceIdNoTrans, :));
[frustaTransEnergyTable, energyInfoVertexModelTran] = getEnergyInfo(allFrustaModel(correspondanceIdTrans, :));

[voronoiNoTransEnergyTable, energyInfoTubModNoTrans] = getEnergyInfo(voronoiModelNoTrans(idsFilter, :));
[voronoiTransEnergyTable, energyInfoTubModTrans] = getEnergyInfo(voronoiModelTrans(idsFilter, :));
[voronoiModelEnergyTable, energyInfoTubMod] = getEnergyInfo(vertcat(voronoiModelTrans(idsFilter, :), voronoiModelNoTrans(idsFilter, :)));

results =  horzcat( frustaEnergyTable,voronoiModelEnergyTable, frustaTransEnergyTable, frustaNoTransEnergyTable, voronoiTransEnergyTable, voronoiNoTransEnergyTable);

% [~, pValue1] = ttestDifferences(energyInfoVertexModel, energyInfoTubMod);
% [~, pValue2] = ttestDifferences(salivaryGlandEnergy, energyInfoTubMod);
% [~, pValue3] = ttestDifferences(salivaryGlandEnergy, energyInfoVertexModel);
% 
% 
% pValueResults = vertcat(pValue1, pValue2, pValue3);

% drawArrowBasalApical(energyInfoTubModNoTrans, 'Tubular Model - NoTransitions');
% drawArrowBasalApical(energyInfoTubModTrans, 'Tubular Model - Transitions');
% 
% drawArrowBasalApical(energyInfoVertexModel(1:100, :), 'Vertex Model - No Transitions');
% drawArrowBasalApical(energyInfoVertexModel(101:200, :), 'Vertex Model - Transitions');


 