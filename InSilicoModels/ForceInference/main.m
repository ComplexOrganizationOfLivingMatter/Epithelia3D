
datFiles = dir('Sugimura_Results\ThirdRound\**\*.dat');

for numFile = 1:length(datFiles)
    actualFile = datFiles(numFile);
    forceInferenceInfo = readtable(strcat(actualFile.folder, '\', actualFile.name));
    readDatFile(
    if contains(lower(actualFile.folder), 'frustra')
        
    elseif contains(lower(actualFile.folder), 'voronoi')
        
    elseif contains(lower(actualFile.folder), 'initialframes')
        
    end
end