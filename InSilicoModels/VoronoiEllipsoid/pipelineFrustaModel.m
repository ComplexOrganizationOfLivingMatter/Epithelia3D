clear
addpath(genpath('src'));
addpath(genpath('lib'));

resultFiles = getAllFiles('results/');
ellipsoidFiles = resultFiles(cellfun(@(x) isempty(strfind(x, '.mat')) == 0 & isempty(strfind(x, 'ellipsoid_x')) == 0, resultFiles));

parfor numEllipsoid = 1:size(ellipsoidFiles, 1)
    inputFile = ellipsoidFiles{numEllipsoid};
    
    if isempty(strfind(inputFile, 'Sphere'))
        disp(['NumEllipsoid: ' num2str(numEllipsoid)]);
        createFrustaModelFromApicalImage(inputFile)
    end
end


