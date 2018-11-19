function getStatsAndRepresentationsEulerLewis3DAcummMeanStd(numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save)

    if ~exist(path2save,'dir')
        mkdir(path2save)
    end
    surfRatios = 1./(1:-0.1:0.1);
    
    totalNeigh = cat(1,numNeighPerSurface{:});
    totalNeighAccum = cat(1,numNeighAccumPerSurfaces{:});
    totalArea = cat(1,areaCellsPerSurface{:});
    totalVolume = cat(1,volumePerSurface{:});

    totalNeighApical = totalNeigh.('sr1');
    
    meanNeighBasal=cellfun(@(x) mean(x{:,:}),numNeighPerSurface,'UniformOutput',false);
    meanNeighBasalAcum=cellfun(@(x) mean(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);
    stdNeighBasal=cellfun(@(x) std(x{:,:}),numNeighPerSurface,'UniformOutput',false);
    stdNeighBasalAcum=cellfun(@(x) std(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);
    
    nUniqueNeighApical = unique(totalNeighApical);
    
    

    for SR = surfRatios 
        
        totalNeighBasal = totalNeigh.(['sr' strrep(num2str(SR),'.','_')]);
        totalNeighBasalAccum = totalNeighAccum.(['sr' strrep(num2str(SR),'.','_')]);
        totalVolumeBasal = totalVolume.(['sr' strrep(num2str(SR),'.','_')]);
        totalAreaBasal = totalArea.(['sr' strrep(num2str(SR),'.','_')]);
        totalAreaApical = totalArea.('sr1');
        
        nUniqueNeighBasal = unique(totalNeighBasal);
        nUniqueNeighBasalAccum = unique(totalNeighBasalAccum);  
        
        nCells = zeros(size(numNeighPerSurface,1),1);

        meanAreaApicalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        stdAreaApicalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        meanAreaApicalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        stdAreaApicalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        meanAreaApicalPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        stdAreaApicalPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        meanAreaBasalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        stdAreaBasalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        meanAreaBasalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        stdAreaBasalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        meanAreaBasalPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        stdAreaBasalPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        meanVolumePerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        stdVolumePerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        meanVolumePerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        stdVolumePerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        meanVolumePerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        stdVolumePerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        
        for nImg = 1:size(numNeighPerSurface,1)
            
            imgNeighBasal = numNeighPerSurface{nImg}.(['sr' strrep(num2str(SR),'.','_')]);
            imgNeighBasalAccum = numNeighAccumPerSurfaces{nImg}.(['sr' strrep(num2str(SR),'.','_')]);
            imgVolumeBasal = volumePerSurface{nImg}.(['sr' strrep(num2str(SR),'.','_')]);
            imgAreaBasal = areaCellsPerSurface{nImg}.(['sr' strrep(num2str(SR),'.','_')]);
            
            imgNeighApical = numNeighPerSurface{nImg}.('sr1');
            imgAreaApical = areaCellsPerSurface{nImg}.('sr1');

            nCells(nImg) = size(imgNeighBasal,1);
 
            %'1_1 area apical - n apical'
            meanAreaApicalPerSideApical(nImg,:) = arrayfun(@(x) mean(imgAreaApical(ismember(imgNeighApical,x))),nUniqueNeighApical);
            stdAreaApicalPerSideApical(nImg,:) = arrayfun(@(x) std(imgAreaApical(ismember(imgNeighApical,x))),nUniqueNeighApical);

            %'1_2 area apical - n basal'
            meanAreaApicalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaApical(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            stdAreaApicalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaApical(ismember(imgNeighBasal,x))),nUniqueNeighBasal);

            %'1_3 area apical - n basal accum'
            meanAreaApicalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaApical(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            stdAreaApicalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaApical(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);

            %'2_1 area basal - n apical'
            meanAreaBasalPerSideApical(nImg,:) = arrayfun(@(x) mean(imgAreaBasal(ismember(imgNeighApical,x))),nUniqueNeighApical);
            stdAreaBasalPerSideApical(nImg,:) = arrayfun(@(x) std(imgAreaBasal(ismember(imgNeighApical,x))),nUniqueNeighApical);

            %'2_2 area basal - n basal'
            meanAreaBasalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            stdAreaBasalPerSideBasal(nImg,:) = arrayfun(@(x) std(imgAreaBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);

            %'2_3 area basal - n basal accum'
            meanAreaBasalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaBasal(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            stdAreaBasalPerSideBasalAccum(nImg,:) = arrayfun(@(x) std(imgAreaBasal(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);

            %'3_1 volume - n apical'
            meanVolumePerSideApical(nImg,:) = arrayfun(@(x) mean(imgVolumeBasal(ismember(imgNeighApical,x))),nUniqueNeighApical);
            stdVolumePerSideApical(nImg,:) = arrayfun(@(x) std(imgVolumeBasal(ismember(imgNeighApical,x))),nUniqueNeighApical);

            %'3_2 volume - n basal'
            meanVolumePerSideBasal(nImg,:) = arrayfun(@(x) mean(imgVolumeBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            stdVolumePerSideBasal(nImg,:) = arrayfun(@(x) std(imgVolumeBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);

            %'3_3 Volume - n basal accum'
            meanVolumePerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgVolumeBasal(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            stdVolumePerSideBasalAccum(nImg,:) = arrayfun(@(x) std(imgVolumeBasal(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            
            %% Pooled Mean and Std calculation
            if nImg == 1
                nPool = nCells(nImg);
                                
                %'1_1 area apical - n apical'
                meanPoolAreaApicalPerSideApical = meanAreaApicalPerSideApical(nImg,:);
                stdPoolAreaApicalPerSideApical = stdAreaApicalPerSideApical(nImg,:);
                
                %'1_2 area apical - n basal'
                meanPoolAreaApicalPerSideBasal = meanAreaApicalPerSideBasal(nImg,:);
                stdPoolAreaApicalPerSideBasal = stdAreaApicalPerSideBasal(nImg,:);
                
                %'1_3 area apical - n basal accum'
                meanPoolAreaApicalPerSideBasalAccum = meanAreaApicalPerSideBasalAccum(nImg,:);
                stdPoolAreaApicalPerSideBasalAccum = stdAreaApicalPerSideBasalAccum(nImg,:);
                
                %'2_1 area basal - n apical'
                meanPoolAreaBasalPerSideApical = meanAreaBasalPerSideApical(nImg,:);
                stdPoolAreaBasalPerSideApical = stdAreaBasalPerSideApical(nImg,:);
                
                %'2_2 area basal - n basal'
                meanPoolAreaBasalPerSideBasal = meanAreaBasalPerSideBasal(nImg,:);
                stdPoolAreaBasalPerSideBasal = stdAreaBasalPerSideBasal(nImg,:);
                
                %'2_3 area basal - n basal accum'
                meanPoolAreaBasalPerSideBasalAccum = meanAreaBasalPerSideBasalAccum(nImg,:);
                stdPoolAreaBasalPerSideBasalAccum = stdAreaBasalPerSideBasalAccum(nImg,:);
                
                %'3_1 volume - n apical'
                meanPoolVolumePerSideApical = meanVolumePerSideApical(nImg,:);
                stdPoolVolumePerSideApical = stdVolumePerSideApical(nImg,:);
                
                %'3_2 volume - n basal'
                meanPoolVolumePerSideBasal = meanVolumePerSideBasal(nImg,:);
                stdPoolVolumePerSideBasal = stdVolumePerSideBasal(nImg,:);
                
                %'3_3 Volume - n basal accum'
                meanPoolVolumePerSideBasalAccum = meanVolumePerSideBasalAccum(nImg,:); 
                stdPoolVolumePerSideBasalAccum = stdVolumePerSideBasalAccum(nImg,:);
                
            else
                %'1_1 area apical - n apical'
                [~,meanPoolAreaApicalPerSideApical,stdPoolAreaApicalPerSideApical] = pooledmeanstd(nPool,meanPoolAreaApicalPerSideApical,stdPoolAreaApicalPerSideApical,nCells(nImg),meanAreaApicalPerSideApical(nImg,:),stdAreaApicalPerSideApical(nImg,:));

                %'1_2 area apical - n basal'
                [~,meanPoolAreaApicalPerSideBasal,stdPoolAreaApicalPerSideBasal] = pooledmeanstd(nPool,meanPoolAreaApicalPerSideBasal,stdPoolAreaApicalPerSideBasal,nCells(nImg),meanAreaApicalPerSideBasal(nImg,:),stdAreaApicalPerSideBasal(nImg,:));

                %'1_3 area apical - n basal accum'
                [~,meanPoolAreaApicalPerSideBasalAccum,stdPoolAreaApicalPerSideBasalAccum] = pooledmeanstd(nPool,meanPoolAreaApicalPerSideBasalAccum,stdPoolAreaApicalPerSideBasalAccum,nCells(nImg),meanAreaApicalPerSideBasalAccum(nImg,:),stdAreaApicalPerSideBasalAccum(nImg,:));
                
                %'2_1 area basal - n apical'
                [~,meanPoolAreaBasalPerSideApical,stdPoolAreaBasalPerSideApical] = pooledmeanstd(nPool,meanPoolAreaBasalPerSideApical,stdPoolAreaBasalPerSideApical,nCells(nImg),meanAreaBasalPerSideApical(nImg,:),stdAreaBasalPerSideApical(nImg,:));

                %'2_2 area basal - n basal'
                [~,meanPoolAreaBasalPerSideBasal,stdPoolAreaBasalPerSideBasal] = pooledmeanstd(nPool,meanPoolAreaBasalPerSideBasal,stdPoolAreaBasalPerSideBasal,nCells(nImg),meanAreaBasalPerSideBasal(nImg,:),stdAreaBasalPerSideBasal(nImg,:));

                %'2_3 area basal - n basal accum'
                [~,meanPoolAreaBasalPerSideBasalAccum,stdPoolAreaBasalPerSideBasalAccum] = pooledmeanstd(nPool,meanPoolAreaBasalPerSideBasalAccum,stdPoolAreaBasalPerSideBasalAccum,nCells(nImg),meanAreaBasalPerSideBasalAccum(nImg,:),stdAreaBasalPerSideBasalAccum(nImg,:));
                
                %'3_1 volume - n apical'
                [~,meanPoolVolumePerSideApical,stdPoolVolumePerSideApical] = pooledmeanstd(nPool,meanPoolVolumePerSideApical,stdPoolVolumePerSideApical,nCells(nImg),meanVolumePerSideApical(nImg,:),stdVolumePerSideApical(nImg,:));

                %'3_2 volume - n basal'
                [~,meanPoolVolumePerSideBasal,stdPoolVolumePerSideBasal] = pooledmeanstd(nPool,meanPoolVolumePerSideBasal,stdPoolVolumePerSideBasal,nCells(nImg),meanVolumePerSideBasal(nImg,:),stdVolumePerSideBasal(nImg,:));

                %'3_3 Volume - n basal accum'
                [nPool,meanPoolVolumePerSideBasalAccum,stdPoolVolumePerSideBasalAccum] = pooledmeanstd(nPool,meanPoolVolumePerSideBasalAccum,stdPoolVolumePerSideBasalAccum,nCells(nImg),meanVolumePerSideBasalAccum(nImg,:),stdVolumePerSideBasalAccum(nImg,:));
               
            end
        end
        
        h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        hold on
        %% ROW 1 -Area Apical VS Sides
        %1 area apical vs sides apical
        subplot(3,4,1) 
        errorbar(nUniqueNeighApical,meanPoolAreaApicalPerSideApical,stdPoolAreaApicalPerSideApical,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolAreaApicalPerSideApical,meanPoolAreaApicalPerSideBasal,meanPoolAreaApicalPerSideBasalAccum])+max([stdPoolAreaApicalPerSideApical,stdPoolAreaApicalPerSideBasal,stdPoolAreaApicalPerSideBasalAccum])])
        title('area apical - n apical')
        ylabel('area apical')
        xlabel('sides apical')

        %2 area apical vs sides basal
        subplot(3,4,2)
        errorbar(nUniqueNeighBasal,meanPoolAreaApicalPerSideBasal,stdPoolAreaApicalPerSideBasal,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolAreaApicalPerSideApical,meanPoolAreaApicalPerSideBasal,meanPoolAreaApicalPerSideBasalAccum])+max([stdPoolAreaApicalPerSideApical,stdPoolAreaApicalPerSideBasal,stdPoolAreaApicalPerSideBasalAccum])])
        title('area apical - n basal')
        ylabel('area apical')
        xlabel('sides basal')
        
        %3 area apical vs sides 3D
        subplot(3,4,3)
        errorbar(nUniqueNeighBasalAccum,meanPoolAreaApicalPerSideBasalAccum,stdPoolAreaApicalPerSideBasalAccum,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolAreaApicalPerSideApical,meanPoolAreaApicalPerSideBasal,meanPoolAreaApicalPerSideBasalAccum])+max([stdPoolAreaApicalPerSideApical,stdPoolAreaApicalPerSideBasal,stdPoolAreaApicalPerSideBasalAccum])])
        title('area apical - n basal accum')
        ylabel('area apical')
        xlabel('neighbours total')
        
        %4 Area Basal VS Area Apical
        subplot(3,4,4)
        plot(totalVolumeBasal,totalAreaApical,'o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        title('volume - area apical')
        ylabel('area apical')
        xlabel('volume')
             
        %% ROW 2 - Area basal VS sides
        %1 area basal vs sides apical
        subplot(3,4,5) 
        errorbar(nUniqueNeighApical,meanPoolAreaBasalPerSideApical,stdPoolAreaBasalPerSideApical,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolAreaBasalPerSideApical,meanPoolAreaBasalPerSideBasal,meanPoolAreaBasalPerSideBasalAccum])+max([stdPoolAreaBasalPerSideApical,stdPoolAreaBasalPerSideBasal,stdPoolAreaBasalPerSideBasalAccum])])
        title('area basal - n apical')
        ylabel('area basal')
        xlabel('sides apical')
        
        %2 area basal vs sides basal
        subplot(3,4,6)
        errorbar(nUniqueNeighBasal,meanPoolAreaBasalPerSideBasal,stdPoolAreaBasalPerSideBasal,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolAreaBasalPerSideApical,meanPoolAreaBasalPerSideBasal,meanPoolAreaBasalPerSideBasalAccum])+max([stdPoolAreaBasalPerSideApical,stdPoolAreaBasalPerSideBasal,stdPoolAreaBasalPerSideBasalAccum])])
        title('area basal - n basal')
        ylabel('area basal')
        xlabel('sides basal')
        
        %3 area basal vs sides 3D
        subplot(3,4,7)
        errorbar(nUniqueNeighBasalAccum,meanPoolAreaBasalPerSideBasalAccum,stdPoolAreaBasalPerSideBasalAccum,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolAreaBasalPerSideApical,meanPoolAreaBasalPerSideBasal,meanPoolAreaBasalPerSideBasalAccum])+max([stdPoolAreaBasalPerSideApical,stdPoolAreaBasalPerSideBasal,stdPoolAreaBasalPerSideBasalAccum])])
        title('area basal - n basal accum')
        ylabel('area basal')
        xlabel('neighbours total')
        
        %4 Area Basal VS Volume
        subplot(3,4,8)
        plot(totalVolumeBasal,totalAreaBasal,'o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        title('volume - area basal')
        ylabel('area basal')
        xlabel('volume')

        %% ROW 3 - Volume VS sides
        %1 volume vs sides apical
        subplot(3,4,9) 
        errorbar(nUniqueNeighApical,meanPoolVolumePerSideApical,stdPoolVolumePerSideApical,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolVolumePerSideApical,meanPoolVolumePerSideBasal,meanPoolVolumePerSideBasalAccum])+max([stdPoolVolumePerSideApical,stdPoolVolumePerSideBasal,stdPoolVolumePerSideBasalAccum])])
        title('volume - n apical')
        xlabel('sides apical')
        ylabel('volume')
        
        %2 volume vs sides basal
        subplot(3,4,10)
        errorbar(nUniqueNeighBasal,meanPoolVolumePerSideBasal,stdPoolVolumePerSideBasal,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolVolumePerSideApical,meanPoolVolumePerSideBasal,meanPoolVolumePerSideBasalAccum])+max([stdPoolVolumePerSideApical,stdPoolVolumePerSideBasal,stdPoolVolumePerSideBasalAccum])])
        title('volume - n basal')
        ylabel('volume')
        xlabel('sides basal')

        %3 volume vs sides 3D
        subplot(3,4,11)
        errorbar(nUniqueNeighBasalAccum,meanPoolVolumePerSideBasalAccum,stdPoolVolumePerSideBasalAccum,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanPoolVolumePerSideApical,meanPoolVolumePerSideBasal,meanPoolVolumePerSideBasalAccum])+max([stdPoolVolumePerSideApical,stdPoolVolumePerSideBasal,stdPoolVolumePerSideBasalAccum])])
        title('volume - n basal accum')
        ylabel('volume')
        xlabel('neighbours total')
        
        
        %4 Area Basal VS Area Apical
        subplot(3,4,12)
        plot(totalAreaApical,totalAreaBasal,'o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        title('area apical - area basal')
        ylabel('area basal')
        xlabel('area apical')
        
        print(h,[path2save 'lewis3D_SR' strrep(num2str(SR),'.','_')],'-dtiff','-r300')

        hold off
        close all
        
    end  

    %% Euler 3D
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');   
    meanPoolNeighBasalAcum = meanNeighBasalAcum{1,:};
    stdPoolNeighBasalAcum = stdNeighBasalAcum{1,:};
    nPool = nCells(1);
    for nImg = 2:length(nCells)
        [nPool,meanPoolNeighBasalAcum,stdPoolNeighBasalAcum]=pooledmeanstd(nPool,meanPoolNeighBasalAcum,stdPoolNeighBasalAcum,nCells(nImg),meanNeighBasalAcum{nImg,:},stdNeighBasalAcum{nImg,:});
    end
    
    errorbar(surfRatios,meanPoolNeighBasalAcum,stdPoolNeighBasalAcum,'-o','MarkerSize',5,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue')
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    print(h,[path2save 'euler3D'],'-dtiff','-r300')
    close all

    %% Euler 2D
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        
    meanPoolNeighBasal = meanNeighBasal{1,:};
    stdPoolNeighBasal = stdNeighBasal{1,:};
    nPool = nCells(1);
    for nImg = 2:length(nCells)
        [nPool,meanPoolNeighBasal,stdPoolNeighBasal]=pooledmeanstd(nPool,meanPoolNeighBasal,stdPoolNeighBasal,nCells(nImg),meanNeighBasal{nImg,:},stdNeighBasal{nImg,:});
    end
    
    errorbar(surfRatios,meanPoolNeighBasal,stdPoolNeighBasal,'-o','MarkerSize',5,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue')
    title('euler 2D - per surface')
    xlabel('surface ratio')
    ylabel('sides')
    ylim([0,10]);
    print(h,[path2save 'euler2D'],'-dtiff','-r300')
    close all

    
end

