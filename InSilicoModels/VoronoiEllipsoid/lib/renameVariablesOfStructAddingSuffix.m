function [ newStruct ] = renameVariablesOfStructAddingSuffix( oldStruct, addedSuffix, variablesInclusion )
%RENAMEVARIABLESOFSTRUCTADDINGSUFFIX Summary of this function goes here
%   Detailed explanation goes here

    fieldNamesOldStruct = fieldnames(oldStruct);
    
    variablesToChange = zeros(size(fieldNamesOldStruct, 1), 1);
    for numVariable = 1:size(variablesInclusion, 2)
        variablesToChange = variablesToChange | cellfun(@(x) isempty(strfind(x, variablesInclusion{numVariable})) == 0, fieldNamesOldStruct);
    end
    
    fieldNamesOldStruct = fieldNamesOldStruct(variablesToChange);
    %Remove the marked fields that were changed by this method
    fieldNamesOldStruct = fieldNamesOldStruct(cellfun(@(x) x(end) ~= '_', fieldNamesOldStruct));
    
    newStruct = oldStruct;
    for numField = 1:size(fieldNamesOldStruct, 1)
        oldName = fieldNamesOldStruct{numField};
        newName = strcat(oldName, '_', addedSuffix, '_');
        [newStruct.(newName)] = newStruct.(oldName);
        newStruct = rmfield(newStruct, oldName);
    end

end

