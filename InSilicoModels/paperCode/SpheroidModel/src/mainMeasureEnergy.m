function [] = mainMeasureEnergy()
%MAINMEASUREENERGY 
% 
    originalDir = 'results';
    filePaths = dir(originalDir);
    filePaths = {filePaths(3:end).name};

    for nPath=1:length(filePaths)
        actualDir = strcat(originalDir, '\', filePaths{nPath}, '\');

        randomDirectories = dir(strcat(actualDir, '\randomizations\random_*'));
        numRandoms = 1:length(randomDirectories);

        cellHeightFiles = dir(strcat(actualDir, 'randomizations\random_1\*llipsoid_*cellHeight*'));

        nCellHeight = length(cellHeightFiles);

        for cellHeight=1:nCellHeight

            %Initialize tables to export
            tableTransitionEnergy=table();
            tableNoTransitionEnergy=table();
            tableTransitionEnergyNonPreservedMotifs=table();
            tableNoTransitionEnergyNonPreservedMotifs=table();
            tableTransitionEnergyAngleThreshold=table();
            tableNoTransitionEnergyAngleThreshold=table();
            tableTransitionEnergyNonPreservedMotifsAngleThreshold=table();
            tableNoTransitionEnergyNonPreservedMotifsAngleThreshold=table();

            for nRand=numRandoms

                try
                    ellipsoidPath=dir([actualDir '\randomizations\random_' num2str(nRand) '\*llipsoid*' ]);

                    splittedPath=strsplit(ellipsoidPath(cellHeight).name,'_');
                    splittedCellHeight=splittedPath{end};

                    [ projectionsInnerWater,projectionsOuterWater ] = checkMaxProjectionExist( actualDir, nRand, nCellHeight, splittedCellHeight );

                    %loading mask central cells in projection
                    maskFile = strcat(actualDir, 'maskInner.tif');
                    if exist(maskFile, 'file') 
                        maskImg = imread(maskFile);
                    else
                        h = figure; imshow(projectionsInnerWater{1})
                        disp('Select the ROI you want to analyze');
                        disp('When you finish, double click on the ellipsoid');
                        e = imellipse(gca);
                        wait(e);
                        maskImg = createMask(e);
                        close(h)
                        imwrite(maskImg, maskFile);
                    end
                    
                    for nProj=1:length(projectionsInnerWater)

                        if sum(size(maskImg) == size(projectionsInnerWater{nProj})) ~= 2
                            maskImg = imresize(maskImg, size(projectionsInnerWater{nProj}));
                        end
                        maskRoiInner=1-logical(maskImg(:, :, 1));
                        
                        %function for getting inner roi, edges, neighbours and valid cells
                        [innerRoiProjection,outerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,totalEdges,labelEdges]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{nProj},projectionsOuterWater{nProj});

                        % Calculate energy if there is any transition
                        for nLab=1:2
                            if ~isempty(totalEdges{nLab});

                                [dataEnergy,dataEnergyOuterNonPreservedMotifs,dataEnergyAngleThreshold,dataEnergyNonPreservedMotifsAngleThreshold,numberOfValidMotifs] = getEnergyFromEdges( projectionsOuterWater{nProj},innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,totalEdges{nLab},labelEdges{nLab});
                                [ tableTransitionEnergy,tableTransitionEnergyNonPreservedMotifs,tableNoTransitionEnergy,tableNoTransitionEnergyNonPreservedMotifs] = acumAndFilterEnergyData( tableTransitionEnergy,tableTransitionEnergyNonPreservedMotifs,tableNoTransitionEnergy,tableNoTransitionEnergyNonPreservedMotifs,dataEnergy,dataEnergyOuterNonPreservedMotifs,totalEdges,labelEdges{nLab},nRand);
                                [ tableTransitionEnergyAngleThreshold,tableTransitionEnergyNonPreservedMotifsAngleThreshold,tableNoTransitionEnergyAngleThreshold,tableNoTransitionEnergyNonPreservedMotifsAngleThreshold] = acumAndFilterEnergyData( tableTransitionEnergyAngleThreshold,tableTransitionEnergyNonPreservedMotifsAngleThreshold,tableNoTransitionEnergyAngleThreshold,tableNoTransitionEnergyNonPreservedMotifsAngleThreshold,dataEnergyAngleThreshold,dataEnergyNonPreservedMotifsAngleThreshold,totalEdges,labelEdges{nLab},nRand);

                            end
                        end
                    end

                    [actualDir 'randomization ' num2str(nRand) '  -  ' splittedCellHeight(1:end-4)]

                catch err
                    % If an error exists, capture it and save it on a logfile
                    disp('-------------ERROR--------------');
                    disp('See logFile');
                    fid = fopen('logFile','a+');
                    % write the error to file
                    % first line: message
                    fprintf(fid,'%s\r\n',['randomization ERROR:' num2str(nRand) '  -  ' actualDir '-' splittedCellHeight(1:end-4)]);
                    fprintf(fid,'%s\r\n',err.message);

                    fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));

                    % close file
                    fclose(fid);
                end


            end

            mkdir([actualDir 'energy\'])
            nameFile=strsplit(actualDir,'\');
            nameFile=nameFile{2};
            %saving tables
            writetable(tableTransitionEnergy,[actualDir 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_'  splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergy,[actualDir 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_'  splittedCellHeight(1:end-4) '_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableTransitionEnergyNonPreservedMotifs,[actualDir 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_NonPreservedMotifs_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyNonPreservedMotifs,[actualDir 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_NonPreservedMotifs_' splittedCellHeight(1:end-4) '_' date '.xls'])

            writetable(tableTransitionEnergyAngleThreshold,[actualDir 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_AngleThreshold_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyAngleThreshold,[actualDir 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_AngleThreshold_' splittedCellHeight(1:end-4) '_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableNoTransitionEnergyNonPreservedMotifsAngleThreshold,[actualDir 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_NonPreservedMotifs_AngleThreshold_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsAngleThreshold,[actualDir 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_NonPreservedMotifs_AngleThreshold_' splittedCellHeight(1:end-4) '_' date '.xls'])

        end
    end
end

