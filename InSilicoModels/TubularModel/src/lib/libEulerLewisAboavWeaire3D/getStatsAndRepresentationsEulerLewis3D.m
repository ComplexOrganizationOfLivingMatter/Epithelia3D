function getStatsAndRepresentationsEulerLewis3D(numNeighOfNeighPerSurface,numNeighOfNeighAccumPerSurface,numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save,surfRatios,initialDiagram)

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
    
    switch initialDiagram
        case 1 %% Voronoi 1
            colorPlot = [200/255,200/255,200/255];
        case 8 %% Voronoi 8
            colorPlot = [0.2,0.4,1];
        case 0 %% WT Gland
            colorPlot = [151 238 152]/255;
        case 2 %% Ecadhi flatten
            colorPlot = [238 173 60]/255;
    end
        
    
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
        
        allVolumeBasalNorm = cell(1,size(numNeighPerSurface,1));
        allAreaBasalNorm = cell(1,size(numNeighPerSurface,1));
        allAreaApicalNorm = cell(1,size(numNeighPerSurface,1));
        
        for nImg = 1:size(numNeighPerSurface,1)
            
            imgNeighBasal = numNeighPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            imgNeighBasalAccum = numNeighAccumPerSurfaces{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgNeighOfNeighBasal = numNeighOfNeighPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            imgNeighOfNeighBasalAccum = numNeighOfNeighAccumPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgVolumeBasal = volumePerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgAreaBasal = areaCellsPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgNeighApical = numNeighPerSurface{nImg}.('sr1');
            imgAreaApical = areaCellsPerSurface{nImg}.('sr1');

            imgVolumeBasalNorm = imgVolumeBasal./mean(imgVolumeBasal);
            imgAreaBasalNorm = imgAreaBasal./mean(imgAreaBasal);
            imgAreaApicalNorm = imgAreaApical./mean(imgAreaApical);
            allVolumeBasalNorm{nImg} = imgVolumeBasalNorm;
            allAreaBasalNorm{nImg} = imgAreaBasalNorm;
            allAreaApicalNorm{nImg} = imgAreaApicalNorm;
            
            nCells(nImg) = size(imgNeighBasal,1);
 
            %'1_1 area apical - n apical'
            meanAreaApicalPerSideApical(nImg,:) = arrayfun(@(x) mean(imgAreaApicalNorm(ismember(imgNeighApical,x))),nUniqueNeighApical);
            %'1_2 area apical - n basal'
            meanAreaApicalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaApicalNorm(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'1_3 area apical - n basal accum'
            meanAreaApicalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaApicalNorm(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            %'2_1 area basal - n apical'
            meanAreaBasalPerSideApical(nImg,:) = arrayfun(@(x) mean(imgAreaBasalNorm(ismember(imgNeighApical,x))),nUniqueNeighApical);
            %'2_2 area basal - n basal'
            meanAreaBasalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaBasalNorm(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'2_3 area basal - n basal accum'
            meanAreaBasalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaBasalNorm(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            %'3_1 volume - n apical'
            meanVolumePerSideApical(nImg,:) = arrayfun(@(x) mean(imgVolumeBasalNorm(ismember(imgNeighApical,x))),nUniqueNeighApical);
            %'3_2 volume - n basal'
            meanVolumePerSideBasal(nImg,:) = arrayfun(@(x) mean(imgVolumeBasalNorm(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'3_3 Volume - n basal accum'
            meanVolumePerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgVolumeBasalNorm(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            
            %'4_1 Neigh of neigh - n basal'
            meanNeighOfNeighPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgNeighOfNeighBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'4_2 Neigh of neigh accum - n basal accum'
            meanNeighOfNeighAccumPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgNeighOfNeighBasalAccum(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);

        end
        
        %% Representation of a 3x4 matrix of graphs
        
%         h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
%         hold on
%         %% ROW 1 -Area Apical VS Sides
%         %1 area apical vs sides apical
%         subplot(3,4,1) 
%         errorbar(nUniqueNeighApical,mean(meanAreaApicalPerSideApical),std(meanAreaApicalPerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
%         title('area apical - n apical')
%         ylabel('area apical')
%         xlabel('sides apical')
% 
%         %2 area apical vs sides basal
%         subplot(3,4,2)
%         errorbar(nUniqueNeighBasal,mean(meanAreaApicalPerSideBasal),std(meanAreaApicalPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
%         title('area apical - n basal')
%         ylabel('area apical')
%         xlabel('sides basal')
%         
%         %3 area apical vs sides 3D
%         subplot(3,4,3)
%         errorbar(nUniqueNeighBasalAccum,mean(meanAreaApicalPerSideBasalAccum),std(meanAreaApicalPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
%         title('area apical - n basal accum')
%         ylabel('area apical')
%         xlabel('neighbours total')
%         
%         %4 volume VS Area Apical
%         subplot(3,4,4)
%         plot(vertcat(allVolumeBasalNorm{:}),vertcat(allAreaApicalNorm{:}),'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         title('volume - area apical')
%         ylabel('area apical')
%         xlabel('volume')
             
%         %% ROW 2 - Area basal VS sides
%         %1 area basal vs sides apical
%         subplot(3,4,5) 
%         errorbar(nUniqueNeighApical,mean(meanAreaBasalPerSideApical),std(meanAreaBasalPerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
%         title('area basal - n apical')
%         ylabel('area basal')
%         xlabel('sides apical')
%         
%         %2 area basal vs sides basal
%         subplot(3,4,6)
%         errorbar(nUniqueNeighBasal,mean(meanAreaBasalPerSideBasal),std(meanAreaBasalPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
%         title('area basal - n basal')
%         ylabel('area basal')
%         xlabel('sides basal')
%         
%         %3 area basal vs sides 3D
%         subplot(3,4,7)
%         errorbar(nUniqueNeighBasalAccum,mean(meanAreaBasalPerSideBasalAccum),std(meanAreaBasalPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
%         title('area basal - n basal accum')
%         ylabel('area basal')
%         xlabel('neighbours total')
        
%         %4 Area Basal VS Volume
%         subplot(3,4,8)
%         plot(vertcat(allVolumeBasalNorm{:}),vertcat(allAreaBasalNorm{:}),'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         title('volume - area basal')
%         ylabel('area basal')
%         xlabel('volume')

%         %% ROW 3 - Volume VS sides
%         %1 volume vs sides apical
%         subplot(3,4,9) 
%         errorbar(nUniqueNeighApical,mean(meanVolumePerSideApical),std(meanVolumePerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
%         title('volume - n apical')
%         xlabel('sides apical')
%         ylabel('volume')
%         
%         %2 volume vs sides basal
%         subplot(3,4,10)
%         errorbar(nUniqueNeighBasal,mean(meanVolumePerSideBasal),std(meanVolumePerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
%         title('volume - n basal')
%         ylabel('volume')
%         xlabel('sides basal')
% 
%         %3 volume vs sides 3D
%         subplot(3,4,11)
%         errorbar(nUniqueNeighBasalAccum,mean(meanVolumePerSideBasalAccum),std(meanVolumePerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
%         title('volume - n basal accum')
%         ylabel('volume')
%         xlabel('neighbours total')
        
        
%         %4 Area Basal VS Area Apical
%         subplot(3,4,12)
%         plot(vertcat(allAreaApicalNorm{:}),vertcat(allAreaBasalNorm{:}),'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         title('area apical - area basal')
%         ylabel('area basal')
%         xlabel('area apical')
%         
%         hold off
        
    end  
    
    
    %% Euler 3D
    close all
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
    stdNeighBasalAcum = std(cat(1,meanNeighBasalAcum{:,:}));
    meanNeighBasalAcum = mean(cat(1,meanNeighBasalAcum{:,:}));   
    
    %fitting using master equation
    opts = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[1,1,1],...
               'Upper',[Inf,Inf,Inf],...
               'StartPoint',[1 1 1]);
    opts.Display = 'Off';
    myFitTypeComplex =fittype('(6 + p1*log(x))*(x <= X0) + (6+p2*log(x)+(p1-p2)*log(X0))*(x > X0)','dependent', {'y'}, 'independent',{'x'},'options',opts);
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    
    %fitting using flinstones law
    
%     myfittypeLn=fittype('6 +b*log(x)','dependent', {'y'}, 'independent',{'x'});

    [myfitLn,outputFitting]=fit(surfRatios',meanNeighBasalAcum(1:length(surfRatios))',myFitTypeComplex);
    myfitLn
    

    plot(myfitLn, [1 11], [6 myfitLn(11)])
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  

    hold on
    errorbar(surfRatios,meanNeighBasalAcum(1:length(surfRatios)),stdNeighBasalAcum(1:length(surfRatios)),'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    
    preD = predint(myfitLn,[surfRatios max(surfRatios)+1],0.95,'observation','off');
    plot([surfRatios max(surfRatios)+1],preD,'--','Color',colorPlot)
    x = [0 11];
    y = [6 6];
    line(x,y,'Color','red','LineStyle','--')
    hold off
    ylim([5,12]);
    yticks(5:12)  
    xticks(0:12)
    legend({['Voronoi ' num2str(initialDiagram) ' - R^2 ' num2str(outputFitting.rsquare,4)]})
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    savefig(h,[path2save 'euler3D_Voronoi' num2str(initialDiagram) '_' date])

    print(h,[path2save 'euler3D_' date],'-dtiff','-r300')
    
    close all

    %% Euler 2D
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    
    stdNeighBasal = std(cat(1,meanNeighBasal{:,:}));
    meanNeighBasal = mean(cat(1,meanNeighBasal{:,:}));
    
    errorbar(surfRatios,meanNeighBasal(1:length(surfRatios)),stdNeighBasal(1:length(surfRatios)),'-o','MarkerSize',5,...
    'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
    title('euler 2D - per surface')
    xlabel('surface ratio')
    ylabel('sides')
    ylim([0,10]);
    print(h,[path2save 'euler2D'],'-dtiff','-r300')
    close all
    
   
end

