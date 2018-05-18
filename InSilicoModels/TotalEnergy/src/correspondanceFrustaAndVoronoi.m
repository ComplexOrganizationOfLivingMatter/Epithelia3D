function [ allFrustaFakeTrans, allFrustaNoTrans,allFrustaFakeTransFiltered, allFrustaNoTransFiltered ] = correspondanceFrustaAndVoronoi( voronoiModelNoTrans, voronoiModelTrans, allFrustaModel )
%CORRESPONDANCEFRUSTAANDVORONOI Summary of this function goes here
%   Detailed explanation goes here

    idsFilter = 1:100;

    noTransIds = table2array(voronoiModelNoTrans);
    transIds = table2array(voronoiModelTrans);
    vertexModel_noTransIds = table2array(allFrustaModel);

    idsTubularModelTrans = transIds(:, [3:4 1:2 19]);
    %idsTubularModelTrans = transIds(:, [1:4 19]);
    idsTubularModelNoTrans = noTransIds(:, [1:4 19]);
    idsVertexModel = vertexModel_noTransIds(:, [1:4 19]);

    [~, correspondanceIdNoTrans] = ismember(idsTubularModelNoTrans, idsVertexModel, 'rows');
    [~, correspondanceIdTrans] = ismember(idsTubularModelTrans, idsVertexModel, 'rows');

    if sum(correspondanceIdTrans == 0) > 0 || sum(correspondanceIdNoTrans == 0) > 0
        warning('Found motifs without correspondance between frusta and voronoi')
    end
    correspondanceIdTrans(correspondanceIdTrans == 0) = [];
    correspondanceIdNoTrans(correspondanceIdNoTrans == 0) = [];
    
    correspondanceIdNoTransFiltered = correspondanceIdNoTrans(idsFilter, :);
    correspondanceIdTransFiltered = correspondanceIdTrans(idsFilter, :);
    
    allFrustaFakeTransFiltered = allFrustaModel( correspondanceIdTransFiltered, :);
    allFrustaNoTransFiltered = allFrustaModel(correspondanceIdNoTransFiltered, :);

    allFrustaFakeTrans = allFrustaModel( correspondanceIdTrans, :);
    allFrustaNoTrans = allFrustaModel(correspondanceIdNoTrans, :);

end

