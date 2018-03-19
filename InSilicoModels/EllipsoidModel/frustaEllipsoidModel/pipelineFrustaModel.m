clear
addpath(genpath('..\voronoiEllipsoidModel'));
addpath(genpath('src'));

resultFilesStage4 = getAllFiles('../voronoiEllipsoidModel/results/Stage 4/');
ellipsoidFilesStage4 = resultFilesStage4(cellfun(@(x) isempty(strfind(x, '.mat')) == 0 & isempty(strfind(x, 'ellipsoid_x')) == 0, resultFilesStage4));
resultFilesStage8 = getAllFiles('../voronoiEllipsoidModel/results/Stage 8/');
ellipsoidFilesStage8 = resultFilesStage8(cellfun(@(x) isempty(strfind(x, '.mat')) == 0 & isempty(strfind(x, 'ellipsoid_x')) == 0, resultFilesStage8));

resultFilesGlobe = getAllFiles('../voronoiEllipsoidModel/results/Globe/');
resultFilesGlobe = resultFilesGlobe(cellfun(@(x) isempty(strfind(x, '.mat')) == 0 & isempty(strfind(x, 'ellipsoid_x')) == 0, resultFilesGlobe));

resultFilesRugby = getAllFiles('../voronoiEllipsoidModel/results/Rugby/');
resultFilesRugby = resultFilesRugby(cellfun(@(x) isempty(strfind(x, '.mat')) == 0 & isempty(strfind(x, 'ellipsoid_x')) == 0, resultFilesRugby));



%ellipsoidFiles=[ellipsoidFilesStage4;ellipsoidFilesStage8];
ellipsoidFiles=[resultFilesGlobe; resultFilesRugby];

% stage8_ValidRandom = [1:5 7:8 10 13 15:17 19:20 22 25 26 29 30];
% stage4_ValidRandom = [7 15 19 20 25 33 36 39 46 61:64 69 80 81 96 102 106 119 124 135 145 150 154 162 170:172 180];

parfor numEllipsoid = 1:size(ellipsoidFiles, 1)
    validRandom = 0;
    inputFile = ellipsoidFiles{numEllipsoid};
    inputFileSplitted = strsplit(inputFile, '\');
    nameRandom = inputFileSplitted{end-1};
    numRandom = strsplit(nameRandom, '_');
    numRandom = str2double(numRandom{end});
    
    if isempty(strfind(inputFile, 'Sphere'))
%         if ismember(nameRandom, stage4_ValidRandom) && isempty(strfind(inputFile, 'Stage4'))
%             validRandom = 1;
%         elseif ismember(nameRandom, stage8_ValidRandom) && isempty(strfind(inputFile, 'Stage8'))
%             validRandom = 1;
%         end
        validRandom = 1;
        
        if validRandom
            disp(nameRandom);
            createFrustaModelFromApicalImage(inputFile)
        end
    end
end


