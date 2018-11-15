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
    totalAreaApical = totalArea.('sr1');
    
    nUniqueNeighApical = unique(totalNeighApical);
    
    %'1_1 area apical - n apical'
    meanAreaApicalPerSideApical = arrayfun(@(x) mean(totalAreaApical(ismember(totalNeighApical,x))),nUniqueNeighApical);
    stdAreaApicalPerSideApical = arrayfun(@(x) std(totalAreaApical(ismember(totalNeighApical,x))),nUniqueNeighApical);

    for SR = surfRatios 
        totalNeighBasal = totalNeigh.(['sr' strrep(num2str(SR),'.','_')]);
        totalNeighBasalAccum = totalNeighAccum.(['sr' strrep(num2str(SR),'.','_')]);
        totalVolumeBasal = totalVolume.(['sr' strrep(num2str(SR),'.','_')]);
        totalAreaBasal = totalArea.(['sr' strrep(num2str(SR),'.','_')]);

        nUniqueNeighBasal = unique(totalNeighBasal);
        nUniqueNeighBasalAccum = unique(totalNeighBasalAccum);    
        
        %'1_2 area apical - n basal'
        meanAreaApicalPerSideBasal = arrayfun(@(x) mean(totalAreaApical(ismember(totalNeighBasal,x))),nUniqueNeighBasal);
        stdAreaApicalPerSideBasal = arrayfun(@(x) mean(totalAreaApical(ismember(totalNeighBasal,x))),nUniqueNeighBasal);
        
        %'1_3 area apical - n basal accum'
        meanAreaApicalPerSideBasalAccum = arrayfun(@(x) mean(totalAreaApical(ismember(totalNeighBasalAccum,x))),nUniqueNeighBasalAccum);
        stdAreaApicalPerSideBasalAccum = arrayfun(@(x) mean(totalAreaApical(ismember(totalNeighBasalAccum,x))),nUniqueNeighBasalAccum);
        
        %'2_1 area basal - n apical'
        meanAreaBasalPerSideApical = arrayfun(@(x) mean(totalAreaBasal(ismember(totalNeighApical,x))),nUniqueNeighApical);
        stdAreaBasalPerSideApical = arrayfun(@(x) std(totalAreaBasal(ismember(totalNeighApical,x))),nUniqueNeighApical);
        
        %'2_2 area basal - n basal'
        meanAreaBasalPerSideBasal = arrayfun(@(x) mean(totalAreaBasal(ismember(totalNeighBasal,x))),nUniqueNeighBasal);
        stdAreaBasalPerSideBasal = arrayfun(@(x) std(totalAreaBasal(ismember(totalNeighBasal,x))),nUniqueNeighBasal);
        
        %'2_3 area basal - n basal accum'
        meanAreaBasalPerSideBasalAccum = arrayfun(@(x) mean(totalAreaBasal(ismember(totalNeighBasalAccum,x))),nUniqueNeighBasalAccum);
        stdAreaBasalPerSideBasalAccum = arrayfun(@(x) std(totalAreaBasal(ismember(totalNeighBasalAccum,x))),nUniqueNeighBasalAccum);
        
        %'3_1 volume - n apical'
        meanVolumePerSideApical = arrayfun(@(x) mean(totalVolumeBasal(ismember(totalNeighApical,x))),nUniqueNeighApical);
        stdVolumePerSideApical = arrayfun(@(x) std(totalVolumeBasal(ismember(totalNeighApical,x))),nUniqueNeighApical);
        
        %'3_2 volume - n basal'
        meanVolumePerSideBasal = arrayfun(@(x) mean(totalVolumeBasal(ismember(totalNeighBasal,x))),nUniqueNeighBasal);
        stdVolumePerSideBasal = arrayfun(@(x) std(totalVolumeBasal(ismember(totalNeighBasal,x))),nUniqueNeighBasal);
        
        %'3_3 Volume - n basal accum'
        meanVolumePerSideBasalAccum = arrayfun(@(x) mean(totalVolumeBasal(ismember(totalNeighBasalAccum,x))),nUniqueNeighBasalAccum);
        stdVolumePerSideBasalAccum = arrayfun(@(x) std(totalVolumeBasal(ismember(totalNeighBasalAccum,x))),nUniqueNeighBasalAccum);
        
        h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        hold on
        %% ROW 1 -Area Apical VS Sides
        %1 area apical vs sides apical
        subplot(3,4,1) 
        errorbar(nUniqueNeighApical,meanAreaApicalPerSideApical,stdAreaApicalPerSideApical,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical;meanAreaApicalPerSideBasal;meanAreaApicalPerSideBasalAccum])+max([stdAreaApicalPerSideApical;stdAreaApicalPerSideBasal;stdAreaApicalPerSideBasalAccum])])
        title('area apical - n apical')
        ylabel('area apical')
        xlabel('sides apical')

        %2 area apical vs sides basal
        subplot(3,4,2)
        errorbar(nUniqueNeighBasal,meanAreaApicalPerSideBasal,stdAreaApicalPerSideBasal,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical;meanAreaApicalPerSideBasal;meanAreaApicalPerSideBasalAccum])+max([stdAreaApicalPerSideApical;stdAreaApicalPerSideBasal;stdAreaApicalPerSideBasalAccum])])
        title('area apical - n basal')
        ylabel('area apical')
        xlabel('sides basal')
        
        %3 area apical vs sides 3D
        subplot(3,4,3)
        errorbar(nUniqueNeighBasalAccum,meanAreaApicalPerSideBasalAccum,stdAreaApicalPerSideBasalAccum,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical;meanAreaApicalPerSideBasal;meanAreaApicalPerSideBasalAccum])+max([stdAreaApicalPerSideApical;stdAreaApicalPerSideBasal;stdAreaApicalPerSideBasalAccum])])
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
        errorbar(nUniqueNeighApical,meanAreaBasalPerSideApical,stdAreaBasalPerSideApical,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical;meanAreaBasalPerSideBasal;meanAreaBasalPerSideBasalAccum])+max([stdAreaBasalPerSideApical;stdAreaBasalPerSideBasal;stdAreaBasalPerSideBasalAccum])])
        title('area basal - n apical')
        ylabel('area basal')
        xlabel('sides apical')
        
        %2 area basal vs sides basal
        subplot(3,4,6)
        errorbar(nUniqueNeighBasal,meanAreaBasalPerSideBasal,stdAreaBasalPerSideBasal,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical;meanAreaBasalPerSideBasal;meanAreaBasalPerSideBasalAccum])+max([stdAreaBasalPerSideApical;stdAreaBasalPerSideBasal;stdAreaBasalPerSideBasalAccum])])
        title('area basal - n basal')
        ylabel('area basal')
        xlabel('sides basal')
        
        %3 area basal vs sides 3D
        subplot(3,4,7)
        errorbar(nUniqueNeighBasalAccum,meanAreaBasalPerSideBasalAccum,stdAreaBasalPerSideBasalAccum,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical;meanAreaBasalPerSideBasal;meanAreaBasalPerSideBasalAccum])+max([stdAreaBasalPerSideApical;stdAreaBasalPerSideBasal;stdAreaBasalPerSideBasalAccum])])
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
        errorbar(nUniqueNeighApical,meanVolumePerSideApical,stdVolumePerSideApical,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical;meanVolumePerSideBasal;meanVolumePerSideBasalAccum])+max([stdVolumePerSideApical;stdVolumePerSideBasal;stdVolumePerSideBasalAccum])])
        title('volume - n apical')
        xlabel('sides apical')
        ylabel('volume')
        
        %2 volume vs sides basal
        subplot(3,4,10)
        errorbar(nUniqueNeighBasal,meanVolumePerSideBasal,stdVolumePerSideBasal,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical;meanVolumePerSideBasal;meanVolumePerSideBasalAccum])+max([stdVolumePerSideApical;stdVolumePerSideBasal;stdVolumePerSideBasalAccum])])
        title('volume - n basal')
        ylabel('volume')
        xlabel('sides basal')

        %3 volume vs sides 3D
        subplot(3,4,11)
        errorbar(nUniqueNeighBasalAccum,meanVolumePerSideBasalAccum,stdVolumePerSideBasalAccum,'-o','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical;meanVolumePerSideBasal;meanVolumePerSideBasalAccum])+max([stdVolumePerSideApical;stdVolumePerSideBasal;stdVolumePerSideBasalAccum])])
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
    
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    averageNeighBasalAccum = mean(table2array(totalNeighAccum));
    stdNeighBasalAccum = std(table2array(totalNeighAccum));
    errorbar(surfRatios,averageNeighBasalAccum,stdNeighBasalAccum,'-o','MarkerSize',5,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue')
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    print(h,[path2save 'euler3D'],'-dtiff','-r300')
    close all

    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    averageNeighBasal = mean(table2array(totalNeigh));
    stdNeighBasal = std(table2array(totalNeigh));
    errorbar(surfRatios,averageNeighBasal,stdNeighBasal,'-o','MarkerSize',5,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue')
    title('euler 2D - per surface')
    xlabel('surface ratio')
    ylabel('sides')
    print(h,[path2save 'euler2D'],'-dtiff','-r300')
    close all

    
end

