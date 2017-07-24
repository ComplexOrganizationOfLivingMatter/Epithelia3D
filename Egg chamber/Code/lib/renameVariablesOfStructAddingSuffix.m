function [ newStruct ] = renameVariablesOfStructAddingSuffix( oldStruct, additionSuffix )
%RENAMEVARIABLESOFSTRUCTADDINGSUFFIX Summary of this function goes here
%   Detailed explanation goes here
            newName = 'baz';
        oldName = 'bar';
    [a.(newName)] = a.(oldName);
    a = rmfield(a,oldName);

end

