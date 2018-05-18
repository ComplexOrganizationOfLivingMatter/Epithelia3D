function [ outputTable ] = computeTotalEnergy( transitionsFile, experimentName, applyEdgeThreshold )
%COMPUTETOTALENERGY Summary of this function goes here
%   Detailed explanation goes here

    noTransitionsFile = strrep(strrep(transitionsFile, 'Fake', ''), '_Transitions_', '_NoTransitions_');
    
    transitionsExcel = readtable(transitionsFile);
    noTransitionsExcel = readtable(noTransitionsFile);

    edgeLengthPositions = cellfun(@(x) isempty(strfind(lower(x), 'edgelength')) == 0, noTransitionsExcel.Properties.VariableNames);
    
    if applyEdgeThreshold
        noTransitionsExcel(any(noTransitionsExcel{:, edgeLengthPositions} <= 4, 2), :) = [];
        transitionsExcel(any(transitionsExcel{:, edgeLengthPositions} <= 4, 2), :) = [];
    end
    
    [noTransitionsEnergy, ~] = getEnergyInfo(noTransitionsExcel);
    [transitionsEnergy, ~] = getEnergyInfo(transitionsExcel);
    [tissueEnergy, ~] = getEnergyInfo(vertcat(transitionsExcel, noTransitionsExcel));
    
    outputTable = table(tissueEnergy, transitionsEnergy, noTransitionsEnergy);
    
    outputTable.Properties.VariableNames = cellfun(@(x) strcat(experimentName, '_', x), outputTable.Properties.VariableNames, 'UniformOutput', false);
    
end

