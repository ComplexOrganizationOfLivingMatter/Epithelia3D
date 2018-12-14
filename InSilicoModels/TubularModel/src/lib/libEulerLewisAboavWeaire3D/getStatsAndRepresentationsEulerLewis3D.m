function getStatsAndRepresentationsEulerLewis3D(numNeighOfNeighPerSurface,numNeighOfNeighAccumPerSurface,numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save,surfRatios)

    if ~exist(path2save,'dir')
        mkdir(path2save)
    end
    
    totalNeigh = cat(1,numNeighPerSurface{:});
    totalNeighAccum = cat(1,numNeighAccumPerSurfaces{:});
    totalNeighOfNeigh = cat(1,numNeighOfNeighPerSurface{:});
    totalNeighOfNeighAccum = cat(1,numNeighOfNeighAccumPerSurface{:});
    totalArea = cat(1,areaCellsPerSurface{:});
    totalVolume = cat(1,volumePerSurface{:});

    totalNeighApical = totalNeigh.('sr1');
    
    meanNeighBasal=cellfun(@(x) mean(x{:,:}),numNeighPerSurface,'UniformOutput',false);
    meanNeighBasalAcum=cellfun(@(x) mean(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);
    
    nUniqueNeighApical = unique(totalNeighApical);
    
    colorSR = bone(length(surfRatios));
    colorSR2 = jet(length(surfRatios));


    for SR = 1:length(surfRatios)
        
        totalNeighBasal = totalNeigh.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
        totalNeighBasalAccum = totalNeighAccum.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
        totalVolumeBasal = totalVolume.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
        totalAreaBasal = totalArea.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
        totalAreaApical = totalArea.('sr1');
        
        nUniqueNeighBasal = unique(totalNeighBasal);
        nUniqueNeighBasalAccum = unique(totalNeighBasalAccum);  
        
        nCells = zeros(size(numNeighPerSurface,1),1);

        meanAreaApicalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        stdAreaApicalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        meanAreaApicalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        stdAreaApicalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        
        meanNeighOfNeighPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        stdNeighOfNeighPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        meanNeighOfNeighAccumPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        stdNeighOfNeighAccumPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        
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
            
            imgNeighBasal = numNeighPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            imgNeighBasalAccum = numNeighAccumPerSurfaces{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgNeighOfNeighBasal = numNeighOfNeighPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            imgNeighOfNeighBasalAccum = numNeighOfNeighAccumPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgVolumeBasal = volumePerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            imgAreaBasal = areaCellsPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
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
            
            %'4_1 Neigh of neigh - n basal'
            meanNeighOfNeighPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgNeighOfNeighBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'4_2 Neigh of neigh accum - n basal accum'
            meanNeighOfNeighAccumPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgNeighOfNeighBasalAccum(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);

        end
        
        h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        hold on
        %% ROW 1 -Area Apical VS Sides
        %1 area apical vs sides apical
        subplot(3,4,1) 
        errorbar(nUniqueNeighApical,mean(meanAreaApicalPerSideApical),std(meanAreaApicalPerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
        title('area apical - n apical')
        ylabel('area apical')
        xlabel('sides apical')

        %2 area apical vs sides basal
        subplot(3,4,2)
        errorbar(nUniqueNeighBasal,mean(meanAreaApicalPerSideBasal),std(meanAreaApicalPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
        title('area apical - n basal')
        ylabel('area apical')
        xlabel('sides basal')
        
        %3 area apical vs sides 3D
        subplot(3,4,3)
        errorbar(nUniqueNeighBasalAccum,mean(meanAreaApicalPerSideBasalAccum),std(meanAreaApicalPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
        title('area apical - n basal accum')
        ylabel('area apical')
        xlabel('neighbours total')
        
        %4 volume VS Area Apical
        subplot(3,4,4)
        plot(totalVolumeBasal,totalAreaApical,'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        title('volume - area apical')
        ylabel('area apical')
        xlabel('volume')
             
        %% ROW 2 - Area basal VS sides
        %1 area basal vs sides apical
        subplot(3,4,5) 
        errorbar(nUniqueNeighApical,mean(meanAreaBasalPerSideApical),std(meanAreaBasalPerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
        title('area basal - n apical')
        ylabel('area basal')
        xlabel('sides apical')
        
        %2 area basal vs sides basal
        subplot(3,4,6)
        errorbar(nUniqueNeighBasal,mean(meanAreaBasalPerSideBasal),std(meanAreaBasalPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
        title('area basal - n basal')
        ylabel('area basal')
        xlabel('sides basal')
        
        %3 area basal vs sides 3D
        subplot(3,4,7)
        errorbar(nUniqueNeighBasalAccum,mean(meanAreaBasalPerSideBasalAccum),std(meanAreaBasalPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
        title('area basal - n basal accum')
        ylabel('area basal')
        xlabel('neighbours total')
        
        %4 Area Basal VS Volume
        subplot(3,4,8)
        plot(totalVolumeBasal,totalAreaBasal,'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        title('volume - area basal')
        ylabel('area basal')
        xlabel('volume')

        %% ROW 3 - Volume VS sides
        %1 volume vs sides apical
        subplot(3,4,9) 
        errorbar(nUniqueNeighApical,mean(meanVolumePerSideApical),std(meanVolumePerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
        title('volume - n apical')
        xlabel('sides apical')
        ylabel('volume')
        
        %2 volume vs sides basal
        subplot(3,4,10)
        errorbar(nUniqueNeighBasal,mean(meanVolumePerSideBasal),std(meanVolumePerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
        title('volume - n basal')
        ylabel('volume')
        xlabel('sides basal')

        %3 volume vs sides 3D
        subplot(3,4,11)
        errorbar(nUniqueNeighBasalAccum,mean(meanVolumePerSideBasalAccum),std(meanVolumePerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
        title('volume - n basal accum')
        ylabel('volume')
        xlabel('neighbours total')
        
        
        %4 Area Basal VS Area Apical
        subplot(3,4,12)
        plot(totalAreaApical,totalAreaBasal,'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        title('area apical - area basal')
        ylabel('area basal')
        xlabel('area apical')
        
        print(h,[path2save 'lewis3D_SR' strrep(num2str(surfRatios(SR)),'.','_')],'-dtiff','-r300')

        hold off
%         close(gcf)
        
        
        %% Aboav-weaire 2d + 3d
        %1 nNeighOfNeighAccum VS n basal accum
        h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        subplot(1,2,1)
        errorbar(nUniqueNeighBasal,mean(meanNeighOfNeighPerSideBasal),std(meanNeighOfNeighPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        hold on
        plot(nUniqueNeighBasal,5+6./nUniqueNeighBasal,'--','MarkerSize',2)
        hold off
        title('nNeighOfNeigh - n basal')
        ylabel('nNeighOfNeigh basal')
        xlabel('sides basal')

        %2 nNeighOfNeigh VS n basal
        subplot(1,2,2)
        errorbar(nUniqueNeighBasalAccum,mean(meanNeighOfNeighAccumPerSideBasalAccum),std(meanNeighOfNeighAccumPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','blue')
        hold on
        plot(nUniqueNeighBasalAccum,5+6./nUniqueNeighBasalAccum,'--','MarkerSize',2)
        hold off
        title('nNeighOfNeigh accum - n basal accum')
        ylabel('nNeighOfNeigh accum')
        xlabel('neighbours total')
        print(h,[path2save 'Aboav-weaire 2D_3D_SR' strrep(num2str(surfRatios(SR)),'.','_')],'-dtiff','-r300')
        close(h)
        
        %% Paper figures 
        %%Lewis 3D - volume vs sides 3D
        figure(90);
        hold on
        meanVolAc = mean(meanVolumePerSideBasalAccum);
        nanNames = isnan(meanVolAc);
        if exist('xNoNaN','var')
           xNoNaNpreviousVol = xNoNaNVol'; 
           yNoNaNpreviousVol = yNoNaNVol;
           xNoNaNVol = nUniqueNeighBasalAccum(~nanNames);
           yNoNaNVol = meanVolAc(~nanNames);
           rowx = [xNoNaNpreviousVol(1) xNoNaNVol(1) xNoNaNVol' xNoNaNVol(end) fliplr(xNoNaNpreviousVol)];
           rowy = [yNoNaNpreviousVol(1) yNoNaNVol(1) yNoNaNVol yNoNaNVol(end) fliplr(yNoNaNpreviousVol)];
           fill(rowx,rowy,colorSR(SR,:),'FaceAlpha',0.5,'EdgeColor','none','DisplayName',['Sr ' num2str(surfRatios(SR))],'HandleVisibility','off')
           plot(xNoNaNpreviousVol,yNoNaNpreviousVol,'--o','MarkerFaceColor',colorSR(SR,:),'Color',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName',['Sr ' num2str(surfRatios(SR))],'HandleVisibility','off')
        end
        xNoNaNVol = nUniqueNeighBasalAccum(~nanNames);
        yNoNaNVol = meanVolAc(~nanNames);
        plot(xNoNaNVol',yNoNaNVol,'--o','MarkerFaceColor',colorSR(SR,:),'Color',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName',['Sr ' num2str(surfRatios(SR))])

        hold off
%         errorbar(nUniqueNeighBasalAccum,mean(meanVolumePerSideBasalAccum),std(meanVolumePerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorSR(SR,:),'DisplayName',['surface ratio: ' num2str(surfRatios(SR))])
%         
        %%aboav-weire 3D
        figure(100);
        hold on
        meanNeigNeigh = mean(meanNeighOfNeighAccumPerSideBasalAccum);
        nanNames = isnan(meanNeigNeigh);
        if exist('xNoNaN','var')
           xNoNaNprevious = xNoNaN'; 
           yNoNaNprevious = yNoNaN;
           xNoNaN = nUniqueNeighBasalAccum(~nanNames);
           yNoNaN = meanNeigNeigh(~nanNames);
           rowx = [xNoNaNprevious(1) xNoNaN(1) xNoNaN' xNoNaN(end) fliplr(xNoNaNprevious)];
           rowy = [yNoNaNprevious(1) yNoNaN(1) yNoNaN yNoNaN(end) fliplr(yNoNaNprevious)];
           fill(rowx,rowy,colorSR(SR,:),'FaceAlpha',0.5,'EdgeColor','none','DisplayName',['Sr ' num2str(surfRatios(SR))],'HandleVisibility','off')
           plot(xNoNaNprevious,yNoNaNprevious,'--o','MarkerFaceColor',colorSR(SR,:),'Color',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName',['Sr ' num2str(surfRatios(SR))],'HandleVisibility','off')
        end
        xNoNaN = nUniqueNeighBasalAccum(~nanNames);
        yNoNaN = meanNeigNeigh(~nanNames);
        plot(xNoNaN',yNoNaN,'--o','MarkerFaceColor',colorSR(SR,:),'Color',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName',['Sr ' num2str(surfRatios(SR))])

%         errorbar(nUniqueNeighBasalAccum,mean(meanNeighOfNeighAccumPerSideBasalAccum),std(meanNeighOfNeighAccumPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor',colorSR(SR,:),'MarkerFaceColor',colorSR(SR,:),'DisplayName',['Sr ' num2str(surfRatios(SR))])
        hold off
        
    end  
    

    figure(90);
    set(gcf, 'Position', get(0, 'Screensize'));
    title('volume - n basal accum')
    ylabel('volume')
    xlabel('neighbours total')
    legend('Location','best')
    print(gcf,[path2save 'Lewis_3D'],'-dtiff','-r300')
    close(gcf)
    
    figure(100);
    set(gcf, 'Position', get(0, 'Screensize'));
    title('nNeighOfNeigh accum - n basal accum')
    ylabel('nNeighOfNeigh accum')
    xlabel('neighbours total')
    legend('Location','best')
    hold on;
    xl = xlim;
    plot([xl(1):xl(end)],5+6./[xl(1):xl(end)],'--','MarkerSize',2,'MarkerEdgeColor',colorSR(SR,:),'DisplayName','Theoretical')
    ylim([4.5,inf])
    print(gcf,[path2save 'Aboav-weaire_3D'],'-dtiff','-r300')
    close(gcf)
    
    %% Euler 3D
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');   
    stdNeighBasalAcum = std(cat(1,meanNeighBasalAcum{:,:}));
    meanNeighBasalAcum = mean(cat(1,meanNeighBasalAcum{:,:}));
   
    errorbar(surfRatios,meanNeighBasalAcum,stdNeighBasalAcum,'-o','MarkerSize',5,...
    'MarkerEdgeColor','black','MarkerFaceColor','blue')
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
    'MarkerEdgeColor','black','MarkerFaceColor','blue')
    title('euler 2D - per surface')
    xlabel('surface ratio')
    ylabel('sides')
    ylim([0,10]);
    print(h,[path2save 'euler2D'],'-dtiff','-r300')
    close all

    
end

