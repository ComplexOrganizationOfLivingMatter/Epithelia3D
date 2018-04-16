close all

filePathVoronoiStage8='results\Stage 8\';
filePathVoronoiStage4='results\Stage 4\';
filePathSphere='results\Sphere\';
filePathGlobe='results\Globe\';
filePathRugby='results\Rugby\';

filePaths={filePathVoronoiStage8,filePathVoronoiStage4,filePathGlobe,filePathRugby,filePathSphere};

for nPath=1:length(filePaths)
    numRandoms=1:10;
    if nPath==1
        nCellHeight=1;
    elseif nPath==2
        nCellHeight=1;
    else
        nCellHeight=3;
    end
    
    for cellHeight=nCellHeight
        
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
                ellipsoidPath=dir([filePaths{nPath} '\randomizations\random_' num2str(nRand) '\*llipsoid*' ]);
                
                splittedPath=strsplit(ellipsoidPath(cellHeight).name,'_');
                splittedCellHeight=splittedPath{end};
                
                [ projectionsInnerWater,projectionsOuterWater ] = checkMaxProjectionExist( filePaths{nPath}, nRand, nCellHeight, splittedCellHeight );
                
                %loading mask central cells in projection
                maskImg = imread([filePaths{nPath} 'maskInner.tif']);
                maskRoiInner=1-logical(maskImg(:, :, 1));
                for nProj=1:length(projectionsInnerWater)
                    
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
                
                [filePaths{nPath} 'randomization ' num2str(nRand) '  -  ' splittedCellHeight(1:end-4)]
                
            catch err
                % If an error exists, caputure it and save it on a logfile
                disp('-------------ERROR--------------');
                fid = fopen('logFile','a+');
                % write the error to file
                % first line: message
                fprintf(fid,'%s\r\n',['randomization ERROR:' num2str(nRand) '  -  ' filePaths{nPath} '-' splittedCellHeight(1:end-4)]);
                fprintf(fid,'%s\r\n',err.message);
                
                fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
                
                % close file
                fclose(fid);
            end
            
            
        end
        
        mkdir([filePaths{nPath} 'energy\'])
        nameFile=strsplit(filePaths{nPath},'\');
        nameFile=nameFile{2};
        %saving tables
        if nCellHeight>1
            writetable(tableTransitionEnergy,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_'  splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergy,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_'  splittedCellHeight(1:end-4) '_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableTransitionEnergyNonPreservedMotifs,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_NonPreservedMotifs_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyNonPreservedMotifs,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_NonPreservedMotifs_' splittedCellHeight(1:end-4) '_' date '.xls'])
            
            writetable(tableTransitionEnergyAngleThreshold,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_AngleThreshold_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyAngleThreshold,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_AngleThreshold_' splittedCellHeight(1:end-4) '_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableNoTransitionEnergyNonPreservedMotifsAngleThreshold,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_NonPreservedMotifs_AngleThreshold_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsAngleThreshold,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_NonPreservedMotifs_AngleThreshold_' splittedCellHeight(1:end-4) '_' date '.xls'])
            
        else
            
            writetable(tableTransitionEnergy,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_' date '.xls'])
            writetable(tableNoTransitionEnergy,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableTransitionEnergyNonPreservedMotifs,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_NonPreservedMotifs_' date '.xls'])
            writetable(tableNoTransitionEnergyNonPreservedMotifs,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_NonPreservedMotifs_' date '.xls'])
            
            writetable(tableTransitionEnergyAngleThreshold,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_AngleThreshold_' date '.xls'])
            writetable(tableNoTransitionEnergyAngleThreshold,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_AngleThreshold_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableNoTransitionEnergyNonPreservedMotifsAngleThreshold,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_NoTransition_NonPreservedMotifs_AngleThreshold_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsAngleThreshold,[filePaths{nPath} 'energy\spheroidVoronoiModelEnergy_' nameFile '_Transition_NonPreservedMotifs_AngleThreshold_' date '.xls'])
            
        end
    end
end

