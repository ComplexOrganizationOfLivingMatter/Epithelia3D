
numSeeds = '200';
surfaceRatio = '1.6667';

voronoiModelNoTrans = readtable(strcat('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\AngleThreshold\Voronoi\Matching_Apical_Basal\unfiltered\voronoiModelEnergy_', numSeeds,'seeds_surfaceRatio', surfaceRatio,'_NoTransitions_AngleThreshold_02-Apr-2018.xls'));
voronoiModelTrans = readtable(strcat('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\AngleThreshold\Voronoi\Matching_Apical_Basal\unfiltered\voronoiModelEnergy_', numSeeds,'seeds_surfaceRatio', surfaceRatio,'_Transitions_AngleThreshold_02-Apr-2018.xls'));

allFrustaModel_Apical = readtable(strcat('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\AngleThreshold\AllFrusta\AllMotifs\allFrustaEnergy_', numSeeds,'seeds_surfaceRatio_1_AngleThreshold_02-Apr-2018.xls'));
allFrustaModel_Basal = readtable(strcat('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\docs\AngleThreshold\AllFrusta\AllMotifs\allFrustaEnergy_', numSeeds,'seeds_surfaceRatio_', surfaceRatio,'_AngleThreshold_02-Apr-2018.xls'));

[ allFrustaModel ] = unifyApicalAndBasal( allFrustaModel_Apical, allFrustaModel_Basal );

[ allFrustaFakeTrans, allFrustaNoTrans, allFrustaFakeTransFiltered, allFrustaNoTransFiltered  ] = correspondanceFrustaAndVoronoi( voronoiModelNoTrans, voronoiModelTrans, allFrustaModel );

writetable(allFrustaNoTrans, strcat('allFrustaEnergy_', numSeeds,'seeds_surfaceRatio_', surfaceRatio,'_NoTransitions_AngleThreshold_02-Apr-2018.xls'));
writetable(allFrustaFakeTrans, strcat('allFrustaEnergy_', numSeeds,'seeds_surfaceRatio_', surfaceRatio,'_FakeTransitions_AngleThreshold_02-Apr-2018.xls'));
writetable(allFrustaNoTransFiltered, strcat('allFrustaEnergy_', numSeeds,'seeds_surfaceRatio_', surfaceRatio,'_NoTransitions_filtered_AngleThreshold_02-Apr-2018.xls'));
writetable(allFrustaFakeTransFiltered, strcat('allFrustaEnergy_', numSeeds,'seeds_surfaceRatio_', surfaceRatio,'_FakeTransitions_filtered_AngleThreshold_02-Apr-2018.xls'));