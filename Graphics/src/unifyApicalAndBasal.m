function [ unifyModel ] = unifyApicalAndBasal( apicalInfo, basalInfo )
%UNIFYAPICALANDBASAL Summary of this function goes here
%   Detailed explanation goes here
    apicalInfo.Properties.VariableNames(5:end-3) = cellfun(@(x) strcat('apical', x), apicalInfo.Properties.VariableNames(5:end-3), 'UniformOutput', false);
    basalInfo.Properties.VariableNames(5:end-3) = cellfun(@(x) strcat('basal', x), basalInfo.Properties.VariableNames(5:end-3), 'UniformOutput', false);

    apicalIds = table2array(apicalInfo(:, [1:4 12]));
    basalIds = table2array(basalInfo(:, [1:4 12]));

    [~, correspondanceIdBasalApical] = ismember(basalIds, apicalIds, 'rows');
    
    unifyModel = horzcat(apicalInfo(:, 1:end-3), basalInfo(correspondanceIdBasalApical, 5:end));

end

