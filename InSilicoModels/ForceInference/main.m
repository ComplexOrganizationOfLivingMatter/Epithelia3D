
addpath(genpath('src'))

datFiles = dir('Sugimura_Results\ThirdRound\**\*.dat');

for numFile = 1:length(datFiles)
    actualFile = datFiles(numFile);
    forceInferenceInfo = readDatFile(strcat(actualFile.folder, '\', actualFile.name));
    
    
    if contains(lower(actualFile.folder), 'frustra')
        
    elseif contains(lower(actualFile.folder), 'voronoi')
        
    elseif contains(lower(actualFile.folder), 'initialframes')
        
    end
end