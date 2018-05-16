%% Salivary gland

addpath('src/');



fileCombinations = {'SalivaryGland', 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\FinalEnergyMeasurements\SalivaryGland\Unfiltered\energyMeasurements_TotalEnergy_Transitions_SalivaryGland_20x_40x_60x_19_02_2018.xls', '';
    'TubVoronoiModel_SR167' , 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\200Seeds_Energy\voronoiModelEnergy_200seeds_surfaceRatio1.6667_Transitions_05-Apr-2018.xls', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\energy_AllFrusta_200seeds\allFrustaEnergy_200seeds_surfaceRatio_1.6667_30-Mar-2018.xls';
    'EggChamber_Stage4', 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\FinalEnergyMeasurements\EggChamber\Unfiltered\energyMeasurements_eggChamber_Stage4_Transitions_19_02_2018.xls', '';
    
    'EggChamber_Stage8', 'D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\FinalEnergyMeasurements\EggChamber\Unfiltered\energyMeasurements_eggChamber_Stage8_Transitions_19_02_2018.xls', '';
    
};

outputTable = table();
for numExperiment = 1:length(fileCombinations(:, 1))
    
    experimentName = fileCombinations{numExperiment, 1};
    transFile = fileCombinations{numExperiment, 2};
    frustaFile = fileCombinations{numExperiment, 3};
    outputTable = horzcat(outputTable, computeTotalEnergy(transFile, experimentName));
    
    if isempty(frustaFile) == 0
        
        noTransitionsFile = strrep(transFile, '_Transitions_', '_NoTransitions_');
        noTransitionsFile = strrep(noTransitionsFile, 'Fake', '');
        voronoiTransitionsExcel = readtable(transFile);
        voronoiNoTransitionsExcel = readtable(noTransitionsFile);
        
        [ allFrustaFakeTrans, allFrustaNoTrans, ~, ~] = correspondanceFrustaAndVoronoi( readtable(noTransitionsFile), readtable(transFile), readtable(frustaFile) );
        positions = strfind(frustaFile, '_');
        
        writetable(allFrustaNoTrans, strcat(frustaFile(1:positions(end)), 'NoTransitions_', frustaFile(positions(end)+1:length(frustaFile))));
        frustaTransFile = strcat(frustaFile(1:positions(end)), 'FakeTransitions_', frustaFile(positions(end)+1:length(frustaFile)));
        writetable(allFrustaFakeTrans, frustaTransFile);
        
        outputTable = horzcat(outputTable, computeTotalEnergy(frustaTransFile, strcat('Frusta_', experimentName)));
    end
end
