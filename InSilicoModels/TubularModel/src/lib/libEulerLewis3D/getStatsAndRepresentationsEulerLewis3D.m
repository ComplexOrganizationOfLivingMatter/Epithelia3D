function getStatsAndRepresentationsEulerLewis3D(numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save)

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
            %'1_2 area apical - n basal'
            meanAreaApicalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaApical(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'1_3 area apical - n basal accum'
            meanAreaApicalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaApical(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            %'2_1 area basal - n apical'
            meanAreaBasalPerSideApical(nImg,:) = arrayfun(@(x) mean(imgAreaBasal(ismember(imgNeighApical,x))),nUniqueNeighApical);
            %'2_2 area basal - n basal'
            meanAreaBasalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'2_3 area basal - n basal accum'
            meanAreaBasalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaBasal(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            %'3_1 volume - n apical'
            meanVolumePerSideApical(nImg,:) = arrayfun(@(x) mean(imgVolumeBasal(ismember(imgNeighApical,x))),nUniqueNeighApical);
            %'3_2 volume - n basal'
            meanVolumePerSideBasal(nImg,:) = arrayfun(@(x) mean(imgVolumeBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'3_3 Volume - n basal accum'
            meanVolumePerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgVolumeBasal(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            
        end
        
        h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        hold on
        %% ROW 1 -Area Apical VS Sides
        %1 area apical vs sides apical
        subplot(3,4,1) 
        errorbar(nUniqueNeighApical,mean(meanAreaApicalPerSideApical),std(meanAreaApicalPerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
        title('area apical - n apical')
        ylabel('area apical')
        xlabel('sides apical')

        %2 area apical vs sides basal
        subplot(3,4,2)
        errorbar(nUniqueNeighBasal,mean(meanAreaApicalPerSideBasal),std(meanAreaApicalPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
        title('area apical - n basal')
        ylabel('area apical')
        xlabel('sides basal')
        
        %3 area apical vs sides 3D
        subplot(3,4,3)
        errorbar(nUniqueNeighBasalAccum,mean(meanAreaApicalPerSideBasalAccum),std(meanAreaApicalPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
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
        errorbar(nUniqueNeighApical,mean(meanAreaBasalPerSideApical),std(meanAreaBasalPerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
        title('area basal - n apical')
        ylabel('area basal')
        xlabel('sides apical')
        
        %2 area basal vs sides basal
        subplot(3,4,6)
        errorbar(nUniqueNeighBasal,mean(meanAreaBasalPerSideBasal),std(meanAreaBasalPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
        title('area basal - n basal')
        ylabel('area basal')
        xlabel('sides basal')
        
        %3 area basal vs sides 3D
        subplot(3,4,7)
        errorbar(nUniqueNeighBasalAccum,mean(meanAreaBasalPerSideBasalAccum),std(meanAreaBasalPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
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
        errorbar(nUniqueNeighApical,mean(meanVolumePerSideApical),std(meanVolumePerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
        title('volume - n apical')
        xlabel('sides apical')
        ylabel('volume')
        
        %2 volume vs sides basal
        subplot(3,4,10)
        errorbar(nUniqueNeighBasal,mean(meanVolumePerSideBasal),std(meanVolumePerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
        title('volume - n basal')
        ylabel('volume')
        xlabel('sides basal')

        %3 volume vs sides 3D
        subplot(3,4,11)
        errorbar(nUniqueNeighBasalAccum,mean(meanVolumePerSideBasalAccum),std(meanVolumePerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
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
    stdNeighBasalAcum = std(cat(1,meanNeighBasalAcum{:,:}));
    meanNeighBasalAcum = mean(cat(1,meanNeighBasalAcum{:,:}));
   
    errorbar(surfRatios,meanNeighBasalAcum,stdNeighBasalAcum,'-o','MarkerSize',5,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue')
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    ylim([0,15]);

    print(h,[path2save 'euler3D'],'-dtiff','-r300')
    close all

    %% Euler 2D
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    
    stdNeighBasal = std(cat(1,meanNeighBasal{:,:}));
    meanNeighBasal = mean(cat(1,meanNeighBasal{:,:}));
    
    errorbar(surfRatios,meanNeighBasal,stdNeighBasal,'-o','MarkerSize',5,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue')
    title('euler 2D - per surface')
    xlabel('surface ratio')
    ylabel('sides')
    ylim([0,10]);
    print(h,[path2save 'euler2D'],'-dtiff','-r300')
    close all

    
end

