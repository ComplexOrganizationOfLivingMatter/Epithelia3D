
% clear all
close all

addpath(genpath('..\voronoiEllipsoidModel\src'))
addpath (genpath('..\voronoiEllipsoidModel\lib'))
addpath(genpath('src'));

filePathFrustaStage8='results\Stage 8\';
filePathFrustaStage4='results\Stage 4\';
filePathVoronoiStage8='..\voronoiEllipsoidModel\results\Stage 8\';
filePathVoronoiStage4='..\voronoiEllipsoidModel\results\Stage 4\';

filePathFrustaGlobe = 'results\Globe\';
filePathFrustaRugby = 'results\Rugby\';
filePathVoronoiGlobe = '..\voronoiEllipsoidModel\results\Globe\';
filePathVoronoiRugby = '..\voronoiEllipsoidModel\results\Rugby\';

filePaths={filePathFrustaStage4,filePathFrustaStage8, filePathFrustaGlobe, filePathFrustaRugby};
    
for nPath=1:length(filePaths)
    
    if nPath==1
       numRandoms=[1:10,61:130];
       nCellHeight=1;
    else if nPath==2
       numRandoms=1:30; 
       nCellHeight=1;
        else
            numRandoms=1:10;
            nCellHeight=3;
        end
    end
  
            
    for cellHeight=1:nCellHeight
        tableNoTransitionEnergyFilterRandom=table();
        tableNoTransitionEnergyTotal=table();
        tableNoTransitionEnergyTotalNonPreservedMotifsOuter=table();
        tableNoTransitionEnergyTotalNonPreservedMotifsInner=table();
        tableTransitionEnergy = table();
        tableTransitionEnergyNonPreservedMotifsOuter = table();
        tableTransitionEnergyNonPreservedMotifsInner = table();

        for nRand=numRandoms
            
            try
                ellipsoidPath=dir([filePaths{nPath} '\randomizations\random_' num2str(nRand) '\*llipsoid*' ]);
                %if projectins are just created...load, else run the
                %maxProjections program
                splittedPath=strsplit(ellipsoidPath(cellHeight).name,'_');
                splittedCellHeight=splittedPath{end};
                [projectionsInnerWater,projectionsOuterWater,projectionsInnerVertices,projectionsOuterVertices,projectionsCellsConnectedToVertex] = checkMaxProjectionExist(ellipsoidPath,filePaths,nRand,nCellHeight,splittedCellHeight,nPath,cellHeight);
                
                [ tableTransitionEnergy, tableTransitionEnergyNonPreservedMotifsOuter, tableNoTransitionEnergyTotalNonPreservedMotifsInner, tableNoTransitionEnergyFilterRandom, tableNoTransitionEnergyTotal, tableNoTransitionEnergyTotalNonPreservedMotifsOuter] = getEnergyFromProjections( filePaths, nPath, projectionsInnerWater,  projectionsOuterWater, tableTransitionEnergy, tableTransitionEnergyNonPreservedMotifsOuter, tableNoTransitionEnergyTotalNonPreservedMotifsInner, tableNoTransitionEnergyFilterRandom, nRand, projectionsOuterVertices,projectionsCellsConnectedToVertex, tableNoTransitionEnergyTotal, tableNoTransitionEnergyTotalNonPreservedMotifsOuter);

                disp([filePaths{nPath} 'randomization ' num2str(nRand) '  -  ' splittedCellHeight(1:end-4)])
                
            catch err
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
         %saving tables
         if nCellHeight>1
            writetable(tableTransitionEnergy,[filePaths{nPath} 'energy\energyTransitionEdges_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyTotal,[filePaths{nPath} 'energy\energyNoTransitionEdges_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyFilterRandom,[filePaths{nPath} 'energy\energyNoTransitionEdgesFilter_' splittedCellHeight(1:end-4) '_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifsOuter,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_Outer_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifsInner,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_Inner_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsOuter,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_Outer_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsInner,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_Inner_' splittedCellHeight(1:end-4) '_' date '.xls'])

         else
            writetable(tableTransitionEnergy,[filePaths{nPath} 'energy\energyTransitionEdges_' date '.xls'])
            writetable(tableNoTransitionEnergyTotal,[filePaths{nPath} 'energy\energyNoTransitionEdges_' date '.xls'])
            writetable(tableNoTransitionEnergyFilterRandom,[filePaths{nPath} 'energy\energyNoTransitionEdgesFilter_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifsOuter,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_Outer_' date '.xls'])
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifsInner,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_Inner_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsOuter,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_Outer_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsInner,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_Inner_' date '.xls'])
         end
    

    end

 

end
    
    

    
    
    
