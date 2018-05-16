function [ ] = computeTotalEnergy( transitionsFile )
%COMPUTETOTALENERGY Summary of this function goes here
%   Detailed explanation goes here

    noTransitionsFile = strrep(transitionsFile, '_Transitions_', '_NoTransitions_');
    
    transitionsExcel = readtable(transitionsFile);
    noTransitionsExcel = readtable(noTransitionsFile);

    [noTransDiffSummary, ~] = getEnergyInfo(noTransitionsExcel);
    [transDiffSummary, ~] = getEnergyInfo(transitionsExcel);
    [diffSummary, ~] = getEnergyInfo(vertcat(transitionsExcel, noTransitionsExcel));
end

