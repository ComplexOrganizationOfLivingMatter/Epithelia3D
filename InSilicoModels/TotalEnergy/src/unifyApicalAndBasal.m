function [ unifyModel ] = unifyApicalAndBasal( apicalInfo, basalInfo )
%UNIFYAPICALANDBASAL Summary of this function goes here
%   Detailed explanation goes here
    apicalInfo.Properties.VariableNames(5:end-3) = cellfun(@(x) strcat('apical', x), apicalInfo.Properties.VariableNames(5:end-3), 'UniformOutput', false);
    basalInfo.Properties.VariableNames(5:end-3) = cellfun(@(x) strcat('basal', x), basalInfo.Properties.VariableNames(5:end-3), 'UniformOutput', false);

    apicalIds = table2array(apicalInfo(:, [1:4 12]));
    basalIds = table2array(basalInfo(:, [1:4 12]));

    [basalFilter, correspondanceIdBasalApical] = ismember(basalIds, apicalIds, 'rows');
    
    if sum(correspondanceIdBasalApical == 0) > 0
        warning('Found motifs without correspondance between apical and basal')
    end
    correspondanceIdBasalApical(correspondanceIdBasalApical == 0) = [];
    
    unifyModel = horzcat(basalInfo(basalFilter, 1:end-3), apicalInfo(correspondanceIdBasalApical, 5:end));

end

