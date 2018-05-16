function [ outputTable ] = computeTotalEnergy( transitionsFile, experimentName )
%COMPUTETOTALENERGY Summary of this function goes here
%   Detailed explanation goes here

    noTransitionsFile = strrep(strrep(transitionsFile, 'Fake', ''), '_Transitions_', '_NoTransitions_');
    
    transitionsExcel = readtable(transitionsFile);
    noTransitionsExcel = readtable(noTransitionsFile);

    [noTransitionsEnergy, ~] = getEnergyInfo(noTransitionsExcel);
    [transitionsEnergy, ~] = getEnergyInfo(transitionsExcel);
    [tissueEnergy, ~] = getEnergyInfo(vertcat(transitionsExcel, noTransitionsExcel));
    
    outputTable = table(tissueEnergy, transitionsEnergy, noTransitionsEnergy);
    
    outputTable.Properties.VariableNames = cellfun(@(x) strcat(experimentName, '_', x), outputTable.Properties.VariableNames, 'UniformOutput', false);
    
end

